# McDonnell Douglas MD-80 Buttons and Switches
# Copyright (c) 2020 Josh Davidson (Octal450)

# Resets buttons to the default values
var variousReset = func {
	
}

var APPanel = {
	altTemp: 0,
	fpaTemp: 0,
	hdgTemp: 0,
	iasTemp: 0,
	machTemp: 0,
	vertTemp: 0,
	vsTemp: 0,
	SPDPush: func() {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			dfgs.Input.ktsMach.setBoolValue(!dfgs.Input.ktsMach.getBoolValue());
		}
	},
	SPDAdjust: func(d) {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			if (dfgs.Input.ktsMach.getBoolValue()) {
				me.machTemp = math.round(dfgs.Input.mach.getValue() + (d * 0.001), (abs(d * 0.001))); # Kill floating point error
				if (me.machTemp < 0.50) {
					dfgs.Input.mach.setValue(0.50);
				} else if (me.machTemp > 0.82) {
					dfgs.Input.mach.setValue(0.82);
				} else {
					dfgs.Input.mach.setValue(me.machTemp);
				}
			} else {
				me.iasTemp = dfgs.Input.ias.getValue() + d;
				if (me.iasTemp < 100) {
					dfgs.Input.ias.setValue(100);
				} else if (me.iasTemp > 350) {
					dfgs.Input.ias.setValue(350);
				} else {
					dfgs.Input.ias.setValue(me.iasTemp);
				}
			}
		}
	},
};

var STD = func {
	if (!pts.Instrumentation.Altimeter.std.getBoolValue()) {
		pts.Instrumentation.Altimeter.oldQnh.setValue(pts.Instrumentation.Altimeter.settingInhg.getValue());
		pts.Instrumentation.Altimeter.settingInhg.setValue(29.92);
		pts.Instrumentation.Altimeter.std.setBoolValue(1);
	}
}

var unSTD = func {
	if (pts.Instrumentation.Altimeter.std.getBoolValue()) {
		pts.Instrumentation.Altimeter.settingInhg.setValue(pts.Instrumentation.Altimeter.oldQnh.getValue());
		pts.Instrumentation.Altimeter.std.setBoolValue(0);
	}
}
