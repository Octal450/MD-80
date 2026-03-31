# McDonnell Douglas MD-80 Fuel
# Copyright (c) 2026 Josh Davidson (Octal450)

var FUEL = {
	Controls: {
		aftPumpC: props.globals.getNode("/controls/fuel/aft-pump-c"),
		aftPumpL: props.globals.getNode("/controls/fuel/aft-pump-l"),
		aftPumpR: props.globals.getNode("/controls/fuel/aft-pump-r"),
		auxAftTransA: props.globals.getNode("/controls/fuel/aux-aft-trans-a"),
		auxAftTransB: props.globals.getNode("/controls/fuel/aux-aft-trans-b"),
		auxFwdTransA: props.globals.getNode("/controls/fuel/aux-fwd-trans-a"),
		auxFwdTransB: props.globals.getNode("/controls/fuel/aux-fwd-trans-b"),
		fwdPumpC: props.globals.getNode("/controls/fuel/fwd-pump-c"),
		fwdPumpL: props.globals.getNode("/controls/fuel/fwd-pump-l"),
		fwdPumpR: props.globals.getNode("/controls/fuel/fwd-pump-r"),
		startPump: props.globals.getNode("/controls/fuel/start-pump"),
		xFeed: props.globals.getNode("/controls/fuel/x-feed"),
	},
	Failures: {
		aftPumpC: props.globals.getNode("/systems/failures/fuel/aft-pump-c"),
		aftPumpL: props.globals.getNode("/systems/failures/fuel/aft-pump-l"),
		aftPumpR: props.globals.getNode("/systems/failures/fuel/aft-pump-r"),
		auxAftTransA: props.globals.getNode("/systems/failures/fuel/aux-aft-trans-a"),
		auxAftTransB: props.globals.getNode("/systems/failures/fuel/aux-aft-trans-b"),
		auxFwdTransA: props.globals.getNode("/systems/failures/fuel/aux-fwd-trans-a"),
		auxFwdTransB: props.globals.getNode("/systems/failures/fuel/aux-fwd-trans-b"),
		fwdPumpC: props.globals.getNode("/systems/failures/fuel/fwd-pump-c"),
		fwdPumpL: props.globals.getNode("/systems/failures/fuel/fwd-pump-l"),
		fwdPumpR: props.globals.getNode("/systems/failures/fuel/fwd-pump-r"),
		startPump: props.globals.getNode("/systems/failures/fuel/start-pump"),
	},
	init: func() {
		me.resetFailures();
		me.Controls.aftPumpC.setValue(0);
		me.Controls.aftPumpL.setBoolValue(0);
		me.Controls.aftPumpR.setBoolValue(0);
		me.Controls.auxAftTransA.setValue(0);
		me.Controls.auxAftTransB.setValue(0);
		me.Controls.auxFwdTransA.setValue(0);
		me.Controls.auxFwdTransB.setValue(0);
		me.Controls.fwdPumpC.setValue(0);
		me.Controls.fwdPumpL.setBoolValue(0);
		me.Controls.fwdPumpR.setBoolValue(0);
		me.Controls.startPump.setBoolValue(0);
		me.Controls.xFeed.setBoolValue(0);
	},
	resetFailures: func() {
		me.Failures.aftPumpC.setBoolValue(0);
		me.Failures.aftPumpL.setBoolValue(0);
		me.Failures.aftPumpR.setBoolValue(0);
		me.Failures.auxAftTransA.setBoolValue(0);
		me.Failures.auxAftTransB.setBoolValue(0);
		me.Failures.auxFwdTransA.setBoolValue(0);
		me.Failures.auxFwdTransB.setBoolValue(0);
		me.Failures.fwdPumpC.setBoolValue(0);
		me.Failures.fwdPumpL.setBoolValue(0);
		me.Failures.fwdPumpR.setBoolValue(0);
		me.Failures.startPump.setBoolValue(0);
	},
};
