# McDonnell Douglas MD-80 Main Libraries
# Copyright (c) 2020 Josh Davidson (Octal450)

print("------------------------------------------------");
print("Copyright (c) 2019-2020 Josh Davidson (Octal450)");
print("------------------------------------------------");

setprop("/sim/menubar/default/menu[0]/item[0]/enabled", 0);
setprop("/sim/menubar/default/menu[2]/item[0]/enabled", 0);
setprop("/sim/menubar/default/menu[2]/item[2]/enabled", 0);
setprop("/sim/menubar/default/menu[3]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[9]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[10]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[11]/enabled", 0);
setprop("/sim/multiplay/visibility-range-nm", 110);

var systemsInit = func {
	dfgs.ITAF.init(0);
	systems.TRI.init();
}

setlistener("sim/signals/fdm-initialized", func {
	systemsInit();
});

var systemsLoop = maketimer(0.1, func {
	# Put loops
	
	if (pts.Velocities.groundspeedKt.getValue() >= 15) {
		pts.Systems.Shake.effect.setBoolValue(1);
	} else {
		pts.Systems.Shake.effect.setBoolValue(0);
	}
});

# Prevent gear up accidently while WoW
setlistener("/controls/gear/gear-down", func {
	if (!pts.Controls.Gear.gearDown.getBoolValue()) {
		if (pts.Gear.wow[0].getBoolValue() or pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) {
			pts.Controls.Gear.gearDown.setBoolValue(1);
		}
	}
});

canvas.Text._lastText = canvas.Text["_lastText"];
canvas.Text.setText = func(text) {
	if (text == me._lastText and text != nil and size(text) == size(me._lastText)) {
		return me;
	}
	me._lastText = text;
	me.set("text", typeof(text) == "scalar" ? text : "");
};
canvas.Element._lastVisible = nil;
canvas.Element.show = func {
	if (1 == me._lastVisible) {
		return me;
	}
	me._lastVisible = 1;
	me.setBool("visible", 1);
};
canvas.Element.hide = func {
	if (0 == me._lastVisible) {
		return me;
	}
	me._lastVisible = 0;
	me.setBool("visible", 0);
};
canvas.Element.setVisible = func(vis) {
	if (vis == me._lastVisible) {
		return me;
	}
	me._lastVisible = vis;
	me.setBool("visible", vis);
};

