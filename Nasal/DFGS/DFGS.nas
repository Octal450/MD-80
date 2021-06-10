# McDonnell Douglas MD-80 DFGS AFS
# Based off IT-AUTOFLIGHT System Controller V4.0.X
# Copyright (c) 2021 Josh Davidson (Octal450)
# This file DOES NOT integrate with Property Tree Setup
# That way, we can update it from generic IT-AUTOFLIGHT easily

# Initialize all used variables and property nodes
# Sim
var Controls = {
	aileron: props.globals.getNode("/controls/flight/aileron", 1),
	elevator: props.globals.getNode("/controls/flight/elevator", 1),
	rudder: props.globals.getNode("/controls/flight/rudder", 1),
};

var Engines = {
	reverserNorm: [props.globals.getNode("/engines/engine[0]/reverser-pos-norm", 1), props.globals.getNode("/engines/engine[1]/reverser-pos-norm", 1)],
};

var FPLN = {
	active: props.globals.getNode("/autopilot/route-manager/active", 1),
	activeTemp: 0,
	currentCourse: 0,
	currentWp: props.globals.getNode("/autopilot/route-manager/current-wp", 1),
	currentWpTemp: 0,
	deltaAngle: 0,
	deltaAngleRad: 0,
	distCoeff: 0,
	maxBank: 0,
	maxBankLimit: 0,
	nextCourse: 0,
	num: props.globals.getNode("/autopilot/route-manager/route/num", 1),
	numTemp: 0,
	R: 0,
	radius: 0,
	turnDist: 0,
	wp0Dist: props.globals.getNode("/autopilot/route-manager/wp/dist", 1),
	wpFlyFrom: 0,
	wpFlyTo: 0,
};

var Gear = {
	wow0: props.globals.getNode("/gear/gear[0]/wow", 1),
	wow0Timer: props.globals.getNode("/gear/gear[0]/wow-timer", 1),
	wow1: props.globals.getNode("/gear/gear[1]/wow", 1),
	wow1Temp: 1,
	wow2: props.globals.getNode("/gear/gear[2]/wow", 1),
	wow2Temp: 1,
};

var Misc = {
	efis0Trk: props.globals.getNode("/instrumentation/efis[0]/hdg-trk-selected", 1),
	efis1Trk: props.globals.getNode("/instrumentation/efis[1]/hdg-trk-selected", 1),
	flapDeg: props.globals.getNode("/fdm/jsbsim/fcs/flap-pos-deg", 1),
	flapDegTemp: 0,
};

var Position = {
	gearAglFtTemp: 0,
	gearAglFt: props.globals.getNode("/position/gear-agl-ft", 1),
	indicatedAltitudeFt: props.globals.getNode("/instrumentation/altimeter/indicated-altitude-ft", 1),
	indicatedAltitudeFtTemp: 0,
};

var Radio = {
	gsDefl: [props.globals.getNode("/instrumentation/nav[0]/gs-needle-deflection-norm", 1), props.globals.getNode("/instrumentation/nav[1]/gs-needle-deflection-norm", 1)],
	gsDeflTemp: 0,
	inRange: [props.globals.getNode("/instrumentation/nav[0]/in-range", 1), props.globals.getNode("/instrumentation/nav[1]/in-range", 1)],
	inRangeTemp: 0,
	locDefl: [props.globals.getNode("/instrumentation/nav[0]/heading-needle-deflection-norm", 1), props.globals.getNode("/instrumentation/nav[1]/heading-needle-deflection-norm", 1)],
	locDeflTemp: 0,
	radioSel: 0,
	signalQuality: [props.globals.getNode("/instrumentation/nav[0]/signal-quality-norm", 1), props.globals.getNode("/instrumentation/nav[1]/signal-quality-norm", 1)],
	signalQualityTemp: 0,
};

var Velocities = {
	groundspeedKt: props.globals.getNode("/velocities/groundspeed-kt", 1),
	groundspeedMps: 0,
	indicatedAirspeedKt: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-speed-kt", 1),
	indicatedMach: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-mach", 1),
	trueAirspeedKt: props.globals.getNode("/instrumentation/airspeed-indicator/true-speed-kt", 1),
	trueAirspeedKtTemp: 0,
};

# IT-AUTOFLIGHT
var Fd = {
	pitchBar: props.globals.initNode("/it-autoflight/fd/pitch-bar", 0, "DOUBLE"),
	rollBar: props.globals.initNode("/it-autoflight/fd/roll-bar", 0, "DOUBLE"),
};

