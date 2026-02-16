# McDonnell Douglas MD-80 Aircraft Core
# Copyright (c) 2026 Josh Davidson (Octal450)

print("------------------------------------------------");
print("Copyright (c) 2019-2026 Josh Davidson (Octal450)");
print("------------------------------------------------");

setprop("/sim/menubar/default/menu[2]/item[0]/enabled", 0);
setprop("/sim/menubar/default/menu[2]/item[2]/enabled", 0);
setprop("/sim/menubar/default/menu[3]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[8]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[9]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[10]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[11]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[12]/enabled", 0);
setprop("/sim/multiplay/visibility-range-nm", 130);

var firetankEquipped = 0;
var initDone = 0;
var systemsInit = func() {
	# Standard modules
	systems.APU.init();
	systems.BRAKES.init();
	systems.ELECTRICAL.init();
	systems.ENGINES.init();
	systems.FCS.init();
	systems.FUEL.init();
	systems.GEAR.init();
	systems.HYDRAULICS.init();
	systems.IGNITION.init();
	systems.IRS.init();
	systems.PNEUMATICS.init();
	dfgs.ITAF.init();
	fms_ht9100.CORE.init();
	systems.THRLIM.init();
	instruments.EFIS.init();
	instruments.XPDR.init();
	
	if (firetankEquipped) {
		firetank.FIRETANK.init();
	}
	
	# Object orientated modules
	if (initDone) { # Anytime after sim init
		mcdu_ht9100.BASE.reset();
	} else { # Sim init
		instruments.COMM.setup();
		mcdu_ht9100.BASE.setup();
	}
	
	# Other switches
	cockpit.variousReset();
}

var fdmInit = setlistener("/sim/signals/fdm-initialized", func() {
	acconfig.SYSTEM.fdmInit();
	systemsInit();
	systemsLoop.start();
	slowLoop.start();
	canvas_pfd.setup();
	canvas_ht9100.setup();
	canvas_fma.setup();
	acconfig.SYSTEM.finalInit();
	settimer(func() { # Ensure it recomputes
		cockpit.setAsiBugs(0);
	}, 0.5);
	removelistener(fdmInit);
	initDone = 1;
});

var systemsLoop = maketimer(0.1, func() {
	if (pts.Systems.Acconfig.Options.nav.getValue() == 0) {
		fms_ht9100.CORE.loop();
		mcdu_ht9100.BASE.loop();
	}
	
	systems.DUController.loop();
	systems.THRLIM.loop();
	SHAKE.loop();
	
	if (pts.Sim.Replay.replayState.getBoolValue()) {
		pts.Sim.Model.wingflexEnable.setBoolValue(0);
	} else {
		pts.Sim.Model.wingflexEnable.setBoolValue(1);
	}
	
	pts.Services.Chocks.enableTemp = pts.Services.Chocks.enable.getBoolValue();
	pts.Velocities.groundspeedKtTemp = pts.Velocities.groundspeedKt.getValue();
	if ((pts.Velocities.groundspeedKtTemp >= 2 or !pts.Position.wow.getBoolValue()) and pts.Services.Chocks.enableTemp) {
		pts.Services.Chocks.enable.setBoolValue(0);
	}
	
	if ((pts.Velocities.groundspeedKtTemp >= 2 or (!systems.GEAR.Controls.brakeParking.getBoolValue() and !pts.Services.Chocks.enableTemp)) and !acconfig.SYSTEM.autoConfigRunning.getBoolValue()) {
		if (systems.ELECTRICAL.Controls.groundCart.getBoolValue()) {
			systems.ELECTRICAL.Controls.groundCart.setBoolValue(0);
		}
		if (systems.PNEUMATICS.Controls.groundAir.getBoolValue()) {
			systems.PNEUMATICS.Controls.groundAir.setBoolValue(0);
		}
	}
});

var slowLoop = maketimer(1, func() {
	if (systems.ENGINES.overspeed.getBoolValue()) {
		gui.popupTip("You are overspeeding the engines! Reduce power to below the EPR limit!");
	}
	
	if (acconfig.SYSTEM.Error.active.getBoolValue()) {
		systemsInit();
	}
	
	# Panel forcer - makes sure an invalid panel configuration is never used
	setPanelConfig();
});

