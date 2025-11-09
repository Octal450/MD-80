# McDonnell Douglas MD-80 Engines
# Copyright (c) 2025 Josh Davidson (Octal450)

var ENGINES = {
	egt: [props.globals.getNode("/engines/engine[0]/egt-actual"), props.globals.getNode("/engines/engine[1]/egt-actual")],
	epr: [props.globals.getNode("/engines/engine[0]/epr-actual"), props.globals.getNode("/engines/engine[1]/epr-actual")],
	ff: [props.globals.getNode("/engines/engine[0]/ff-actual"), props.globals.getNode("/engines/engine[1]/ff-actual")],
	n1: [props.globals.getNode("/engines/engine[0]/n1-actual"), props.globals.getNode("/engines/engine[1]/n1-actual")],
	n2: [props.globals.getNode("/engines/engine[0]/n2-actual"), props.globals.getNode("/engines/engine[1]/n2-actual")],
	oilPsi: [props.globals.getNode("/engines/engine[0]/oil-psi"), props.globals.getNode("/engines/engine[1]/oil-psi")],
	oilQty: [props.globals.getNode("/engines/engine[0]/oil-qty"), props.globals.getNode("/engines/engine[1]/oil-qty")],
	oilQtyInput: [props.globals.getNode("/engines/engine[0]/oil-qty-input"), props.globals.getNode("/engines/engine[1]/oil-qty-input")],
	overspeed: props.globals.getNode("/systems/engines/limit/overspeed"),
	reverseEngage: [props.globals.getNode("/systems/engines/reverse-1/engage"), props.globals.getNode("/systems/engines/reverse-2/engage")],
	state: [props.globals.getNode("/engines/engine[0]/state"), props.globals.getNode("/engines/engine[1]/state")],
	Controls: {
		cutoff: [props.globals.getNode("/controls/engines/engine[0]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[1]/cutoff-switch")],
		engSync: props.globals.getNode("/controls/engines/eng-sync"),
		eprTemp: 0,
		fuReset: props.globals.getNode("/controls/engines/fu-reset"),
		manEpr: [props.globals.getNode("/controls/engines/engine[0]/man-epr"), props.globals.getNode("/controls/engines/engine[1]/man-epr")],
		manEprSet: [props.globals.getNode("/controls/engines/engine[0]/man-epr-set"), props.globals.getNode("/controls/engines/engine[1]/man-epr-set")],
		start: [props.globals.getNode("/controls/engines/engine[0]/start-switch"), props.globals.getNode("/controls/engines/engine[1]/start-switch")],
		throttle: [props.globals.getNode("/controls/engines/engine[0]/throttle"), props.globals.getNode("/controls/engines/engine[1]/throttle")],
		throttleTemp: [0, 0],
	},
	Covers: {
		startL: props.globals.getNode("/controls/engines/covers/start-l"),
		startR: props.globals.getNode("/controls/engines/covers/start-r"),
	},
	init: func() {
		me.reverseEngage[0].setBoolValue(0);
		me.reverseEngage[1].setBoolValue(0);
		me.Controls.engSync.setValue(0);
		me.Controls.fuReset.setBoolValue(0);
		me.Controls.manEpr[0].setValue(2);
		me.Controls.manEpr[1].setValue(2);
		me.Controls.manEprSet[0].setBoolValue(0);
		me.Controls.manEprSet[1].setBoolValue(0);
		me.Controls.start[0].setBoolValue(0);
		me.Controls.start[1].setBoolValue(0);
		me.Covers.startL.setBoolValue(0);
		me.Covers.startR.setBoolValue(0);
		systems.ENGINES.oilQtyInput[0].setValue(math.round((rand() * 4) + 14 , 0.1)); # Random between 14 and 18
		systems.ENGINES.oilQtyInput[1].setValue(math.round((rand() * 4) + 14 , 0.1)); # Random between 14 and 18
	},
	adjustManEpr: func(n, d) {
		if (me.Controls.manEprSet[n].getBoolValue() and pts.Instrumentation.Epr.powerAvail[n].getBoolValue()) {
			me.Controls.eprTemp = math.round(me.Controls.manEpr[n].getValue() + (d * 0.01), (abs(d * 0.01))); # Kill floating point error
			if (me.Controls.eprTemp < 1) {
				me.Controls.manEpr[n].setValue(1);
			} else if (me.Controls.eprTemp > 2.5) {
				me.Controls.manEpr[n].setValue(2.5);
			} else {
				me.Controls.manEpr[n].setValue(me.Controls.eprTemp);
			}
		}
	},
};

