# McDonnell Douglas MD-80 Transponder
# Copyright (c) 2026 Josh Davidson (Octal450)

var XPDR = {
	altSource: props.globals.initNode("/instrumentation/transponder/input/alt-source"),
	fgKnob: props.globals.getNode("/instrumentation/transponder/inputs/knob-mode", 1),
	fgMode: props.globals.getNode("/sim/gui/dialogs/radios/transponder-mode", 1), # OFF, STANDBY, TEST, GROUND, ON, ALTITUDE
	fgModeList: ["OFF", "STANDBY", "TEST", "GROUND", "ON", "ALTITUDE"],
	knob: props.globals.getNode("/instrumentation/transponder/output/knob"),
	mode: 1,
	ident: props.globals.getNode("/instrumentation/transponder/inputs/ident-btn", 1),
	identTime: 0,
	power: props.globals.getNode("/systems/electrical/outputs/transponder", 1),
	tcasDir: props.globals.getNode("/instrumentation/transponder/input/tcas-dir"),
	tcasMode: props.globals.getNode("/instrumentation/tcas/inputs/mode"),
	xpdr: props.globals.getNode("/instrumentation/transponder/input/xpdr"),
	init: func() { # Don't reset the code
		me.altSource.setBoolValue(0);
		me.setMode(0);
		me.tcasDir.setValue(-1);
		me.xpdr.setBoolValue(0);
	},
	modeKnob: func(d) {
		me.setMode(math.clamp(me.knob.getValue() + d, 0, 4));
	},
	setIdent: func() {
		me.ident.setBoolValue(1);
		me.identTime = pts.Sim.Time.elapsedSec.getValue();
		identChk.start();
	},
	setMode: func(m) {
		me.knob.setValue(m);
		if (m == 0) { # STBY
			me.fgKnob.setValue(1); # Standby
			me.fgMode.setValue("STANDBY");
			me.tcasMode.setValue(0); # OFF
		} else if (m == 1 or m == 2) { # ALT RPTG OFF
			me.fgKnob.setValue(4); # On
			me.fgMode.setValue("ON");
			me.tcasMode.setValue(0); # OFF
		} else if (m == 2) { # XPDR
			me.fgKnob.setValue(5);
			me.fgMode.setValue("ALTITUDE");
			me.tcasMode.setValue(0); # OFF
		} else if (m == 3) { # TA
			me.fgKnob.setValue(5);
			me.fgMode.setValue("ALTITUDE");
			me.tcasMode.setValue(2); # TA Only
		} else if (m == 4) { # TA/RA
			me.fgKnob.setValue(5);
			me.fgMode.setValue("ALTITUDE");
			me.tcasMode.setValue(3); # TA/RA
		}
	},
};

var identChk = maketimer(0.5, func {
	if (XPDR.power.getValue() >= 24) {
		if (XPDR.identTime + 18 <= pts.Sim.Time.elapsedSec.getValue()) {
			identChk.stop();
			XPDR.ident.setBoolValue(0);
		}
	} else {
		identChk.stop();
		XPDR.ident.setBoolValue(0);
	}
});
