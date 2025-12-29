# McDonnell Douglas MD-80 DFGS
# Copyright (c) 2025 Josh Davidson (Octal450)

var Main = {
	art: props.globals.getNode("/controls/dfgs/art"),
	artCover: props.globals.getNode("/controls/dfgs/covers/art"),
	bit1: props.globals.getNode("/systems/dfgs/bit-1/active"),
	bit2: props.globals.getNode("/systems/dfgs/bit-2/active"),
	nlgWowTimer20: props.globals.getNode("/systems/dfgs/nlg-timer-20/wow-timer"),
	powerAvail: props.globals.getNode("/systems/dfgs/power-avail"),
	powerAvailTemp: 0,
	stallAlphaDeg: props.globals.getNode("/systems/dfgs/stall-alpha-deg"),
	stickPusherActive: props.globals.getNode("/systems/dfgs/stick-pusher/active"),
};

var Speeds = {
	vmaxType: props.globals.getNode("/systems/dfgs/speeds/vmax-type"),
	vmax: props.globals.getNode("/systems/dfgs/speeds/vmax"),
	vmaxMach: props.globals.getNode("/systems/dfgs/speeds/vmax-mach"),
	vmin: props.globals.getNode("/systems/dfgs/speeds/vmin"),
	vmin90Percent: props.globals.getNode("/systems/dfgs/speeds/vmin-90-percent"),
	vminMach: props.globals.getNode("/systems/dfgs/speeds/vmin-mach"),
	vmoMmo: props.globals.getNode("/systems/dfgs/speeds/vmo-mmo"),
};

var Fma = {
	armA: props.globals.initNode("/instrumentation/fma/arm-mode-a", "", "STRING"),
	armB: props.globals.initNode("/instrumentation/fma/arm-mode-b", "", "STRING"),
	pitchA: props.globals.initNode("/instrumentation/fma/pitch-mode-a", "", "STRING"),
	pitchB: props.globals.initNode("/instrumentation/fma/pitch-mode-b", "", "STRING"),
	rollA: props.globals.initNode("/instrumentation/fma/roll-mode-a", "", "STRING"),
	rollB: props.globals.initNode("/instrumentation/fma/roll-mode-b", "", "STRING"),
	spdLow: 0,
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
		
		Output.vertTemp = Output.vert.getValue();
		if (Output.vertTemp != 4 and Output.vertTemp != 7 and !pts.Position.wow.getBoolValue()) {
			if (Velocities.indicatedAirspeedKt.getValue() <= Speeds.vmin90Percent.getValue()) {
				me.spdLow = 1;
			} else {
				me.spdLow = 0;
			}
		} else {
			me.spdLow = 0;
		}
	},
	startBlink: func(window) { # 0 THR, 1 ARM, 2 ROLL, 3 PITCH
		if (window == 0 and !Output.athr.getBoolValue()) return;
		me.Blink.time[window] = pts.Sim.Time.elapsedSec.getValue();
	},
	startLongBlink: func(window) { # 0 THR, 1 ARM, 2 ROLL, 3 PITCH
		if (window == 0 and !Output.athr.getBoolValue()) return;
		me.Blink.time[window] = 1000000000; # Really really long!
	},
	stopBlink: func(window) {
		me.Blink.time[window] = -5;
	},
};

