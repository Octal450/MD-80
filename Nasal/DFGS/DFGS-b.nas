# McDonnell Douglas MD-80 DFGS AFS Interface
# Copyright (c) 2020 Josh Davidson (Octal450)

var FMA = { # $ splits top and bottom
	thrA: props.globals.initNode("/instrumentation/pfd/fma/thr-mode-a", "", "STRING"),
	thrB: props.globals.initNode("/instrumentation/pfd/fma/thr-mode-b", "", "STRING"),
	armA: props.globals.initNode("/instrumentation/pfd/fma/arm-mode-a", "", "STRING"),
	armB: props.globals.initNode("/instrumentation/pfd/fma/arm-mode-b", "", "STRING"),
	pitchA: props.globals.initNode("/instrumentation/pfd/fma/pitch-mode-a", "TAK", "STRING"),
	pitchB: props.globals.initNode("/instrumentation/pfd/fma/pitch-mode-b", "OFF", "STRING"),
	rollA: props.globals.initNode("/instrumentation/pfd/fma/roll-mode-a", "TAK", "STRING"),
	rollB: props.globals.initNode("/instrumentation/pfd/fma/roll-mode-b", "OFF", "STRING"),
};

var updateFMA = {
	pitchText: "T/O CLB",
	rollText: "T/O",
	roll: func() {
		me.rollText = Text.lat.getValue();
		if (me.rollText == "HDG") {
			FMA.rollA.setValue("HDG");
			if (Output.hdgInHld.getBoolValue()) {
				FMA.rollB.setValue("HLD");
			} else {
				FMA.rollB.setValue("SEL");
			}
		} else if (me.rollText == "LNAV") {
			FMA.rollA.setValue("NAV");
			FMA.rollB.setValue("TRK");
		} else if (me.rollText == "LOC") { # Needs logic for AUT LND
			FMA.rollA.setValue("LOC");
			FMA.rollB.setValue("TRK"); # Needs logic for CAP/TRK
		} else if (me.rollText == "ALGN") {
			FMA.rollA.setValue("ALN");
			FMA.rollB.setValue("");
		} else if (me.rollText == "T/O") {
			FMA.rollA.setValue("TAK");
			FMA.rollB.setValue("OFF");
		} else if (me.rollText == "RLOU") {
			FMA.rollA.setValue("ROL");
			FMA.rollB.setValue("OUT");
		}
	},
	pitch: func() {
		me.pitchText = Text.vert.getValue();
		if (me.pitchText == "SPD CLB") {
			if (Input.ktsMachFlch.getBoolValue()) {
				FMA.pitchA.setValue("MACH");
				FMA.pitchB.setValue("");
			} else {
				FMA.pitchA.setValue("IAS");
				FMA.pitchB.setValue("");
			}
		} else if (me.pitchText == "SPD DES") {
			if (Input.ktsMachFlch.getBoolValue()) {
				FMA.pitchA.setValue("MACH");
				FMA.pitchB.setValue("");
			} else {
				FMA.pitchA.setValue("IAS");
				FMA.pitchB.setValue("");
			}
		} else if (me.pitchText == "T/O CLB") {
			FMA.pitchA.setValue("TAK");
			FMA.pitchB.setValue("OFF");
		} else if (me.pitchText == "G/A CLB") {
			FMA.pitchA.setValue("GO");
			FMA.pitchB.setValue("RND");
		} else if (me.pitchText == "ALT HLD") {
			FMA.pitchA.setValue("ALT");
			FMA.pitchB.setValue("HLD");
		} else if (me.pitchText == "ALT CAP") {
			FMA.pitchA.setValue("ALT");
			FMA.pitchB.setValue("CAP");
		} else if (me.pitchText == "V/S") {
			FMA.pitchA.setValue("VERT");
			FMA.pitchB.setValue("SPD");
		} else if (me.pitchText == "G/S") {
			FMA.pitchA.setValue("G/S");
			FMA.pitchB.setValue("TRK"); # Needs logic for CAP/TRK
		} else if (me.pitchText == "FPA") {
			FMA.pitchA.setValue("");
			FMA.pitchB.setValue("");
		} else if (me.pitchText == "FLARE") {
			FMA.pitchA.setValue("FLAR");
			FMA.pitchB.setValue("");
		} else if (me.pitchText == "ROLLOUT") {
			FMA.pitchA.setValue("ROL");
			FMA.pitchB.setValue("OUT");
		}
		# Arm of ALT
		if (me.pitchText != "ALT HLD" and me.pitchText != "ALT CAP" and me.pitchText != "G/S" and me.pitchText != "FLARE" and me.pitchText != "ROLLOUT") { # Change to if alt is armed later
			FMA.armB.setValue("ALT");
		} else {
			FMA.armB.setValue("");
		}
	},
	arm: func() {
		if (Output.apprArm.getBoolValue()) {
			FMA.armA.setValue("ILS");
		} else if (Output.locArm.getBoolValue()) {
			FMA.armA.setValue("LOC");
		} else if (Output.lnavArm.getBoolValue()) {
			FMA.armA.setValue("NAV");
		} else {
			FMA.armA.setValue("");
		}
	},
};

setlistener("/it-autoflight/input/kts-mach-flch", func {
	updateFMA.pitch();
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
