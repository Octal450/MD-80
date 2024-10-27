var delta_time = props.globals.getNode("/sim/time/delta-realtime-sec", 1);

setlistener("/sim/signals/fdm-initialized", func {

    var tankop_timer = maketimer(0.01, func{tank_operations()});

    setlistener("/sim/model/firetank/opentankdoors", func {
        if (getprop("/sim/model/firetank/opentankdoors") and getprop("/sim/model/firetank/enabled")) {
            tankop_timer.start();
        } else {
            tankop_timer.stop();
            setprop("sim/model/firetank/opentankdoors", 0);
            setprop("sim/model/firetank/retardantdropparticlectrl", 0);
        }
    });
});

#################### watertank ####################

# 1 Gallon = 8.345404 lbs * 4000 = 33360 lbs

var capacity = 0.0;
var weight = 0.0;
var volume = 0.0;

#optimize using listeners VS loop where possible
var tank_operations = func {

    var paused = getprop("sim/freeze/clock");
    var crashed = getprop("sim/crashed");

    if (crashed or paused) {
        setprop("sim/model/firetank/retardantdropparticlectrl", 0);
        return;
    }

    var tankdooropen = getprop("sim/model/firetank/opentankdoors");
    var foam = getprop("sim/model/firetank/foam");
    var hopperweight = getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[4]");
    var groundspeed = getprop("velocities/groundspeed-kt");
    var airspeed = getprop("velocities/airspeed-kt");
    var particles = getprop("sim/model/firetank/effects/particles/enabled");
    var altitude = getprop("position/altitude-agl-ft");
    var normalized = 1 - (altitude - 0) / (60 - 0);
    var quantity = getprop("sim/model/firetank/quantity");
	var tank = getprop("sim/model/firetank/tank");
	var bladder_one = getprop("sim/model/firetank/bladder-one");
	var bladder_two = getprop("sim/model/firetank/bladder-two");
	var bladder_three = getprop("sim/model/firetank/bladder-three");

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

	setprop("sim/model/firetank/retardantdropparticlectrl", tankdooropen * hopperweight * particles);

    if (tankdooropen and hopperweight) {

		#water = 4000 gal * 8.34 weight per gal = 33360 lb / 8 sec dump = 4170 lb per sec / 100 (.01 seconds timer cycle) = 41.7 lb capacity per cycle
		#retardant = 4000 gal * 8.87 weight per gal = 35480 lb / 8 sec dump = 4435 lb per sec / 100 (.01 seconds timer cycle) = 44.35 lb capacity per cycle

        if (foam) {
            capacity = 41.7 * 7;
            if (quantity == 1) weight = 8340;
				else if (quantity == 2) weight = 16680;
					else if (quantity == 3) weight = 25020;
						else if (quantity == 4) weight = 33360;
        } else {
            capacity = 44.35 * 7;
            if (quantity == 1) weight = 8870;
				else if (quantity == 2) weight = 17740;
					else if (quantity == 3) weight = 26610;
						else if (quantity == 4) weight = 35480;
        }
        setprop("sim/model/firetank/droprate", 400);

        if (volume < weight) {
            volume += capacity;
            hopperweight -= capacity;
            if (hopperweight < 10) {
                volume = 0;
                hopperweight = 0;
                setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 0);
                setprop("sim/model/firetank/opentankdoors", 0);
				setprop("sim/model/firetank/retardantdropparticlectrl", 0);
            } else {
                setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[4]", hopperweight);
            }
        } else {
            setprop("sim/model/firetank/opentankdoors", 0);
            setprop("sim/model/firetank/retardantdropparticlectrl", 0);
            tankdooropen = 0;
			volume = 0;
        }

		setprop("sim/model/firetank/retardantdropparticlectrl", 1);
		if (volume < weight*.33) {
			setprop("sim/model/firetank/bladder-one", 1);
			setprop("sim/model/firetank/bladder-two", 0);
			setprop("sim/model/firetank/bladder-three", 0);
		}
		if (volume < weight*.66 and volume >= weight*.33) {
			setprop("sim/model/firetank/bladder-one", 0);
			setprop("sim/model/firetank/bladder-two", 1);
			setprop("sim/model/firetank/bladder-three", 0);
		}
		if (volume < weight*1 and volume >= weight*.66) {
			setprop("sim/model/firetank/bladder-one", 0);
			setprop("sim/model/firetank/bladder-two", 0);
			setprop("sim/model/firetank/bladder-three", 1);
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
