# McDonnell Douglas MD-80 Buttons and Switches
# Copyright (c) 2024 Josh Davidson (Octal450)

var furt = 0;

# Resets buttons to the default values
var variousReset = func() {
	pts.Controls.Dfgs.Switches.art.setBoolValue(1);
	pts.Controls.Dfgs.Switches.artCover.setBoolValue(0);
	pts.Controls.Flight.dialAFlap.setValue(0);
	pts.Controls.Lighting.beacon.setBoolValue(0);
	pts.Controls.Lighting.captDigitalKnb.setValue(1);
	pts.Controls.Lighting.emerLt.setValue(0);
	pts.Controls.Lighting.fgcpDigitalKnb.setValue(1);
	pts.Controls.Lighting.foDigitalKnb.setValue(1);
	pts.Controls.Lighting.landingLightL.setValue(0);
	pts.Controls.Lighting.landingLightN.setValue(0);
	pts.Controls.Lighting.landingLightR.setValue(0);
	pts.Controls.Lighting.logoLights.setBoolValue(0);
	pts.Controls.Lighting.pedestalDigitalKnb.setValue(1);
	pts.Controls.Lighting.positionStrobeLight.setValue(0);
	pts.Controls.Lighting.taxiLight.setBoolValue(0);
	pts.Controls.Lighting.wingLights.setValue(0);
	pts.Controls.Switches.gpws.setValue(0);
	pts.Controls.Switches.gpwsCover.setBoolValue(0);
	pts.Controls.Switches.maxSpdWarnTest.setValue(0);
	pts.Controls.Switches.minimums.setValue(200);
	pts.Controls.Switches.noSmokingSign.setValue(1); # Smoking is bad!
	pts.Controls.Switches.seatbeltSign.setValue(0);
	pts.Controls.Switches.stallTest.setValue(0);
	pts.Instrumentation.Du.ndDimmer[0].setValue(1);
	pts.Instrumentation.Du.ndDimmer[1].setValue(1);
	pts.Instrumentation.Du.pfdDimmer[0].setValue(1);
	pts.Instrumentation.Du.pfdDimmer[1].setValue(1);
	furt = math.round((rand() * 6000) + 2000) * -1; # Random between 2000 and 8000
	pts.Instrumentation.Ff.fuResetTrim[0].setValue(furt);
	pts.Instrumentation.Ff.fuResetTrim[1].setValue(furt);
	pts.Instrumentation.Hsi.slavedToGps[0].setBoolValue(0);
	pts.Instrumentation.Hsi.slavedToGps[1].setBoolValue(0);
}

