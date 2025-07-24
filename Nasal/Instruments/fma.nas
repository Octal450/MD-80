# McDonnell Douglas MD-80 FMA
# Copyright (c) 2025 Josh Davidson (Octal450)

var fmaL = nil;
var fmaLDisplay = nil;
var fmaR = nil;
var fmaRDisplay = nil;

var Modes = { # 0 thrust, 1 arm, 2 roll, 3 pitch
	line1: [dfgs.Fma.thrA, dfgs.Fma.armA, dfgs.Fma.rollA, dfgs.Fma.pitchA],
	line2: [dfgs.Fma.thrB, dfgs.Fma.armB, dfgs.Fma.rollB, dfgs.Fma.pitchB],
};

var Value = {
	activeModeInt: 0,
	altStr: "",
	annunTest: 0,
	apOn: 0,
	atsOn: 0,
	blink: 0,
	blinkActive: [0, 0, 0, 0],
	fdOn: 0,
	line2: ["", "", "", ""],
};

var canvasBase = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return "Std16SegCustom.ttf";
		};
		
		canvas.parsesvg(canvasGroup, file, {"font-mapper": font_mapper});
		
		var svgKeys = me.getKeys();
		foreach(var key; svgKeys) {
			me[key] = canvasGroup.getElementById(key);
		}
		
		me.page = canvasGroup;
		
		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
		# Blink Generator - We use this because the FMA updates only ever quarter second, so we need to ensure it is in sync
		if (Value.blink < 3) Value.blink = Value.blink + 1;
		else Value.blink = 0;
		
		if (systems.ELECTRICAL.Outputs.fma[0].getValue() >= 24) {
			fmaL.update();
			fmaL.page.show();
		} else {
			fmaL.page.hide();
		}
		
		if (systems.ELECTRICAL.Outputs.fma[1].getValue() >= 24) {
			fmaR.update();
			fmaR.page.show();
		} else {
			fmaR.page.hide();
		}
	},
	updateBase: func(n) {
		Value.activeModeInt = systems.THRLIM.Limit.activeModeInt.getValue();
		Value.annunTest = pts.Controls.Switches.annunTest5Sec.getValue() > 0;
		Value.apOn = dfgs.Output.ap1.getBoolValue() or dfgs.Output.ap2.getBoolValue();
		Value.atsOn = dfgs.Output.athr.getBoolValue();
		if (n == 0) Value.fdOn = dfgs.Output.fd1.getBoolValue();
		if (n == 1) Value.fdOn = dfgs.Output.fd2.getBoolValue();
		
		# Thrust
		if (Value.atsOn or Value.activeModeInt == 5 or Value.annunTest) { # For showing flex digit
			Value.line2[0] = Modes.line2[0].getValue();
			
			if (Value.blinkActive[0] and Value.blink < 2) {
				me["ThrLine1"].setText("");
				me["ThrLine2"].setText("");
			} else {
				me["ThrLine1"].setText(Modes.line1[0].getValue());
				
				if (Value.line2[0] == "FLX") {
					me["ThrLine2"].setText(sprintf("%02d", systems.THRLIM.Limit.flexTemp.getValue()));
				} else {
					me["ThrLine2"].setText(Value.line2[0]);
				}
			}
			
			if (!Value.atsOn and Value.activeModeInt == 5) { # For showing flex digit
				me["ThrLine1"].hide();
			} else {
				me["ThrLine1"].show();
			}
			
			me["Thr"].show();
		} else {
			me["Thr"].hide();
		}
		
		if (Value.apOn or Value.fdOn) {
			# Arm
			Value.line2[1] = Modes.line2[1].getValue();
			
			if (Value.blinkActive[1] and Value.blink < 2) {
				me["ArmLine1"].setText("");
				me["ArmLine2"].setText("");
			} else {
				me["ArmLine1"].setText(Modes.line1[1].getValue());
				
				if (Value.line2[1] == "ALT" and pts.Systems.Acconfig.Options.armedAltAsFl.getBoolValue()) { # For ARM window Altitude as Flight Level
					Value.altStr = sprintf("%d", math.round(dfgs.Input.alt.getValue() / 100));
					if (int(Value.altStr) < 10) {
						Value.altStr = "==" ~ Value.altStr;
					} else if (int(Value.altStr) < 100) {
						Value.altStr = "=" ~ Value.altStr;
					}
					
					me["ArmLine2"].setText(Value.altStr);
				} else {
					me["ArmLine2"].setText(Value.line2[1]);
				}
			}
			
			# Roll
			Value.line2[2] = Modes.line2[2].getValue();
			
			if (Value.blinkActive[2] and Value.blink < 2) {
				me["RollLine1"].setText("");
				me["RollLine2"].setText("");
			} else {
				me["RollLine1"].setText(Modes.line1[2].getValue());
				me["RollLine2"].setText(Modes.line2[2].getValue());
			}
			
			# Pitch
			Value.line2[3] = Modes.line2[3].getValue();
			
			if (Value.blinkActive[3] and Value.blink < 2) {
				me["PitchLine1"].setText("");
				me["PitchLine2"].setText("");
			} else {
				if (dfgs.Fma.spdLow and Value.blink < 2) {
					me["PitchLine1"].setText("SPD");
					me["PitchLine2"].setText("LOW");
				} else if (dfgs.Output.vert.getValue() == 1 and abs(dfgs.Input.vs.getValue()) < 50) {
					me["PitchLine1"].setText("ALT");
					me["PitchLine2"].setText("HLD");
				} else {
					me["PitchLine1"].setText(Modes.line1[3].getValue());
					me["PitchLine2"].setText(Modes.line2[3].getValue());
				}
			}
			
			me["Arm"].show();
			me["Roll"].show();
			me["Pitch"].show();
		} else {
			me["Arm"].hide();
			me["Roll"].hide();
			me["Pitch"].hide();
		}
	},
};

var canvasFmaL = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasFmaL, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Arm", "ArmLine1", "ArmLine2", "Pitch", "PitchLine1", "PitchLine2", "Roll", "RollLine1", "RollLine2", "Thr", "ThrLine1", "ThrLine2"];
	},
	update: func() {
		me.updateBase(0);
	},
};

var canvasFmaR = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasFmaR, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Arm", "ArmLine1", "ArmLine2", "Pitch", "PitchLine1", "PitchLine2", "Roll", "RollLine1", "RollLine2", "Thr", "ThrLine1", "ThrLine2"];
	},
	update: func() {
		me.updateBase(1);
	},
};

var setup = func() {
	fmaLDisplay = canvas.new({
		"name": "fmaL",
		"size": [1208, 180],
		"view": [1208, 180],
		"mipmapping": 1
	});
	fmaRDisplay = canvas.new({
		"name": "fmaR",
		"size": [1208, 180],
		"view": [1208, 180],
		"mipmapping": 1
	});
	
	fmaLDisplay.addPlacement({"node": "fma1.screen"});
	fmaRDisplay.addPlacement({"node": "fma2.screen"});
	
	var fmaLGroup = fmaLDisplay.createGroup();
	var fmaRGroup = fmaRDisplay.createGroup();
	
	fmaL = canvasFmaL.new(fmaLGroup, "Aircraft/MD-80/Nasal/Instruments/res/fma.svg");
	fmaR = canvasFmaR.new(fmaRGroup, "Aircraft/MD-80/Nasal/Instruments/res/fma.svg");
	
	update.start();
}

var update = maketimer(0.25, func() {
	canvasBase.update();
});
