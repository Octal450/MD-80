# McDonnell Douglas MD-80 DU Controller
# Copyright (c) 2025 Josh Davidson (Octal450)
# This controls the DU's in an efficient and synchronized way

var DUController = {
	ht9100On: props.globals.initNode("/instrumentation/ht9100/mcdu1-on", 0, "BOOL"),
	PowerSource: {
		acRadioR: 0,
		emerAc: 0,
	},
	showNd1: props.globals.initNode("/instrumentation/nd/show-nd1", 0, "BOOL"),
	showNd2: props.globals.initNode("/instrumentation/nd/show-nd2", 0, "BOOL"),
	updateHt9100: 0,
	updateNd1: 0,
	updateNd2: 0,
	updatePfd1: 0,
	updatePfd2: 0,
	loop: func() {
		if (pts.Systems.Acconfig.Options.efis.getBoolValue()) {
			me.PowerSource.acRadioR = systems.ELECTRICAL.Bus.acRadioR.getValue();
			me.PowerSource.emerAc = systems.ELECTRICAL.Bus.emerAc.getValue();
			
			# Emer AC
			if (me.PowerSource.emerAc >= 112 and pts.Instrumentation.Du.pfdDimmer[0].getValue() > 0.01) {
				if (!me.updatePfd1) {
					me.updatePfd1 = 1;
					canvas_pfd.pfd1.update();
					canvas_pfd.pfd1.page.show();
				}
			} else {
				if (me.updatePfd1) {
					me.updatePfd1 = 0;
					canvas_pfd.pfd1.page.hide();
				}
			}
			
			if (me.PowerSource.emerAc >= 112 and pts.Instrumentation.Du.ndDimmer[0].getValue() > 0.01) {
				if (!me.updateNd1) {
					me.updateNd1 = 1;
					me.showNd1.setBoolValue(1); # Temporary
				}
			} else {
				if (me.updateNd1) {
					me.updateNd1 = 0;
					me.showNd1.setBoolValue(0); # Temporary
				}
			}
			
			# AC Radio R
			if (me.PowerSource.acRadioR >= 112 and pts.Instrumentation.Du.pfdDimmer[1].getValue() > 0.01) {
				if (!me.updatePfd2) {
					me.updatePfd2 = 1;
					canvas_pfd.pfd2.update();
					canvas_pfd.pfd2.page.show();
				}
			} else {
				if (me.updatePfd2) {
					me.updatePfd2 = 0;
					canvas_pfd.pfd2.page.hide();
				}
			}
			
			if (me.PowerSource.acRadioR >= 112 and pts.Instrumentation.Du.ndDimmer[1].getValue() > 0.01) {
				if (!me.updateNd2) {
					me.updateNd2 = 1;
					me.showNd2.setBoolValue(1); # Temporary
				}
			} else {
				if (me.updateNd2) {
					me.updateNd2 = 0;
					me.showNd2.setBoolValue(0); # Temporary
				}
			}
		} else {
			me.updatePfd1 = 0;
			me.updatePfd2 = 0;
			me.updateNd1 = 0;
			me.updateNd2 = 0;
			me.showNd1.setBoolValue(0); # Temporary
			me.showNd2.setBoolValue(0); # Temporary
		}
		
		# HT9100
		if (pts.Systems.Acconfig.Options.nav.getValue() == 0) {
			if (mcdu_ht9100.unit[0].powerSource.getValue() >= 24) {
				if (!me.updateHt9100) {
					me.updateHt9100 = 1;
					canvas_ht9100.mcdu1.update();
					canvas_ht9100.mcdu1.page.show();
				}
			} else {
				if (me.updateHt9100) {
					me.updateHt9100 = 0;
					canvas_ht9100.mcdu1.page.hide();
				}
			}
		} else {
			me.updateHt9100 = 0;
			canvas_ht9100.mcdu1.page.hide();
		}
	},
};
