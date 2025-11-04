# McDonnell Douglas MD-80 FCS
# Copyright (c) 2025 Josh Davidson (Octal450)

var FCS = {
	dialAFlapCalc: 0,
	dialAFlapPos: props.globals.getNode("/systems/fcs/flaps/dial-a-flap-pos"),
	dialAFlapPosTemp: 0,
	flapsInput: props.globals.getNode("/systems/fcs/flaps/input"),
	flapsInputTemp: 0,
	mainGearAnd: props.globals.getNode("/systems/fcs/spoilers/main-gear-and"),
	stabilizerRate: props.globals.getNode("/systems/fcs/stabilizer/rate-switch"),
	Controls: {
		machTrim: props.globals.getNode("/controls/fcs/mach-trim"),
		rudderPwr: props.globals.getNode("/controls/fcs/rudder-pwr"),
		stabCutout: props.globals.getNode("/controls/fcs/stab-cutout"),
		yawDamper: props.globals.getNode("/controls/fcs/yaw-damper"),
	},
	Covers: {
		stabCutout: props.globals.getNode("/controls/fcs/covers/stab-cutout"),
	},
	Failures: {
		elevatorPwr: props.globals.getNode("/systems/failures/fcs/elevator-pwr"),
		rudderPwr: props.globals.getNode("/systems/failures/fcs/rudder-pwr"),
		yawDamper: props.globals.getNode("/systems/failures/fcs/yaw-damper"),
	},
	init: func() {
		me.resetFailures();
		me.Controls.machTrim.setBoolValue(1);
		me.Controls.rudderPwr.setBoolValue(1);
		me.Controls.stabCutout.setBoolValue(0);
		me.Controls.yawDamper.setValue(1);
		me.Covers.stabCutout.setBoolValue(0);
	},
	resetFailures: func() {
		me.Failures.elevatorPwr.setBoolValue(0);
		me.Failures.rudderPwr.setBoolValue(0);
		me.Failures.yawDamper.setBoolValue(0);
	},
	dialAFlap: func(d) {
		me.flapsInputTemp = me.flapsInput.getValue();
		if (me.flapsInputTemp == 2 or me.flapsInputTemp == 4 or me.flapsInputTemp == 6) {
			gui.popupTip("You need to move the flap lever out of the Dial-A-Flap position to adjust");
		} else {
			me.dialAFlapCalc = math.round(pts.Controls.Flight.dialAFlap.getValue() + d, 0.25);
			
			if (me.dialAFlapCalc < -1) me.dialAFlapCalc = -1;
			else if (me.dialAFlapCalc > 24) me.dialAFlapCalc = 24;
			
			pts.Controls.Flight.dialAFlap.setValue(me.dialAFlapCalc);
		}
	},
};