var Input = {
	activeAp: props.globals.initNode("/it-autoflight/input/active-ap", 1, "INT"),
	altArmed: props.globals.initNode("/it-autoflight/input/alt-armed", 0, "BOOL"),
	alt: props.globals.initNode("/it-autoflight/input/alt", 10000, "INT"),
	ap1: props.globals.initNode("/it-autoflight/input/ap1", 0, "BOOL"),
	ap2: props.globals.initNode("/it-autoflight/input/ap2", 0, "BOOL"),
	autoLand: props.globals.initNode("/it-autoflight/input/auto-land", 0, "BOOL"),
	autoLandTemp: 0,
	athr: props.globals.initNode("/it-autoflight/input/athr", 0, "BOOL"),
	altDiff: 0,
	bankLimitSw: props.globals.initNode("/it-autoflight/input/bank-limit-sw", 4, "INT"), # 30
	bankLimitSwTemp: 0,
	fd1: props.globals.initNode("/it-autoflight/input/fd1", 0, "BOOL"),
	fd2: props.globals.initNode("/it-autoflight/input/fd2", 0, "BOOL"),
	fpa: props.globals.initNode("/it-autoflight/input/fpa", 0, "DOUBLE"),
	fpaAbs: props.globals.initNode("/it-autoflight/input/fpa-abs", 0, "DOUBLE"), # Set by property rule
	hdg: props.globals.initNode("/it-autoflight/input/hdg", 0, "INT"),
	hdgCalc: 0,
	kts: props.globals.initNode("/it-autoflight/input/kts", 100, "INT"),
	ktsFlch: props.globals.initNode("/it-autoflight/input/kts-flch", 100, "INT"),
	ktsMach: props.globals.initNode("/it-autoflight/input/kts-mach", 0, "BOOL"),
	ktsMachFlch: props.globals.initNode("/it-autoflight/input/kts-mach-flch", 0, "BOOL"),
	lat: props.globals.initNode("/it-autoflight/input/lat", 3, "INT"),
	latTemp: 3,
	mach: props.globals.initNode("/it-autoflight/input/mach", 0.5, "DOUBLE"),
	machFlch: props.globals.initNode("/it-autoflight/input/mach-flch", 0.5, "DOUBLE"),
	toga: props.globals.initNode("/it-autoflight/input/toga", 0, "BOOL"),
	trk: props.globals.initNode("/it-autoflight/input/trk", 0, "BOOL"),
	trueCourse: props.globals.initNode("/it-autoflight/input/true-course", 0, "BOOL"),
	vs: props.globals.initNode("/it-autoflight/input/vs", 0, "INT"),
	vsAbs: props.globals.initNode("/it-autoflight/input/vs-abs", 0, "INT"), # Set by property rule
	vert: props.globals.initNode("/it-autoflight/input/vert", 1, "INT"),
	vertTemp: 1,
};

var Internal = {
	alt: props.globals.initNode("/it-autoflight/internal/alt", 10000, "INT"),
	altCaptureActive: 0,
	altDiff: 0,
	altTemp: 0,
	altPredicted: props.globals.initNode("/it-autoflight/internal/altitude-predicted", 0, "DOUBLE"),
	bankLimit: props.globals.initNode("/it-autoflight/internal/bank-limit", 30, "INT"),
	bankLimitMax: [10, 15, 20, 25, 30],
	captVs: 0,
	canAutoland: 0,
	driftAngle: props.globals.initNode("/it-autoflight/internal/drift-angle-deg", 0, "DOUBLE"),
	flchActive: 0,
	fpa: props.globals.initNode("/it-autoflight/internal/fpa", 0, "DOUBLE"),
	goAround: 0, # 0 Off, 1 MAN G/A, 2 FD G/A, 3 AUT G/A
	hdgErrorDeg: props.globals.initNode("/it-autoflight/internal/heading-error-deg", 0, "DOUBLE"),
	hdgHldTarget: props.globals.initNode("/it-autoflight/internal/hdg-hld-target", 360, "INT"),
	hdgPredicted: props.globals.initNode("/it-autoflight/internal/heading-predicted", 0, "DOUBLE"),
	landModeActive: 0,
	lnavAdvanceNm: props.globals.initNode("/it-autoflight/internal/lnav-advance-nm", 0, "DOUBLE"),
	minVs: props.globals.initNode("/it-autoflight/internal/min-vs", -500, "INT"),
	maxVs: props.globals.initNode("/it-autoflight/internal/max-vs", 500, "INT"),
	togaKts: props.globals.initNode("/it-autoflight/internal/toga-kts", 150, "INT"),
	vs: props.globals.initNode("/it-autoflight/internal/vert-speed-fpm", 0, "DOUBLE"),
	vsTemp: 0,
};

var Output = {
	ap1: props.globals.initNode("/it-autoflight/output/ap1", 0, "BOOL"),
	ap1Temp: 0,
	ap2: props.globals.initNode("/it-autoflight/output/ap2", 0, "BOOL"),
	ap2Temp: 0,
	apprArm: props.globals.initNode("/it-autoflight/output/appr-armed", 0, "BOOL"),
	athr: props.globals.initNode("/it-autoflight/output/athr", 0, "BOOL"),
	athrTemp: 0,
	clamp: props.globals.initNode("/it-autoflight/output/clamp", 0, "BOOL"),
	fd1: props.globals.initNode("/it-autoflight/output/fd1", 0, "BOOL"),
	fd1Temp: 0,
	fd2: props.globals.initNode("/it-autoflight/output/fd2", 0, "BOOL"),
	fd2Temp: 0,
	hdgInHld: props.globals.initNode("/it-autoflight/output/hdg-in-hld", 1, "BOOL"),
	lat: props.globals.initNode("/it-autoflight/output/lat", 0, "INT"),
	latTemp: 0,
	lnavArm: props.globals.initNode("/it-autoflight/output/lnav-armed", 0, "BOOL"),
	locArm: props.globals.initNode("/it-autoflight/output/loc-armed", 0, "BOOL"),
	thrMode: props.globals.initNode("/it-autoflight/output/thr-mode", 3, "INT"),
	thrModeTemp: 3,
	vert: props.globals.initNode("/it-autoflight/output/vert", 1, "INT"),
	vertTemp: 1,
};

var Text = {
	lat: props.globals.initNode("/it-autoflight/mode/lat", "HDG", "STRING"),
	vert: props.globals.initNode("/it-autoflight/mode/vert", "V/S", "STRING"),
	vertTemp: "V/S",
};

var Sound = {
	apOff: props.globals.initNode("/it-autoflight/sound/apoff", 0, "BOOL"),
	enableApOff: 0,
};

