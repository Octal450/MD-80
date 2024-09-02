# McDonnell Douglas MD-80 EFIS Controller
# Copyright (c) 2024 Josh Davidson (Octal450)

var EFIS = {
	rng: 0,
	init: func() {
		me.setMode(0, 2);
		me.setMode(1, 2);
		pts.Instrumentation.Efis.Inputs.rangeNm[0].setValue(10);
		pts.Instrumentation.Efis.Inputs.rangeNm[1].setValue(10);
		pts.Instrumentation.Efis.Inputs.lhVorAdf[0].setValue(1);
		pts.Instrumentation.Efis.Inputs.lhVorAdf[1].setValue(1);
		pts.Instrumentation.Efis.Inputs.rhVorAdf[0].setValue(1);
		pts.Instrumentation.Efis.Inputs.rhVorAdf[1].setValue(1);
		pts.Instrumentation.Efis.Inputs.arpt[0].setBoolValue(0);
		pts.Instrumentation.Efis.Inputs.arpt[1].setBoolValue(0);
		pts.Instrumentation.Efis.Inputs.data[0].setBoolValue(1);
		pts.Instrumentation.Efis.Inputs.data[1].setBoolValue(1);
		pts.Instrumentation.Efis.Inputs.sta[0].setBoolValue(0);
		pts.Instrumentation.Efis.Inputs.sta[1].setBoolValue(0);
		pts.Instrumentation.Efis.Inputs.tfc[0].setBoolValue(1);
		pts.Instrumentation.Efis.Inputs.tfc[1].setBoolValue(1);
		pts.Instrumentation.Efis.Inputs.wpt[0].setBoolValue(0);
		pts.Instrumentation.Efis.Inputs.wpt[1].setBoolValue(0);
	},
	adjustMode: func(n, d) {
		d = pts.Instrumentation.Efis.mode[n].getValue() + d;
		if (d < 0) d = 0;
		else if (d > 3) d = 3;
		me.setMode(n, d);
	},
	setMode: func(n, m) {
		pts.Instrumentation.Efis.mode[n].setValue(m);
		
		if (m == 0) { # ROSE
			pts.Instrumentation.Efis.Mfd.displayMode[n].setValue("VOR");
			pts.Instrumentation.Efis.Inputs.ndCentered[n].setBoolValue(1);
		} else if (m == 1) { # ARC
			pts.Instrumentation.Efis.Mfd.displayMode[n].setValue("VOR");
			pts.Instrumentation.Efis.Inputs.ndCentered[n].setBoolValue(0);
		} else if (m == 2) { # MAP
			pts.Instrumentation.Efis.Mfd.displayMode[n].setValue("MAP");
			pts.Instrumentation.Efis.Inputs.ndCentered[n].setBoolValue(0);
		} else if (m == 3) { # PLAN
			pts.Instrumentation.Efis.Mfd.displayMode[n].setValue("PLAN");
			pts.Instrumentation.Efis.Inputs.ndCentered[n].setBoolValue(1);
		}
	},
	setRange: func(n, d) {
		me.rng = pts.Instrumentation.Efis.Inputs.rangeNm[n].getValue();
		if (d == 1) {
			me.rng = me.rng * 2;
			if (me.rng > 320) {
				me.rng = 320;
			}
		} else if (d == -1){
			me.rng = me.rng / 2;
			if (me.rng < 10) {
				me.rng = 10;
			}
		}
		pts.Instrumentation.Efis.Inputs.rangeNm[n].setValue(me.rng);
	},
};
