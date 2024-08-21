# McDonnell Douglas MD-80 Main Systems
# Copyright (c) 2024 Josh Davidson (Octal450)

# Electrical
var ELEC = {
	Bus: {
		acGenL: props.globals.getNode("/systems/electrical/bus/ac-gen-l"),
		acGenR: props.globals.getNode("/systems/electrical/bus/ac-gen-r"),
		acRadioL: props.globals.getNode("/systems/electrical/bus/ac-radio-l"),
		acRadioR: props.globals.getNode("/systems/electrical/bus/ac-radio-r"),
		acGndSvc: props.globals.getNode("/systems/electrical/bus/ac-gndsvc"),
		acTie: props.globals.getNode("/systems/electrical/bus/ac-tie"),
		acL: props.globals.getNode("/systems/electrical/bus/ac-l"),
		acR: props.globals.getNode("/systems/electrical/bus/ac-r"),
		dcBat: props.globals.getNode("/systems/electrical/bus/dc-bat"),
		dcBatDirect: props.globals.getNode("/systems/electrical/bus/dc-bat-direct"),
		dcL: props.globals.getNode("/systems/electrical/bus/dc-l"),
		dcR: props.globals.getNode("/systems/electrical/bus/dc-r"),
		dcRadioL: props.globals.getNode("/systems/electrical/bus/dc-radio-l"),
		dcRadioR: props.globals.getNode("/systems/electrical/bus/dc-radio-r"),
		dcTie: props.globals.getNode("/systems/electrical/bus/dc-tie"),
		dcTrans: props.globals.getNode("/systems/electrical/bus/dc-trans"),
		emerAc: props.globals.getNode("/systems/electrical/bus/emer-ac"),
		emerDc: props.globals.getNode("/systems/electrical/bus/emer-dc"),
		instAcL: props.globals.getNode("/systems/electrical/bus/inst-ac-l"),
		instAcR: props.globals.getNode("/systems/electrical/bus/inst-ac-r"),
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
		efis: props.globals.initNode("/systems/electrical/outputs/efis", 0, "DOUBLE"),
		fgcp: props.globals.initNode("/systems/electrical/outputs/fgcp", 0, "DOUBLE"),
		fma: [props.globals.initNode("/systems/electrical/outputs/fma[0]", 0, "DOUBLE"), props.globals.initNode("/systems/electrical/outputs/fma[1]", 0, "DOUBLE")],
	},
	Source: {
		Apu: {
			hertz: props.globals.getNode("/systems/electrical/sources/apu/output-hertz"),
			pmgHertz: props.globals.getNode("/systems/electrical/sources/apu/pmg-hertz"),
			pmgVolt: props.globals.getNode("/systems/electrical/sources/apu/pmg-volt"),
			volt: props.globals.getNode("/systems/electrical/sources/apu/output-volt"),
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
		batChargerPowered: props.globals.getNode("/systems/electrical/sources/bat-charger-powered"),
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

# Fuel
var FUEL = {
	Fail: {
		auxTransA: props.globals.getNode("/systems/failures/fuel/aux-trans-a"),
		auxTransB: props.globals.getNode("/systems/failures/fuel/aux-trans-b"),
		pumpsC: props.globals.getNode("/systems/failures/fuel/pumps-c"),
		pumpsL: props.globals.getNode("/systems/failures/fuel/pumps-l"),
		pumpsR: props.globals.getNode("/systems/failures/fuel/pumps-r"),
		pumpStart: props.globals.getNode("/systems/failures/fuel/pump-start"),
	},
	Switch: {
		auxTransAftA: props.globals.getNode("/controls/fuel/switches/aux-trans-aft-a"),
		auxTransAftB: props.globals.getNode("/controls/fuel/switches/aux-trans-aft-b"),
		auxTransFwdA: props.globals.getNode("/controls/fuel/switches/aux-trans-fwd-a"),
		auxTransFwdB: props.globals.getNode("/controls/fuel/switches/aux-trans-fwd-b"),
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
		me.Switch.auxTransAftA.setValue(0);
		me.Switch.auxTransAftB.setValue(0);
		me.Switch.auxTransFwdA.setValue(0);
		me.Switch.auxTransFwdB.setValue(0);
		me.Switch.pumpAftC.setValue(0);
		me.Switch.pumpAftL.setBoolValue(0);
		me.Switch.pumpAftR.setBoolValue(0);
		me.Switch.pumpFwdC.setValue(0);
		me.Switch.pumpFwdL.setBoolValue(0);
		me.Switch.pumpFwdR.setBoolValue(0);
		me.Switch.pumpStart.setBoolValue(0);
		me.Switch.xFeed.setBoolValue(0);
	},
	resetFailures: func() {
		me.Fail.auxTransA.setBoolValue(0);
		me.Fail.auxTransB.setBoolValue(0);
		me.Fail.pumpsC.setBoolValue(0);
		me.Fail.pumpsL.setBoolValue(0);
		me.Fail.pumpsR.setBoolValue(0);
		me.Fail.pumpStart.setBoolValue(0);
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
		gearGravityExt: props.globals.getNode("/controls/hydraulics/switches/gear-gravity-ext"),
		lPump: props.globals.getNode("/controls/hydraulics/switches/l-pump"),
		rPump: props.globals.getNode("/controls/hydraulics/switches/r-pump"),
		trans: props.globals.getNode("/controls/hydraulics/switches/trans"),
	},
	init: func() {
		me.resetFailures();
		me.Qty.sysLInput.setValue(math.round((rand() * 8) + 10 , 0.1)); # Random between 10 and 18
		me.Qty.sysRInput.setValue(math.round((rand() * 8) + 10 , 0.1)); # Random between 10 and 18
		me.Switch.auxPump.setValue(0);
		me.Switch.gearGravityExt.setBoolValue(0);
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
		tempSel: props.globals.getNode("/controls/pneumatics/switches/temp-sel"),
		xBleedL: props.globals.getNode("/controls/pneumatics/switches/x-bleed-l"),
		xBleedR: props.globals.getNode("/controls/pneumatics/switches/x-bleed-r"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.bleedApu.setValue(0);
		me.Switch.cabinTemp.setValue(0.45);
		me.Switch.cockpitTemp.setValue(0.45);
		me.Switch.groundAir.setBoolValue(0);
		me.Switch.instrumentFlow.setValue(0);
		me.Switch.radioRack.setBoolValue(0);
		me.Switch.supplyL.setValue(0);
		me.Switch.supplyR.setValue(0);
		me.Switch.tempSel.setBoolValue(0);
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
