# McDonnell Douglas MD-80 FCS
# Copyright (c) 2024 Josh Davidson (Octal450)

var FCS = {
	flapsInput: props.globals.getNode("/systems/fcs/flaps/input"),
	mainGearAnd: props.globals.getNode("/systems/fcs/spoilers/main-gear-and"),
	stabilizerRate: props.globals.getNode("/systems/fcs/stabilizer/rate-switch"),
	Controls: {
		machTrim: props.globals.getNode("/controls/fcs/mach-trim"),
		rudderPwr: props.globals.getNode("/controls/fcs/rudder-pwr"),
		yawDamper: props.globals.getNode("/controls/fcs/yaw-damper"),
	},
	Failures: {
		elevatorPwr: props.globals.getNode("/systems/failures/fcs/elevator-pwr"),
		rudderPwr: props.globals.getNode("/systems/failures/fcs/rudder-pwr"),
		yawDamper: props.globals.getNode("/systems/failures/fcs/yaw-damper"),
	},
	init: func() {
		me.resetFailures();
		me.Controls.machTrim.setBoolValue(1);
		me.Controls.rudderPwr.setBoolValue(1);
		me.Controls.yawDamper.setValue(1);
	},
	resetFailures: func() {
		me.Failures.elevatorPwr.setBoolValue(0);
		me.Failures.rudderPwr.setBoolValue(0);
		me.Failures.yawDamper.setBoolValue(0);
	}
};
