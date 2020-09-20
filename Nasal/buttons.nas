# McDonnell Douglas MD-80 Buttons and Switches
# Copyright (c) 2020 Josh Davidson (Octal450)

# Resets buttons to the default values
var variousReset = func {
	
}

var apPanel = {
	hdgTemp: 0,
	ktsTemp: 0,
	machTemp: 0,
	vertTemp: 0,
	apSwitch: func() {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			if (dfgs.Output.ap1.getBoolValue() or dfgs.Output.ap2.getBoolValue()) {
				dfgs.ITAF.ap1Master(0);
				dfgs.ITAF.ap2Master(0);
			} else {
				if (dfgs.Input.activeAp.getValue() == 2) {
					dfgs.ITAF.ap2Master(1);
					dfgs.ITAF.ap1Master(0);
				} else {
					dfgs.ITAF.ap1Master(1);
					dfgs.ITAF.ap2Master(0);
				}
			}
		}
	},
	apDisc: func() {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			if (dfgs.Output.ap1.getBoolValue()) {
				dfgs.ITAF.ap1Master(0);
			}
			if (dfgs.Output.ap2.getBoolValue()) {
				dfgs.ITAF.ap2Master(0);
			}
		}
	},
	atDisc: func() {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			if (dfgs.Output.athr.getBoolValue()) {
				dfgs.ITAF.athrMaster(0);
			}
		}
	},
	spdPush: func() {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			dfgs.Input.ktsMach.setBoolValue(!dfgs.Input.ktsMach.getBoolValue());
		}
	},
	spdAdjust: func(d) {
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
				me.ktsTemp = dfgs.Input.kts.getValue() + d;
				if (me.ktsTemp < 100) {
					dfgs.Input.kts.setValue(100);
				} else if (me.ktsTemp > 350) {
					dfgs.Input.kts.setValue(350);
				} else {
					dfgs.Input.kts.setValue(me.ktsTemp);
				}
			}
		}
	},
	hdgPush: func() {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			dfgs.Input.lat.setValue(3);
		}
	},
	hdgPull: func() {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			dfgs.Input.lat.setValue(0);
		}
	},
	hdgAdjust: func(d) {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			me.hdgTemp = dfgs.Input.hdg.getValue() + d;
			if (me.hdgTemp < 0.5) {
				dfgs.Input.hdg.setValue(me.hdgTemp + 360);
			} else if (me.hdgTemp >= 360.5) {
				dfgs.Input.hdg.setValue(me.hdgTemp - 360);
			} else {
				dfgs.Input.hdg.setValue(me.hdgTemp);
			}
		}
	},
	nav: func() {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			dfgs.Input.lat.setValue(1);
		}
	},
	vorLoc: func() {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			dfgs.Input.lat.setValue(2);
		}
	},
	ils: func() {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			dfgs.Input.vert.setValue(2);
		}
	},
	vsAdjust: func(d) {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			me.vertTemp = dfgs.Output.vert.getValue();
			if (me.vertTemp == 1) {
				me.vsTemp = dfgs.Input.vs.getValue() + (d * 100);
				if (me.vsTemp < -6000) {
					dfgs.Input.vs.setValue(-6000);
				} else if (me.vsTemp > 6000) {
					dfgs.Input.vs.setValue(6000);
				} else {
					dfgs.Input.vs.setValue(me.vsTemp);
				}
			} else {
				dfgs.Input.vert.setValue(1);
			}
		}
	},
	altPush: func() {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			
		}
	},
	altPull: func() {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			
		}
	},
	altAdjust: func(d) {
		if (systems.ELEC.Generic.fgcpPower.getBoolValue()) {
			me.altTemp = dfgs.Input.alt.getValue();
			if (d == 1) {
				if (me.altTemp >= 10000) {
					me.altTemp = math.round(me.altTemp, 500) + 500; # Make sure it rounds to the nearest 500 from previous before changing
				} else {
					me.altTemp = math.round(me.altTemp, 100) + 100; # Make sure it rounds to the nearest 100 from previous before changing
				}
			} else if (d == -1) {
				if (me.altTemp > 10000) { # Intentionally not >=
					me.altTemp = math.round(me.altTemp, 500) - 500; # Make sure it rounds to the nearest 500 from previous before changing
				} else {
					me.altTemp = math.round(me.altTemp, 100) - 100; # Make sure it rounds to the nearest 100 from previous before changing
				}
			} else {
				me.altTemp = me.altTemp + (d * 100);
			}
			if (me.altTemp < 0) {
				dfgs.Input.alt.setValue(0);
			} else if (me.altTemp > 50000) {
				dfgs.Input.alt.setValue(50000);
			} else {
				dfgs.Input.alt.setValue(me.altTemp);
			}
		}
	},
};
