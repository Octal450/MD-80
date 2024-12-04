# McDonnell Douglas MD-80 Misc Systems
# Copyright (c) 2024 Josh Davidson (Octal450)

# APU
var APU = {
	egt: props.globals.getNode("/engines/engine[2]/egt-actual"),
	ff: props.globals.getNode("/engines/engine[2]/ff-actual"),
	n1: props.globals.getNode("/engines/engine[2]/n1-actual"),
	n2: props.globals.getNode("/engines/engine[2]/n2-actual"),
	state: props.globals.getNode("/engines/engine[2]/state"),
	Controls: {
		master: props.globals.getNode("/controls/apu/master"),
	},
	init: func() {
		me.Controls.master.setValue(0);
	},
	fastStart: func() {
		me.Controls.master.setValue(1);
		settimer(func() { # Give the fuel system a moment to provide fuel in the pipe
			pts.Fdm.JSBSim.Propulsion.setRunning.setValue(2);
		}, 1);
	},
	stopRpm: func() {
		settimer(func() { # Required delay
			if (me.n2.getValue() >= 1) {
				pts.Fdm.JSBSim.Propulsion.Engine.n1[2].setValue(0.1);
				pts.Fdm.JSBSim.Propulsion.Engine.n2[2].setValue(0.1);
			}
		}, 0.1);
	},
};

# Brakes
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

# Engine Control
var ENGINES = {
	atsCmdRawPid: props.globals.initNode("/systems/engines/ats-cmd-raw-pid", 0, "DOUBLE"),
	egt: [props.globals.getNode("/engines/engine[0]/egt-actual"), props.globals.getNode("/engines/engine[1]/egt-actual")],
	epr: [props.globals.getNode("/engines/engine[0]/epr-actual"), props.globals.getNode("/engines/engine[1]/epr-actual")],
	ff: [props.globals.getNode("/engines/engine[0]/ff-actual"), props.globals.getNode("/engines/engine[1]/ff-actual")],
	n1: [props.globals.getNode("/engines/engine[0]/n1-actual"), props.globals.getNode("/engines/engine[1]/n1-actual")],
	n2: [props.globals.getNode("/engines/engine[0]/n2-actual"), props.globals.getNode("/engines/engine[1]/n2-actual")],
	oilPsi: [props.globals.getNode("/engines/engine[0]/oil-psi"), props.globals.getNode("/engines/engine[1]/oil-psi")],
	oilQty: [props.globals.getNode("/engines/engine[0]/oil-qty"), props.globals.getNode("/engines/engine[1]/oil-qty")],
	oilQtyInput: [props.globals.getNode("/engines/engine[0]/oil-qty-input"), props.globals.getNode("/engines/engine[1]/oil-qty-input")],
	overspeed: props.globals.getNode("/systems/engines/limit/overspeed"),
	reverseEngage: [props.globals.getNode("/systems/engines/reverse-1/engage"), props.globals.getNode("/systems/engines/reverse-2/engage")],
	state: [props.globals.getNode("/engines/engine[0]/state"), props.globals.getNode("/engines/engine[1]/state")],
	Controls: {
		cutoff: [props.globals.getNode("/controls/engines/engine[0]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[1]/cutoff-switch")],
		engSync: props.globals.getNode("/controls/engines/eng-sync"),
		eprTemp: 0,
		fuReset: props.globals.getNode("/controls/engines/fu-reset"),
		manEpr: [props.globals.getNode("/controls/engines/engine[0]/man-epr"), props.globals.getNode("/controls/engines/engine[1]/man-epr")],
		manEprSet: [props.globals.getNode("/controls/engines/engine[0]/man-epr-set"), props.globals.getNode("/controls/engines/engine[1]/man-epr-set")],
		start: [props.globals.getNode("/controls/engines/engine[0]/start-switch"), props.globals.getNode("/controls/engines/engine[1]/start-switch")],
		throttle: [props.globals.getNode("/controls/engines/engine[0]/throttle"), props.globals.getNode("/controls/engines/engine[1]/throttle")],
		throttleTemp: [0, 0],
	},
	Covers: {
		startL: props.globals.getNode("/controls/engines/covers/start-l"),
		startR: props.globals.getNode("/controls/engines/covers/start-r"),
	},
	init: func() {
		me.reverseEngage[0].setBoolValue(0);
		me.reverseEngage[1].setBoolValue(0);
		me.Controls.engSync.setValue(0);
		me.Controls.fuReset.setBoolValue(0);
		me.Controls.manEpr[0].setValue(2);
		me.Controls.manEpr[1].setValue(2);
		me.Controls.manEprSet[0].setBoolValue(0);
		me.Controls.manEprSet[1].setBoolValue(0);
		me.Controls.start[0].setBoolValue(0);
		me.Controls.start[1].setBoolValue(0);
		me.Covers.startL.setBoolValue(0);
		me.Covers.startR.setBoolValue(0);
		systems.ENGINES.oilQtyInput[0].setValue(math.round((rand() * 4) + 14 , 0.1)); # Random between 14 and 18
		systems.ENGINES.oilQtyInput[1].setValue(math.round((rand() * 4) + 14 , 0.1)); # Random between 14 and 18
	},
	adjustManEpr: func(n, d) {
		if (me.Controls.manEprSet[n].getBoolValue() and pts.Instrumentation.Epr.powerAvail[n].getBoolValue()) {
			me.Controls.eprTemp = math.round(me.Controls.manEpr[n].getValue() + (d * 0.01), (abs(d * 0.01))); # Kill floating point error
			if (me.Controls.eprTemp < 1) {
				me.Controls.manEpr[n].setValue(1);
			} else if (me.Controls.eprTemp > 2.5) {
				me.Controls.manEpr[n].setValue(2.5);
			} else {
				me.Controls.manEpr[n].setValue(me.Controls.eprTemp);
			}
		}
	},
};