var setPanelConfig = func() {
	if (!pts.Systems.Acconfig.Options.efis.getBoolValue()) {
		pts.Systems.Acconfig.Options.dualCueFd.setBoolValue(0);
		pts.Systems.Acconfig.Options.edpSdp.setBoolValue(0);
		pts.Sim.Gui.Dialogs.AcconfigMain.ht9100.setBoolValue(1);
		pts.Sim.Gui.Dialogs.AcconfigMain.afms.setBoolValue(0);
		if (pts.Systems.Acconfig.Options.nav.getValue() == 1) {
			pts.Systems.Acconfig.Options.nav.setValue(0);
			fms_ht9100.CORE.init();
		}
	}
}

# Custom controls.nas overrides
controls.autopilotDisconnect = func() {
	cockpit.ApPanel.apDisc();
}

controls.reverserTogglePosition = func() {
	systems.toggleRevThrust();
}

controls.flapsDown = func(step) {
	pts.Controls.Flight.flapsTemp = pts.Controls.Flight.flaps.getValue();
	systems.FCS.dialAFlapPosTemp = systems.FCS.dialAFlapPos.getValue();
	if (step == 1) {
		if (pts.Controls.Flight.flapsTemp < 0.14) {
			pts.Controls.Flight.flaps.setValue(0.14);
		} else if (pts.Controls.Flight.flapsTemp < 0.25 and systems.FCS.dialAFlapPosTemp == 2) {
			pts.Controls.Flight.flaps.setValue(0.25);
		} else if (pts.Controls.Flight.flapsTemp < 0.36) {
			pts.Controls.Flight.flaps.setValue(0.36);
		} else if (pts.Controls.Flight.flapsTemp < 0.47 and systems.FCS.dialAFlapPosTemp == 4) {
			pts.Controls.Flight.flaps.setValue(0.47);
		} else if (pts.Controls.Flight.flapsTemp < 0.58) {
			pts.Controls.Flight.flaps.setValue(0.58);
		} else if (pts.Controls.Flight.flapsTemp < 0.69 and systems.FCS.dialAFlapPosTemp == 6) {
			pts.Controls.Flight.flaps.setValue(0.69);
		} else if (pts.Controls.Flight.flapsTemp < 0.8) {
			pts.Controls.Flight.flaps.setValue(0.8);
		} else if (pts.Controls.Flight.flapsTemp < 0.91) {
			pts.Controls.Flight.flaps.setValue(0.91);
		}
	} else if (step == -1) {
		if (pts.Controls.Flight.flapsTemp > 0.8) {
			pts.Controls.Flight.flaps.setValue(0.8);
		} else if (pts.Controls.Flight.flapsTemp > 0.69 and systems.FCS.dialAFlapPosTemp == 6) {
			pts.Controls.Flight.flaps.setValue(0.69);
		} else if (pts.Controls.Flight.flapsTemp > 0.58) {
			pts.Controls.Flight.flaps.setValue(0.58);
		} else if (pts.Controls.Flight.flapsTemp > 0.47 and systems.FCS.dialAFlapPosTemp == 4) {
			pts.Controls.Flight.flaps.setValue(0.47);
		} else if (pts.Controls.Flight.flapsTemp > 0.36) {
			pts.Controls.Flight.flaps.setValue(0.36);
		} else if (pts.Controls.Flight.flapsTemp > 0.25 and systems.FCS.dialAFlapPosTemp == 2) {
			pts.Controls.Flight.flaps.setValue(0.25);
		} else if (pts.Controls.Flight.flapsTemp > 0.14) {
			pts.Controls.Flight.flaps.setValue(0.14);
		} else if (pts.Controls.Flight.flapsTemp > 0) {
			pts.Controls.Flight.flaps.setValue(0);
		}
	}
}

