# McDonnell Douglas MD-80 FMA
# Copyright (c) 2023 Josh Davidson (Octal450)

var armL = nil;
var armLDisplay = nil;
var armR = nil;
var armRDisplay = nil;
var pitchL = nil;
var pitchLDisplay = nil;
var pitchR = nil;
var pitchRDisplay = nil;
var rollL = nil;
var rollLDisplay = nil;
var rollR = nil;
var rollRDisplay = nil;
var thrL = nil;
var thrLDisplay = nil;
var thrR = nil;
var thrRDisplay = nil;

var Modes = { # 0 thrust, 1 arm, 2 roll, 3 pitch
	Line1: [dfgs.Fma.thrA, dfgs.Fma.armA, dfgs.Fma.rollA, dfgs.Fma.pitchA],
	Line2: [dfgs.Fma.thrB, dfgs.Fma.armB, dfgs.Fma.rollB, dfgs.Fma.pitchB],
};

var Value = {
	activeModeInt: 0,
	annunTest: 0,
	apOn: 0,
	atsOn: 0,
	blink: 0,
	blinkActive: [0, 0, 0, 0],
	line2: "",
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
	setup: func() {
		armL.setup();
		armR.setup();
	},
	update: func() {
		# Blink Generator - We use this because the FMA updates only ever quarter second, so we need to ensure it is in sync
		if (Value.blink < 3) Value.blink = Value.blink + 1;
		else Value.blink = 0;
		
		Value.activeModeInt = systems.TRI.Limit.activeModeInt.getValue();
		Value.annunTest = pts.Controls.Switches.annunTest5Sec.getValue() > 0;
		Value.apOn = dfgs.Output.ap1.getBoolValue() or dfgs.Output.ap2.getBoolValue();
		Value.atsOn = dfgs.Output.athr.getBoolValue();
		
		if (systems.ELEC.Generic.fma[0].getValue() >= 24) {
			if (Value.annunTest) {
				thrL.update();
				thrL.page.show();
				armL.update();
				armL.page.show();
				pitchL.update();
				pitchL.page.show();
				rollL.update();
				rollL.page.show();
			} else {
				if (Value.atsOn or Value.activeModeInt == 5) { # For showing flex digit
					thrL.update();
					thrL.page.show();
				} else {
					thrL.page.hide();
				}
				
				if (dfgs.Output.fd1.getBoolValue() or Value.apOn) {
					armL.update();
					armL.page.show();
					pitchL.update();
					pitchL.page.show();
					rollL.update();
					rollL.page.show();
				} else {
					armL.page.hide();
					pitchL.page.hide();
					rollL.page.hide();
				}
			}
		} else {
			armL.page.hide();
			pitchL.page.hide();
			rollL.page.hide();
			thrL.page.hide();
		}
		
		if (systems.ELEC.Generic.fma[1].getValue() >= 24) {
			if (Value.annunTest) {
				thrR.update();
				thrR.page.show();
				armR.update();
				armR.page.show();
				pitchR.update();
				pitchR.page.show();
				rollR.update();
				rollR.page.show();
			} else {
				if (Value.atsOn or Value.activeModeInt == 5) { # For showing flex digit
					thrR.update();
					thrR.page.show();
				} else {
					thrR.page.hide();
				}
				
				if (dfgs.Output.fd2.getBoolValue() or Value.apOn) {
					armR.update();
					armR.page.show();
					pitchR.update();
					pitchR.page.show();
					rollR.update();
					rollR.page.show();
				} else {
					armR.page.hide();
					pitchR.page.hide();
					rollR.page.hide();
				}
			}
		} else {
			armR.page.hide();
			pitchR.page.hide();
			rollR.page.hide();
			thrR.page.hide();
		}
	},
	updateCommon: func(w) { # w is window, 0 thrust, 1 arm, 2 roll, 3 pitch
		if (Value.annunTest) { # Stays active for 5 seconds
			if (w == 1 or w == 2) {
				me["Line1"].setText("¤¤¤");
				me["Line2"].setText("¤¤¤");
			} else {
				me["Line1"].setText("¤¤¤¤");
				me["Line2"].setText("¤¤¤¤");
			}
		} else {
			if (Value.blinkActive[w] and Value.blink < 2) {
				me["Line1"].setText("");
				me["Line2"].setText("");
			} else {
				me["Line1"].setText(Modes.Line1[w].getValue());
				Value.line2 = Modes.Line2[w].getValue();
				
				if (w == 0 and Value.line2 == "FLX") { # For THR window Flex Temp
					me["Line2"].setText(sprintf("%02d", systems.TRI.Limit.flexTemp.getValue()));
				} else if (w == 1 and Value.line2 == "ALT" and pts.Systems.Acconfig.Options.armedAltAsFl.getBoolValue()) { # For ARM window Altitude as Flight Level
					me["Line2"].setText(sprintf("%03d", math.round(dfgs.Input.alt.getValue() / 100)));
				} else {
					me["Line2"].setText(Value.line2);
				}
			}
		}
	},
};