# Base off Engine 1
var doRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		ENGINES.Controls.throttleTemp[0] = ENGINES.Controls.throttle[0].getValue();
		if (!ENGINES.reverseEngage[0].getBoolValue() or !ENGINES.reverseEngage[1].getBoolValue()) {
			ENGINES.reverseEngage[0].setBoolValue(1);
			ENGINES.reverseEngage[1].setBoolValue(1);
			ENGINES.Controls.throttle[0].setValue(0);
			ENGINES.Controls.throttle[1].setValue(0);
		} else if (ENGINES.Controls.throttleTemp[0] < 0.4) {
			ENGINES.Controls.throttle[0].setValue(0.4);
			ENGINES.Controls.throttle[1].setValue(0.4);
		} else if (ENGINES.Controls.throttleTemp[0] < 0.7) {
			ENGINES.Controls.throttle[0].setValue(0.7);
			ENGINES.Controls.throttle[1].setValue(0.7);
		} else if (ENGINES.Controls.throttleTemp[0] < 1) {
			ENGINES.Controls.throttle[0].setValue(1);
			ENGINES.Controls.throttle[1].setValue(1);
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.reverseEngage[0].setBoolValue(0);
		ENGINES.reverseEngage[1].setBoolValue(0);
	}
}

var unRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINES.reverseEngage[0].getBoolValue() or ENGINES.reverseEngage[1].getBoolValue()) {
			ENGINES.Controls.throttleTemp[0] = ENGINES.Controls.throttle[0].getValue();
			if (ENGINES.Controls.throttleTemp[0] > 0.7) {
				ENGINES.Controls.throttle[0].setValue(0.7);
				ENGINES.Controls.throttle[1].setValue(0.7);
			} else if (ENGINES.Controls.throttleTemp[0] > 0.4) {
				ENGINES.Controls.throttle[0].setValue(0.4);
				ENGINES.Controls.throttle[1].setValue(0.4);
			} else if (ENGINES.Controls.throttleTemp[0] > 0.05) {
				ENGINES.Controls.throttle[0].setValue(0);
				ENGINES.Controls.throttle[1].setValue(0);
			} else {
				ENGINES.Controls.throttle[0].setValue(0);
				ENGINES.Controls.throttle[1].setValue(0);
				ENGINES.reverseEngage[0].setBoolValue(0);
				ENGINES.reverseEngage[1].setBoolValue(0);
			}
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.reverseEngage[0].setBoolValue(0);
		ENGINES.reverseEngage[1].setBoolValue(0);
	}
}

var toggleRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINES.reverseEngage[0].getBoolValue() or ENGINES.reverseEngage[1].getBoolValue()) {
			ENGINES.Controls.throttle[0].setValue(0);
			ENGINES.Controls.throttle[1].setValue(0);
			ENGINES.reverseEngage[0].setBoolValue(0);
			ENGINES.reverseEngage[1].setBoolValue(0);
		} else {
			ENGINES.reverseEngage[0].setBoolValue(1);
			ENGINES.reverseEngage[1].setBoolValue(1);
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.reverseEngage[0].setBoolValue(0);
		ENGINES.reverseEngage[1].setBoolValue(0);
	}
}

var doIdleThrust = func() {
	ENGINES.Controls.throttle[0].setValue(0);
	ENGINES.Controls.throttle[1].setValue(0);
}

var doLimitThrust = func() {
	var active = THRLIM.Limit.activeNorm.getValue();
	ENGINES.Controls.throttle[0].setValue(active);
	ENGINES.Controls.throttle[1].setValue(active);
}

var doFullThrust = func() {
	var highest = THRLIM.Limit.highestNorm.getValue();
	ENGINES.Controls.throttle[0].setValue(highest);
	ENGINES.Controls.throttle[1].setValue(highest);
}

# Flight Controls
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

# Landing Gear
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

# Ignition
var IGNITION = {
	cutoff1: props.globals.getNode("/systems/ignition/cutoff-1"),
	cutoff2: props.globals.getNode("/systems/ignition/cutoff-2"),
	starter1: props.globals.getNode("/systems/ignition/starter-1"),
	starter2: props.globals.getNode("/systems/ignition/starter-2"),
	Controls: {
		ign: props.globals.getNode("/controls/ignition/ign"),
	},
	init: func() {
		me.Controls.ign.setBoolValue(0);
	},
	fastStart: func(n) {
		ENGINES.Controls.cutoff[n].setBoolValue(0);
		pts.Fdm.JSBSim.Propulsion.setRunning.setValue(n);
	},
	fastStop: func(n) {
		ENGINES.Controls.cutoff[n].setBoolValue(1);
		settimer(func() { # Required delay
			if (systems.ENGINES.n2[n].getValue() > 1) {
				pts.Fdm.JSBSim.Propulsion.Engine.n1[n].setValue(0.1);
				pts.Fdm.JSBSim.Propulsion.Engine.n2[n].setValue(0.1);
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
	Controls: {
		knob: [props.globals.getNode("/controls/iru[0]/knob"), props.globals.getNode("/controls/iru[1]/knob")],
	},
	init: func() {
		me.Controls.knob[0].setValue(0);
		me.Controls.knob[1].setValue(0);
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
		atsMax: [props.globals.getNode("/systems/engines/control-1/ats-max"), props.globals.getNode("/systems/engines/control-2/ats-max")],
	},
	pitchMode: 0,
	Limit: {
		active: props.globals.getNode("/systems/engines/limit/active"),
		activeMode: props.globals.getNode("/systems/engines/limit/active-mode"),
		activeModeInt: props.globals.getNode("/systems/engines/limit/active-mode-int"), # -1 NONE, 0 T/O, 1 G/A, 2 MCT, 3 CLB, 4 CRZ, 5 T/O FLX, 6 TEST
		activeModeIntTemp: 0,
		activeModeLast: "T/O",
		activeNorm: props.globals.getNode("/systems/engines/limit/active-norm"),
		cruise: props.globals.getNode("/systems/engines/limit/cruise"),
		climb: props.globals.getNode("/systems/engines/limit/climb"),
		flexTemp: props.globals.getNode("/systems/engines/limit/flex-temp"),
		goAround: props.globals.getNode("/systems/engines/limit/go-around"),
		highestNorm: props.globals.getNode("/systems/engines/limit/highest-norm"),
		idleNorm: props.globals.getNode("/systems/engines/limit/idle-norm"),
		mct: props.globals.getNode("/systems/engines/limit/mct"),
		takeoff: props.globals.getNode("/systems/engines/limit/takeoff"),
	},
	throttleCompareMax: props.globals.getNode("/systems/engines/throttle-compare-max"),
	init: func() {
		me.Limit.activeModeInt.setValue(-1);
		me.Limit.activeMode.setValue("---");
	},
	loop: func() {
		if (me.Limit.activeModeInt.getValue() == 5) {
			if (dfgs.Main.art.getBoolValue()) {
				me.setMode(-1);
			}
		}
	},
	setMode: func(m) {
		if (m == 5) {
			if (dfgs.Main.art.getBoolValue()) {
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