var ITAF = {
	init: func(t = 0) { # Not everything should be reset if the reset is type 1
		if (t != 1) {
			Input.alt.setValue(10000);
			Input.bankLimitSw.setValue(4); # 30
			Input.hdg.setValue(360);
			Input.ktsMach.setBoolValue(0);
			Input.ktsMachFlch.setBoolValue(0);
			Input.kts.setValue(100);
			Input.ktsFlch.setValue(100);
			Input.mach.setValue(0.5);
			Input.machFlch.setValue(0.5);
			Input.trk.setBoolValue(0);
			Input.trueCourse.setBoolValue(0);
			Input.activeAp.setValue(1);
		}
		Input.ap1.setBoolValue(0);
		Input.ap2.setBoolValue(0);
		me.updateAutoLand(0);
		Input.athr.setBoolValue(0);
		if (t != 1) {
			Input.fd1.setBoolValue(0);
			Input.fd2.setBoolValue(0);
		}
		Input.vs.setValue(0);
		Input.fpa.setValue(0);
		Input.altArmed.setBoolValue(0);
		Input.lat.setValue(3);
		Input.vert.setValue(1);
		Input.toga.setBoolValue(0);
		Output.ap1.setBoolValue(0);
		Output.ap2.setBoolValue(0);
		Output.athr.setBoolValue(0);
		if (t != 1) {
			Output.fd1.setBoolValue(0);
			Output.fd2.setBoolValue(0);
		}
		Output.hdgInHld.setBoolValue(1);
		me.updateLnavArm(0);
		me.updateLocArm(0);
		me.updateApprArm(0);
		Output.lat.setValue(0);
		Output.vert.setValue(1);
		Internal.minVs.setValue(-500);
		Internal.maxVs.setValue(500);
		Internal.alt.setValue(10000);
		Internal.altCaptureActive = 0;
		updateFma.thr();
		updateFma.arm();
		me.updateLatText("HDG");
		me.updateVertText("V/S");
		loopTimer.start();
		slowLoopTimer.start();
	},
	loop: func() {
		Output.latTemp = Output.lat.getValue();
		Output.vertTemp = Output.vert.getValue();
		Output.ap1Temp = Output.ap1.getBoolValue();
		Output.ap2Temp = Output.ap2.getBoolValue();
		
		# VOR/ILS Revision
		if (Output.latTemp == 2 or Output.latTemp == 4 or Output.vertTemp == 2 or Output.vertTemp == 6) {
			me.checkRadioRevision(Output.latTemp, Output.vertTemp);
		}
		
		Gear.wow1Temp = Gear.wow1.getBoolValue();
		Gear.wow2Temp = Gear.wow2.getBoolValue();
		Output.latTemp = Output.lat.getValue();
		Output.vertTemp = Output.vert.getValue();
		Text.vertTemp = Text.vert.getValue();
		Position.gearAglFtTemp = Position.gearAglFt.getValue();
		Internal.vsTemp = Internal.vs.getValue();
		Position.indicatedAltitudeFtTemp = Position.indicatedAltitudeFt.getValue();
		
		# LNAV Engagement
		if (Output.lnavArm.getBoolValue()) {
			me.checkLnav(1);
		}
		
		# VOR/LOC or ILS/LOC Capture
		if (Output.locArm.getBoolValue()) {
			me.checkLoc(1);
		}
		
		# G/S Capture
		if (Output.apprArm.getBoolValue()) {
			me.checkAppr(1);
		}
		
		# Autoland Logic
		Input.autoLandTemp = Input.autoLand.getBoolValue();
		if (Output.ap1Temp or Output.ap2Temp) {
			if ((Output.vertTemp == 2 or Output.vertTemp == 6) and Input.autoLandTemp) {
				Radio.radioSel = Input.activeAp.getValue() - 1;
				Radio.locDeflTemp = Radio.locDefl[Radio.radioSel].getValue();
				Radio.signalQualityTemp = Radio.signalQuality[Radio.radioSel].getValue();
				Internal.canAutoland = (abs(Radio.locDeflTemp) <= 0.1 and Radio.locDeflTemp != 0 and Radio.signalQualityTemp >= 0.99) or Gear.wow0.getBoolValue();
			} else {
				Internal.canAutoland = 0;
			}
		} else {
			Internal.canAutoland = 0;
			if (Input.autoLandTemp) {
				me.updateAutoLand(0);
			}
		}
		
		if (Internal.canAutoland) {
			if (Output.vertTemp == 2) {
				if (Position.gearAglFtTemp <= 1500 and Position.gearAglFtTemp >= 5) {
					if (Output.latTemp != 4 and Text.lat.getValue() != "LAND") {
						me.updateLatText("LAND");
					}
					if (Text.vert.getValue() != "LAND") {
						me.updateVertText("LAND");
					}
				}
				if (Position.gearAglFtTemp <= 100 and Position.gearAglFtTemp >= 5) {
					me.setVertMode(6);
				}
			} else if (Output.vertTemp == 6) {
				if (Position.gearAglFtTemp <= 50 and Position.gearAglFtTemp >= 5 and Text.vert.getValue() != "FLARE") {
					me.updateVertText("FLARE");
				}
				if (Gear.wow1Temp and Gear.wow2Temp and Text.vert.getValue() != "ROLLOUT") {
					me.updateLatText("RLOU");
					me.updateVertText("ROLLOUT");
				}
			}
			if (Output.latTemp == 2) { # After pitch or else the cockpit indications will be wonky
				if (Position.gearAglFtTemp <= 150) {
					me.setLatMode(4);
				}
			}
		} else {
			if (Output.vertTemp == 2) {
				if (Output.ap1Temp or Output.ap2Temp) {
					if (Position.gearAglFtTemp <= 100 and Position.gearAglFtTemp >= 5) {
						me.updateVertText("NO FLARE");
					}
				} else if (Text.vert.getValue() == "NO FLARE") {
					me.updateVertText("G/S");
				}
			}
			if (Output.latTemp == 4 or Output.vertTemp == 6) {
				me.activateLoc();
				me.activateGs();
			}
		}
		
		# Go Around Arm
		if (Gear.wow0Timer.getValue() < 1 and Output.vertTemp != 7 and Position.gearAglFtTemp < 1500 and Misc.flapDeg.getValue() >= 25.9) {
			if (Output.ap1Temp or Output.ap2Temp) {
				if (Internal.goAround != 3) {
					Internal.goAround = 3;
					updateFma.arm();
				}
			} else {
				if (Internal.goAround != 2) {
					Internal.goAround = 2;
					updateFma.arm();
				}
			}
		} else {
			if (Internal.goAround != 0) {
				Internal.goAround = 0;
				updateFma.arm();
			}
		}
		
		
		# Altitude Capture/Sync Logic
		if (Output.vertTemp != 0) {
			Internal.alt.setValue(Input.alt.getValue());
		}
		Internal.altTemp = Internal.alt.getValue();
		Internal.altDiff = Internal.altTemp - Position.indicatedAltitudeFtTemp;
		
		if (Input.altArmed.getBoolValue()) {
			if (Output.vertTemp != 0 and Output.vertTemp != 2 and Output.vertTemp != 6) {
				Internal.captVs = math.clamp(math.round(abs(Internal.vs.getValue()) / 5, 100), 50, 2500); # Capture limits
				if (abs(Internal.altDiff) <= Internal.captVs and !Gear.wow1Temp and !Gear.wow2Temp) {
					if (Internal.altTemp >= Position.indicatedAltitudeFtTemp and Internal.vsTemp >= -25) { # Don't capture if we are going the wrong way
						me.setVertMode(3);
					} else if (Internal.altTemp < Position.indicatedAltitudeFtTemp and Internal.vsTemp <= 25) { # Don't capture if we are going the wrong way
						me.setVertMode(3);
					}
				}
			} else { # If armed and in 0 2 or 6 mode, disarm
				Input.altArmed.setBoolValue(0);
			}
		}
		
		# Altitude Hold Min/Max Reset
		if (Internal.altCaptureActive) {
			if (abs(Internal.altDiff) <= 25 and Text.vert.getValue() != "ALT HLD") {
				me.resetClimbRateLim();
				me.updateVertText("ALT HLD");
			}
		}
		
		# Autothrottle Update
		Athr.loop();
		
		# Trip system off
		if (Output.ap1Temp == 1 or Output.ap2Temp == 1) { 
			if (abs(Controls.aileron.getValue()) >= 0.2 or abs(Controls.elevator.getValue()) >= 0.2 or pts.Fdm.JSBsim.Dfgs.StickPusher.active.getBoolValue()) {
				me.ap1Master(0);
				me.ap2Master(0);
			}
		}
	},
	slowLoop: func() {
		Input.bankLimitSwTemp = Input.bankLimitSw.getValue();
		Velocities.trueAirspeedKtTemp = Velocities.trueAirspeedKt.getValue();
		FPLN.activeTemp = FPLN.active.getValue();
		FPLN.currentWpTemp = FPLN.currentWp.getValue();
		FPLN.numTemp = FPLN.num.getValue();
		
		# Bank Limit
		Internal.bankLimit.setValue(Internal.bankLimitMax[Input.bankLimitSwTemp]); # Non auto
		
		# If in LNAV mode and route is not longer active, switch to HDG HLD
		if (Output.lat.getValue() == 1) { # Only evaulate the rest of the condition if we are in LNAV mode
			if (FPLN.num.getValue() == 0 or !FPLN.active.getBoolValue()) {
				me.setLatMode(3);
			}
		}
		
		# Waypoint Advance Logic
		if (FPLN.numTemp > 0 and FPLN.activeTemp == 1) {
			if ((FPLN.currentWpTemp + 1) < FPLN.numTemp) {
				Velocities.groundspeedMps = Velocities.groundspeedKt.getValue() * 0.5144444444444;
				FPLN.wpFlyFrom = FPLN.currentWpTemp;
				if (FPLN.wpFlyFrom < 0) {
					FPLN.wpFlyFrom = 0;
				}
				FPLN.currentCourse = getprop("/autopilot/route-manager/route/wp[" ~ FPLN.wpFlyFrom ~ "]/leg-bearing-true-deg"); # Best left at getprop
				FPLN.wpFlyTo = FPLN.currentWpTemp + 1;
				if (FPLN.wpFlyTo < 0) {
					FPLN.wpFlyTo = 0;
				}
				FPLN.nextCourse = getprop("/autopilot/route-manager/route/wp[" ~ FPLN.wpFlyTo ~ "]/leg-bearing-true-deg"); # Best left at getprop
				FPLN.maxBankLimit = Internal.bankLimit.getValue();

				FPLN.deltaAngle = math.abs(geo.normdeg180(FPLN.currentCourse - FPLN.nextCourse));
				FPLN.maxBank = FPLN.deltaAngle * 1.5;
				if (FPLN.maxBank > FPLN.maxBankLimit) {
					FPLN.maxBank = FPLN.maxBankLimit;
				}
				FPLN.radius = (Velocities.groundspeedMps * Velocities.groundspeedMps) / (9.81 * math.tan(FPLN.maxBank / 57.2957795131));
				FPLN.deltaAngleRad = (180 - FPLN.deltaAngle) / 114.5915590262;
				FPLN.R = FPLN.radius / math.sin(FPLN.deltaAngleRad);
				FPLN.distCoeff = FPLN.deltaAngle * -0.011111 + 2;
				if (FPLN.distCoeff < 1) {
					FPLN.distCoeff = 1;
				}
				FPLN.turnDist = math.cos(FPLN.deltaAngleRad) * FPLN.R * FPLN.distCoeff / 1852;
				if (Gear.wow0.getBoolValue() and FPLN.turnDist < 1) {
					FPLN.turnDist = 1;
				}
				Internal.lnavAdvanceNm.setValue(FPLN.turnDist);
				
				if (FPLN.wp0Dist.getValue() <= FPLN.turnDist and flightplan().getWP(FPLN.currentWp.getValue()).fly_type == "flyBy") { # Don't care unless we are flyBy-ing
					FPLN.currentWp.setValue(FPLN.currentWpTemp + 1);
				}
			}
		}
		
		# Reset system once flight complete
		Output.latTemp = Output.lat.getValue();
		Output.vertTemp = Output.vert.getValue();
		if (!Output.ap1.getBoolValue() and !Output.ap2.getBoolValue() and Gear.wow0.getBoolValue() and Velocities.groundspeedKt.getValue() < 80 and (Output.latTemp == 2 or Output.latTemp == 4 or Output.vertTemp == 2 or Output.vertTemp == 6)) {
			me.init(1);
		}
	},
	ap1Master: func(s) {
		if (s == 1) {
			if (Output.vert.getValue() != 6 and !Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue()) {
				if (!Output.fd1.getBoolValue() and !Output.fd2.getBoolValue() and !Output.ap1.getBoolValue() and !Output.ap2.getBoolValue()) {
					me.setLatMode(3); # HDG HOLD
					if (abs(Internal.vs.getValue()) > 75) {
						me.setVertMode(1); # V/S
					} else {
						me.setVertMode(0); # HOLD
					}
				}
				Controls.rudder.setValue(0);
				Output.ap1.setBoolValue(1);
				Sound.enableApOff = 1;
				Sound.apOff.setBoolValue(0);
			}
		} else {
			Output.ap1.setBoolValue(0);
			me.apOffFunction();
		}
		Output.ap1Temp = Output.ap1.getBoolValue();
		if (Input.ap1.getBoolValue() != Output.ap1Temp) {
			Input.ap1.setBoolValue(Output.ap1Temp);
		}
	},
	ap2Master: func(s) {
		if (s == 1) {
			if (Output.vert.getValue() != 6 and !Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue()) {
				if (!Output.fd1.getBoolValue() and !Output.fd2.getBoolValue() and !Output.ap1.getBoolValue() and !Output.ap2.getBoolValue()) {
					me.setLatMode(3); # HDG HOLD
					if (abs(Internal.vs.getValue()) > 75) {
						me.setVertMode(1); # V/S
					} else {
						me.setVertMode(0); # HOLD
					}
				}
				Controls.rudder.setValue(0);
				Output.ap2.setBoolValue(1);
				Sound.enableApOff = 1;
				Sound.apOff.setBoolValue(0);
			}
		} else {
			Output.ap2.setBoolValue(0);
			me.apOffFunction();
		}
		Output.ap2Temp = Output.ap2.getBoolValue();
		if (Input.ap2.getBoolValue() != Output.ap2Temp) {
			Input.ap2.setBoolValue(Output.ap2Temp);
		}
	},
	apOffFunction: func() {
		if (!Output.ap1.getBoolValue() and !Output.ap2.getBoolValue()) { # Only do if both APs are off
			if (Text.vert.getValue() == "ROLLOUT") {
				me.init(1);
			}
			if (Sound.enableApOff) {
				Sound.apOff.setBoolValue(1);
				Sound.enableApOff = 0;
			}
		}
	},
	athrMaster: func(s) {
		if (s == 1) {
			Output.thrModeTemp = Output.thrMode.getValue();
			if (Output.thrModeTemp == 1 or Output.thrModeTemp == 2) {
				Athr.setMode(3); # Clamp
			}
			Output.athr.setBoolValue(1);
		} else {
			Output.athr.setBoolValue(0);
		}
		Output.athrTemp = Output.athr.getBoolValue();
		if (Input.athr.getBoolValue() != Output.athrTemp) {
			Input.athr.setBoolValue(Output.athrTemp);
		}
	},
	fd1Master: func(s) {
		if (s == 1) {
			if (!Output.fd1.getBoolValue() and !Output.fd2.getBoolValue() and !Output.ap1.getBoolValue() and !Output.ap2.getBoolValue()) {
				me.setLatMode(3); # HDG HOLD
					if (abs(Internal.vs.getValue()) > 75) {
					me.setVertMode(1); # V/S
				} else {
					me.setVertMode(0); # HOLD
				}
			}
			Output.fd1.setBoolValue(1);
		} else {
			if (!Output.fd1.getBoolValue() and !Output.fd2.getBoolValue() and !Output.ap1.getBoolValue() and !Output.ap2.getBoolValue()) {
				me.setLatMode(3); # HDG HOLD
					if (abs(Internal.vs.getValue()) > 75) {
					me.setVertMode(1); # V/S
				} else {
					me.setVertMode(0); # HOLD
				}
			}
			Output.fd1.setBoolValue(0);
		}
		Output.fd1Temp = Output.fd1.getBoolValue();
		if (Input.fd1.getBoolValue() != Output.fd1Temp) {
			Input.fd1.setBoolValue(Output.fd1Temp);
		}
	},
	fd2Master: func(s) {
		if (s == 1) {
			Output.fd2.setBoolValue(1);
		} else {
			Output.fd2.setBoolValue(0);
		}
		Output.fd2Temp = Output.fd2.getBoolValue();
		if (Input.fd2.getBoolValue() != Output.fd2Temp) {
			Input.fd2.setBoolValue(Output.fd2Temp);
		}
	},
	setLatMode: func(n) {
		Output.vertTemp = Output.vert.getValue();
		if (n == 0) { # HDG SEL
			me.updateLnavArm(0);
			me.updateLocArm(0);
			me.updateApprArm(0);
			Output.hdgInHld.setBoolValue(0);
			Output.lat.setValue(0);
			me.updateLatText("HDG");
			if (Output.vertTemp == 2 or Output.vertTemp == 6) { # Also cancel G/S or FLARE if active
				me.setVertMode(1);
			}
		} else if (n == 1) { # LNAV
			me.updateLocArm(0);
			me.updateApprArm(0);
			me.checkLnav(0);
		} else if (n == 2) { # VOR/LOC
			me.updateLnavArm(0);
			me.checkLoc(0);
		} else if (n == 3) { # HDG HLD
			me.updateLnavArm(0);
			me.updateLocArm(0);
			me.updateApprArm(0);
			Internal.hdgHldTarget.setValue(math.round(Internal.hdgPredicted.getValue())); # Switches to track automatically
			Output.hdgInHld.setBoolValue(1);
			Output.lat.setValue(0);
			me.updateLatText("HDG");
			if (Output.vertTemp == 2 or Output.vertTemp == 6) { # Also cancel G/S or FLARE if active
				me.setVertMode(1);
			}
		} else if (n == 4) { # ALIGN
			me.updateLnavArm(0);
			me.updateLocArm(0);
			me.updateApprArm(0);
			Output.lat.setValue(4);
			me.updateLatText("ALGN");
		} else if (n == 5) { # T/O or G/A, text is set by TOGA selector
			me.updateLnavArm(0);
			me.updateLocArm(0);
			me.updateApprArm(0);
			Output.lat.setValue(5);
		}
	},
	setVertMode: func(n) {
		Input.altDiff = Input.alt.getValue() - Position.indicatedAltitudeFt.getValue();
		if (n == 0) { # ALT HLD
			Input.altArmed.setBoolValue(0);
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			me.updateApprArm(0);
			me.updateAutoLand(0);
			Output.vert.setValue(0);
			me.resetClimbRateLim();
			me.updateVertText("ALT HLD");
			me.syncAlt();
			Athr.setMode(0); # Thrust
		} else if (n == 1) { # V/S
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			me.updateApprArm(0);
			me.updateAutoLand(0);
			Output.vert.setValue(1);
			me.updateVertText("V/S");
			me.syncVs();
			Athr.setMode(0); # Thrust
		} else if (n == 2) { # G/S
			me.updateLnavArm(0);
			me.checkLoc(0);
			me.checkAppr(0);
		} else if (n == 3) { # ALT CAP
			Input.altArmed.setBoolValue(0);
			Internal.flchActive = 0;
			me.updateAutoLand(0);
			Output.vert.setValue(0);
			me.setClimbRateLim();
			Internal.altCaptureActive = 1;
			me.updateVertText("ALT CAP");
			Athr.setMode(0); # Thrust
		} else if (n == 4) { # FLCH
			me.updateApprArm(0);
			me.updateAutoLand(0);
			Internal.altCaptureActive = 0;
			Output.vert.setValue(4);
			me.updateVertText("FLCH");
			Internal.flchActive = 1;
			if (Output.thrMode.getValue() != 2) {
				Athr.setMode(3); # Clamp
			}
			if (Input.ktsMachFlch.getBoolValue()) {
				me.syncMachFlch();
			} else {
				me.syncKtsFlch();
			}
		} else if (n == 5) { # FPA
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			me.updateApprArm(0);
			me.updateAutoLand(0);
			Output.vert.setValue(5);
			me.updateVertText("FPA");
			me.syncFpa();
			Athr.setMode(0); # Thrust
		} else if (n == 6) { # FLARE/ROLLOUT
			Input.altArmed.setBoolValue(0);
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			me.updateApprArm(0);
			Output.vert.setValue(6);
			me.updateVertText("LAND");
			Athr.setMode(0); # Thrust
		} else if (n == 7) { # T/O CLB or G/A CLB, text is set by TOGA selector
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			me.updateApprArm(0);
			me.updateAutoLand(0);
			Output.vert.setValue(7);
			Athr.setMode(2); # EPR Lim
			Input.ktsMachFlch.setBoolValue(0);
		}
	},
	activateLnav: func() {
		if (Output.lat.getValue() != 1) {
			me.updateLnavArm(0);
			me.updateLocArm(0);
			me.updateApprArm(0);
			Output.lat.setValue(1);
			me.updateLatText("LNAV");
			if (Output.vertTemp == 2 or Output.vertTemp == 6) { # Also cancel G/S or FLARE if active
				me.setVertMode(1);
			}
		}
	},
	activateLoc: func() {
		if (Output.lat.getValue() != 2) {
			me.updateLnavArm(0);
			me.updateLocArm(0);
			me.updateAutoLand(0);
			Output.lat.setValue(2);
			me.updateLatText("LOC");
		}
	},
	activateGs: func() {
		if (Output.vert.getValue() != 2) {
			Input.altArmed.setBoolValue(0);
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			me.updateApprArm(0);
			Output.vert.setValue(2);
			me.updateVertText("G/S");
			Athr.setMode(0); # Thrust
		}
	},
	checkLnav: func(t) {
		FPLN.activeTemp = FPLN.active.getBoolValue();
		if (FPLN.num.getValue() > 0 and FPLN.activeTemp and Position.gearAglFt.getValue() >= 150) {
			me.activateLnav();
		} else if (FPLN.activeTemp and Output.lat.getValue() != 1 and t != 1) {
			me.updateLnavArm(1);
		}
		if (!FPLN.activeTemp) {
			me.updateLnavArm(0);
		}
	},
	checkLoc: func(t) {
		Radio.radioSel = Input.activeAp.getValue() - 1;
		if (Radio.inRange[Radio.radioSel].getBoolValue()) { #  # Only evaulate the rest of the condition unless we are in range
			Radio.locDeflTemp = Radio.locDefl[Radio.radioSel].getValue();
			Radio.signalQualityTemp = Radio.signalQuality[Radio.radioSel].getValue();
			if (abs(Radio.locDeflTemp) <= 0.95 and Radio.locDeflTemp != 0 and Radio.signalQualityTemp >= 0.99) {
				me.activateLoc();
			} else if (t != 1) { # Do not do this if loop calls it
				if (Output.lat.getValue() != 2) {
					me.updateLnavArm(0);
					me.updateLocArm(1);
				}
			}
		} else {
			Radio.signalQuality[Radio.radioSel].setValue(0); # Prevent bad behavior due to FG not updating it when not in range
			me.updateLocArm(0);
		}
	},
	checkAppr: func(t) {
		Radio.radioSel = Input.activeAp.getValue() - 1;
		if (Radio.inRange[Radio.radioSel].getBoolValue()) { #  # Only evaulate the rest of the condition unless we are in range
			Radio.gsDeflTemp = Radio.gsDefl[Radio.radioSel].getValue();
			if (abs(Radio.gsDeflTemp) <= 0.2 and Radio.gsDeflTemp != 0 and Output.lat.getValue()  == 2) { # Only capture if LOC is active
				me.activateGs();
			} else if (t != 1) { # Do not do this if loop calls it
				if (Output.vert.getValue() != 2) {
					me.updateApprArm(1);
				}
			}
		} else {
			Radio.signalQuality[Radio.radioSel].setValue(0); # Prevent bad behavior due to FG not updating it when not in range
			me.updateApprArm(0);
		}
	},
	checkRadioRevision: func(l, v) { # Revert mode if signal lost
		Radio.radioSel = Input.activeAp.getValue() - 1;
		Radio.inRangeTemp = Radio.inRange[Radio.radioSel].getBoolValue();
		if (!Radio.inRangeTemp) {
			if (l == 4 or v == 6) {
				me.ap1Master(0);
				me.ap2Master(0);
				me.setLatMode(3);
				me.setVertMode(1);
			} else {
				me.setLatMode(3); # Also cancels G/S if active
			}
		}
	},
	setClimbRateLim: func() {
		Internal.vsTemp = Internal.vs.getValue();
		if (Internal.alt.getValue() >= Position.indicatedAltitudeFt.getValue()) {
			Internal.maxVs.setValue(math.round(Internal.vsTemp));
			Internal.minVs.setValue(-500);
		} else {
			Internal.maxVs.setValue(500);
			Internal.minVs.setValue(math.round(Internal.vsTemp));
		}
	},
	resetClimbRateLim: func() {
		Internal.minVs.setValue(-500);
		Internal.maxVs.setValue(500);
	},
	takeoffGoAround: func() {
		Output.vertTemp = Output.vert.getValue();
		Misc.flapDegTemp = Misc.flapDeg.getValue();
		if (Gear.wow0Timer.getValue() < 1 and Output.vertTemp != 7 and Position.gearAglFt.getValue() < 1500 and Misc.flapDegTemp >= 25.9) {
			systems.TRI.Limit.activeModeInt.setValue(1); # G/A
			me.setLatMode(5);
			me.updateLatText("G/A");
			me.setVertMode(7); # Must be before kicking AP off
			me.updateVertText("G/A CLB");
			if (Gear.wow1.getBoolValue() or Gear.wow2.getBoolValue()) {
				me.ap1Master(0);
				me.ap2Master(0);
			}
		} else if ((Gear.wow1Temp or Gear.wow2Temp) and Misc.flapDegTemp >= 4.9) {
			if (Output.lat.getValue() != 5) { # Don't accidently disarm LNAV
				me.setLatMode(5);
				me.updateLatText("T/O");
			}
			me.setVertMode(7);
			me.updateVertText("T/O CLB");
		}
	},
	syncKts: func() {
		Input.kts.setValue(math.clamp(math.round(Velocities.indicatedAirspeedKt.getValue()), 100, 340));
	},
	syncKtsFlch: func() {
		Input.ktsFlch.setValue(math.clamp(math.round(Velocities.indicatedAirspeedKt.getValue()), 100, 340));
	},
	syncMach: func() {
		Input.mach.setValue(math.clamp(math.round(Velocities.indicatedMach.getValue(), 0.001), 0.5, 0.84));
	},
	syncMachFlch: func() {
		Input.machFlch.setValue(math.clamp(math.round(Velocities.indicatedMach.getValue(), 0.001), 0.5, 0.84));
	},
	syncHdg: func() {
		Input.hdg.setValue(math.round(Internal.hdgPredicted.getValue())); # Switches to track automatically
	},
	syncAlt: func() {
		#Input.alt.setValue(math.clamp(math.round(Internal.altPredicted.getValue(), 100), 0, 50000)); # Don't
		Internal.alt.setValue(math.clamp(math.round(Internal.altPredicted.getValue(), 100), 0, 50000));
	},
	syncVs: func() {
		Input.vs.setValue(math.clamp(math.round(Internal.vs.getValue(), 100), -6000, 6000));
	},
	syncFpa: func() {
		Input.fpa.setValue(math.clamp(math.round(Internal.fpa.getValue(), 0.1), -9.9, 9.9));
	},
	# Custom Stuff Below
	updateLatText: func(t) {
		Text.lat.setValue(t);
		updateFma.roll();
	},
	updateVertText: func(t) {
		Text.vert.setValue(t);
		updateFma.pitch();
	},
	updateLnavArm: func(n) {
		Output.lnavArm.setBoolValue(n);
		updateFma.arm();
	},
	updateLocArm: func(n) {
		Output.locArm.setBoolValue(n);
		updateFma.arm();
	},
	updateApprArm: func(n) {
		Output.apprArm.setBoolValue(n);
		updateFma.arm();
	},
	updateAutoLand: func(n) {
		Input.autoLand.setBoolValue(n);
		if (n == 0) {
			if (Text.lat.getValue() == "LAND") {
				me.updateLatText("LOC");
			}
			if (Text.vert.getValue() == "LAND") {
				me.updateVertText("G/S");
			}
		}
		updateFma.arm();
	},
};

