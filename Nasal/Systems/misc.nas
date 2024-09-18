# McDonnell Douglas MD-80 Misc Systems
# Copyright (c) 2024 Josh Davidson (Octal450)

# APU
var APU = {
	egt: props.globals.getNode("/engines/engine[2]/egt-actual"),
	ff: props.globals.getNode("/engines/engine[2]/ff-actual"),
	n1: props.globals.getNode("/engines/engine[2]/n1-actual"),
	n2: props.globals.getNode("/engines/engine[2]/n2-actual"),
	state: props.globals.getNode("/engines/engine[2]/state"),
	Switch: {
		master: props.globals.getNode("/controls/apu/switches/master"),
	},
	init: func() {
		me.Switch.master.setValue(0);
	},
	fastStart: func() {
		me.Switch.master.setValue(1);
		settimer(func() { # Give the fuel system a moment to provide fuel in the pipe
			pts.Fdm.JSBsim.Propulsion.setRunning.setValue(2);
		}, 1);
	},
	stopRpm: func() {
		settimer(func() { # Required delay
			if (me.n2.getValue() >= 1) {
				pts.Fdm.JSBsim.Propulsion.Engine.n1[2].setValue(0.1);
				pts.Fdm.JSBsim.Propulsion.Engine.n2[2].setValue(0.1);
			}
		}, 0.1);
	},
};

# Brakes
var BRAKES = {
	Abs: {
		armed: props.globals.getNode("/gear/abs/armed"),
		disarm: props.globals.getNode("/gear/abs/disarm"),
		mode: props.globals.getNode("/gear/abs/mode"), # -2: RTO MAX, -1: RTO MIN, 0: OFF, 1: MIN, 2: MED, 3: MAX
	},
	Fail: {
		abs: props.globals.getNode("/systems/failures/brakes/abs"),
	},
	Switch: {
		abs: props.globals.getNode("/controls/gear/abs/knob"), # -1: RTO, 0: OFF, 1: MIN, 2: MED, 3: MAX
		arm: props.globals.getNode("/controls/gear/abs/armed"),
	},
	init: func() {
		me.Switch.abs.setValue(0);
		me.Switch.arm.setBoolValue(0);
	},
};

setlistener("/controls/gear/abs/armed", func {
	libraries.Sound.switch1();
}, 0, 0);

# Engine Control
var ENGINE = {
	Cover: {
		startL: props.globals.getNode("/controls/engines/covers/start-l"),
		startR: props.globals.getNode("/controls/engines/covers/start-r"),
	},
	cutoffSwitch: [props.globals.getNode("/controls/engines/engine[0]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[1]/cutoff-switch")],
	engSync: props.globals.getNode("/controls/engines/eng-sync"),
	eprTemp: 0,
	fuReset: props.globals.getNode("/controls/engines/fu-reset"),
	manEpr: [props.globals.getNode("/controls/engines/engine[0]/man-epr"), props.globals.getNode("/controls/engines/engine[1]/man-epr")],
	manEprSet: [props.globals.getNode("/controls/engines/engine[0]/man-epr-set"), props.globals.getNode("/controls/engines/engine[1]/man-epr-set")],
	reverseEngage: [props.globals.getNode("/controls/engines/engine[0]/reverse-engage"), props.globals.getNode("/controls/engines/engine[1]/reverse-engage")],
	reverseEngageTemp: [0, 0],
	startSwitch: [props.globals.getNode("/controls/engines/engine[0]/start-switch"), props.globals.getNode("/controls/engines/engine[1]/start-switch")],
	throttle: [props.globals.getNode("/controls/engines/engine[0]/throttle"), props.globals.getNode("/controls/engines/engine[1]/throttle")],
	throttleTemp: [0, 0],
	init: func() {
		me.engSync.setValue(0);
		me.fuReset.setBoolValue(0);
		me.manEpr[0].setValue(2);
		me.manEpr[1].setValue(2);
		me.manEprSet[0].setBoolValue(0);
		me.manEprSet[1].setBoolValue(0);
		me.reverseEngage[0].setBoolValue(0);
		me.reverseEngage[1].setBoolValue(0);
		me.startSwitch[0].setBoolValue(0);
		me.startSwitch[1].setBoolValue(0);
		me.Cover.startL.setBoolValue(0);
		me.Cover.startR.setBoolValue(0);
		pts.Engines.Engine.oilQtyInput[0].setValue(math.round((rand() * 4) + 14 , 0.1)); # Random between 14 and 18
		pts.Engines.Engine.oilQtyInput[1].setValue(math.round((rand() * 4) + 14 , 0.1)); # Random between 14 and 18
	},
	adjustManEpr: func(n, d) {
		if (me.manEprSet[n].getBoolValue() and pts.Instrumentation.Epr.powerAvail[n].getBoolValue()) {
			me.eprTemp = math.round(me.manEpr[n].getValue() + (d * 0.01), (abs(d * 0.01))); # Kill floating point error
			if (me.eprTemp < 1) {
				me.manEpr[n].setValue(1);
			} else if (me.eprTemp > 2.5) {
				me.manEpr[n].setValue(2.5);
			} else {
				me.manEpr[n].setValue(me.eprTemp);
			}
		}
	},
};

