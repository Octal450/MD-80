var delta_time = props.globals.getNode("/sim/time/delta-realtime-sec", 1);

#################### watertank ####################

# 1 Gallon = 8.345404 lbs * 4000 = 33360 lbs

var capacity = 0.0;
var weight = 0.0;
var volume = 0.0;
var tankdooropen = 0;
var hopperweight = 0;

setlistener("/sim/signals/fdm-initialized", func {

    var tankop_timer = maketimer(0.01, func{tank_operations()});

    setlistener("/sim/model/firetank/opentankdoors", func {
        if (getprop("/sim/model/firetank/opentankdoors") and getprop("/sim/model/firetank/enabled")) {
		
			tankdooropen = getprop("sim/model/firetank/opentankdoors");
			hopperweight = getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[4]");

			# quantity is 0-3 = 1/8, 4-8 = 1/4, 9-14 = 1/5% 15-21 = full salvo
			# 1/8 = 0=1, 1=2, 2=3, 3=4 sec
			# 1/4 = 4=1, 5=2, 6=3, 7=4, 8=6 sec
			# 1/2 = 9=1, 10=2, 11=3, 12=4, 13=6, 14=8 sec
			# full salvo = 15=.5, 16=1, 17=2, 18=3, 19=4, 20=6, 21=8 sec
			var quantity = getprop("controls/firetank/distribution/dial");
			
			var foam = getprop("sim/model/firetank/foam");
			var red_diffuse = getprop("/rendering/scene/diffuse/red");
			if (foam) {
				setprop("/sim/model/firetank/effects/particles/redcombined", red_diffuse * .95);
				setprop("/sim/model/firetank/effects/particles/greencombined", red_diffuse * .98);
				setprop("/sim/model/firetank/effects/particles/bluecombined", red_diffuse * 1);
			} else {
				setprop("/sim/model/firetank/effects/particles/redcombined", red_diffuse * .89);
				setprop("/sim/model/firetank/effects/particles/greencombined", red_diffuse * .35);
				setprop("/sim/model/firetank/effects/particles/bluecombined", red_diffuse * .13);
			}
	
			#water = 4000 gal * 8.34 weight per gal = 33360 lb / 8 sec dump = 4170 lb per sec / 100 (.01 seconds timer cycle) = 41.7 lb capacity per cycle
			#retardant = 4000 gal * 8.87 weight per gal = 35480 lb / 8 sec dump = 4435 lb per sec / 100 (.01 seconds timer cycle) = 44.35 lb capacity per cycle
			if (foam) {
				if (quantity < 4) {
					weight = 33360/8; 
				} elsif (quantity >= 4 and quantity < 9) {
					weight = 33360/4;
				} elsif (quantity >= 9 and quantity < 15) {
					weight = 33360/2;
				} else {
					weight = 33360;
				}
			} else {
				if (quantity < 4) {
					weight = 35480/8;
				} elsif (quantity >= 4 and quantity < 9) {
					weight = 35480/4;
				} elsif (quantity >= 9 and quantity < 15) {
					weight = 35480/2;
				 } else {
					weight = 35480;
				}
			}
			if (   quantity ==  0) capacity = weight / 1 * .05;
			elsif (quantity ==  1) capacity = weight / 2 * .05;
			elsif (quantity ==  2) capacity = weight / 3 * .05;
			elsif (quantity ==  3) capacity = weight / 4 * .05;
			elsif (quantity ==  4) capacity = weight / 1 * .068;
			elsif (quantity ==  5) capacity = weight / 2 * .068
			elsif (quantity ==  6) capacity = weight / 3 * .068;
			elsif (quantity ==  7) capacity = weight / 4 * .068;
			elsif (quantity ==  8) capacity = weight / 6 * .068;
			elsif (quantity ==  9) capacity = weight / 1 * .082;
			elsif (quantity == 10) capacity = weight / 2 * .082;
			elsif (quantity == 11) capacity = weight / 3 * .082;
			elsif (quantity == 12) capacity = weight / 4 * .082;
			elsif (quantity == 13) capacity = weight / 6 * .082;
			elsif (quantity == 14) capacity = weight / 8 * .082;
			elsif (quantity == 15) capacity = weight /.5 * .1;
			elsif (quantity == 16) capacity = weight / 1 * .1;
			elsif (quantity == 17) capacity = weight / 2 * .1;
			elsif (quantity == 18) capacity = weight / 3 * .1;
			elsif (quantity == 19) capacity = weight / 4 * .1;
			elsif (quantity == 20) capacity = weight / 6 * .1;
			elsif (quantity == 21) capacity = weight / 8 * .1;
            tankop_timer.start();
        } else {
            tankop_timer.stop();
            setprop("sim/model/firetank/opentankdoors", 0);
			setprop("controls/firetank/salvodrop/switch", 0);
            setprop("sim/model/firetank/retardantdropparticlectrl", 0);
        }
    });
});

var tank_operations = func {

    var paused = getprop("sim/freeze/clock");
    var crashed = getprop("sim/crashed");
	var particles = getprop("sim/model/firetank/effects/particles/enabled");

    if (crashed or paused) {
        setprop("sim/model/firetank/retardantdropparticlectrl", 0);
        return;
    }

	setprop("sim/model/firetank/retardantdropparticlectrl", tankdooropen * hopperweight * particles);

    if (tankdooropen and hopperweight) {
        if (volume < weight) {
            volume += capacity;
            hopperweight -= capacity;
			if (hopperweight < 80) setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 80);
				else setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[4]", hopperweight);
        } else {
			if (hopperweight < 80) setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 80);
            setprop("sim/model/firetank/opentankdoors", 0);
			hopperweight = 0;
            tankdooropen = 0;
			volume = 0;
			setprop("controls/firetank/salvodrop/switch", 0);
			tankop_timer.stop()
        }
    }
}

var digital_display =
  {

    new : func(designation, model_element, num_display, num_format, font_size, clr_r, clr_g, clr_b)
      {
        var obj = {parents : [digital_display] };
        obj.designation = designation;
        obj.model_element = model_element;
        obj.num_format = num_format;

        var dev_canvas= canvas.new({
          "name": designation,
          "size": [128,128], 
          "view": [128,128],                        
          "mipmapping": 0     
        });

        dev_canvas.addPlacement({"node": model_element});
        dev_canvas.setColorBackground(0,0,0,0);

        obj._canvas = dev_canvas;

        var root = dev_canvas.createGroup();

        obj.string = root.createChild("text")
        .setText(num_display)
        .setColor(clr_r, clr_g, clr_b)
        .setFontSize(font_size)
        .setScale(1,3)
        .setFont("DSEG/DSEG7/Classic-MINI/DSEG7ClassicMini-Bold.ttf")
        .setAlignment("right-bottom")
        .setTranslation(110, 110);

        obj.string.enableUpdate();

        return obj;
      },

  display : func()
    {
      var string =  sprintf(me.num_format, getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[4]"));
      me.string.updateText(string);
    },

  update: func()
    {
      me.display();
      settimer (func me.update(), 0.1);
    },
};

var tank_volume_indicator = digital_display.new("Tank_Volume", "tank-volume-glass", "00000", "%4.0f", "28", "1.0", "0.2", "0.2");
tank_volume_indicator.update();
