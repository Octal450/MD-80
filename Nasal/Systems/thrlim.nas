# McDonnell Douglas MD-80 Thrust Limits
# Copyright (c) 2024 Josh Davidson (Octal450)

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