var leverCockpit = 3;
controls.gearDown = func(d) { # Requires a mod-up
	pts.Position.wowTemp = pts.Position.wow.getBoolValue();
	leverCockpit = systems.GEAR.Controls.lever.getValue();
	if (d < 0) {
		if (pts.Position.wowTemp) {
			if (leverCockpit == 3) {
				systems.GEAR.Controls.lever.setValue(2);
			} else if (leverCockpit == 0) {
				systems.GEAR.Controls.lever.setValue(1);
			}
		} else {
			systems.GEAR.Controls.lever.setValue(0);
		}
	} else if (d > 0) {
		if (pts.Position.wowTemp) {
			if (leverCockpit == 3) {
				systems.GEAR.Controls.lever.setValue(2);
			} else if (leverCockpit == 0) {
				systems.GEAR.Controls.lever.setValue(1);
			}
		} else {
			systems.GEAR.Controls.lever.setValue(3);
		}
	} else {
		if (leverCockpit == 2) {
			systems.GEAR.Controls.lever.setValue(3);
		} else if (leverCockpit == 1) {
			systems.GEAR.Controls.lever.setValue(0);
		}
	}
}

controls.gearDownSmart = func(d) { # Used by cockpit, requires a mod-up
	if (d) {
		if (systems.GEAR.Controls.lever.getValue() >= 2) {
			controls.gearDown(-1);
		} else {
			controls.gearDown(1);
		}
	} else {
		controls.gearDown(0);
	}
}

controls.gearToggle = func() {
	if (!pts.Position.wow.getBoolValue()) {
		if (systems.GEAR.Controls.lever.getValue() >= 2) {
			systems.GEAR.Controls.lever.setValue(0);
		} else {
			systems.GEAR.Controls.lever.setValue(3);
		}
	} else {
		systems.GEAR.Controls.lever.setValue(3);
	}
}

controls.gearTogglePosition = func(d) {
	if (d) {
		controls.gearToggle();
	}
}

controls.stepSpoilers = func(step) {
	pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
	if (step == 1) {
		deploySpeedbrake();
	} else if (step == -1) {
		retractSpeedbrake();
	}
}

var speedbrakeKey = func() {
	if (pts.Controls.Flight.speedbrakeArm.getBoolValue()) {
		pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
	} else {
		pts.Controls.Flight.speedbrakeTemp = pts.Controls.Flight.speedbrake.getValue();
		if (systems.FCS.mainGearAnd.getBoolValue()) {
			if (pts.Controls.Flight.speedbrakeTemp < 0.2) {
				pts.Controls.Flight.speedbrake.setValue(0.2);
			} else if (pts.Controls.Flight.speedbrakeTemp < 0.4) {
				pts.Controls.Flight.speedbrake.setValue(0.4);
			} else if (pts.Controls.Flight.speedbrakeTemp < 0.6) {
				pts.Controls.Flight.speedbrake.setValue(0.6);
			} else if (pts.Controls.Flight.speedbrakeTemp < 0.8) {
				pts.Controls.Flight.speedbrake.setValue(0.8);
			} else {
				pts.Controls.Flight.speedbrake.setValue(0);
			}
		} else {
			if (pts.Controls.Flight.speedbrakeTemp < 0.2) {
				pts.Controls.Flight.speedbrake.setValue(0.2);
			} else if (pts.Controls.Flight.speedbrakeTemp < 0.4) {
				pts.Controls.Flight.speedbrake.setValue(0.4);
			} else if (pts.Controls.Flight.speedbrakeTemp < 0.8) { # Not 0.6!
				pts.Controls.Flight.speedbrake.setValue(0.8); # Not 0.6!
			} else {
				pts.Controls.Flight.speedbrake.setValue(0);
			}
		}
	}
}

