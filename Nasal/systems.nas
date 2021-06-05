# McDonnell Douglas MD-80 Master System
# Copyright (c) 2021 Josh Davidson (Octal450)


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

# Electrical
var ELEC = {
	Bus: {
		acGenL: props.globals.getNode("/systems/electrical/bus/ac-gen-l"),
		acGenR: props.globals.getNode("/systems/electrical/bus/ac-gen-r"),
		acGndSvc: props.globals.getNode("/systems/electrical/bus/ac-gndsvc"),
		acL: props.globals.getNode("/systems/electrical/bus/ac-l"),
		acR: props.globals.getNode("/systems/electrical/bus/ac-r"),
		dcBat: props.globals.getNode("/systems/electrical/bus/dc-bat"),
		dcBatDirect: props.globals.getNode("/systems/electrical/bus/dc-bat-direct"),
		dcL: props.globals.getNode("/systems/electrical/bus/dc-l"),
		dcR: props.globals.getNode("/systems/electrical/bus/dc-r"),
		dcTrans: props.globals.getNode("/systems/electrical/bus/dc-trans"),
		emerAc: props.globals.getNode("/systems/electrical/bus/emer-ac"),
		emerDc: props.globals.getNode("/systems/electrical/bus/emer-dc"),
	},
	Fail: {
		acTie: props.globals.getNode("/systems/failures/electrical/ac-tie"),
		apu: props.globals.getNode("/systems/failures/electrical/apu"),
		battery: props.globals.getNode("/systems/failures/electrical/battery"),
		dcTie: props.globals.getNode("/systems/failures/electrical/dc-tie"),
		genL: props.globals.getNode("/systems/failures/electrical/gen-l"),
		genR: props.globals.getNode("/systems/failures/electrical/gen-r"),
	},
	Generic: {
		adf: props.globals.initNode("/systems/electrical/outputs/adf", 0, "DOUBLE"),
		dme: props.globals.initNode("/systems/electrical/outputs/dme", 0, "DOUBLE"),
		efis: props.globals.initNode("/systems/electrical/outputs/efis", 0, "DOUBLE"),
		fgcpPower: props.globals.initNode("/systems/electrical/outputs/fgcp-power", 0, "DOUBLE"),
		fmaPower: props.globals.initNode("/systems/electrical/outputs/fma-power", 0, "DOUBLE"),
		fuelPump0: props.globals.initNode("/systems/electrical/outputs/fuel-pump[0]", 0, "DOUBLE"),
		fuelPump1: props.globals.initNode("/systems/electrical/outputs/fuel-pump[1]", 0, "DOUBLE"),
		fuelPump2: props.globals.initNode("/systems/electrical/outputs/fuel-pump[2]", 0, "DOUBLE"),
		gps: props.globals.initNode("/systems/electrical/outputs/gps", 0, "DOUBLE"),
		idk: props.globals.initNode("/systems/electrical/outputs/idk", 0, "DOUBLE"),
		mkViii: props.globals.initNode("/systems/electrical/outputs/mk-viii", 0, "DOUBLE"),
		nav0: props.globals.initNode("/systems/electrical/outputs/nav[0]", 0, "DOUBLE"),
		nav1: props.globals.initNode("/systems/electrical/outputs/nav[1]", 0, "DOUBLE"),
		nav2: props.globals.initNode("/systems/electrical/outputs/nav[2]", 0, "DOUBLE"),
		transponder: props.globals.initNode("/systems/electrical/outputs/transponder", 0, "DOUBLE"),
		turnCoordinator: props.globals.initNode("/systems/electrical/outputs/turn-coordinator", 0, "DOUBLE"),
	},
	Source: {
		batChargerPowered: props.globals.getNode("/systems/electrical/sources/bat-charger-powered"),
		#Apu: {
		#	hertz: props.globals.getNode("/systems/electrical/sources/apu/output-hertz"),
		#	volt: props.globals.getNode("/systems/electrical/sources/apu/output-volt"),
		#	pmgHertz: props.globals.getNode("/systems/electrical/sources/apu/pmg-hertz"),
		#	pmgVolt: props.globals.getNode("/systems/electrical/sources/apu/pmg-volt"),
		#},
		Bat1: {
			amp: props.globals.getNode("/systems/electrical/sources/bat-1/amp"),
			percent: props.globals.getNode("/systems/electrical/sources/bat-1/percent"),
			volt: props.globals.getNode("/systems/electrical/sources/bat-1/volt"),
		},
		Bat2: {
			amp: props.globals.getNode("/systems/electrical/sources/bat-2/amp"),
			percent: props.globals.getNode("/systems/electrical/sources/bat-2/percent"),
			volt: props.globals.getNode("/systems/electrical/sources/bat-2/volt"),
		},
		Ext: {
			cart: props.globals.getNode("/controls/switches/cart"),
			hertz: props.globals.getNode("/systems/electrical/sources/ext/output-hertz"),
			volt: props.globals.getNode("/systems/electrical/sources/ext/output-volt"),
		},
		IdgL: {
			outputHertz: props.globals.getNode("/systems/electrical/sources/idg-l/output-hertz"),
			outputVolt: props.globals.getNode("/systems/electrical/sources/idg-l/output-volt"),
			pmgHertz: props.globals.getNode("/systems/electrical/sources/idg-l/pmg-hertz"),
			pmgVolt: props.globals.getNode("/systems/electrical/sources/idg-l/pmg-volt"),
		},
		IdgR: {
			outputHertz: props.globals.getNode("/systems/electrical/sources/idg-r/output-hertz"),
			outputVolt: props.globals.getNode("/systems/electrical/sources/idg-r/output-volt"),
			pmgHertz: props.globals.getNode("/systems/electrical/sources/idg-r/pmg-hertz"),
			pmgVolt: props.globals.getNode("/systems/electrical/sources/idg-r/pmg-volt"),
		},
		Si1: {
			volt: props.globals.getNode("/systems/electrical/sources/si-1/output-volt"),
		},
		TrL1: {
			amp: props.globals.getNode("/systems/electrical/sources/tr-l1/output-amp"),
			volt: props.globals.getNode("/systems/electrical/sources/tr-l1/output-volt"),
		},
		TrL2: {
			amp: props.globals.getNode("/systems/electrical/sources/tr-l2/output-amp"),
			volt: props.globals.getNode("/systems/electrical/sources/tr-l2/output-volt"),
		},
		TrR1: {
			amp: props.globals.getNode("/systems/electrical/sources/tr-r1/output-amp"),
			volt: props.globals.getNode("/systems/electrical/sources/tr-r1/output-volt"),
		},
		TrR2: {
			amp: props.globals.getNode("/systems/electrical/sources/tr-r2/output-amp"),
			volt: props.globals.getNode("/systems/electrical/sources/tr-r2/output-volt"),
		},
	},
	Switch: {
		acTie: props.globals.getNode("/controls/electrical/switches/ac-tie"),
		apuGndSvc: props.globals.getNode("/controls/electrical/switches/apu-gndsvc"),
		apuPwrL: props.globals.getNode("/controls/electrical/switches/apu-pwr-l"),
		apuPwrR: props.globals.getNode("/controls/electrical/switches/apu-pwr-r"),
		battery: props.globals.getNode("/controls/electrical/switches/battery"),
		csdL: props.globals.getNode("/controls/electrical/switches/csd-l"),
		csdR: props.globals.getNode("/controls/electrical/switches/csd-r"),
		dcTie: props.globals.getNode("/controls/electrical/switches/dc-tie"),
		emerPwr: props.globals.getNode("/controls/electrical/switches/emer-pwr"),
		extGndSvc: props.globals.getNode("/controls/electrical/switches/ext-gndsvc"),
		extPwrL: props.globals.getNode("/controls/electrical/switches/ext-pwr-l"),
		extPwrR: props.globals.getNode("/controls/electrical/switches/ext-pwr-r"),
		galley: props.globals.getNode("/controls/electrical/switches/galley"),
		genApu: props.globals.getNode("/controls/electrical/switches/gen-apu"),
		genL: props.globals.getNode("/controls/electrical/switches/gen-l"),
		genR: props.globals.getNode("/controls/electrical/switches/gen-r"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.acTie.setBoolValue(1);
		me.Switch.apuGndSvc.setBoolValue(0);
		me.Switch.apuPwrL.setBoolValue(0);
		me.Switch.apuPwrR.setBoolValue(0);
		me.Switch.battery.setBoolValue(0);
		me.Switch.csdL.setBoolValue(1);
		me.Switch.csdR.setBoolValue(1);
		me.Switch.dcTie.setBoolValue(0);
		me.Switch.emerPwr.setBoolValue(0);
		me.Switch.extGndSvc.setBoolValue(0);
		me.Switch.extPwrL.setBoolValue(0);
		me.Switch.extPwrR.setBoolValue(0);
		me.Switch.galley.setBoolValue(1);
		me.Switch.genApu.setBoolValue(1);
		me.Switch.genL.setValue(1);
		me.Switch.genR.setValue(1);
		me.Source.Bat1.percent.setValue(99.9);
		me.Source.Bat2.percent.setValue(99.9);
		me.Source.Ext.cart.setBoolValue(0);
	},
	resetFailures: func() {
		me.Switch.csdL.setBoolValue(1);
		me.Switch.csdR.setBoolValue(1);
		me.Fail.acTie.setBoolValue(0);
		me.Fail.apu.setBoolValue(0);
		me.Fail.battery.setBoolValue(0);
		me.Fail.dcTie.setBoolValue(0);
		me.Fail.genL.setBoolValue(0);
		me.Fail.genR.setBoolValue(0);
	},
};

# Engine Sim Control Stuff
# Don't want to change the bindings yet
# Intentionally not using + or -, floating point error would be BAD
# We just based it off Engine 1
var doRevThrust = func() {
	pts.Controls.Engines.Engine.reverseLeverTemp[0] = pts.Controls.Engines.Engine.reverseLever[0].getValue();
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and systems.TRI.throttleCompareMax.getValue() <= 0.05) {
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

var unRevThrust = func() {
	pts.Controls.Engines.Engine.reverseLeverTemp[0] = pts.Controls.Engines.Engine.reverseLever[0].getValue();
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and systems.TRI.throttleCompareMax.getValue() <= 0.05) {
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

var toggleFastRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and systems.TRI.throttleCompareMax.getValue() <= 0.05) {
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

var doIdleThrust = func() {
	pts.Controls.Engines.Engine.throttle[0].setValue(0);
	pts.Controls.Engines.Engine.throttle[1].setValue(0);
}

var doFullThrust = func() {
	pts.Controls.Engines.Engine.throttle[0].setValue(1);
	pts.Controls.Engines.Engine.throttle[1].setValue(1);
}

# Flight Controls
var FCTL = {
	Fail: {
		elevatorPwr: props.globals.getNode("/systems/failures/fctl/elevator-pwr"),
		rudderPwr: props.globals.getNode("/systems/failures/fctl/rudder-pwr"),
		yawDamper: props.globals.getNode("/systems/failures/fctl/yaw-damper"),
	},
	Switch: {
		rudderPwr: props.globals.getNode("/controls/fctl/switches/rudder-pwr"),
		yawDamper: props.globals.getNode("/controls/fctl/switches/yaw-damper"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.rudderPwr.setBoolValue(1);
		me.Switch.yawDamper.setValue(2);
	},
	resetFailures: func() {
		me.Fail.elevatorPwr.setBoolValue(0);
		me.Fail.rudderPwr.setBoolValue(0);
		me.Fail.yawDamper.setBoolValue(0);
	}
};

# Fuel
var FUEL = {
	Fail: {
		pumpStart: props.globals.getNode("/systems/failures/fuel/pump-start"),
		pumpsC: props.globals.getNode("/systems/failures/fuel/pumps-c"),
		pumpsL: props.globals.getNode("/systems/failures/fuel/pumps-l"),
		pumpsR: props.globals.getNode("/systems/failures/fuel/pumps-r"),
	},
	Switch: {
		pumpStart: props.globals.getNode("/controls/fuel/switches/pump-start"),
		pumpAftC: props.globals.getNode("/controls/fuel/switches/pump-aft-c"),
		pumpAftL: props.globals.getNode("/controls/fuel/switches/pump-aft-l"),
		pumpAftR: props.globals.getNode("/controls/fuel/switches/pump-aft-r"),
		pumpFwdC: props.globals.getNode("/controls/fuel/switches/pump-fwd-c"),
		pumpFwdL: props.globals.getNode("/controls/fuel/switches/pump-fwd-l"),
		pumpFwdR: props.globals.getNode("/controls/fuel/switches/pump-fwd-r"),
		xFeed: props.globals.getNode("/controls/fuel/switches/x-feed"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.pumpStart.setBoolValue(0);
		me.Switch.pumpAftC.setBoolValue(0);
		me.Switch.pumpAftL.setBoolValue(0);
		me.Switch.pumpAftR.setBoolValue(0);
		me.Switch.pumpFwdC.setBoolValue(0);
		me.Switch.pumpFwdL.setBoolValue(0);
		me.Switch.pumpFwdR.setBoolValue(0);
		me.Switch.xFeed.setBoolValue(0);
	},
	resetFailures: func() {
		me.Fail.pumpStart.setBoolValue(0);
		me.Fail.pumpsC.setBoolValue(0);
		me.Fail.pumpsL.setBoolValue(0);
		me.Fail.pumpsR.setBoolValue(0);
	},
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
	resetFailures: func() {
		me.Fail.leftActuator.setBoolValue(0);
		me.Fail.noseActuator.setBoolValue(0);
		me.Fail.rightActuator.setBoolValue(0);
	},
};

# Hydraulics
var HYD = {
	Fail: {
		auxPump: props.globals.getNode("/systems/failures/hydraulics/aux-pump"),
		lPump: props.globals.getNode("/systems/failures/hydraulics/l-pump"),
		rPump: props.globals.getNode("/systems/failures/hydraulics/r-pump"),
		trans: props.globals.getNode("/systems/failures/hydraulics/trans"),
		sysLLeak: props.globals.getNode("/systems/failures/hydraulics/sys-l-leak"),
		sysRLeak: props.globals.getNode("/systems/failures/hydraulics/sys-r-leak"),
	},
	Psi: {
		auxPump: props.globals.getNode("/systems/hydraulics/aux-pump-psi"),
		lPump: props.globals.getNode("/systems/hydraulics/l-pump-psi"),
		rPump: props.globals.getNode("/systems/hydraulics/r-pump-psi"),
		sysL: props.globals.getNode("/systems/hydraulics/sys-l-psi"),
		sysR: props.globals.getNode("/systems/hydraulics/sys-r-psi"),
	},
	Qty: {
		sysL: props.globals.getNode("/systems/hydraulics/sys-l-qty"),
		sysLInput: props.globals.getNode("/systems/hydraulics/sys-l-qty-input"),
		sysR: props.globals.getNode("/systems/hydraulics/sys-r-qty"),
		sysRInput: props.globals.getNode("/systems/hydraulics/sys-r-qty-input"),
	},
	Switch: {
		auxPump: props.globals.getNode("/controls/hydraulics/switches/aux-pump"),
		lPump: props.globals.getNode("/controls/hydraulics/switches/l-pump"),
		rPump: props.globals.getNode("/controls/hydraulics/switches/r-pump"),
		trans: props.globals.getNode("/controls/hydraulics/switches/trans"),
	},
	init: func() {
		me.resetFailures();
		me.Qty.sysLInput.setValue(math.round((rand() * 4) + 8 , 0.1)); # Random between 8 and 12
		me.Qty.sysRInput.setValue(math.round((rand() * 4) + 8 , 0.1)); # Random between 8 and 12
		me.Switch.auxPump.setValue(0);
		me.Switch.lPump.setValue(0);
		me.Switch.rPump.setValue(0);
		me.Switch.trans.setBoolValue(0);
	},
	resetFailures: func() {
		me.Fail.auxPump.setBoolValue(0);
		me.Fail.lPump.setBoolValue(0);
		me.Fail.rPump.setBoolValue(0);
		me.Fail.trans.setBoolValue(0);
		me.Fail.sysLLeak.setBoolValue(0);
		me.Fail.sysRLeak.setBoolValue(0);
	},
};

# TRI
var TRI = {
	pitchMode: 0,
	throttleCompareMax: props.globals.getNode("/fdm/jsbsim/engine/throttle-compare-max"),
	Limit: {
		active: props.globals.getNode("/fdm/jsbsim/engine/limit/active"),
		activeMode: props.globals.getNode("/fdm/jsbsim/engine/limit/active-mode"),
		activeModeInt: props.globals.getNode("/fdm/jsbsim/engine/limit/active-mode-int"), # -1 NONE, 0 T/O, 1 G/A, 2 MCT, 3 CLB, 4 CRZ, 5 T/O FLX
		activeModeIntTemp: 0,
		activeModeLast: "T/O",
		activeNorm: props.globals.getNode("/fdm/jsbsim/engine/limit/active-norm"),
		cruise: props.globals.getNode("/fdm/jsbsim/engine/limit/cruise"),
		climb: props.globals.getNode("/fdm/jsbsim/engine/limit/climb"),
		goAround: props.globals.getNode("/fdm/jsbsim/engine/limit/go-around"),
		mct: props.globals.getNode("/fdm/jsbsim/engine/limit/mct"),
		idleNorm: props.globals.getNode("/fdm/jsbsim/engine/limit/idle-norm"),
		takeoff: props.globals.getNode("/fdm/jsbsim/engine/limit/takeoff"),
	},
	init: func() {
		me.Limit.activeModeInt.setValue(0);
		me.Limit.activeMode.setValue("T/O");
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
			me.Limit.activeMode.setValue("CL");
		} else if (me.Limit.activeModeIntTemp == 4) {
			me.Limit.activeMode.setValue("CR");
		} else if (me.Limit.activeModeIntTemp == 5) {
			me.Limit.activeMode.setValue("T/O"); # Check
			dfgs.Athr.toCheck();
		}
		dfgs.Athr.limitChanged(me.Limit.activeModeLast, me.Limit.activeMode.getValue());
	},
};

setlistener("/fdm/jsbsim/engine/limit/active-mode-int", func() {
	TRI.updateTxt();
}, 0, 0);