# Custom controls.nas overwrites
controls.flapsDown = func(step) {
	pts.Controls.Flight.flapsTemp = pts.Controls.Flight.flaps.getValue();
	if (step == 1) {
		if (pts.Controls.Flight.flapsTemp < 0.2) {
			pts.Controls.Flight.flaps.setValue(0.2);
		} else if (pts.Controls.Flight.flapsTemp < 0.36) {
			pts.Controls.Flight.flaps.setValue(0.36);
		} else if (pts.Controls.Flight.flapsTemp < 0.52) {
			pts.Controls.Flight.flaps.setValue(0.52);
		} else if (pts.Controls.Flight.flapsTemp < 0.68) {
			pts.Controls.Flight.flaps.setValue(0.68);
		} else if (pts.Controls.Flight.flapsTemp < 0.84) {
			pts.Controls.Flight.flaps.setValue(0.84);
		}
	} else if (step == -1) {
		if (pts.Controls.Flight.flapsTemp > 0.68) {
			pts.Controls.Flight.flaps.setValue(0.68);
		} else if (pts.Controls.Flight.flapsTemp > 0.52) {
			pts.Controls.Flight.flaps.setValue(0.52);
		} else if (pts.Controls.Flight.flapsTemp > 0.36) {
			pts.Controls.Flight.flaps.setValue(0.36);
		} else if (pts.Controls.Flight.flapsTemp > 0.2) {
			pts.Controls.Flight.flaps.setValue(0.2);
		} else if (pts.Controls.Flight.flapsTemp > 0) {
			pts.Controls.Flight.flaps.setValue(0);
		}
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

var deploySpeedbrake = func {
	pts.Controls.Flight.speedbrakeTemp = pts.Controls.Flight.speedbrake.getValue();
	if (pts.Gear.wow[0].getBoolValue()) {
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

var retractSpeedbrake = func {
	pts.Controls.Flight.speedbrakeTemp = pts.Controls.Flight.speedbrake.getValue();
	if (pts.Gear.wow[0].getBoolValue()) {
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
	#if (trim motor has power) { # Fix prop
		slewProp("/controls/flight/elevator-trim", d * 0.02666664); # 0.02666664 is the rate in JSB normalized (0.333333 / 12.5)
	#}
}

setlistener("/controls/flight/elevator-trim", func {
	if (pts.Controls.Flight.elevatorTrim.getValue() > 0.2) {
		pts.Controls.Flight.elevatorTrim.setValue(0.2);
	}
}, 0, 0);

if (pts.Controls.Flight.autoCoordination.getBoolValue()) {
	pts.Controls.Flight.autoCoordination.setBoolValue(0);
	pts.Controls.Flight.aileronDrivesTiller.setBoolValue(1);
} else {
	pts.Controls.Flight.aileronDrivesTiller.setBoolValue(0);
}

setlistener("/controls/flight/auto-coordination", func {
	pts.Controls.Flight.autoCoordination.setBoolValue(0);
	print("System: Auto Coordination has been turned off as it is not compatible with the flight control system of this aircraft.");
	screen.log.write("Auto Coordination has been disabled as it is not compatible with the flight control system of this aircraft", 1, 0, 0);
});

var _shakeFlag = 0;
var hd_t = 360;
var resetView = func() {
	if (!pts.Sim.CurrentView.viewNumber.getBoolValue()) {
		if (pts.Sim.Rendering.Headshake.enabled.getBoolValue()) {
			_shakeFlag = 1;
			pts.Sim.Rendering.Headshake.enabled.setBoolValue(0);
		} else {
			_shakeFlag = 0;
		}
		
		hd_t = 360;
		if (pts.Sim.CurrentView.headingOffsetDeg.getValue() < 180) {
			hd_t = hd_t - 360;
		}
		
		interpolate("sim/current-view/field-of-view", 84, 0.33);
		interpolate("sim/current-view/heading-offset-deg", hd_t, 0.33);
		interpolate("sim/current-view/pitch-offset-deg", -18, 0.33);
		interpolate("sim/current-view/roll-offset-deg", 0, 0.33);
		interpolate("sim/current-view/x-offset-m", -0.5, 0.33); 
		interpolate("sim/current-view/y-offset-m", 1.3, 0.33); 
		interpolate("sim/current-view/z-offset-m", -19.6, 0.33);
		
		if (_shakeFlag) {
			pts.Sim.Rendering.Headshake.enabled.setBoolValue(1);
		}
	} 
}

# Custom Sounds
var Sound = {
	btn1: func() {
		if (pts.Sim.Sound.btn1.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.btn1.setBoolValue(1);
		settimer(func {
			pts.Sim.Sound.btn1.setBoolValue(0);
		}, 0.2);
	},
	btn3: func() {
		if (pts.Sim.Sound.btn3.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.btn3.setBoolValue(1);
		settimer(func {
			pts.Sim.Sound.btn3.setBoolValue(0);
		}, 0.2);
	},
	knb1: func() {
		if (pts.Sim.Sound.knb1.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.knb1.setBoolValue(1);
		settimer(func {
			pts.Sim.Sound.knb1.setBoolValue(0);
		}, 0.2);
	},
	ohBtn: func() {
		if (pts.Sim.Sound.ohBtn.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.ohBtn.setBoolValue(1);
		settimer(func {
			pts.Sim.Sound.ohBtn.setBoolValue(0);
		}, 0.2);
	},
	switch1: func() {
		if (pts.Sim.Sound.switch1.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.switch1.setBoolValue(1);
		settimer(func {
			pts.Sim.Sound.switch1.setBoolValue(0);
		}, 0.2);
	},
};

var flaps_click = props.globals.getNode("/MD80/other/flaps-click", 1);

setlistener("/controls/flight/flaps", func {
	if (flaps_click.getBoolValue()) {
		return;
	}
	flaps_click.setBoolValue(1);
}, 0, 0);

setlistener("/MD80/other/flaps-click", func {
	if (!flaps_click.getBoolValue()) {
		return;
	}
	settimer(func {
		flaps_click.setBoolValue(0);
	}, 0.4);
});

setlistener("/controls/switches/seatbelt-sign-status", func {
	if (pts.Sim.Sound.seatbeltSign.getBoolValue()) {
		return;
	}
	if (systems.ELEC.Generic.efis.getValue() >= 25) {
		pts.Sim.Sound.noSmokingSignInhibit.setBoolValue(1); # Prevent no smoking sound from playing at same time
		pts.Sim.Sound.seatbeltSign.setBoolValue(1);
		settimer(func {
			pts.Sim.Sound.seatbeltSign.setBoolValue(0);
			pts.Sim.Sound.noSmokingSignInhibit.setBoolValue(0);
		}, 2);
	}
}, 0, 0);

setlistener("/controls/switches/no-smoking-sign-status", func {
	if (pts.Sim.Sound.noSmokingSign.getBoolValue()) {
		return;
	}
	if (systems.ELEC.Generic.efis.getValue() >= 25 and !pts.Sim.Sound.noSmokingSignInhibit.getBoolValue()) {
		pts.Sim.Sound.noSmokingSign.setBoolValue(1);
		settimer(func {
			pts.Sim.Sound.noSmokingSign.setBoolValue(0);
		}, 1);
	}
}, 0, 0);

setprop("/systems/acconfig/libraries-loaded", 1);
