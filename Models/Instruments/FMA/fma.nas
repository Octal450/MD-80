# McDonnell Douglas MD-80 FMA
# Copyright (c) 2020 Josh Davidson (Octal450)

var armL = nil;
var armLDisplay = nil;
var pitchL = nil;
var pitchLDisplay = nil;
var rollL = nil;
var rollLDisplay = nil;

var Modes = { # 0 thrust, 1 arm, 2 roll, 3 pitch
	Line1: [nil, dfgs.FMA.armA, dfgs.FMA.rollA, dfgs.FMA.pitchA],
	Line2: [nil, dfgs.FMA.armB, dfgs.FMA.rollB, dfgs.FMA.pitchB],
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
	},
	update: func() {
		if (systems.ELEC.Generic.fmaPower.getValue() >= 25) {
			armL.page.show();
			rollL.page.show();
			pitchL.page.show();
			armL.update();
			rollL.update();
			pitchL.update();
		} else {
			armL.page.hide();
			rollL.page.hide();
			pitchL.page.hide();
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

setlistener("sim/signals/fdm-initialized", func {
	armLDisplay = canvas.new({
		"name": "armL",
		"size": [256, 180],
		"view": [256, 180],
		"mipmapping": 1
	});
	rollLDisplay = canvas.new({
		"name": "rollL",
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
	
	armLDisplay.addPlacement({"node": "arm1.screen"});
	rollLDisplay.addPlacement({"node": "roll1.screen"});
	pitchLDisplay.addPlacement({"node": "pitch1.screen"});
	
	var armLGroup = armLDisplay.createGroup();
	var rollLGroup = rollLDisplay.createGroup();
	var pitchLGroup = pitchLDisplay.createGroup();
	
	armL = canvasArmL.new(armLGroup, "Aircraft/MD-80/Models/Instruments/FMA/res/three.svg");
	rollL = canvasRollL.new(rollLGroup, "Aircraft/MD-80/Models/Instruments/FMA/res/three.svg");
	pitchL = canvasPitchL.new(pitchLGroup, "Aircraft/MD-80/Models/Instruments/FMA/res/four.svg");
	
	canvasBase.setup();
	fmaUpdate.start();
});

var fmaUpdate = maketimer(0.25, func {
	canvasBase.update();
});