var deploySpeedbrake = func() {
	pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
	pts.Controls.Flight.speedbrakeTemp = pts.Controls.Flight.speedbrake.getValue();
	if (systems.FCS.mainGearAnd.getBoolValue()) {
		if (pts.Controls.Flight.speedbrakeTemp < 0.2) {
			pts.Controls.Flight.speedbrake.setValue(0.2);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.4) {
			pts.Controls.Flight.speedbrake.setValue(0.4);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.6) {
			pts.Controls.Flight.speedbrake.setValue(0.6);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.8) {
			pts.Controls.Flight.speedbrake.setValue(0.8);
		}
	} else {
		if (pts.Controls.Flight.speedbrakeTemp < 0.2) {
			pts.Controls.Flight.speedbrake.setValue(0.2);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.4) {
			pts.Controls.Flight.speedbrake.setValue(0.4);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.8) { # Not 0.6!
			pts.Controls.Flight.speedbrake.setValue(0.8); # Not 0.6!
		}
	}
}

var retractSpeedbrake = func() {
	pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
	pts.Controls.Flight.speedbrakeTemp = pts.Controls.Flight.speedbrake.getValue();
	if (systems.FCS.mainGearAnd.getBoolValue()) {
		if (pts.Controls.Flight.speedbrakeTemp > 0.6) {
			pts.Controls.Flight.speedbrake.setValue(0.6);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0.4) {
			pts.Controls.Flight.speedbrake.setValue(0.4);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0.2) {
			pts.Controls.Flight.speedbrake.setValue(0.2);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0) {
			pts.Controls.Flight.speedbrake.setValue(0);
		}
	} else {
		if (pts.Controls.Flight.speedbrakeTemp > 0.4) {
			pts.Controls.Flight.speedbrake.setValue(0.4);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0.2) {
			pts.Controls.Flight.speedbrake.setValue(0.2);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0) {
			pts.Controls.Flight.speedbrake.setValue(0);
		}
	}
}

var delta = 0;
var output = 0;
var slewProp = func(prop, delta) {
	delta *= pts.Sim.Time.deltaRealtimeSec.getValue();
	output = props.globals.getNode(prop).getValue() + delta;
	props.globals.getNode(prop).setValue(output);
	return output;
}

controls.elevatorTrim = func(d) {
	if (dfgs.Output.ap1.getBoolValue()) {
		dfgs.ITAF.ap1Master(0);
	}
	if (dfgs.Output.ap2.getBoolValue()) {
		dfgs.ITAF.ap2Master(0);
	}
	if (systems.ELECTRICAL.Bus.emerAc.getValue() >= 112) { # Check?
		slewProp("/controls/flight/elevator-trim", d * (systems.FCS.stabilizerRate.getValue() / 12.5)); # Rate normalized by max degrees (rate / 12.5)
	}
}

setlistener("/controls/flight/elevator-trim", func() {
	if (pts.Controls.Flight.elevatorTrim.getValue() > 0.2) {
		pts.Controls.Flight.elevatorTrim.setValue(0.2);
	}
}, 0, 0);

# Override FG's generic brake
controls.applyBrakes = func(v, which = 0) { # No interpolate, that's bad, we will apply rate-limit in JSBSim
	if (which <= 0) {
		systems.GEAR.Controls.brakeLeft.setValue(v);
	}
	if (which >= 0) {
		systems.GEAR.Controls.brakeRight.setValue(v);
	}
}

if (pts.Controls.Flight.autoCoordination.getBoolValue()) {
	pts.Controls.Flight.autoCoordination.setBoolValue(0);
	pts.Controls.Flight.aileronDrivesTiller.setBoolValue(1);
} else {
	pts.Controls.Flight.aileronDrivesTiller.setBoolValue(0);
}

setlistener("/controls/flight/auto-coordination", func() {
	pts.Controls.Flight.autoCoordination.setBoolValue(0);
	print("System: Auto Coordination has been turned off as it is not compatible with the flight control system of this aircraft.");
	screen.log.write("Auto Coordination has been disabled as it is not compatible with the flight control system of this aircraft", 1, 0, 0);
});

# Aircraft Lighting
var beacon = aircraft.light.new("/sim/model/lights/beacon", [0.15, 1.35], "/systems/exterior-lights/beacon");
var strobe = aircraft.light.new("/sim/model/lights/strobe", [0.2, 1], "/systems/exterior-lights/strobe-lights");

