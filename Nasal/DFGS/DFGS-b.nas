# McDonnell Douglas MD-80 DFGS AFS Interface
# Copyright (c) 2020 Josh Davidson (Octal450)

var Fma = {
	thrA: props.globals.initNode("/instrumentation/pfd/fma/thr-mode-a", "", "STRING"),
	thrB: props.globals.initNode("/instrumentation/pfd/fma/thr-mode-b", "", "STRING"),
	armA: props.globals.initNode("/instrumentation/pfd/fma/arm-mode-a", "", "STRING"),
	armB: props.globals.initNode("/instrumentation/pfd/fma/arm-mode-b", "", "STRING"),
	pitchA: props.globals.initNode("/instrumentation/pfd/fma/pitch-mode-a", "TAK", "STRING"),
	pitchB: props.globals.initNode("/instrumentation/pfd/fma/pitch-mode-b", "OFF", "STRING"),
	rollA: props.globals.initNode("/instrumentation/pfd/fma/roll-mode-a", "TAK", "STRING"),
	rollB: props.globals.initNode("/instrumentation/pfd/fma/roll-mode-b", "OFF", "STRING"),
};

var updateFma = {
	pitchText: "T/O CLB",
	rollText: "T/O",
	roll: func() {
		me.rollText = Text.lat.getValue();
		if (me.rollText == "HDG") {
			Fma.rollA.setValue("HDG");
			if (Output.hdgInHld.getBoolValue()) {
				Fma.rollB.setValue("HLD");
			} else {
				Fma.rollB.setValue("SEL");
			}
		} else if (me.rollText == "LNAV") {
			Fma.rollA.setValue("NAV");
			Fma.rollB.setValue("TRK");
		} else if (me.rollText == "LOC") { # Needs logic for AUT LND
			Fma.rollA.setValue("LOC");
			Fma.rollB.setValue("TRK"); # Needs logic for CAP/TRK
		} else if (me.rollText == "ALGN") {
			Fma.rollA.setValue("ALN");
			Fma.rollB.setValue("");
		} else if (me.rollText == "T/O") {
			Fma.rollA.setValue("TAK");
			Fma.rollB.setValue("OFF");
		} else if (me.rollText == "RLOU") {
			Fma.rollA.setValue("ROL");
			Fma.rollB.setValue("OUT");
		}
	},
	pitch: func() {
		me.pitchText = Text.vert.getValue();
		if (me.pitchText == "SPD CLB") {
			if (Input.ktsMachFlch.getBoolValue()) {
				Fma.pitchA.setValue("MACH");
				Fma.pitchB.setValue("");
			} else {
				Fma.pitchA.setValue("IAS");
				Fma.pitchB.setValue("");
			}
		} else if (me.pitchText == "SPD DES") {
			if (Input.ktsMachFlch.getBoolValue()) {
				Fma.pitchA.setValue("MACH");
				Fma.pitchB.setValue("");
			} else {
				Fma.pitchA.setValue("IAS");
				Fma.pitchB.setValue("");
			}
		} else if (me.pitchText == "T/O CLB") {
			Fma.pitchA.setValue("TAK");
			Fma.pitchB.setValue("OFF");
		} else if (me.pitchText == "G/A CLB") {
			Fma.pitchA.setValue("GO");
			Fma.pitchB.setValue("RND");
		} else if (me.pitchText == "ALT HLD") {
			Fma.pitchA.setValue("ALT");
			Fma.pitchB.setValue("HLD");
		} else if (me.pitchText == "ALT CAP") {
			Fma.pitchA.setValue("ALT");
			Fma.pitchB.setValue("CAP");
		} else if (me.pitchText == "V/S") {
			Fma.pitchA.setValue("VERT");
			Fma.pitchB.setValue("SPD");
		} else if (me.pitchText == "G/S") {
			Fma.pitchA.setValue("G/S");
			Fma.pitchB.setValue("TRK"); # Needs logic for CAP/TRK
		} else if (me.pitchText == "FPA") {
			Fma.pitchA.setValue("");
			Fma.pitchB.setValue("");
		} else if (me.pitchText == "FLARE") {
			Fma.pitchA.setValue("FLAR");
			Fma.pitchB.setValue("");
		} else if (me.pitchText == "ROLLOUT") {
			Fma.pitchA.setValue("ROL");
			Fma.pitchB.setValue("OUT");
		}
		# Arm of ALT
		if (me.pitchText != "ALT HLD" and me.pitchText != "ALT CAP" and me.pitchText != "G/S" and me.pitchText != "FLARE" and me.pitchText != "ROLLOUT") { # Change to if alt is armed later
			Fma.armB.setValue("ALT");
		} else {
			Fma.armB.setValue("");
		}
	},
	arm: func() {
		if (Output.apprArm.getBoolValue()) {
			Fma.armA.setValue("ILS");
		} else if (Output.locArm.getBoolValue()) {
			Fma.armA.setValue("LOC");
		} else if (Output.lnavArm.getBoolValue()) {
			Fma.armA.setValue("NAV");
		} else {
			Fma.armA.setValue("");
		}
	},
};

setlistener("/it-autoflight/input/kts-mach-flch", func() {
	updateFma.pitch();
}, 0, 0);

var Clamp = { # To be removed
	active: 0,
	pitchText: "T/O CLB",
	triMode: 0,
	loop: func() {
		me.pitchText = Text.vert.getValue();
		me.triMode = systems.TRI.Limit.activeModeInt.getValue();
		
		if (me.triMode == 0 or me.triMode == 5) {
			if (me.pitchText == "T/O CLB") {
				if (Output.athr.getBoolValue() and pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue() < 60) {
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
			me.active = 1;
		} else {
			me.active = 0;
		}
		
		if (Output.clamp.getBoolValue() != me.active) {
			Output.clamp.setBoolValue(me.active);
		}
	},
};

var clampLoop = maketimer(0.05, Clamp, Clamp.loop);
