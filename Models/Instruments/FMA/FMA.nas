# McDonnell Douglas MD-80 FMA
# Copyright (c) 2020 Josh Davidson (Octal450)

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

var Modes = { # 0 thrust, 1 arm, 2 roll, 3 pitch
	Line1: [nil, dfgs.FMA.armA, dfgs.FMA.rollA, dfgs.FMA.pitchA],
	Line2: [nil, dfgs.FMA.armB, dfgs.FMA.rollB, dfgs.FMA.pitchB],
};

var Value = {
	apOn: 0,
};

var canvasBase = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "FMA.ttf";
		};
		
		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}
		
		me.page = canvas_group;
		
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
		Value.apOn = dfgs.Output.ap1.getBoolValue() or dfgs.Output.ap2.getBoolValue();
		if (systems.ELEC.Generic.fmaPower.getValue() >= 25 and (dfgs.Output.fd1.getBoolValue() or Value.apOn)) {
			armL.page.show();
			pitchL.page.show();
			rollL.page.show();
			armL.update();
			pitchL.update();
			rollL.update();
		} else {
			armL.page.hide();
			pitchL.page.hide();
			rollL.page.hide();
		}
		if (systems.ELEC.Generic.fmaPower.getValue() >= 25 and (dfgs.Output.fd2.getBoolValue() or Value.apOn)) {
			armR.page.show();
			pitchR.page.show();
			rollR.page.show();
			armR.update();
			pitchR.update();
			rollR.update();
		} else {
			armR.page.hide();
			pitchR.page.hide();
			rollR.page.hide();
		}
	},
	updateCommon: func(w) { # w is window, 0 thrust, 1 arm, 2 roll, 3 pitch
		me["Line1"].setText(Modes.Line1[w].getValue());
		me["Line2"].setText(Modes.Line2[w].getValue());
	},
};

var canvasArmL = {
	new: func(canvas_group, file) {
		var m = {parents: [canvasArmL, canvasBase]};
		m.init(canvas_group, file);

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
	new: func(canvas_group, file) {
		var m = {parents: [canvasArmR, canvasBase]};
		m.init(canvas_group, file);

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
	new: func(canvas_group, file) {
		var m = {parents: [canvasPitchL, canvasBase]};
		m.init(canvas_group, file);

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
	new: func(canvas_group, file) {
		var m = {parents: [canvasPitchR, canvasBase]};
		m.init(canvas_group, file);

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
	new: func(canvas_group, file) {
		var m = {parents: [canvasRollL, canvasBase]};
		m.init(canvas_group, file);

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
	new: func(canvas_group, file) {
		var m = {parents: [canvasRollR, canvasBase]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["Line1", "Line2"];
	},
	update: func() {
		me.updateCommon(2);
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
		"name": "armL",
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
		"name": "pitchL",
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
		"name": "rollL",
		"size": [256, 180],
		"view": [256, 180],
		"mipmapping": 1
	});
	
	armLDisplay.addPlacement({"node": "arm1.screen"});
	armRDisplay.addPlacement({"node": "arm2.screen"});
	pitchLDisplay.addPlacement({"node": "pitch1.screen"});
	pitchRDisplay.addPlacement({"node": "pitch2.screen"});
	rollLDisplay.addPlacement({"node": "roll1.screen"});
	rollRDisplay.addPlacement({"node": "roll2.screen"});
	
	var armLGroup = armLDisplay.createGroup();
	var armRGroup = armRDisplay.createGroup();
	var pitchLGroup = pitchLDisplay.createGroup();
	var pitchRGroup = pitchRDisplay.createGroup();
	var rollLGroup = rollLDisplay.createGroup();
	var rollRGroup = rollRDisplay.createGroup();
	
	armL = canvasArmL.new(armLGroup, "Aircraft/MD-80/Models/Instruments/FMA/res/three.svg");
	armR = canvasArmR.new(armRGroup, "Aircraft/MD-80/Models/Instruments/FMA/res/three.svg");
	pitchL = canvasPitchL.new(pitchLGroup, "Aircraft/MD-80/Models/Instruments/FMA/res/four.svg");
	pitchR = canvasPitchR.new(pitchRGroup, "Aircraft/MD-80/Models/Instruments/FMA/res/four.svg");
	rollL = canvasRollL.new(rollLGroup, "Aircraft/MD-80/Models/Instruments/FMA/res/three.svg");
	rollR = canvasRollR.new(rollRGroup, "Aircraft/MD-80/Models/Instruments/FMA/res/three.svg");
	
	canvasBase.setup();
	fmaUpdate.start();
}

var fmaUpdate = maketimer(0.25, func() {
	canvasBase.update();
});
