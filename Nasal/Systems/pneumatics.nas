# McDonnell Douglas MD-80 Pneumatic System
# Copyright (c) 2024 Josh Davidson (Octal450)

var PNEU = {
	Fail: {
		bleedApu: props.globals.getNode("/systems/failures/pneumatics/bleed-apu"),
		bleedL: props.globals.getNode("/systems/failures/pneumatics/bleed-l"),
		bleedR: props.globals.getNode("/systems/failures/pneumatics/bleed-r"),
		packL: props.globals.getNode("/systems/failures/pneumatics/pack-l"),
		packR: props.globals.getNode("/systems/failures/pneumatics/pack-r"),
	},
	Flow: {
		packL: props.globals.getNode("/systems/pneumatics/pack-l-flow"),
		packR: props.globals.getNode("/systems/pneumatics/pack-r-flow"),
	},
	Psi: {
		apu: props.globals.getNode("/systems/pneumatics/apu-psi"),
		bleedL: props.globals.getNode("/systems/pneumatics/bleed-l-psi"),
		bleedR: props.globals.getNode("/systems/pneumatics/bleed-r-psi"),
		engL: props.globals.getNode("/systems/pneumatics/eng-l-psi"),
		engR: props.globals.getNode("/systems/pneumatics/eng-r-psi"),
		ground: props.globals.getNode("/systems/pneumatics/ground-psi"),
	},
	Switch: {
		bleedApu: props.globals.getNode("/controls/pneumatics/switches/bleed-apu"),
		cabinTemp: props.globals.getNode("/controls/pneumatics/switches/cabin-temp"),
		cockpitTemp: props.globals.getNode("/controls/pneumatics/switches/cockpit-temp"),
		groundAir: props.globals.getNode("/controls/pneumatics/switches/ground-air"), # No switch in cockpit
		instrumentFlow: props.globals.getNode("/controls/pneumatics/switches/instrument-flow"),
		radioRack: props.globals.getNode("/controls/pneumatics/switches/radio-rack"),
		supplyL: props.globals.getNode("/controls/pneumatics/switches/supply-l"),
		supplyR: props.globals.getNode("/controls/pneumatics/switches/supply-r"),
		tempSel: props.globals.getNode("/controls/pneumatics/switches/temp-sel"),
		xBleedL: props.globals.getNode("/controls/pneumatics/switches/x-bleed-l"),
		xBleedR: props.globals.getNode("/controls/pneumatics/switches/x-bleed-r"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.bleedApu.setValue(0);
		me.Switch.cabinTemp.setValue(0.45);
		me.Switch.cockpitTemp.setValue(0.45);
		me.Switch.groundAir.setBoolValue(0);
		me.Switch.instrumentFlow.setValue(0);
		me.Switch.radioRack.setBoolValue(0);
		me.Switch.supplyL.setValue(0);
		me.Switch.supplyR.setValue(0);
		me.Switch.tempSel.setBoolValue(0);
		me.Switch.xBleedL.setValue(0);
		me.Switch.xBleedR.setValue(0);
	},
	resetFailures: func() {
		me.Fail.bleedApu.setBoolValue(0);
		me.Fail.bleedL.setBoolValue(0);
		me.Fail.bleedR.setBoolValue(0);
		me.Fail.packL.setBoolValue(0);
		me.Fail.packR.setBoolValue(0);
	},
};
