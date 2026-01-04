# McDonnell Douglas MD-80 Brakes
# Copyright (c) 2026 Josh Davidson (Octal450)

var BRAKES = {
	Abs: {
		armed: props.globals.getNode("/systems/abs/armed"),
		disarm: props.globals.getNode("/systems/abs/disarm"),
		mode: props.globals.getNode("/systems/abs/mode"), # -2: RTO MAX, -1: RTO MIN, 0: OFF, 1: MIN, 2: MED, 3: MAX
	},
	Controls: {
		abs: props.globals.getNode("/controls/abs/knob"), # -1: RTO, 0: OFF, 1: MIN, 2: MED, 3: MAX
		arm: props.globals.getNode("/controls/abs/armed"),
	},
	Failures: {
		abs: props.globals.getNode("/systems/failures/brakes/abs"),
	},
	init: func() {
		me.Controls.abs.setValue(0);
		me.Controls.arm.setBoolValue(0);
	},
};