var canvasArmL = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasArmL, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	setup: func() {
		me["Line1"].setColor(0.7333,0.3803,0);
		me["Line2"].setColor(0.7333,0.3803,0);
	},
	update: func() {
		me.updateCommon(1);
	},
};

var canvasArmR = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasArmR, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	setup: func() {
		me["Line1"].setColor(0.7333,0.3803,0);
		me["Line2"].setColor(0.7333,0.3803,0);
	},
	update: func() {
		me.updateCommon(1);
	},
};

var canvasPitchL = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPitchL, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		me.updateCommon(3);
	},
};

var canvasPitchR = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPitchR, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		me.updateCommon(3);
	},
};

var canvasRollL = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasRollL, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		me.updateCommon(2);
	},
};

var canvasRollR = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasRollR, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		me.updateCommon(2);
	},
};

var canvasThrL = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasThrL, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		if (!Value.atsOn and Value.activeModeInt == 5) { # For showing flex digit
			me["Line1"].hide();
		} else {
			me["Line1"].show();
		}
		
		me.updateCommon(0);
	},
};

var canvasThrR = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasThrR, canvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		if (!Value.atsOn and Value.activeModeInt == 5) { # For showing flex digit
			me["Line1"].hide();
		} else {
			me["Line1"].show();
		}
		
		me.updateCommon(0);
	},
};

var init = func() {
	armLDisplay = canvas.new({
		"name": "armL",
		"size": [256, 180],
		"view": [256, 180],
		"mipmapping": 1
	});
	armRDisplay = canvas.new({
		"name": "armR",
		"size": [256, 180],
		"view": [256, 180],
		"mipmapping": 1
	});
	pitchLDisplay = canvas.new({
		"name": "pitchL",
		"size": [305, 180],
		"view": [305, 180],
		"mipmapping": 1
	});
	pitchRDisplay = canvas.new({
		"name": "pitchR",
		"size": [305, 180],
		"view": [305, 180],
		"mipmapping": 1
	});
	rollLDisplay = canvas.new({
		"name": "rollL",
		"size": [256, 180],
		"view": [256, 180],
		"mipmapping": 1
	});
	rollRDisplay = canvas.new({
		"name": "rollR",
		"size": [256, 180],
		"view": [256, 180],
		"mipmapping": 1
	});
	thrLDisplay = canvas.new({
		"name": "thrL",
		"size": [305, 180],
		"view": [305, 180],
		"mipmapping": 1
	});
	thrRDisplay = canvas.new({
		"name": "thrR",
		"size": [305, 180],
		"view": [305, 180],
		"mipmapping": 1
	});
	
	armLDisplay.addPlacement({"node": "arm1.screen"});
	armRDisplay.addPlacement({"node": "arm2.screen"});
	pitchLDisplay.addPlacement({"node": "pitch1.screen"});
	pitchRDisplay.addPlacement({"node": "pitch2.screen"});
	rollLDisplay.addPlacement({"node": "roll1.screen"});
	rollRDisplay.addPlacement({"node": "roll2.screen"});
	thrLDisplay.addPlacement({"node": "thr1.screen"});
	thrRDisplay.addPlacement({"node": "thr2.screen"});
	
	var armLGroup = armLDisplay.createGroup();
	var armRGroup = armRDisplay.createGroup();
	var pitchLGroup = pitchLDisplay.createGroup();
	var pitchRGroup = pitchRDisplay.createGroup();
	var rollLGroup = rollLDisplay.createGroup();
	var rollRGroup = rollRDisplay.createGroup();
	var thrLGroup = thrLDisplay.createGroup();
	var thrRGroup = thrRDisplay.createGroup();
	
	armL = canvasArmL.new(armLGroup, "Aircraft/MD-80/Nasal/Displays/res/FMA_Arm_Roll.svg");
	armR = canvasArmR.new(armRGroup, "Aircraft/MD-80/Nasal/Displays/res/FMA_Arm_Roll.svg");
	pitchL = canvasPitchL.new(pitchLGroup, "Aircraft/MD-80/Nasal/Displays/res/FMA_Pitch.svg");
	pitchR = canvasPitchR.new(pitchRGroup, "Aircraft/MD-80/Nasal/Displays/res/FMA_Pitch.svg");
	rollL = canvasRollL.new(rollLGroup, "Aircraft/MD-80/Nasal/Displays/res/FMA_Arm_Roll.svg");
	rollR = canvasRollR.new(rollRGroup, "Aircraft/MD-80/Nasal/Displays/res/FMA_Arm_Roll.svg");
	thrL = canvasThrL.new(thrLGroup, "Aircraft/MD-80/Nasal/Displays/res/FMA_Thrust.svg");
	thrR = canvasThrR.new(thrRGroup, "Aircraft/MD-80/Nasal/Displays/res/FMA_Thrust.svg");
	
	canvasBase.setup();
	update.start();
}

var update = maketimer(0.25, func() {
	canvasBase.update();
});
