# McDonnell Douglas MD-80 Hydraulic System
# Copyright (c) 2024 Josh Davidson (Octal450)

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
		auxPump: props.globals.getNode("/controls/hydraulics/aux-pump"),
		gearGravityExt: props.globals.getNode("/controls/hydraulics/gear-gravity-ext"),
		lPump: props.globals.getNode("/controls/hydraulics/l-pump"),
		rPump: props.globals.getNode("/controls/hydraulics/r-pump"),
		trans: props.globals.getNode("/controls/hydraulics/trans"),
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
