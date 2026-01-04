# McDonnell Douglas MD-80 Gear
# Copyright (c) 2026 Josh Davidson (Octal450)

var GEAR = {
	allNorm: props.globals.getNode("/systems/gear/all-norm"),
	cmd: props.globals.getNode("/systems/gear/cmd"),
	Controls: {
		brakeLeft: props.globals.getNode("/controls/gear/brake-left"),
		brakeParking: props.globals.getNode("/controls/gear/brake-parking"),
		brakeRight: props.globals.getNode("/controls/gear/brake-right"),
		lever: props.globals.getNode("/controls/gear/lever"),
	},
	Failures: {
		leftActuator: props.globals.getNode("/systems/failures/gear/left-actuator"),
		noseActuator: props.globals.getNode("/systems/failures/gear/nose-actuator"),
		rightActuator: props.globals.getNode("/systems/failures/gear/right-actuator"),
	},
	init: func() {
		me.resetFailures();
		me.Controls.brakeParking.setBoolValue(0);
	},
	resetFailures: func() {
		me.Failures.leftActuator.setBoolValue(0);
		me.Failures.noseActuator.setBoolValue(0);
		me.Failures.rightActuator.setBoolValue(0);
	},
};