# Shaking Logic
var SHAKE = {
	force: 0,
	rollspeedMs: [0, 0, 0],
	wow: [0, 0, 0],
	loop: func() {
		me.rollspeedMs[0] = pts.Gear.rollspeedMs[0].getValue();
		me.rollspeedMs[1] = pts.Gear.rollspeedMs[1].getValue();
		me.rollspeedMs[2] = pts.Gear.rollspeedMs[2].getValue();
		me.wow[0] = pts.Gear.wow[0].getBoolValue();
		me.wow[1] = pts.Gear.wow[1].getBoolValue();
		me.wow[2] = pts.Gear.wow[2].getBoolValue();
		
		if (pts.Velocities.groundspeedKt.getValue() >= 1 and (me.wow[0] or me.wow[1] or me.wow[2])) {
			if (me.wow[0]) {
				me.force = me.rollspeedMs[0] / 94000;
			} else {
				me.force = math.max(me.rollspeedMs[1], me.rollspeedMs[2]) / 188000;
			}
			
			interpolate(pts.Systems.Shake.shaking, 0, 0.03);
			settimer(func() {
				interpolate(pts.Systems.Shake.shaking, me.force * 1.5, 0.03); 
			}, 0.5);
		} else {
			pts.Systems.Shake.shaking.setBoolValue(0);
		}	    
	},
};

# Sounds
var Sound = {
	btn1: func() {
		if (pts.Sim.Sound.btn1.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.btn1.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.btn1.setBoolValue(0);
		}, 0.2);
	},
	btn3: func() {
		if (pts.Sim.Sound.btn3.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.btn3.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.btn3.setBoolValue(0);
		}, 0.2);
	},
	knb1: func() {
		if (pts.Sim.Sound.knb1.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.knb1.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.knb1.setBoolValue(0);
		}, 0.2);
	},
	ohBtn: func() {
		if (pts.Sim.Sound.btn2.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.btn2.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.btn2.setBoolValue(0);
		}, 0.2);
	},
	switch1: func() {
		if (pts.Sim.Sound.switch1.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.switch1.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.switch1.setBoolValue(0);
		}, 0.2);
	},
};

setlistener("/systems/fcs/flaps/input", func() {
	if (pts.Sim.Sound.flapsClick.getBoolValue()) {
		return;
	}
	pts.Sim.Sound.flapsClick.setBoolValue(1);
	settimer(func() {
		pts.Sim.Sound.flapsClick.setBoolValue(0);
	}, 0.4);
}, 0, 0);

setlistener("/controls/flight/speedbrake-arm", func() {
	if (pts.Sim.Sound.speedbrakeArmClick.getBoolValue()) {
		return;
	}
	pts.Sim.Sound.speedbrakeArmClick.setBoolValue(1);
	settimer(func() {
		pts.Sim.Sound.speedbrakeArmClick.setBoolValue(0);
	}, 0.4);
}, 0, 0);

setlistener("/controls/switches/seatbelt-sign-status", func() {
	if (pts.Sim.Sound.seatbeltSign.getBoolValue()) {
		return;
	}
	if (systems.ELECTRICAL.Outputs.efis.getValue() >= 25) {
		pts.Sim.Sound.noSmokingSignInhibit.setBoolValue(1); # Prevent no smoking sound from playing at same time
		pts.Sim.Sound.seatbeltSign.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.seatbeltSign.setBoolValue(0);
			pts.Sim.Sound.noSmokingSignInhibit.setBoolValue(0);
		}, 2);
	}
}, 0, 0);

setlistener("/controls/switches/no-smoking-sign-status", func() {
	if (pts.Sim.Sound.noSmokingSign.getBoolValue()) {
		return;
	}
	if (systems.ELECTRICAL.Outputs.efis.getValue() >= 25 and !pts.Sim.Sound.noSmokingSignInhibit.getBoolValue()) {
		pts.Sim.Sound.noSmokingSign.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.noSmokingSign.setBoolValue(0);
		}, 1);
	}
}, 0, 0);
