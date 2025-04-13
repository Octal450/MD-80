# McDonnell Douglas MD-80 Pneumatics
# Copyright (c) 2025 Josh Davidson (Octal450)

var PNEUMATICS = {
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
	Controls: {
		autoPackShutdown: props.globals.getNode("/controls/pneumatics/auto-pack-shutdown"),
		bleedApu: props.globals.getNode("/controls/pneumatics/bleed-apu"),
		cabinTemp: props.globals.getNode("/controls/pneumatics/cabin-temp"),
		cockpitTemp: props.globals.getNode("/controls/pneumatics/cockpit-temp"),
		groundAir: props.globals.getNode("/controls/pneumatics/ground-air"), # No switch in cockpit
		instrumentFlow: props.globals.getNode("/controls/pneumatics/instrument-flow"),
		radioRack: props.globals.getNode("/controls/pneumatics/radio-rack"),
		ramAir: props.globals.getNode("/controls/pneumatics/ram-air"),
		supplyL: props.globals.getNode("/controls/pneumatics/supply-l"),
		supplyR: props.globals.getNode("/controls/pneumatics/supply-r"),
		tempSel: props.globals.getNode("/controls/pneumatics/temp-sel"),
		xBleedL: props.globals.getNode("/controls/pneumatics/x-bleed-l"),
		xBleedR: props.globals.getNode("/controls/pneumatics/x-bleed-r"),
	},
	Failures: {
		bleedApu: props.globals.getNode("/systems/failures/pneumatics/bleed-apu"),
		bleedL: props.globals.getNode("/systems/failures/pneumatics/bleed-l"),
		bleedR: props.globals.getNode("/systems/failures/pneumatics/bleed-r"),
		packL: props.globals.getNode("/systems/failures/pneumatics/pack-l"),
		packR: props.globals.getNode("/systems/failures/pneumatics/pack-r"),
	},
	init: func() {
		me.resetFailures();
		me.Controls.autoPackShutdown.setBoolValue(1);
		me.Controls.bleedApu.setValue(0);
		me.Controls.cabinTemp.setValue(0.45);
		me.Controls.cockpitTemp.setValue(0.45);
		me.Controls.groundAir.setBoolValue(0);
		me.Controls.instrumentFlow.setValue(0);
		me.Controls.radioRack.setBoolValue(1);
		me.Controls.ramAir.setBoolValue(0);
		me.Controls.supplyL.setValue(0);
		me.Controls.supplyR.setValue(0);
		me.Controls.tempSel.setBoolValue(0);
		me.Controls.xBleedL.setValue(0);
		me.Controls.xBleedR.setValue(0);
	},
	resetFailures: func() {
		me.Failures.bleedApu.setBoolValue(0);
		me.Failures.bleedL.setBoolValue(0);
		me.Failures.bleedR.setBoolValue(0);
		me.Failures.packL.setBoolValue(0);
		me.Failures.packR.setBoolValue(0);
	},
};
