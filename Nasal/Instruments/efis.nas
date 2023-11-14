# MD-80 EFIS Controller
# Copyright (c) 2023 Josh Davidson (Octal450)

var EFIS = {
	rng: 0,
	init: func() {
		#me.setCptND("MAP");
		#me.setFoND("MAP");
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
	setNDRange: func(n, d) {
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
