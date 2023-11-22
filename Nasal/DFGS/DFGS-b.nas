# McDonnell Douglas MD-80 DFGS AFS Interface
# Copyright (c) 2023 Josh Davidson (Octal450)

var Fma = {
	armA: props.globals.initNode("/instrumentation/fma/arm-mode-a", "", "STRING"),
	armB: props.globals.initNode("/instrumentation/fma/arm-mode-b", "", "STRING"),
	pitchA: props.globals.initNode("/instrumentation/fma/pitch-mode-a", "TAK", "STRING"),
	pitchB: props.globals.initNode("/instrumentation/fma/pitch-mode-b", "OFF", "STRING"),
	rollA: props.globals.initNode("/instrumentation/fma/roll-mode-a", "TAK", "STRING"),
	rollB: props.globals.initNode("/instrumentation/fma/roll-mode-b", "OFF", "STRING"),
	thrA: props.globals.initNode("/instrumentation/fma/thr-mode-a", "", "STRING"),
	thrB: props.globals.initNode("/instrumentation/fma/thr-mode-b", "", "STRING"),
	Blink: {
		elapsed: 0,
		time: [-5, -5, -5, -5],
	},
	loop: func() {
		me.Blink.elapsed = pts.Sim.Time.elapsedSec.getValue();
		if (me.Blink.elapsed <= me.Blink.time[0] + 5) {
			if (Output.athr.getBoolValue()) {
				canvas_fma.Value.blinkActive[0] = 1;
			} else {
				me.stopBlink(0);
			}
		} else {
			canvas_fma.Value.blinkActive[0] = 0;
		}
		if (me.Blink.elapsed <= me.Blink.time[1] + 5) {
			canvas_fma.Value.blinkActive[1] = 1;
		} else {
			canvas_fma.Value.blinkActive[1] = 0;
		}
		if (me.Blink.elapsed <= me.Blink.time[2] + 5) {
			canvas_fma.Value.blinkActive[2] = 1;
		} else {
			canvas_fma.Value.blinkActive[2] = 0;
		}
		if (me.Blink.elapsed <= me.Blink.time[3] + 5) {
			canvas_fma.Value.blinkActive[3] = 1;
		} else {
			canvas_fma.Value.blinkActive[3] = 0;
		}
	},
	startBlink: func(w) { # 0 THR, 1 ARM, 2 ROLL, 3 PITCH
		if (w == 0 and !Output.athr.getBoolValue()) return;
		me.Blink.time[w] = pts.Sim.Time.elapsedSec.getValue();
	},
	stopBlink: func(w) {
		me.Blink.time[w] = -5;
	},
};