# Base off Engine 1
var doRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		ENGINE.throttleTemp[0] = ENGINE.throttle[0].getValue();
		if (!ENGINE.reverseEngage[0].getBoolValue() or !ENGINE.reverseEngage[1].getBoolValue()) {
			ENGINE.reverseEngage[0].setBoolValue(1);
			ENGINE.reverseEngage[1].setBoolValue(1);
			ENGINE.throttle[0].setValue(0);
			ENGINE.throttle[1].setValue(0);
		} else if (ENGINE.throttleTemp[0] < 0.4) {
			ENGINE.throttle[0].setValue(0.4);
			ENGINE.throttle[1].setValue(0.4);
		} else if (ENGINE.throttleTemp[0] < 0.7) {
			ENGINE.throttle[0].setValue(0.7);
			ENGINE.throttle[1].setValue(0.7);
		} else if (ENGINE.throttleTemp[0] < 1) {
			ENGINE.throttle[0].setValue(1);
			ENGINE.throttle[1].setValue(1);
		}
	} else {
		ENGINE.throttle[0].setValue(0);
		ENGINE.throttle[1].setValue(0);
		ENGINE.reverseEngage[0].setBoolValue(0);
		ENGINE.reverseEngage[1].setBoolValue(0);
	}
}

var unRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINE.reverseEngage[0].getBoolValue() or ENGINE.reverseEngage[1].getBoolValue()) {
			ENGINE.throttleTemp[0] = ENGINE.throttle[0].getValue();
			if (ENGINE.throttleTemp[0] > 0.7) {
				ENGINE.throttle[0].setValue(0.7);
				ENGINE.throttle[1].setValue(0.7);
			} else if (ENGINE.throttleTemp[0] > 0.4) {
				ENGINE.throttle[0].setValue(0.4);
				ENGINE.throttle[1].setValue(0.4);
			} else if (ENGINE.throttleTemp[0] > 0.05) {
				ENGINE.throttle[0].setValue(0);
				ENGINE.throttle[1].setValue(0);
			} else {
				ENGINE.throttle[0].setValue(0);
				ENGINE.throttle[1].setValue(0);
				ENGINE.reverseEngage[0].setBoolValue(0);
				ENGINE.reverseEngage[1].setBoolValue(0);
			}
		}
	} else {
		ENGINE.throttle[0].setValue(0);
		ENGINE.throttle[1].setValue(0);
		ENGINE.reverseEngage[0].setBoolValue(0);
		ENGINE.reverseEngage[1].setBoolValue(0);
	}
}

var toggleRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINE.reverseEngage[0].getBoolValue() or ENGINE.reverseEngage[1].getBoolValue()) {
			ENGINE.throttle[0].setValue(0);
			ENGINE.throttle[1].setValue(0);
			ENGINE.reverseEngage[0].setBoolValue(0);
			ENGINE.reverseEngage[1].setBoolValue(0);
		} else {
			ENGINE.reverseEngage[0].setBoolValue(1);
			ENGINE.reverseEngage[1].setBoolValue(1);
		}
	} else {
		ENGINE.throttle[0].setValue(0);
		ENGINE.throttle[1].setValue(0);
		ENGINE.reverseEngage[0].setBoolValue(0);
		ENGINE.reverseEngage[1].setBoolValue(0);
	}
}

var doIdleThrust = func() {
	ENGINE.throttle[0].setValue(0);
	ENGINE.throttle[1].setValue(0);
}

var doLimitThrust = func() {
	var active = THRLIM.Limit.activeNorm.getValue();
	ENGINE.throttle[0].setValue(active);
	ENGINE.throttle[1].setValue(active);
}

