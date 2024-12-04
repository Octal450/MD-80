# McDonnell Douglas MD-80 Fuel
# Copyright (c) 2024 Josh Davidson (Octal450)

var FUEL = {
	Controls: {
		auxTransAftA: props.globals.getNode("/controls/fuel/aux-trans-aft-a"),
		auxTransAftB: props.globals.getNode("/controls/fuel/aux-trans-aft-b"),
		auxTransFwdA: props.globals.getNode("/controls/fuel/aux-trans-fwd-a"),
		auxTransFwdB: props.globals.getNode("/controls/fuel/aux-trans-fwd-b"),
		pumpAftC: props.globals.getNode("/controls/fuel/pump-aft-c"),
		pumpAftL: props.globals.getNode("/controls/fuel/pump-aft-l"),
		pumpAftR: props.globals.getNode("/controls/fuel/pump-aft-r"),
		pumpFwdC: props.globals.getNode("/controls/fuel/pump-fwd-c"),
		pumpFwdL: props.globals.getNode("/controls/fuel/pump-fwd-l"),
		pumpFwdR: props.globals.getNode("/controls/fuel/pump-fwd-r"),
		pumpStart: props.globals.getNode("/controls/fuel/pump-start"),
		xFeed: props.globals.getNode("/controls/fuel/x-feed"),
	},
	Failures: {
		auxTransA: props.globals.getNode("/systems/failures/fuel/aux-trans-a"),
		auxTransB: props.globals.getNode("/systems/failures/fuel/aux-trans-b"),
		pumpsC: props.globals.getNode("/systems/failures/fuel/pumps-c"),
		pumpsL: props.globals.getNode("/systems/failures/fuel/pumps-l"),
		pumpsR: props.globals.getNode("/systems/failures/fuel/pumps-r"),
		pumpStart: props.globals.getNode("/systems/failures/fuel/pump-start"),
	},
	init: func() {
		me.resetFailures();
		me.Controls.auxTransAftA.setValue(0);
		me.Controls.auxTransAftB.setValue(0);
		me.Controls.auxTransFwdA.setValue(0);
		me.Controls.auxTransFwdB.setValue(0);
		me.Controls.pumpAftC.setValue(0);
		me.Controls.pumpAftL.setBoolValue(0);
		me.Controls.pumpAftR.setBoolValue(0);
		me.Controls.pumpFwdC.setValue(0);
		me.Controls.pumpFwdL.setBoolValue(0);
		me.Controls.pumpFwdR.setBoolValue(0);
		me.Controls.pumpStart.setBoolValue(0);
		me.Controls.xFeed.setBoolValue(0);
	},
	resetFailures: func() {
		me.Failures.auxTransA.setBoolValue(0);
		me.Failures.auxTransB.setBoolValue(0);
		me.Failures.pumpsC.setBoolValue(0);
		me.Failures.pumpsL.setBoolValue(0);
		me.Failures.pumpsR.setBoolValue(0);
		me.Failures.pumpStart.setBoolValue(0);
	},
};