var updateFma = {
	pitchText: "T/O CLB",
	rollText: "T/O",
	thrTemp: 0,
	capTrkReCheck: func() {
		me.locUpdate();
		locUpdateT.start();
		me.gsUpdate();
		gsUpdateT.start();
	},
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
		} else if (me.rollText == "LOC") {
			if (pts.Instrumentation.Nav.navLoc[Input.activeAp.getValue() - 1].getBoolValue()) {
				Fma.rollA.setValue("LOC");
			} else {
				Fma.rollA.setValue("VOR");
			}
			me.locUpdate();
			locUpdateT.start();
		} else if (me.rollText == "LAND") {
			Fma.rollA.setValue("AUT");
			Fma.rollB.setValue("LND");
		} else if (me.rollText == "ALGN") {
			Fma.rollA.setValue("ALN");
			Fma.rollB.setValue("");
		} else if (me.rollText == "RLOU") {
			Fma.rollA.setValue("ROL");
			Fma.rollB.setValue("OUT");
		} else if (me.rollText == "T/O") {
			Fma.rollA.setValue("TAK");
			Fma.rollB.setValue("OFF");
		} else if (me.rollText == "G/A") {
			Fma.rollA.setValue("GO");
			Fma.rollB.setValue("RND");
		} else if (me.rollText == "LVL") {
			Fma.rollA.setValue("WNG");
			Fma.rollB.setValue("LVL");
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
			me.gsUpdate();
			gsUpdateT.start();
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
		} else if (me.pitchText == "PITCH") {
			Fma.pitchA.setValue("TURB");
			Fma.pitchB.setValue("");
		}
	},
	arm: func() {
		me.pitchText = Text.vert.getValue();
		if (Input.autoLand.getBoolValue() and me.pitchText != "LAND" and me.pitchText != "ROLLOUT") {
			Fma.armA.setValue("LND");
			me.altArm();
		} else if (Output.apprArm.getBoolValue()) {
			Fma.armA.setValue("ILS");
			me.altArm();
		} else if (Output.locArm.getBoolValue()) {
			if (pts.Instrumentation.Nav.navLoc[Input.activeAp.getValue() - 1].getBoolValue()) {
				Fma.armA.setValue("LOC");
			} else {
				Fma.armA.setValue("VOR");
			}
			me.altArm();
		} else if (Output.lnavArm.getBoolValue()) {
			Fma.armA.setValue("NAV");
			me.altArm();
		} else if (Internal.goAround == 3) {
			Fma.armA.setValue("AUT");
			Fma.armB.setValue("G/A");
		} else if (Internal.goAround == 2) {
			Fma.armA.setValue("F/D");
			Fma.armB.setValue("G/A");
		} else if (Internal.goAround == 1) {
			Fma.armA.setValue("MAN");
			Fma.armB.setValue("G/A");
		} else {
			Fma.armA.setValue("");
			me.altArm();
		}
	},
	altArm: func() {
		if (Input.altArmed.getBoolValue()) {
			Fma.armB.setValue("ALT");
		} else {
			Fma.armB.setValue("");
		}
	},
	thr: func() {
		me.thrTemp = Output.thrMode.getValue();
		if (me.thrTemp == 3) {
			Fma.thrA.setValue("CLMP");
			if (systems.TRI.Limit.activeModeInt.getValue() == 5) {
				Fma.thrB.setValue("FLX"); # Handled by FMA.nas
			} else {
				Fma.thrB.setValue("");
			}
		} else if (me.thrTemp == 2) {
			Fma.thrA.setValue("EPR");
			if (systems.TRI.Limit.activeModeInt.getValue() == 5) {
				Fma.thrB.setValue("FLX"); # Handled by FMA.nas
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
	# Special stuff
	locUpdate: func() {
		updateFma.rollText = Text.lat.getValue();
		if (updateFma.rollText == "LOC") {
			if (abs(pts.Instrumentation.Nav.headingNeedleDeflectionNorm[Input.activeAp.getValue() - 1].getValue()) < 0.1) {
				locUpdateT.stop();
				Fma.rollB.setValue("TRK");
			} else {
				if (Fma.rollB.getValue() != "CAP") {
					Fma.rollB.setValue("CAP");
				}
			}
		} else {
			locUpdateT.stop();
		}
	},
	gsUpdate: func() {
		updateFma.pitchText = Text.vert.getValue();
		if (updateFma.pitchText == "G/S") {
			if (abs(pts.Instrumentation.Nav.gsNeedleDeflectionNorm[Input.activeAp.getValue() - 1].getValue()) < 0.1) {
				gsUpdateT.stop();
				Fma.pitchB.setValue("TRK");
			} else {
				if (Fma.pitchB.getValue() != "CAP") {
					Fma.pitchB.setValue("CAP");
				}
			}
		} else {
			gsUpdateT.stop();
		}
	},
};

var locUpdateT = maketimer(0.5, updateFma.locUpdate, updateFma);
var gsUpdateT = maketimer(0.5, updateFma.gsUpdate, updateFma);

setlistener("/it-autoflight/input/kts-mach", func() {
	updateFma.thr();
}, 0, 0);

setlistener("/it-autoflight/input/kts-mach-flch", func() {
	updateFma.pitch();
}, 0, 0);

setlistener("/instrumentation/nav[0]/nav-loc", func() {
	if (Input.activeAp.getValue() == 1) {
		updateFma.arm();
		updateFma.roll();
	}
}, 0, 0);

setlistener("/instrumentation/nav[1]/nav-loc", func() {
	if (Input.activeAp.getValue() == 2) {
		updateFma.arm();
		updateFma.roll();
	}
}, 0, 0);

setlistener("/it-autoflight/input/alt-armed", func() {
	updateFma.altArm();
}, 0, 0);

# Seperated the Autothrottle from ITAF because its very different from ITAF Core. So we do it here!
var Athr = {
	atsCmdRawPid: 0,
	ktsMach: 0,
	retard: 0,
	triMode: 0,
	vmaxTypeTemp: 0,
	loop: func() {
		me.triMode = systems.TRI.Limit.activeModeInt.getValue();
		Output.thrModeTemp = Output.thrMode.getValue();
		me.retard = Output.athr.getBoolValue() and Output.vert.getValue() != 7 and pts.Position.gearAglFt.getValue() <= 50 and Misc.flapDeg.getValue() >= 27.9 and me.triMode != 0 and me.triMode != 5;
		
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
		}
	},
	modeZeroCheck: func() {
		me.atsCmdRawPid = pts.Fdm.JSBsim.Engine.atsCmdRawPid.getValue();
		me.ktsMach = Input.ktsMach.getBoolValue();
		if (Input.mach.getValue() < pts.Fdm.JSBsim.Dfgs.Speeds.vminMach.getValue() and me.ktsMach) {
			Fma.thrA.setValue("ALFA");
			Fma.thrB.setValue("SPD");
		} else if (Input.kts.getValue() < pts.Fdm.JSBsim.Dfgs.Speeds.vmin.getValue() and !me.ktsMach) {
			Fma.thrA.setValue("ALFA");
			Fma.thrB.setValue("SPD");
		} else if (Input.mach.getValue() > pts.Fdm.JSBsim.Dfgs.Speeds.vmaxMach.getValue() and me.ktsMach) {
			me.setVmaxCheckFma();
		} else if (Input.kts.getValue() > pts.Fdm.JSBsim.Dfgs.Speeds.vmax.getValue() and !me.ktsMach) {
			me.setVmaxCheckFma();
		} else if (me.atsCmdRawPid >= systems.TRI.Control.athrMax[0].getValue() - 0.005 or me.atsCmdRawPid >= systems.TRI.Control.athrMax[1].getValue() - 0.005) {
			if (me.ktsMach) {
				Fma.thrA.setValue("MACH");
			} else {
				Fma.thrA.setValue("SPD");
			}
			Fma.thrB.setValue("ATL");
		} else if (me.atsCmdRawPid <= systems.TRI.Limit.idleNorm.getValue() + 0.005) {
			Fma.thrA.setValue("LOW");
			Fma.thrB.setValue("LIM");
		} else {
			if (me.ktsMach) {
				Fma.thrA.setValue("MACH");
				Fma.thrB.setValue(sprintf("%3.0f", dfgs.Input.mach.getValue() * 1000));
			} else {
				Fma.thrA.setValue("SPD");
				Fma.thrB.setValue(sprintf("%3.0f", dfgs.Input.kts.getValue()));
			}
		}
	},
	setVmaxCheckFma: func() {
		me.vmaxTypeTemp = pts.Fdm.JSBsim.Dfgs.Speeds.vmaxType.getValue();
		if (me.vmaxTypeTemp == 0) {
			Fma.thrA.setValue("VMO");
			Fma.thrB.setValue("LIM");
		} else if (me.vmaxTypeTemp == 1) {
			Fma.thrA.setValue("MMO");
			Fma.thrB.setValue("LIM");
		} else if (me.vmaxTypeTemp == 2) {
			Fma.thrA.setValue("SLAT");
			Fma.thrB.setValue("LIM");
		} else if (me.vmaxTypeTemp == 3) {
			Fma.thrA.setValue("FLAP");
			Fma.thrB.setValue("LIM");
		}
	},
	setMode: func(n) { # 0 Thrust, 1 Retard, 2 EPR Limit, 3 Clamp
		me.triMode = systems.TRI.Limit.activeModeInt.getValue();
		
		if (me.triMode == 0 or me.triMode == 5) {
			me.toCheck();
		} else if (!me.retard or dfgs.Output.vert.getValue() == 7) {
			Fma.stopBlink(0);
			Output.thrMode.setValue(n);
		}
		updateFma.thr();
	},
	toCheck: func() {
		if (Text.vert.getValue() == "T/O CLB") {
			if (pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue() < 60 and pts.Fdm.JSBsim.Position.wow.getBoolValue()) {
				if (Output.thrMode.getValue() != 2) {
					Fma.stopBlink(0);
					Output.thrMode.setValue(2);
					updateFma.thr();
				}
			} else {
				if (Internal.atrCmd.getBoolValue()) {
					systems.TRI.setMode(1);
					if (Output.thrMode.getValue() != 2) {
						Fma.stopBlink(0);
						Output.thrMode.setValue(2);
						updateFma.thr();
					}
				} else {
					if (Output.thrMode.getValue() != 3) {
						Output.thrMode.setValue(3);
						updateFma.thr();
						Fma.startBlink(0);
					}
				}
			}
		} else {
			if (Output.thrMode.getValue() != 3) {
				Output.thrMode.setValue(3);
				updateFma.thr();
				Fma.startBlink(0);
			}
		}
	},
	limitChanged: func(l, c) {
		if (l == "T/O" and c != "T/O") { # If last mode was T/O, and the new mode is not T/O, set EPR Lim
			me.setMode(2);
		}
		updateFma.thr()
	},
};
