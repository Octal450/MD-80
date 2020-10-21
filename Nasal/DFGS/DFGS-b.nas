# McDonnell Douglas MD-80 DFGS AFS Interface
# Copyright (c) 2020 Josh Davidson (Octal450)

var Fma = {
	thrA: props.globals.initNode("/instrumentation/fma/thr-mode-a", "", "STRING"),
	thrB: props.globals.initNode("/instrumentation/fma/thr-mode-b", "", "STRING"),
	armA: props.globals.initNode("/instrumentation/fma/arm-mode-a", "", "STRING"),
	armB: props.globals.initNode("/instrumentation/fma/arm-mode-b", "", "STRING"),
	pitchA: props.globals.initNode("/instrumentation/fma/pitch-mode-a", "TAK", "STRING"),
	pitchB: props.globals.initNode("/instrumentation/fma/pitch-mode-b", "OFF", "STRING"),
	rollA: props.globals.initNode("/instrumentation/fma/roll-mode-a", "TAK", "STRING"),
	rollB: props.globals.initNode("/instrumentation/fma/roll-mode-b", "OFF", "STRING"),
};

var updateFma = {
	pitchText: "T/O CLB",
	rollText: "T/O",
	thrTemp: 0,
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
		} else if (me.rollText == "LAND") {
			Fma.rollA.setValue("AUT");
			Fma.rollB.setValue("LND");
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
		if (me.pitchText == "FLCH") { # Replaces SPD CLB/DES from ITAF Core
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
		} else if (me.pitchText == "LAND") {
			Fma.pitchA.setValue("AUT");
			Fma.pitchB.setValue("LND");
			me.arm(); # Clear LND
		} else if (me.pitchText == "NO FLARE") {
			Fma.pitchA.setValue("NO");
			Fma.pitchB.setValue("FLAR");
		} else if (me.pitchText == "FLARE") {
			Fma.pitchA.setValue("FLAR");
			Fma.pitchB.setValue("");
		} else if (me.pitchText == "ROLLOUT") {
			Fma.pitchA.setValue("ROL");
			Fma.pitchB.setValue("OUT");
		}
	},
	arm: func() {
		if (Input.autoLand.getBoolValue() and Text.vert.getValue() != "LAND") {
			Fma.armA.setValue("LND");
		} else if (Output.apprArm.getBoolValue()) {
			Fma.armA.setValue("ILS");
		} else if (Output.locArm.getBoolValue()) {
			Fma.armA.setValue("LOC");
		} else if (Output.lnavArm.getBoolValue()) {
			Fma.armA.setValue("NAV");
		} else {
			Fma.armA.setValue("");
		}
	},
	thr: func() {
		me.thrTemp = Output.thrMode.getValue();
		if (me.thrTemp == 3) {
			Fma.thrA.setValue("CLMP");
			if (systems.TRI.Limit.activeModeInt.getValue() == 5) {
				Fma.thrB.setValue(sprintf("%02d", pts.Fdm.JSBsim.Engine.Limit.flexTemp.getValue()));
			} else {
				Fma.thrB.setValue("");
			}
		} else if (me.thrTemp == 2) {
			Fma.thrA.setValue("EPR");
			if (systems.TRI.Limit.activeModeInt.getValue() == 5) {
				Fma.thrB.setValue(sprintf("%02d", pts.Fdm.JSBsim.Engine.Limit.flexTemp.getValue()));
			} else {
				Fma.thrB.setValue(systems.TRI.Limit.activeMode.getValue());
			}
		} else if (me.thrTemp == 1) {
			Fma.thrA.setValue("RETD");
			Fma.thrB.setValue("");
		} else if (me.thrTemp == 0) {
			Athr.modeZeroCheck(); # Handled there cause its complicated...
		}
	},
};

setlistener("/it-autoflight/input/kts-mach", func() {
	updateFma.thr();
}, 0, 0);

setlistener("/it-autoflight/input/kts-mach-flch", func() {
	updateFma.pitch();
}, 0, 0);

setlistener("/fdm/jsbsim/engine/limit/flex-temp", func() {
	updateFma.thrTemp = Output.thrMode.getValue();
	if ((updateFma.thrTemp == 2 or updateFma.thrTemp == 3) and systems.TRI.Limit.activeModeInt.getValue() == 5) {
		Fma.thrB.setValue(sprintf("%02d", pts.Fdm.JSBsim.Engine.Limit.flexTemp.getValue()));
	}
}, 0, 0);

setlistener("/it-autoflight/input/alt-armed", func() {
	# Arm of ALT
	if (Input.altArmed.getBoolValue()) {
		Fma.armB.setValue("ALT");
	} else {
		Fma.armB.setValue("");
	}
}, 0, 0);

# Seperated the Autothrottle from ITAF because its very different from the ITAF base. So we do it here!
var Athr = {
	retard: 0,
	triMode: 0,
	loop: func() {
		me.triMode = systems.TRI.Limit.activeModeInt.getValue();
		Output.thrModeTemp = Output.thrMode.getValue();
		me.retard = Output.athr.getBoolValue() and Output.vert.getValue() != 7 and pts.Position.gearAglFt.getValue() <= 50 and pts.SurfacePositions.flapPosNorm.getValue() >= 0.679 and me.triMode != 0 and me.triMode != 1 and me.triMode != 5;
		
		if (Output.thrModeTemp == 0) { # Update it as the updateFma only does it once
			me.modeZeroCheck();
		}
		
		if (me.triMode == 0 or me.triMode == 5) {
			me.toCheck();
		} else if (me.retard) {
			if (Output.thrMode.getValue() != 1) {
				Output.thrMode.setValue(1);
				updateFma.thr();
			}
			if (pts.Fdm.JSBsim.Position.wow.getBoolValue()) {
				if (Output.athr.getBoolValue()) {
					ITAF.athrMaster(0);
				}
			}
		}
	},
	modeZeroCheck: func() {
		if (pts.Fdm.JSBsim.Engine.atsCmdRawPid.getValue() <= systems.TRI.Limit.idleNorm.getValue() + 0.005) {
			Fma.thrA.setValue("LOW");
			Fma.thrB.setValue("LIM");
		} else {
			if (Input.ktsMach.getBoolValue()) {
				Fma.thrA.setValue("MACH");
				Fma.thrB.setValue(sprintf("%3.0f", dfgs.Input.mach.getValue() * 1000));
			} else {
				Fma.thrA.setValue("SPD");
				Fma.thrB.setValue(sprintf("%3.0f", dfgs.Input.kts.getValue()));
			}
		}
	},
	setMode: func(n) { # 0 Thrust, 1 Retard, 2 EPR Limit, 3 Clamp
		me.triMode = systems.TRI.Limit.activeModeInt.getValue();
		
		if (me.triMode == 0 or me.triMode == 5) {
			me.toCheck();
		} else if (!me.retard or dfgs.Output.vert.getValue() == 7) {
			Output.thrMode.setValue(n);
		}
		updateFma.thr();
	},
	toCheck: func() {
		if (pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue() < 60 and pts.Fdm.JSBsim.Position.wow.getBoolValue() and Output.vert.getValue() == 7) {
			if (Output.thrMode.getValue() != 2) {
				Output.thrMode.setValue(2);
				updateFma.thr();
			}
		} else {
			if (Output.thrMode.getValue() != 3) {
				Output.thrMode.setValue(3);
				updateFma.thr();
			}
		}
	},
};
