var FIRETANK = {
	capacity: 0.0,
	weight: 0.0,
	volume: 0.0,
	hopperweight: 0,
	tankdooropen: 0,
	tankDoorOpen: props.globals.getNode("/sim/model/firetank/opentankdoors"),
	hopperWeight: props.globals.getNode("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]"),
	salvoDropSwitch: props.globals.getNode("/controls/firetank/salvodrop/switch"),
	pauseClock: props.globals.getNode("/sim/freeze/clock"),
	crashed: props.globals.getNode("/sim/crashed"),
	particles: props.globals.getNode("/sim/model/firetank/effects/particles/enabled"),
	dropParticleCtrl: props.globals.getNode("/sim/model/firetank/retardantdropparticlectrl"),
	enabled: props.globals.getNode("/sim/model/firetank/enabled"),
	distributionDial: props.globals.getNode("/controls/firetank/distribution/dial"),
	foam: props.globals.getNode("/sim/model/firetank/foam"),
	redDiffuse: props.globals.getNode("/rendering/scene/diffuse/red"),
	redCombined: props.globals.getNode("/sim/model/firetank/effects/particles/redcombined"),
	greenCombined: props.globals.getNode("/sim/model/firetank/effects/particles/greencombined"),
	blueCombined: props.globals.getNode("/sim/model/firetank/effects/particles/bluecombined"),
	tankop_timer: maketimer(0.01, func{FIRETANK.drop_control()}),
	init: func() {
		setlistener("/sim/model/firetank/opentankdoors", func {
			if (me.tankDoorOpen.getValue() and me.enabled.getValue()) {
				me.tankdooropen = me.tankDoorOpen.getValue();
				me.hopperweight = me.hopperWeight.getValue();
				# quantity is 0-3 = 1/8, 4-8 = 1/4, 9-14 = 1/5% 15-21 = full salvo
				# 1/8 = 0=1, 1=2, 2=3, 3=4 sec
				# 1/4 = 4=1, 5=2, 6=3, 7=4, 8=6 sec
				# 1/2 = 9=1, 10=2, 11=3, 12=4, 13=6, 14=8 sec
				# full salvo = 15=.5, 16=1, 17=2, 18=3, 19=4, 20=6, 21=8 sec
				var quantity = me.distributionDial.getValue();
				if (me.foam.getValue()) {
					me.redCombined.setValue(me.redDiffuse.getValue() * .95);
					me.greenCombined.setValue(me.redDiffuse.getValue() * .98);
					me.blueCombined.setValue(me.redDiffuse.getValue() * 1);
					if (quantity < 4) {
						me.weight = 33360/8; 
					} elsif (quantity >= 4 and quantity < 9) {
						me.weight = 33360/4;
					} elsif (quantity >= 9 and quantity < 15) {
						me.weight = 33360/2;
					} else {
						me.weight = 33360;
					}
				} else {
					me.redCombined.setValue(me.redDiffuse.getValue() * .89);
					me.greenCombined.setValue(me.redDiffuse.getValue() * .35);
					me.blueCombined.setValue(me.redDiffuse.getValue() * .13);
					if (quantity < 4) {
						me.weight = 35480/8;
					} elsif (quantity >= 4 and quantity < 9) {
						me.weight = 35480/4;
					} elsif (quantity >= 9 and quantity < 15) {
						me.weight = 35480/2;
					} else {
						me.weight = 35480;
					}
				}
				if (   quantity ==  0) me.capacity = me.weight / 1 * .05;
				elsif (quantity ==  1) me.capacity = me.weight / 2 * .05;
				elsif (quantity ==  2) me.capacity = me.weight / 3 * .05;
				elsif (quantity ==  3) me.capacity = me.weight / 4 * .05;
				elsif (quantity ==  4) me.capacity = me.weight / 1 * .068;
				elsif (quantity ==  5) me.capacity = me.weight / 2 * .068;
				elsif (quantity ==  6) me.capacity = me.weight / 3 * .068;
				elsif (quantity ==  7) me.capacity = me.weight / 4 * .068;
				elsif (quantity ==  8) me.capacity = me.weight / 6 * .068;
				elsif (quantity ==  9) me.capacity = me.weight / 1 * .082;
				elsif (quantity == 10) me.capacity = me.weight / 2 * .082;
				elsif (quantity == 11) me.capacity = me.weight / 3 * .082;
				elsif (quantity == 12) me.capacity = me.weight / 4 * .082;
				elsif (quantity == 13) me.capacity = me.weight / 6 * .082;
				elsif (quantity == 14) me.capacity = me.weight / 8 * .082;
				elsif (quantity == 15) me.capacity = me.weight /.5 * .1;
				elsif (quantity == 16) me.capacity = me.weight / 1 * .1;
				elsif (quantity == 17) me.capacity = me.weight / 2 * .1;
				elsif (quantity == 18) me.capacity = me.weight / 3 * .1;
				elsif (quantity == 19) me.capacity = me.weight / 4 * .1;
				elsif (quantity == 20) me.capacity = me.weight / 6 * .1;
				elsif (quantity == 21) me.capacity = me.weight / 8 * .1;
				me.tankop_timer.start();
			} else {
				me.tankop_timer.stop();
				me.tankDoorOpen.setValue(0);
				me.salvoDropSwitch.setValue(0);
				me.dropParticleCtrl.setValue(0);
			}
		});		
	},
	drop_control: func() {
		if (me.crashed.getValue() or me.pauseClock.getValue()) {
			me.dropParticleCtrl.setValue(0);
			return;
		}
		me.dropParticleCtrl.setValue(me.tankdooropen * me.hopperweight * me.particles.getValue());
		if (me.tankdooropen and me.hopperweight) {
			if (me.volume < me.weight) {
				me.volume += me.capacity;
				me.hopperweight -= me.capacity;
				if (me.hopperweight < 80) me.hopperWeight.setValue(80);
					else me.hopperWeight.setValue(me.hopperweight);
			} else {
				if (me.hopperweight < 80) me.hopperWeight.setValue(80);
				me.tankDoorOpen.setValue(0);
				me.hopperweight = 0;
				me.tankdooropen = 0;
				me.volume = 0;
				me.salvoDropSwitch.setValue(0);
				me.tankop_timer.stop();
			}
		}
	},
};
FIRETANK.init();

