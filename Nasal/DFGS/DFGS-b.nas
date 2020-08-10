# McDonnell Douglas MD-80 DFGS AFS Interface
# Copyright (c) 2020 Josh Davidson (Octal450)

var FMA = { # $ splits top and bottom
	thr: props.globals.initNode("/instrumentation/pfd/fma/thr-mode", "", "STRING"),
	arm: props.globals.initNode("/instrumentation/pfd/fma/arm-mode", "", "STRING"),
	pitch: props.globals.initNode("/instrumentation/pfd/fma/pitch-mode", "TAK$OFF", "STRING"),
	roll: props.globals.initNode("/instrumentation/pfd/fma/roll-mode", "TAK$OFF", "STRING"),
};

var updateFMA = {
	pitchText: "T/O CLB",
	rollText: "T/O",
	roll: func() {
		me.rollText = Text.lat.getValue();
		
	},
	pitch: func() {
		me.pitchText = Text.vert.getValue();
		
	},
	arm: func() {
		
	},
};

var Clamp = {
	active: 0,
	pitchText: "T/O CLB",
	stopCheck: 0,
	stopThrottleReset: 0,
	throttleMax: 0,
	triMode: 0,
	loop: func() { # Conflicts should put it into clamp too, but I'm not quite sure how I want to do that yet
		me.pitchText = Text.vert.getValue();
		me.throttleMax = systems.TRI.throttleCompareMax.getValue();
		me.triMode = systems.TRI.Limit.activeModeInt.getValue();
		
		if (me.triMode == 0 or me.triMode == 5) {
			if (me.pitchText == "T/O CLB") {
				if (Output.athr.getBoolValue() and pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue() < 80) {
					me.active = 0;
				} else {
					me.active = 1;
				}
			} else {
				me.active = 1;
			}
		} else if (me.triMode == 1) {
			if (me.pitchText == "G/A CLB") {
				me.active = 0;
			} else {
				me.active = 1;
			}
		} else if (me.pitchText == "SPD DES") {
			if (me.throttleMax <= 0.155) { # Should be Idle Limit + 0.005
				me.stopCheck = 1;
				me.active = 1;
				if (me.stopThrottleReset != 1) {
					me.stopThrottleReset = 1;
				}
			} else if (me.stopCheck != 1) {
				me.stopThrottleReset = 0;
				me.active = 0;
			}
		} else {
			me.stopCheck = 0;
			me.stopThrottleReset = 0;
			me.active = 0;
		}
		
		if (pts.Systems.Acconfig.Options.throttleOverride.getValue() == "Never") {
			if (Custom.Output.clamp.getBoolValue() != 0) {
				Custom.Output.clamp.setBoolValue(0);
			}
		} else {
			if (Custom.Output.clamp.getBoolValue() != me.active) {
				Custom.Output.clamp.setBoolValue(me.active);
			}
		}
	},
};

var clampLoop = maketimer(0.05, Clamp, Clamp.loop);