var UpdateFma = {
	latText: "T/O",
	thrTemp: 0,
	vertText: "T/O CLB",
	capTrkReCheck: func() {
		me.locUpdate();
		locUpdateT.start();
		me.gsUpdate();
		gsUpdateT.start();
	},
	lat: func() {
		me.latText = Text.lat.getValue();
		if (me.latText == "HDG") {
			Fma.rollA.setValue("HDG");
			if (Output.hdgInHld.getBoolValue()) {
				Fma.rollB.setValue("HLD");
			} else {
				Fma.rollB.setValue("SEL");
			}
		} else if (me.latText == "LNAV") {
			Fma.rollA.setValue("NAV");
			Fma.rollB.setValue("TRK");
		} else if (me.latText == "LOC") {
			if (pts.Instrumentation.Nav.navLoc[Input.activeAp.getValue() - 1].getBoolValue()) {
				Fma.rollA.setValue("LOC");
			} else {
				Fma.rollA.setValue("VOR");
			}
			me.locUpdate();
			locUpdateT.start();
		} else if (me.latText == "LAND") {
			Fma.rollA.setValue("AUT");
			Fma.rollB.setValue("LND");
		} else if (me.latText == "ALIGN") {
			Fma.rollA.setValue("ALN");
			Fma.rollB.setValue("");
		} else if (me.latText == "ROLLOUT") {
			Fma.rollA.setValue("ROL");
			Fma.rollB.setValue("OUT");
		} else if (me.latText == "T/O") {
			Fma.rollA.setValue("TAK");
			Fma.rollB.setValue("OFF");
		} else if (me.latText == "G/A") {
			Fma.rollA.setValue("GO");
			Fma.rollB.setValue("RND");
		} else if (me.latText == "LVL") {
			Fma.rollA.setValue("WNG");
			Fma.rollB.setValue("LVL");
		}
	},
	vert: func() {
		me.vertText = Text.vert.getValue();
		if (me.vertText == "FLCH") { # Replaces SPD CLB/DES from ITAF Core
			if (Input.ktsMachFlch.getBoolValue()) {
				Fma.pitchA.setValue("MACH");
				Fma.pitchB.setValue("");
			} else {
				Fma.pitchA.setValue("IAS");
				Fma.pitchB.setValue("");
			}
		} else if (me.vertText == "T/O CLB") {
			Fma.pitchA.setValue("TAK");
			Fma.pitchB.setValue("OFF");
		} else if (me.vertText == "G/A CLB") {
			Fma.pitchA.setValue("GO");
			Fma.pitchB.setValue("RND");
		} else if (me.vertText == "ALT HLD") {
			Fma.pitchA.setValue("ALT");
			Fma.pitchB.setValue("HLD");
		} else if (me.vertText == "ALT CAP") {
			Fma.pitchA.setValue("ALT");
			Fma.pitchB.setValue("CAP");
		} else if (me.vertText == "V/S") {
			if (Internal.vsAltActive.getBoolValue()) {
				Fma.pitchA.setValue("ALT");
				Fma.pitchB.setValue("HLD");
			} else {
				Fma.pitchA.setValue("VERT");
				Fma.pitchB.setValue("SPD");
			}
		} else if (me.vertText == "G/S") {
			Fma.pitchA.setValue("G/S");
			me.gsUpdate();
			gsUpdateT.start();
		} else if (me.vertText == "LAND") {
			Fma.pitchA.setValue("AUT");
			Fma.pitchB.setValue("LND");
			me.arm(); # Clear LND
		} else if (me.vertText == "NO FLARE") {
			Fma.pitchA.setValue("NO");
			Fma.pitchB.setValue("FLR");
		} else if (me.vertText == "FLARE") {
			Fma.pitchA.setValue("FLAR");
			Fma.pitchB.setValue("");
		} else if (me.vertText == "ROLLOUT") {
			Fma.pitchA.setValue("ROL");
			Fma.pitchB.setValue("OUT");
		} else if (me.vertText == "PITCH") {
			Fma.pitchA.setValue("TURB");
			Fma.pitchB.setValue("");
		}
	},
	arm: func() {
		me.vertText = Text.vert.getValue();
		if (Input.autoLand.getBoolValue() and me.vertText != "LAND" and me.vertText != "ROLLOUT") {
			Fma.armA.setValue("LND");
			me.altArm();
		} else if (Output.gsArm.getBoolValue()) {
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
			if (systems.THRLIM.Limit.activeModeInt.getValue() == 5) {
				Fma.thrB.setValue("FLX"); # Handled by FMA.nas
			} else {
				Fma.thrB.setValue("");
			}
		} else if (me.thrTemp == 2) {
			Fma.thrA.setValue("EPR");
			if (systems.THRLIM.Limit.activeModeInt.getValue() == 5) {
				Fma.thrB.setValue("FLX"); # Handled by FMA.nas
			} else {
				Fma.thrB.setValue(systems.THRLIM.Limit.activeMode.getValue());
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
		UpdateFma.latText = Text.lat.getValue();
		if (UpdateFma.latText == "LOC") {
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
		UpdateFma.vertText = Text.vert.getValue();
		if (UpdateFma.vertText == "G/S") {
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

var locUpdateT = maketimer(0.5, UpdateFma.locUpdate, UpdateFma);
var gsUpdateT = maketimer(0.5, UpdateFma.gsUpdate, UpdateFma);

setlistener("/it-autoflight/input/kts-mach", func() {
	UpdateFma.thr();
}, 0, 0);

setlistener("/it-autoflight/input/kts-mach-flch", func() {
	UpdateFma.vert();
}, 0, 0);

setlistener("/instrumentation/nav[0]/nav-loc", func() {
	if (Input.activeAp.getValue() == 1) {
		UpdateFma.arm();
		UpdateFma.lat();
	}
}, 0, 0);

setlistener("/instrumentation/nav[1]/nav-loc", func() {
	if (Input.activeAp.getValue() == 2) {
		UpdateFma.arm();
		UpdateFma.lat();
	}
}, 0, 0);

setlistener("/it-autoflight/input/alt-armed", func() {
	UpdateFma.arm();
}, 0, 0);

# Seperated the Autothrottle from ITAF because its very different from ITAF Core. So we do it here!
var Athr = {
	ktsMach: 0,
	retard: 0,
	throttlePid: props.globals.initNode("/it-autoflight/internal/throttle-cmd-raw-shape", 0, "DOUBLE"),
	throttlePidTemp: 0,
	triMode: 0,
	vmaxTypeTemp: 0,
	loop: func() {
		me.triMode = systems.THRLIM.Limit.activeModeInt.getValue();
		Output.thrModeTemp = Output.thrMode.getValue();
		Output.vertTemp = Output.vert.getValue();
		me.retard = Output.athr.getBoolValue() and Output.vertTemp != 7 and Output.vertTemp != 8 and pts.Position.gearAglFt.getValue() <= 50 and Misc.flapDeg.getValue() >= 27.9 and me.triMode != 0 and me.triMode != 5;
		
		if (Output.thrModeTemp == 0) { # Update it as the UpdateFma only does it once
			me.modeZeroCheck();
		}
		
		if (me.triMode == 0 or me.triMode == 5) {
			me.toCheck();
		} else if (me.retard) {
			if (Output.thrMode.getValue() != 1) {
				Output.thrMode.setValue(1);
				UpdateFma.thr();
			}
		}
	},
	modeZeroCheck: func() {
		me.ktsMach = Input.ktsMach.getBoolValue();
		me.throttlePidTemp = me.throttlePid.getValue();
		if (Input.mach.getValue() < Speeds.vminMach.getValue() - 0.0000001 and me.ktsMach) {
			Fma.thrA.setValue("ALFA");
			Fma.thrB.setValue("SPD");
		} else if (Input.kts.getValue() < Speeds.vmin.getValue() and !me.ktsMach) {
			Fma.thrA.setValue("ALFA");
			Fma.thrB.setValue("SPD");
		} else if (Input.mach.getValue() > Speeds.vmaxMach.getValue() + 0.0000001 and me.ktsMach) {
			me.setVmaxCheckFma();
		} else if (Input.kts.getValue() > Speeds.vmax.getValue() and !me.ktsMach) {
			me.setVmaxCheckFma();
		} else if (me.throttlePidTemp >= systems.THRLIM.Control.atsMax[0].getValue() - 0.005 or me.throttlePidTemp >= systems.THRLIM.Control.atsMax[1].getValue() - 0.005) {
			if (me.ktsMach) {
				Fma.thrA.setValue("MACH");
			} else {
				Fma.thrA.setValue("SPD");
			}
			Fma.thrB.setValue("ATL");
		} else if (me.throttlePidTemp <= systems.THRLIM.Limit.idleNorm.getValue() + 0.005) {
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
		me.vmaxTypeTemp = Speeds.vmaxType.getValue();
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
		me.triMode = systems.THRLIM.Limit.activeModeInt.getValue();
		Output.vertTemp = Output.vert.getValue();
		
		if (me.triMode == 0 or me.triMode == 5) {
			me.toCheck();
		} else if (!me.retard or Output.vertTemp == 7 or Output.vertTemp == 8) {
			Fma.stopBlink(0);
			Output.thrMode.setValue(n);
		}
		UpdateFma.thr();
	},
	toCheck: func() {
		if (Output.vert.getValue() == 7) {
			if (pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue() < 60 and pts.Position.wow.getBoolValue()) {
				if (Output.thrMode.getValue() != 2) {
					Fma.stopBlink(0);
					Output.thrMode.setValue(2);
					UpdateFma.thr();
				}
			} else {
				if (Internal.atrCmd.getBoolValue()) {
					systems.THRLIM.setMode(1);
					if (Output.thrMode.getValue() != 2) {
						Fma.stopBlink(0);
						Output.thrMode.setValue(2);
						UpdateFma.thr();
					}
				} else {
					if (Output.thrMode.getValue() != 3) {
						Output.thrMode.setValue(3);
						UpdateFma.thr();
						Fma.startBlink(0);
					}
				}
			}
		} else {
			if (Output.thrMode.getValue() != 3) {
				Output.thrMode.setValue(3);
				UpdateFma.thr();
				Fma.startBlink(0);
			}
		}
	},
	limitChanged: func(l, c) {
		if ((l == "T/O" or l == "FLX") and (c != "T/O" and c != "FLX")) { # If last mode was T/O or FLX, and the new mode is not T/O or FLX, set EPR Lim
			me.setMode(2);
		}
		UpdateFma.thr();
	},
};