setlistener("/it-autoflight/input/ap1", func() {
	Input.ap1Temp = Input.ap1.getBoolValue();
	if (Input.ap1Temp != Output.ap1.getBoolValue()) {
		ITAF.ap1Master(Input.ap1Temp);
	}
});

setlistener("/it-autoflight/input/ap2", func() {
	Input.ap2Temp = Input.ap2.getBoolValue();
	if (Input.ap2Temp != Output.ap2.getBoolValue()) {
		ITAF.ap2Master(Input.ap2Temp);
	}
});

setlistener("/it-autoflight/input/athr", func() {
	Input.athrTemp = Input.athr.getBoolValue();
	if (Input.athrTemp != Output.athr.getBoolValue()) {
		ITAF.athrMaster(Input.athrTemp);
	}
});

setlistener("/it-autoflight/input/fd1", func() {
	Input.fd1Temp = Input.fd1.getBoolValue();
	if (Input.fd1Temp != Output.fd1.getBoolValue()) {
		ITAF.fd1Master(Input.fd1Temp);
	}
});

setlistener("/it-autoflight/input/fd2", func() {
	Input.fd2Temp = Input.fd2.getBoolValue();
	if (Input.fd2Temp != Output.fd2.getBoolValue()) {
		ITAF.fd2Master(Input.fd2Temp);
	}
});