var doFullThrust = func() {
	var highest = THRLIM.Limit.highestNorm.getValue();
	ENGINE.throttle[0].setValue(highest);
	ENGINE.throttle[1].setValue(highest);
}

# Flight Controls
var FCTL = {
	Fail: {
		elevatorPwr: props.globals.getNode("/systems/failures/fctl/elevator-pwr"),
		rudderPwr: props.globals.getNode("/systems/failures/fctl/rudder-pwr"),
		yawDamper: props.globals.getNode("/systems/failures/fctl/yaw-damper"),
	},
	Switch: {
		machTrim: props.globals.getNode("/controls/fctl/switches/mach-trim"),
		rudderPwr: props.globals.getNode("/controls/fctl/switches/rudder-pwr"),
		yawDamper: props.globals.getNode("/controls/fctl/switches/yaw-damper"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.machTrim.setBoolValue(1);
		me.Switch.rudderPwr.setBoolValue(1);
		me.Switch.yawDamper.setValue(1);
	},
	resetFailures: func() {
		me.Fail.elevatorPwr.setBoolValue(0);
		me.Fail.rudderPwr.setBoolValue(0);
		me.Fail.yawDamper.setBoolValue(0);
	}
};

# Landing Gear
var GEAR = {
	Fail: {
		leftActuator: props.globals.getNode("/systems/failures/gear/left-actuator"),
		noseActuator: props.globals.getNode("/systems/failures/gear/nose-actuator"),
		rightActuator: props.globals.getNode("/systems/failures/gear/right-actuator"),
	},
	Switch: {
		brakeLeft: props.globals.getNode("/controls/gear/brake-left"),
		brakeParking: props.globals.getNode("/controls/gear/brake-parking"),
		brakeRight: props.globals.getNode("/controls/gear/brake-right"),
		lever: props.globals.getNode("/controls/gear/lever"),
		leverCockpit: props.globals.getNode("/controls/gear/lever-cockpit"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.brakeParking.setBoolValue(0);
	},
	resetFailures: func() {
		me.Fail.leftActuator.setBoolValue(0);
		me.Fail.noseActuator.setBoolValue(0);
		me.Fail.rightActuator.setBoolValue(0);
	},
};

# Ignition
var IGNITION = {
	cutoff1: props.globals.getNode("/systems/ignition/cutoff-1"),
	cutoff2: props.globals.getNode("/systems/ignition/cutoff-2"),
	starter1: props.globals.getNode("/systems/ignition/starter-1"),
	starter2: props.globals.getNode("/systems/ignition/starter-2"),
	Switch: {
		ign: props.globals.getNode("/controls/ignition/switches/ign"),
	},
	init: func() {
		me.Switch.ign.setBoolValue(0);
	},
	fastStart: func(n) {
		ENGINE.cutoffSwitch[n].setBoolValue(0);
		pts.Fdm.JSBsim.Propulsion.setRunning.setValue(n);
	},
	fastStop: func(n) {
		ENGINE.cutoffSwitch[n].setBoolValue(1);
		settimer(func() { # Required delay
			if (pts.Engines.Engine.n2Actual[n].getValue() > 1) {
				pts.Fdm.JSBsim.Propulsion.Engine.n1[n].setValue(0.1);
				pts.Fdm.JSBsim.Propulsion.Engine.n2[n].setValue(0.1);
			}
		}, 0.1);
	},
};

# IRS
var IRS = {
	Iru: {
		alignTimer: [props.globals.getNode("/systems/iru[0]/align-timer"), props.globals.getNode("/systems/iru[1]/align-timer")],
		alignTimeRemainingMinutes: [props.globals.getNode("/systems/iru[0]/align-time-remaining-minutes"), props.globals.getNode("/systems/iru[1]/align-time-remaining-minutes")],
		attAvail: [props.globals.getNode("/systems/iru[0]/att-avail"), props.globals.getNode("/systems/iru[1]/att-avail")],
		mainAvail: [props.globals.getNode("/systems/iru[0]/main-avail"), props.globals.getNode("/systems/iru[1]/main-avail")],
	},
	Switch: {
		knob: [props.globals.getNode("/controls/iru[0]/switches/knob"), props.globals.getNode("/controls/iru[1]/switches/knob")],
	},
	init: func() {
		me.Switch.knob[0].setValue(0);
		me.Switch.knob[1].setValue(0);
	},
};

# Platform (AHRS and IRS)
var PLATFORM = {
	Unit: {
		aligned: [props.globals.getNode("/systems/platform[0]/aligned"), props.globals.getNode("/systems/platform[1]/aligned")],
		attAvail: [props.globals.getNode("/systems/platform[0]/att-avail"), props.globals.getNode("/systems/platform[1]/att-avail")],
	},
};

# Thrust Limits
var THRLIM = {
	Control: {
		atsMax: [props.globals.getNode("/fdm/jsbsim/engine/control-1/ats-max"), props.globals.getNode("/fdm/jsbsim/engine/control-2/ats-max")],
	},
	pitchMode: 0,
	Limit: {
		active: props.globals.getNode("/fdm/jsbsim/engine/limit/active"),
		activeMode: props.globals.getNode("/fdm/jsbsim/engine/limit/active-mode"),
		activeModeInt: props.globals.getNode("/fdm/jsbsim/engine/limit/active-mode-int"), # -1 NONE, 0 T/O, 1 G/A, 2 MCT, 3 CLB, 4 CRZ, 5 T/O FLX, 6 TEST
		activeModeIntTemp: 0,
		activeModeLast: "T/O",
		activeNorm: props.globals.getNode("/fdm/jsbsim/engine/limit/active-norm"),
		cruise: props.globals.getNode("/fdm/jsbsim/engine/limit/cruise"),
		climb: props.globals.getNode("/fdm/jsbsim/engine/limit/climb"),
		flexTemp: props.globals.getNode("/fdm/jsbsim/engine/limit/flex-temp"),
		goAround: props.globals.getNode("/fdm/jsbsim/engine/limit/go-around"),
		highestNorm: props.globals.getNode("/fdm/jsbsim/engine/limit/highest-norm"),
		idleNorm: props.globals.getNode("/fdm/jsbsim/engine/limit/idle-norm"),
		mct: props.globals.getNode("/fdm/jsbsim/engine/limit/mct"),
		takeoff: props.globals.getNode("/fdm/jsbsim/engine/limit/takeoff"),
	},
	throttleCompareMax: props.globals.getNode("/fdm/jsbsim/engine/throttle-compare-max"),
	init: func() {
		me.Limit.activeModeInt.setValue(-1);
		me.Limit.activeMode.setValue("---");
	},
	loop: func() {
		if (me.Limit.activeModeInt.getValue() == 5) {
			if (pts.Controls.Dfgs.Switches.art.getBoolValue()) {
				me.setMode(-1);
			}
		}
	},
	setMode: func(m) {
		if (m == 5) {
			if (pts.Controls.Dfgs.Switches.art.getBoolValue()) {
				me.Limit.activeModeInt.setValue(-1);
			} else {
				me.Limit.activeModeInt.setValue(5);
			}
		} else {
			me.Limit.activeModeInt.setValue(m);
		}
		me.updateTxt();
	},
	testBtn: func(d) {
		if (d) {
			me.setMode(6);
		} else {
			me.setMode(-1);
		}
	},
	updateTxt: func() {
		me.Limit.activeModeIntTemp = me.Limit.activeModeInt.getValue();
		me.Limit.activeModeLast = me.Limit.activeMode.getValue();
		if (me.Limit.activeModeIntTemp == -1) {
			me.Limit.activeMode.setValue("---");
		} else if (me.Limit.activeModeIntTemp == 0) {
			me.Limit.activeMode.setValue("T/O");
			dfgs.Athr.toCheck();
		} else if (me.Limit.activeModeIntTemp == 1) {
			me.Limit.activeMode.setValue("G/A");
		} else if (me.Limit.activeModeIntTemp == 2) {
			me.Limit.activeMode.setValue("MCT");
		} else if (me.Limit.activeModeIntTemp == 3) {
			me.Limit.activeMode.setValue("CL ");
		} else if (me.Limit.activeModeIntTemp == 4) {
			me.Limit.activeMode.setValue("CR ");
		} else if (me.Limit.activeModeIntTemp == 5) {
			me.Limit.activeMode.setValue("FLX");
			dfgs.Athr.toCheck();
		} else if (me.Limit.activeModeIntTemp == 6) {
			me.Limit.activeMode.setValue("---");
		}
		dfgs.Athr.limitChanged(me.Limit.activeModeLast, me.Limit.activeMode.getValue());
	},
};

# Warnings
var WARNINGS = {
	altitudeAlert: props.globals.getNode("/systems/caws/logic/altitude-alert"),
	altitudeAlertCaptured: props.globals.getNode("/systems/caws/logic/altitude-alert-captured"),
};