var ApPanel = {
	hdgTemp: 0,
	latTemp: 0,
	ktsTemp: 0,
	ktsFlchTemp: 0,
	machTemp: 0,
	machFlchTemp: 0,
	pitchTemp: 0,
	vertTemp: 0,
	vsTemp: 0,
	apSwitch: func() {
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
	},
	apSelector: func() {
		dfgs.Input.activeAp.setValue(!(dfgs.Input.activeAp.getValue() - 1) + 1); # This sh*t just toggles between 1 and 2
		dfgs.updateFma.capTrkReCheck();
	},
	apDisc: func() {
		dfgs.killApWarn();
		if (dfgs.Output.ap1.getBoolValue()) {
			dfgs.ITAF.ap1Master(0);
		}
		if (dfgs.Output.ap2.getBoolValue()) {
			dfgs.ITAF.ap2Master(0);
		}
	},
	atDisc: func() {
		dfgs.killAtsWarn();
		if (dfgs.Output.athr.getBoolValue()) {
			dfgs.ITAF.athrMaster(0);
		}
	},
	spdPush: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			dfgs.Input.ktsMach.setBoolValue(!dfgs.Input.ktsMach.getBoolValue());
		}
	},
	spdAdjust: func(d) {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			if (dfgs.Input.ktsMach.getBoolValue()) {
				me.machTemp = math.round(dfgs.Input.mach.getValue() + (d * 0.002), (abs(d * 0.002))); # Kill floating point error
				if (me.machTemp < 0.50) {
					dfgs.Input.mach.setValue(0.50);
				} else if (me.machTemp > 0.9) {
					dfgs.Input.mach.setValue(0.9);
				} else {
					dfgs.Input.mach.setValue(me.machTemp);
				}
			} else {
				me.ktsTemp = dfgs.Input.kts.getValue() + d;
				if (me.ktsTemp < 100) {
					dfgs.Input.kts.setValue(100);
				} else if (me.ktsTemp > 380) {
					dfgs.Input.kts.setValue(380);
				} else {
					dfgs.Input.kts.setValue(me.ktsTemp);
				}
			}
		}
	},
	spd: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			me.vertTemp = dfgs.Output.vert.getValue();
			dfgs.Input.ktsMach.setBoolValue(0);
			dfgs.Athr.setMode(0); # Thrust
			if (me.vertTemp == 4 or me.vertTemp == 7) {
				dfgs.Input.vert.setValue(1);
				dfgs.Fma.startBlink(3);
			}
		}
	},
	mach: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			me.vertTemp = dfgs.Output.vert.getValue();
			dfgs.Input.ktsMach.setBoolValue(1);
			dfgs.Athr.setMode(0); # Thrust
			if (me.vertTemp == 4 or me.vertTemp == 7) {
				dfgs.Input.vert.setValue(1);
				dfgs.Fma.startBlink(3);
			}
		}
	},
	eprLim: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			dfgs.Athr.setMode(2); # EPR Limit
		}
	},
	hdgPush: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			dfgs.Input.lat.setValue(3);
		}
	},
	hdgPull: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			dfgs.Input.lat.setValue(0);
		}
	},
	hdgAdjust: func(d) {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
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
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			dfgs.Input.lat.setValue(1);
		}
	},
	vorLoc: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			dfgs.Input.lat.setValue(2);
		}
	},
	ils: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			dfgs.ITAF.updateAutoLand(0);
			dfgs.Input.vert.setValue(2);
		}
	},
	autoLand: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			if (dfgs.Output.ap1.getBoolValue() or dfgs.Output.ap2.getBoolValue()) {
				dfgs.ITAF.updateAutoLand(1);
				dfgs.Input.vert.setValue(2);
			}
		}
	},
	vsAdjust: func(d) { # Called the pitch wheel this so that one binding works on many planes
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
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
			} else if (me.vertTemp == 4) {
				if (dfgs.Input.ktsMachFlch.getBoolValue()) {
					me.machFlchTemp = math.round(dfgs.Input.machFlch.getValue() + (d * -0.002), (abs(d * 0.002))); # Kill floating point error
					if (me.machFlchTemp < 0.50) {
						dfgs.Input.machFlch.setValue(0.50);
					} else if (me.machFlchTemp > 0.9) {
						dfgs.Input.machFlch.setValue(0.9);
					} else {
						dfgs.Input.machFlch.setValue(me.machFlchTemp);
					}
				} else {
					me.ktsFlchTemp = dfgs.Input.ktsFlch.getValue() + (d * -1);
					if (me.ktsFlchTemp < 100) {
						dfgs.Input.ktsFlch.setValue(100);
					} else if (me.ktsFlchTemp > 380) {
						dfgs.Input.ktsFlch.setValue(380);
					} else {
						dfgs.Input.ktsFlch.setValue(me.ktsFlchTemp);
					}
				}
			} else if (me.vertTemp == 8) {
				if (abs(d) == 10) {
					me.pitchTemp = dfgs.Input.pitch.getValue() + (d * 0.5);
				} else {
					me.pitchTemp = dfgs.Input.pitch.getValue() + d;
				}
				if (me.pitchTemp < -10) {
					dfgs.Input.pitch.setValue(-10);
				} else if (me.pitchTemp > 25) {
					dfgs.Input.pitch.setValue(25);
				} else {
					dfgs.Input.pitch.setValue(me.pitchTemp);
				}
			} else {
				dfgs.Input.vert.setValue(1);
			}
		}
	},
	altPush: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			dfgs.Input.altArmed.setBoolValue(0);
			systems.WARNINGS.altitudeAlertCaptured.setValue(0); # Reset out of captured state
			if (systems.WARNINGS.altitudeAlert.getValue() == 2) systems.WARNINGS.altitudeAlert.setValue(0); # Cancel altitude alert deviation alarm
		}
	},
	altPull: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			me.vertTemp = dfgs.Output.vert.getValue();
			if (me.vertTemp != 0 and me.vertTemp != 2 and me.vertTemp != 6) {
				dfgs.Input.altArmed.setBoolValue(1);
			}
		}
	},
	altAdjust: func(d) {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			me.altTemp = dfgs.Input.alt.getValue();
			if (d == 10) {
				if (me.altTemp >= 1000) {
					me.altTemp = math.round(me.altTemp + 1000, 100);
				} else {
					me.altTemp = math.round(me.altTemp + 100, 100);
				}
			} else if (d == -10) {
				if (me.altTemp > 1000) { # Intentionally not >=
					me.altTemp = math.round(me.altTemp - 1000, 100);
				} else {
					me.altTemp = math.round(me.altTemp - 100, 100);
				}
			} else {
				me.altTemp = math.round(me.altTemp + (d * 100), 100);
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
	vertSpd: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			dfgs.Input.vert.setValue(1);
		}
	},
	iasMach: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			if (dfgs.Output.vert.getValue() == 4) {
				if (dfgs.Velocities.indicatedMach.getValue() >= 0.4995) {
					dfgs.Input.ktsMachFlch.setBoolValue(!dfgs.Input.ktsMachFlch.getBoolValue());
				} else {
					dfgs.Input.ktsMachFlch.setBoolValue(0);
				}
			} else {
				if (dfgs.Position.indicatedAltitudeFt.getValue() >= 26995 and dfgs.Velocities.indicatedMach.getValue() >= 0.4995) {
					dfgs.Input.ktsMachFlch.setBoolValue(1);
				} else {
					dfgs.Input.ktsMachFlch.setBoolValue(0);
				}
				dfgs.Input.vert.setValue(4);
			}
		}
	},
	altHold: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			dfgs.Input.vert.setValue(0);
		}
	},
	turb: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			dfgs.Input.lat.setValue(6);
			dfgs.Input.vert.setValue(8);
		}
	},
	toga: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			dfgs.Input.toga.setValue(1);
		}
	},
};
