# McDonnell Douglas MD-80 Fuel System
# Copyright (c) 2024 Josh Davidson (Octal450)

var FUEL = {
	Fail: {
		auxTransA: props.globals.getNode("/systems/failures/fuel/aux-trans-a"),
		auxTransB: props.globals.getNode("/systems/failures/fuel/aux-trans-b"),
		pumpsC: props.globals.getNode("/systems/failures/fuel/pumps-c"),
		pumpsL: props.globals.getNode("/systems/failures/fuel/pumps-l"),
		pumpsR: props.globals.getNode("/systems/failures/fuel/pumps-r"),
		pumpStart: props.globals.getNode("/systems/failures/fuel/pump-start"),
	},
	Switch: {
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
	init: func() {
		me.resetFailures();
		me.Switch.auxTransAftA.setValue(0);
		me.Switch.auxTransAftB.setValue(0);
		me.Switch.auxTransFwdA.setValue(0);
		me.Switch.auxTransFwdB.setValue(0);
		me.Switch.pumpAftC.setValue(0);
		me.Switch.pumpAftL.setBoolValue(0);
		me.Switch.pumpAftR.setBoolValue(0);
		me.Switch.pumpFwdC.setValue(0);
		me.Switch.pumpFwdL.setBoolValue(0);
		me.Switch.pumpFwdR.setBoolValue(0);
		me.Switch.pumpStart.setBoolValue(0);
		me.Switch.xFeed.setBoolValue(0);
	},
	resetFailures: func() {
		me.Fail.auxTransA.setBoolValue(0);
		me.Fail.auxTransB.setBoolValue(0);
		me.Fail.pumpsC.setBoolValue(0);
		me.Fail.pumpsL.setBoolValue(0);
		me.Fail.pumpsR.setBoolValue(0);
		me.Fail.pumpStart.setBoolValue(0);
	},
};