# Base off Engine 1
var doRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		ENGINES.Controls.throttleTemp[0] = ENGINES.Controls.throttle[0].getValue();
		if (!ENGINES.reverseEngage[0].getBoolValue() or !ENGINES.reverseEngage[1].getBoolValue()) {
			ENGINES.reverseEngage[0].setBoolValue(1);
			ENGINES.reverseEngage[1].setBoolValue(1);
			ENGINES.Controls.throttle[0].setValue(0);
			ENGINES.Controls.throttle[1].setValue(0);
		} else if (ENGINES.Controls.throttleTemp[0] < 0.4) {
			ENGINES.Controls.throttle[0].setValue(0.4);
			ENGINES.Controls.throttle[1].setValue(0.4);
		} else if (ENGINES.Controls.throttleTemp[0] < 0.7) {
			ENGINES.Controls.throttle[0].setValue(0.7);
			ENGINES.Controls.throttle[1].setValue(0.7);
		} else if (ENGINES.Controls.throttleTemp[0] < 1) {
			ENGINES.Controls.throttle[0].setValue(1);
			ENGINES.Controls.throttle[1].setValue(1);
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.reverseEngage[0].setBoolValue(0);
		ENGINES.reverseEngage[1].setBoolValue(0);
	}
}

var unRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINES.reverseEngage[0].getBoolValue() or ENGINES.reverseEngage[1].getBoolValue()) {
			ENGINES.Controls.throttleTemp[0] = ENGINES.Controls.throttle[0].getValue();
			if (ENGINES.Controls.throttleTemp[0] > 0.7) {
				ENGINES.Controls.throttle[0].setValue(0.7);
				ENGINES.Controls.throttle[1].setValue(0.7);
			} else if (ENGINES.Controls.throttleTemp[0] > 0.4) {
				ENGINES.Controls.throttle[0].setValue(0.4);
				ENGINES.Controls.throttle[1].setValue(0.4);
			} else if (ENGINES.Controls.throttleTemp[0] > 0.05) {
				ENGINES.Controls.throttle[0].setValue(0);
				ENGINES.Controls.throttle[1].setValue(0);
			} else {
				ENGINES.Controls.throttle[0].setValue(0);
				ENGINES.Controls.throttle[1].setValue(0);
				ENGINES.reverseEngage[0].setBoolValue(0);
				ENGINES.reverseEngage[1].setBoolValue(0);
			}
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.reverseEngage[0].setBoolValue(0);
		ENGINES.reverseEngage[1].setBoolValue(0);
	}
}

var toggleRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and THRLIM.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINES.reverseEngage[0].getBoolValue() or ENGINES.reverseEngage[1].getBoolValue()) {
			ENGINES.Controls.throttle[0].setValue(0);
			ENGINES.Controls.throttle[1].setValue(0);
			ENGINES.reverseEngage[0].setBoolValue(0);
			ENGINES.reverseEngage[1].setBoolValue(0);
		} else {
			ENGINES.reverseEngage[0].setBoolValue(1);
			ENGINES.reverseEngage[1].setBoolValue(1);
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.reverseEngage[0].setBoolValue(0);
		ENGINES.reverseEngage[1].setBoolValue(0);
	}
}

var doIdleThrust = func() {
	ENGINES.Controls.throttle[0].setValue(0);
	ENGINES.Controls.throttle[1].setValue(0);
}

var doLimitThrust = func() {
	var active = THRLIM.Limit.activeNorm.getValue();
	ENGINES.Controls.throttle[0].setValue(active);
	ENGINES.Controls.throttle[1].setValue(active);
}

var doFullThrust = func() {
	var highest = THRLIM.Limit.highestNorm.getValue();
	ENGINES.Controls.throttle[0].setValue(highest);
	ENGINES.Controls.throttle[1].setValue(highest);
}
