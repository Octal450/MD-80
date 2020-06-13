# McDonnell Douglas MD-80 Master System
# Copyright (c) 2020 Josh Davidson (Octal450)

# Engine Sim Control Stuff
# Don't want to change the bindings yet
# Intentionally not using + or -, floating point error would be BAD
# We just based it off Engine 1
var doRevThrust = func {
	pts.Controls.Engines.Engine.reverseLeverTemp[0] = pts.Controls.Engines.Engine.reverseLever[0].getValue();
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and pts.Fdm.JSBsim.Engine.throttleCompareMax.getValue() <= 0.05) {
		if (pts.Controls.Engines.Engine.reverseLeverTemp[0] < 0.25) {
			pts.Controls.Engines.Engine.reverseLever[0].setValue(0.25);
			pts.Controls.Engines.Engine.reverseLever[1].setValue(0.25);
		} else if (pts.Controls.Engines.Engine.reverseLeverTemp[0] < 0.5) {
			pts.Controls.Engines.Engine.reverseLever[0].setValue(0.5);
			pts.Controls.Engines.Engine.reverseLever[1].setValue(0.5);
		} else if (pts.Controls.Engines.Engine.reverseLeverTemp[0] < 0.75) {
			pts.Controls.Engines.Engine.reverseLever[0].setValue(0.75);
			pts.Controls.Engines.Engine.reverseLever[1].setValue(0.75);
		} else if (pts.Controls.Engines.Engine.reverseLeverTemp[0] < 1.0) {
			pts.Controls.Engines.Engine.reverseLever[0].setValue(1.0);
			pts.Controls.Engines.Engine.reverseLever[1].setValue(1.0);
		}
		pts.Controls.Engines.Engine.throttle[0].setValue(0);
		pts.Controls.Engines.Engine.throttle[1].setValue(0);
	} else {
		pts.Controls.Engines.Engine.reverseLever[0].setValue(0);
		pts.Controls.Engines.Engine.reverseLever[1].setValue(0);
	}
}

var unRevThrust = func {
	pts.Controls.Engines.Engine.reverseLeverTemp[0] = pts.Controls.Engines.Engine.reverseLever[0].getValue();
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and pts.Fdm.JSBsim.Engine.throttleCompareMax.getValue() <= 0.05) {
		if (pts.Controls.Engines.Engine.reverseLeverTemp[0] > 0.75) {
			pts.Controls.Engines.Engine.reverseLever[0].setValue(0.75);
			pts.Controls.Engines.Engine.reverseLever[1].setValue(0.75);
		} else if (pts.Controls.Engines.Engine.reverseLeverTemp[0] > 0.5) {
			pts.Controls.Engines.Engine.reverseLever[0].setValue(0.5);
			pts.Controls.Engines.Engine.reverseLever[1].setValue(0.5);
		} else if (pts.Controls.Engines.Engine.reverseLeverTemp[0] > 0.25) {
			pts.Controls.Engines.Engine.reverseLever[0].setValue(0.25);
			pts.Controls.Engines.Engine.reverseLever[1].setValue(0.25);
		} else if (pts.Controls.Engines.Engine.reverseLeverTemp[0] > 0) {
			pts.Controls.Engines.Engine.reverseLever[0].setValue(0);
			pts.Controls.Engines.Engine.reverseLever[1].setValue(0);
		}
		pts.Controls.Engines.Engine.throttle[0].setValue(0);
		pts.Controls.Engines.Engine.throttle[1].setValue(0);
	} else {
		pts.Controls.Engines.Engine.reverseLever[0].setValue(0);
		pts.Controls.Engines.Engine.reverseLever[1].setValue(0);
	}
}

var toggleFastRevThrust = func {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and pts.Fdm.JSBsim.Engine.throttleCompareMax.getValue() <= 0.05) {
		if (pts.Controls.Engines.Engine.reverseLever[0].getValue() != 0) { # NOT a bool, this way it always closes even if partially open
			pts.Controls.Engines.Engine.reverseLever[0].setValue(0);
			pts.Controls.Engines.Engine.reverseLever[1].setValue(0);
		} else {
			pts.Controls.Engines.Engine.reverseLever[0].setValue(1);
			pts.Controls.Engines.Engine.reverseLever[1].setValue(1);
		}
		pts.Controls.Engines.Engine.throttle[0].setValue(0);
		pts.Controls.Engines.Engine.throttle[1].setValue(0);
	} else {
		pts.Controls.Engines.Engine.reverseLever[0].setValue(0);
		pts.Controls.Engines.Engine.reverseLever[1].setValue(0);
	}
}

var doIdleThrust = func {
	pts.Controls.Engines.Engine.throttle[0].setValue(0);
	pts.Controls.Engines.Engine.throttle[1].setValue(0);
}

var doFullThrust = func {
	pts.Controls.Engines.Engine.throttle[0].setValue(1);
	pts.Controls.Engines.Engine.throttle[1].setValue(1);
}

# TRI
var TRI = {
	pitchMode: 0,
	throttleCompareMax: props.globals.getNode("/fdm/jsbsim/engine/throttle-compare-max"),
	Limit: {
		active: props.globals.getNode("/fdm/jsbsim/engine/limit/active"),
		activeMode: props.globals.getNode("/fdm/jsbsim/engine/limit/active-mode"),
		activeModeInt: props.globals.getNode("/fdm/jsbsim/engine/limit/active-mode-int"), # 0 T/O, 1 G/A, 2 MCT, 3 CLB, 4 CRZ, 5 T/O FLX
		#cruise: props.globals.getNode("/fdm/jsbsim/engine/limit/cruise"),
		climb: props.globals.getNode("/fdm/jsbsim/engine/limit/climb"),
		goAround: props.globals.getNode("/fdm/jsbsim/engine/limit/go-around"),
		#mct: props.globals.getNode("/fdm/jsbsim/engine/limit/mct"),
		takeoff: props.globals.getNode("/fdm/jsbsim/engine/limit/takeoff"),
	},
	init: func() {
		me.Limit.activeModeInt.setValue(0);
		me.Limit.activeMode.setValue("T/O");
	},
};
