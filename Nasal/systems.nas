# McDonnell Douglas MD-80 Systems
# Copyright (c) 2022 Josh Davidson (Octal450)

# AHRS
var AHRS = {
	Ahrs: {
		aligned: [props.globals.getNode("/systems/ahrs[0]/aligned"), props.globals.getNode("/systems/ahrs[1]/aligned")],
	},
};

# APU
var APU = {
	autoConnect: 0,
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
		Apu: {
			hertz: props.globals.getNode("/systems/electrical/sources/apu/output-hertz"),
			volt: props.globals.getNode("/systems/electrical/sources/apu/output-volt"),
			pmgHertz: props.globals.getNode("/systems/electrical/sources/apu/pmg-hertz"),
			pmgVolt: props.globals.getNode("/systems/electrical/sources/apu/pmg-volt"),
		},
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
		groundCart: props.globals.getNode("/controls/electrical/switches/ground-cart"),
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
		me.Switch.groundCart.setBoolValue(0);
		me.Source.Bat1.percent.setValue(99.9);
		me.Source.Bat2.percent.setValue(99.9);
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

# Engine Control
var ENGINE = {
	cutoffSwitch: [props.globals.getNode("/controls/engines/engine[0]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[1]/cutoff-switch")],
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
		me.fuReset.setBoolValue(0);
		me.manEpr[0].setValue(2);
		me.manEpr[1].setValue(2);
		me.manEprSet[0].setBoolValue(0);
		me.manEprSet[1].setBoolValue(0);
		me.reverseEngage[0].setBoolValue(0);
		me.reverseEngage[1].setBoolValue(0);
		me.startSwitch[0].setBoolValue(0);
		me.startSwitch[1].setBoolValue(0);
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
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and systems.TRI.throttleCompareMax.getValue() <= 0.05) {
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
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and systems.TRI.throttleCompareMax.getValue() <= 0.05) {
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
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and systems.TRI.throttleCompareMax.getValue() <= 0.05) {
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

var doFullThrust = func() {
	var highest = TRI.Limit.highestNorm.getValue();
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
		rudderPwr: props.globals.getNode("/controls/fctl/switches/rudder-pwr"),
		yawDamper: props.globals.getNode("/controls/fctl/switches/yaw-damper"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.rudderPwr.setBoolValue(1);
		me.Switch.yawDamper.setValue(1);
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
		pumpsC: props.globals.getNode("/systems/failures/fuel/pumps-c"),
		pumpsL: props.globals.getNode("/systems/failures/fuel/pumps-l"),
		pumpsR: props.globals.getNode("/systems/failures/fuel/pumps-r"),
		pumpStart: props.globals.getNode("/systems/failures/fuel/pump-start"),
	},
	Switch: {
		pumpAftC: props.globals.getNode("/controls/fuel/switches/pump-aft-c"),
		pumpAftL: props.globals.getNode("/controls/fuel/switches/pump-aft-l"),
		pumpAftR: props.globals.getNode("/controls/fuel/switches/pump-aft-r"),
		pumpFwdC: props.globals.getNode("/controls/fuel/switches/pump-fwd-c"),
		pumpFwdL: props.globals.getNode("/controls/fuel/switches/pump-fwd-l"),
		pumpFwdR: props.globals.getNode("/controls/fuel/switches/pump-fwd-r"),
		pumpStart: props.globals.getNode("/controls/fuel/switches/pump-start"),
		xFeed: props.globals.getNode("/controls/fuel/switches/x-feed"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.pumpAftC.setBoolValue(0);
		me.Switch.pumpAftL.setBoolValue(0);
		me.Switch.pumpAftR.setBoolValue(0);
		me.Switch.pumpFwdC.setBoolValue(0);
		me.Switch.pumpFwdL.setBoolValue(0);
		me.Switch.pumpFwdR.setBoolValue(0);
		me.Switch.pumpStart.setBoolValue(0);
		me.Switch.xFeed.setBoolValue(0);
	},
	resetFailures: func() {
		me.Fail.pumpsC.setBoolValue(0);
		me.Fail.pumpsL.setBoolValue(0);
		me.Fail.pumpsR.setBoolValue(0);
		me.Fail.pumpStart.setBoolValue(0);
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
		me.Qty.sysLInput.setValue(math.round((rand() * 8) + 10 , 0.1)); # Random between 10 and 18
		me.Qty.sysRInput.setValue(math.round((rand() * 8) + 10 , 0.1)); # Random between 10 and 18
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

# Ignition
var IGNITION = {
	cutoff1: props.globals.getNode("/systems/ignition/cutoff-1"),
	cutoff2: props.globals.getNode("/systems/ignition/cutoff-2"),
	starter1: props.globals.getNode("/systems/ignition/starter-1"),
	starter2: props.globals.getNode("/systems/ignition/starter-2"),
	Switch: {
		ign: props.globals.getNode("/controls/ignition/ign"),
	},
	init: func() {
		me.Switch.ign.setBoolValue(0);
	},
	fastStart: func(n) {
		ENGINE.cutoffSwitch[n].setBoolValue(0);
		pts.Fdm.JSBsim.Propulsion.setRunning.setValue(n);
	},
};

# Pneumatics
var PNEU = {
	Fail: {
		bleedApu: props.globals.getNode("/systems/failures/pneumatics/bleed-apu"),
		bleedL: props.globals.getNode("/systems/failures/pneumatics/bleed-l"),
		bleedR: props.globals.getNode("/systems/failures/pneumatics/bleed-r"),
		packL: props.globals.getNode("/systems/failures/pneumatics/pack-l"),
		packR: props.globals.getNode("/systems/failures/pneumatics/pack-r"),
	},
	Flow: {
		packL: props.globals.getNode("/systems/pneumatics/pack-l-flow"),
		packR: props.globals.getNode("/systems/pneumatics/pack-r-flow"),
	},
	Psi: {
		apu: props.globals.getNode("/systems/pneumatics/apu-psi"),
		bleedL: props.globals.getNode("/systems/pneumatics/bleed-l-psi"),
		bleedR: props.globals.getNode("/systems/pneumatics/bleed-r-psi"),
		engL: props.globals.getNode("/systems/pneumatics/eng-l-psi"),
		engR: props.globals.getNode("/systems/pneumatics/eng-r-psi"),
		ground: props.globals.getNode("/systems/pneumatics/ground-psi"),
	},
	Switch: {
		bleedApu: props.globals.getNode("/controls/pneumatics/switches/bleed-apu"),
		cabinTemp: props.globals.getNode("/controls/pneumatics/switches/cabin-temp"),
		cockpitTemp: props.globals.getNode("/controls/pneumatics/switches/cockpit-temp"),
		groundAir: props.globals.getNode("/controls/pneumatics/switches/ground-air"), # No switch in cockpit
		instrumentFlow: props.globals.getNode("/controls/pneumatics/switches/instrument-flow"),
		radioRack: props.globals.getNode("/controls/pneumatics/switches/radio-rack"),
		supplyL: props.globals.getNode("/controls/pneumatics/switches/supply-l"),
		supplyR: props.globals.getNode("/controls/pneumatics/switches/supply-r"),
		xBleedL: props.globals.getNode("/controls/pneumatics/switches/x-bleed-l"),
		xBleedR: props.globals.getNode("/controls/pneumatics/switches/x-bleed-r"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.bleedApu.setValue(0);
		me.Switch.cabinTemp.setValue(0.5);
		me.Switch.cockpitTemp.setValue(0.5);
		me.Switch.groundAir.setBoolValue(0);
		me.Switch.instrumentFlow.setValue(0);
		me.Switch.radioRack.setValue(0);
		me.Switch.supplyL.setValue(0);
		me.Switch.supplyR.setValue(0);
		me.Switch.xBleedL.setValue(0);
		me.Switch.xBleedR.setValue(0);
	},
	resetFailures: func() {
		me.Fail.bleedApu.setBoolValue(0);
		me.Fail.bleedL.setBoolValue(0);
		me.Fail.bleedR.setBoolValue(0);
		me.Fail.packL.setBoolValue(0);
		me.Fail.packR.setBoolValue(0);
	},
};

# TRI
var TRI = {
	Control: {
		athrMax: [props.globals.getNode("/fdm/jsbsim/engine/control-1/athr-max"), props.globals.getNode("/fdm/jsbsim/engine/control-2/athr-max")],
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
		me.Limit.activeModeInt.setValue(0);
		me.Limit.activeMode.setValue("T/O");
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
			me.Limit.activeMode.setValue("T/O"); # Check
			dfgs.Athr.toCheck();
		} else if (me.Limit.activeModeIntTemp == 6) {
			me.Limit.activeMode.setValue("---");
		}
		dfgs.Athr.limitChanged(me.Limit.activeModeLast, me.Limit.activeMode.getValue());
	},
};

# Warnings
var WARNINGS = {
	altitudeAlert: props.globals.getNode("/systems/warnings/altitude-alert"),
	altitudeAlertCaptured: props.globals.getNode("/systems/warnings/altitude-alert-captured"),
};