setlistener("/it-autoflight/input/kts-mach", func() {
	if (Input.ktsMach.getBoolValue()) {
		ITAF.syncMach();
	} else {
		ITAF.syncKts();
	}
}, 0, 0);

setlistener("/it-autoflight/input/kts-mach-flch", func() {
	if (Output.vert.getValue() == 7) { # Mach is not allowed in Mode 7, and don't sync
		if (Input.ktsMachFlch.getBoolValue()) {
			Input.ktsMachFlch.setBoolValue(0);
		}
	} else {
		if (Input.ktsMachFlch.getBoolValue()) {
			ITAF.syncMachFlch();
		} else {
			ITAF.syncKtsFlch();
		}
	}
}, 0, 0);

setlistener("/it-autoflight/input/toga", func() {
	if (Input.toga.getBoolValue()) {
		ITAF.takeoffGoAround();
		Input.toga.setBoolValue(0);
	}
});

setlistener("/it-autoflight/input/lat", func() {
	Input.latTemp = Input.lat.getValue();
	ITAF.setLatMode(Input.latTemp);
});

setlistener("/it-autoflight/input/vert", func() {
	ITAF.setVertMode(Input.vert.getValue());
});

setlistener("/it-autoflight/input/trk", func() {
	Input.trkTemp = Input.trk.getBoolValue();
	Internal.driftAngleTemp = math.round(Internal.driftAngle.getValue());
	
	if (Input.trkTemp) {
		Input.hdgCalc = Input.hdg.getValue() + Internal.driftAngleTemp;
		Input.hdgHldCalc = Internal.hdgHldTarget.getValue() + Internal.driftAngleTemp;
	} else {
		Input.hdgCalc = Input.hdg.getValue() - Internal.driftAngleTemp;
		Input.hdgHldCalc = Internal.hdgHldTarget.getValue() - Internal.driftAngleTemp;
	}
	
	if (Input.hdgCalc > 360) { # It's rounded, so this is ok. Otherwise do >= 360.5
		Input.hdgCalc = Input.hdgCalc - 360;
	} else if (Input.hdgCalc < 1) { # It's rounded, so this is ok. Otherwise do < 0.5
		Input.hdgCalc = Input.hdgCalc + 360;
	}
	if (Input.hdgHldCalc > 360) { # It's rounded, so this is ok. Otherwise do >= 360.5
		Input.hdgHldCalc = Input.hdgHldCalc - 360;
	} else if (Input.hdgHldCalc < 1) { # It's rounded, so this is ok. Otherwise do < 0.5
		Input.hdgHldCalc = Input.hdgHldCalc + 360;
	}
	
	Input.hdg.setValue(Input.hdgCalc);
	Internal.hdgHldTarget.setValue(Input.hdgHldCalc);
	
	Misc.efis0Trk.setBoolValue(Input.trkTemp); # For Canvas Nav Display.
	Misc.efis1Trk.setBoolValue(Input.trkTemp); # For Canvas Nav Display.
}, 0, 0);

# For Canvas Nav Display.
setlistener("/it-autoflight/input/hdg", func() {
	setprop("/autopilot/settings/heading-bug-deg", getprop("/it-autoflight/input/hdg"));
}, 0, 0);

setlistener("/it-autoflight/internal/alt", func() {
	setprop("/autopilot/settings/target-altitude-ft", getprop("/it-autoflight/internal/alt"));
}, 0, 0);

var loopTimer = maketimer(0.1, ITAF, ITAF.loop);
var slowLoopTimer = maketimer(1, ITAF, ITAF.slowLoop);
