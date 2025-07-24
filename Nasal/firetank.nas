# McDonnell Douglas MD-80 Firefighting
# Copyright (c) 2025 Wayne Bragg
# Modified by Josh Davidson (Octal450)

libraries.firetankEquipped = 1; # Tell IS that the module has loaded

var FIRETANK = {
	blueCombined: props.globals.getNode("/systems/firetank/effects/particles/bluecombined"),
	capacity: 0,
	crashed: props.globals.getNode("/sim/crashed"),
	distributionDial: props.globals.getNode("/controls/firetank/distribution/dial"),
	dropArm: props.globals.getNode("/controls/firetank/droparm/switch"),
	dropArmCover: props.globals.getNode("/controls/firetank/droparm/cover"),
	dropParticleCtrl: props.globals.getNode("/systems/firetank/retardantdropparticlectrl"),
	dropPower: props.globals.getNode("/controls/firetank/droppower/switch"),
	dropPowerCover: props.globals.getNode("/controls/firetank/droppower/cover"),
	foam: props.globals.getNode("/systems/firetank/foam"),
	greenCombined: props.globals.getNode("/systems/firetank/effects/particles/greencombined"),
	hopperWeight: props.globals.getNode("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]"),
	hopperWeightTemp: 0,
	particles: props.globals.getNode("/systems/firetank/effects/particles/enabled"),
	pauseClock: props.globals.getNode("/sim/freeze/clock"),
	redCombined: props.globals.getNode("/systems/firetank/effects/particles/redcombined"),
	redDiffuse: props.globals.getNode("/rendering/scene/diffuse/red"),
	salvoDrop: props.globals.getNode("/controls/firetank/salvodrop/switch"),
	salvoDropCover: props.globals.getNode("/controls/firetank/salvodrop/cover"),
	volume: 0,
	weight: 0,
	init: func() {
		firetankTimer.stop();
		me.distributionDial.setValue(0);
		me.dropArm.setBoolValue(0);
		me.dropArmCover.setBoolValue(0);
		me.dropParticleCtrl.setValue(0);
		me.dropPower.setValue(0);
		me.dropPowerCover.setValue(0);
		me.salvoDrop.setBoolValue(0);
		me.salvoDropCover.setBoolValue(0);
	},
	doorsUpdate: func() {
		if (me.salvoDrop.getBoolValue() and me.dropArm.getBoolValue() and pts.Systems.Acconfig.Options.firetank.getBoolValue()) {
			# Quantity is 0-3 = 1/8, 4-8 = 1/4, 9-14 = 1/5% 15-21 = full salvo
			# 1/8 = 0=1, 1=2, 2=3, 3=4 sec
			# 1/4 = 4=1, 5=2, 6=3, 7=4, 8=6 sec
			# 1/2 = 9=1, 10=2, 11=3, 12=4, 13=6, 14=8 sec
			# full salvo = 15=.5, 16=1, 17=2, 18=3, 19=4, 20=6, 21=8 sec
			var quantity = me.distributionDial.getValue();
			
			if (pts.Systems.Acconfig.Options.firetankWater.getBoolValue()) {
				me.redCombined.setValue(me.redDiffuse.getValue() * 0.95);
				me.greenCombined.setValue(me.redDiffuse.getValue() * 0.98);
				me.blueCombined.setValue(me.redDiffuse.getValue() * 1);
				if (quantity < 4) {
					me.weight = 33360 / 8; 
				} else if (quantity >= 4 and quantity < 9) {
					me.weight = 33360 / 4;
				} else if (quantity >= 9 and quantity < 15) {
					me.weight = 33360 / 2;
				} else {
					me.weight = 33360;
				}
			} else {
				me.redCombined.setValue(me.redDiffuse.getValue() * 0.89);
				me.greenCombined.setValue(me.redDiffuse.getValue() * 0.35);
				me.blueCombined.setValue(me.redDiffuse.getValue() * 0.13);
				if (quantity < 4) {
					me.weight = 35480 / 8;
				} else if (quantity >= 4 and quantity < 9) {
					me.weight = 35480 / 4;
				} else if (quantity >= 9 and quantity < 15) {
					me.weight = 35480 / 2;
				} else {
					me.weight = 35480;
				}
			}
			
			if      (quantity ==  0) me.capacity = me.weight / 1   * 0.05;
			else if (quantity ==  1) me.capacity = me.weight / 2   * 0.05;
			else if (quantity ==  2) me.capacity = me.weight / 3   * 0.05;
			else if (quantity ==  3) me.capacity = me.weight / 4   * 0.05;
			else if (quantity ==  4) me.capacity = me.weight / 1   * 0.068;
			else if (quantity ==  5) me.capacity = me.weight / 2   * 0.068;
			else if (quantity ==  6) me.capacity = me.weight / 3   * 0.068;
			else if (quantity ==  7) me.capacity = me.weight / 4   * 0.068;
			else if (quantity ==  8) me.capacity = me.weight / 6   * 0.068;
			else if (quantity ==  9) me.capacity = me.weight / 1   * 0.082;
			else if (quantity == 10) me.capacity = me.weight / 2   * 0.082;
			else if (quantity == 11) me.capacity = me.weight / 3   * 0.082;
			else if (quantity == 12) me.capacity = me.weight / 4   * 0.082;
			else if (quantity == 13) me.capacity = me.weight / 6   * 0.082;
			else if (quantity == 14) me.capacity = me.weight / 8   * 0.082;
			else if (quantity == 15) me.capacity = me.weight / 0.5 * 0.1;
			else if (quantity == 16) me.capacity = me.weight / 1   * 0.1;
			else if (quantity == 17) me.capacity = me.weight / 2   * 0.1;
			else if (quantity == 18) me.capacity = me.weight / 3   * 0.1;
			else if (quantity == 19) me.capacity = me.weight / 4   * 0.1;
			else if (quantity == 20) me.capacity = me.weight / 6   * 0.1;
			else if (quantity == 21) me.capacity = me.weight / 8   * 0.1;
			
			firetankTimer.start();
		} else {
			firetankTimer.stop();
			me.salvoDrop.setBoolValue(0);
			me.dropParticleCtrl.setBoolValue(0);
		}
	},
	dropControl: func() {
		me.hopperWeightTemp = me.hopperWeight.getValue();
		
		if (!pts.Systems.Acconfig.Options.firetank.getBoolValue()) {
			me.init();
			return;
		}
		
		if (me.crashed.getValue() or me.pauseClock.getValue() or me.hopperWeightTemp <= 80.001) {
			firetankTimer.stop();
			me.salvoDrop.setBoolValue(0);
			me.dropParticleCtrl.setBoolValue(0);
			return;
		}
		
		me.dropParticleCtrl.setBoolValue(me.salvoDrop.getBoolValue() * me.hopperWeightTemp * me.particles.getValue());
		
		if (me.salvoDrop.getBoolValue() and me.hopperWeight.getValue()) {
			if (me.volume < me.weight) {
				me.volume += me.capacity;
				me.hopperWeightTemp -= me.capacity;
				if (me.hopperWeightTemp < 80) me.hopperWeight.setValue(80);
				else me.hopperWeight.setValue(me.hopperWeightTemp);
			} else {
				firetankTimer.stop();
				me.salvoDrop.setBoolValue(0);
				me.dropParticleCtrl.setBoolValue(0);
				if (me.hopperWeight.getValue() < 80) me.hopperWeight.setValue(80);
				me.volume = 0;
			}
		}
	},
};

setlistener("/controls/firetank/salvodrop/switch", func {
	FIRETANK.doorsUpdate();
}, 0, 0);

var firetankTimer = maketimer(0.01, FIRETANK, FIRETANK.dropControl);
