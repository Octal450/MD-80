# McDonnell Douglas MD-11 PFD
# Copyright (c) 2020 Josh Davidson (Octal450)
# TODO: Add slow update loop

var pfd1Display = nil;
var pfd2Display = nil;
var pfd1 = nil;
var pfd2 = nil;

var Value = {
	Ai: {
		pitch: 0,
		roll: 0,
	},
};

var canvasBase = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
			
			var clip_el = canvas_group.getElementById(key ~ "_clip");
			if (clip_el != nil) {
				clip_el.setVisible(0);
				var tran_rect = clip_el.getTransformedBounds();
				
				var clip_rect = sprintf("rect(%d, %d, %d, %d)", 
					tran_rect[1], # 0 ys
					tran_rect[2], # 1 xe
					tran_rect[3], # 2 ye
					tran_rect[0] # 3 xs
				);
				
				# Coordinates are top, right, bottom, left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
				me[key].set("clip", clip_rect);
				me[key].set("clip-frame", canvas.Element.PARENT);
			}
		}
		
		me.aiBackgroundTrans = me["AI_background"].createTransform();
		me.aiBackgroundRot = me["AI_background"].createTransform();
		
		me.aiScaleTrans = me["AI_scale"].createTransform();
		me.aiScaleRot = me["AI_scale"].createTransform();
		
		me.page = canvas_group;
		
		return me;
	},
	getKeys: func() {
		return ["AI_center", "AI_background", "AI_scale", "FD_pitch", "FD_roll"];
	},
	setup: func() {
	},
	update: func() {
		pfd1.update();
		pfd2.update();
	},
	updateBase: func() {
		# AI
		Value.Ai.pitch = pts.Orientation.pitchDeg.getValue();
		Value.Ai.roll = pts.Orientation.rollDeg.getValue();
		
		AICenter = me["AI_center"].getCenter();
		
		me.aiBackgroundTrans.setTranslation(0, math.clamp(Value.Ai.pitch * 12.345, -240, 240)); # According to a pilot, it don't go the whole way
		me.aiBackgroundRot.setRotation(-Value.Ai.roll * D2R, AICenter);
		
		me.aiScaleTrans.setTranslation(0, Value.Ai.pitch * 12.345);
		me.aiScaleRot.setRotation(-Value.Ai.roll * D2R, AICenter);
	},
};

var canvasPfd1 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvasPfd1, canvasBase]};
		m.init(canvas_group, file);
		
		return m;
	},
	setup: func() {		
	},
	update: func() {
		if (dfgs.Output.fd1.getBoolValue()) {
			me["FD_pitch"].show();
			me["FD_roll"].show();
			
			me["FD_pitch"].setTranslation(0, -dfgs.Fd.pitchBar.getValue() * 4.2);
			me["FD_roll"].setTranslation(dfgs.Fd.rollBar.getValue() * 2.5, 0);
		} else {
			me["FD_pitch"].hide();
			me["FD_roll"].hide();
		}
		
		me.updateBase();
	},
};

var canvasPfd2 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvasPfd2, canvasBase]};
		m.init(canvas_group, file);
		
		return m;
	},
	setup: func() {
	},
	update: func() {
		if (dfgs.Output.fd2.getBoolValue()) {
			me["FD_pitch"].show();
			me["FD_roll"].show();
			
			me["FD_pitch"].setTranslation(0, -dfgs.Fd.pitchBar.getValue() * 4.2);
			me["FD_roll"].setTranslation(dfgs.Fd.rollBar.getValue() * 2.5, 0);
		} else {
			me["FD_pitch"].hide();
			me["FD_roll"].hide();
		}
		
		me.updateBase();
	},
};

var init = func() {
	pfd1Display = canvas.new({
		"name": "PFD1",
		"size": [1024, 800],
		"view": [1024, 800],
		"mipmapping": 1
	});
	pfd2Display = canvas.new({
		"name": "PFD2",
		"size": [1024, 800],
		"view": [1024, 800],
		"mipmapping": 1
	});
	
	pfd1Display.addPlacement({"node": "pfd1.screen"});
	pfd2Display.addPlacement({"node": "pfd2.screen"});
	
	var pfd1Group = pfd1Display.createGroup();
	var pfd2Group = pfd2Display.createGroup();
	
	pfd1 = canvasPfd1.new(pfd1Group, "Aircraft/MD-80/Models/Instruments/PFD/res/PFD.svg");
	pfd2 = canvasPfd2.new(pfd2Group, "Aircraft/MD-80/Models/Instruments/PFD/res/PFD.svg");
	
	canvasBase.setup();
	pfdUpdate.start();
	if (pts.Systems.Acconfig.Options.pfdRate.getValue() > 1) {
		rateApply();
	}
}

var rateApply = func() {
	pfdUpdate.restart(pts.Systems.Acconfig.Options.pfdRate.getValue() * 0.05);
}

var pfdUpdate = maketimer(0.05, func() {
	canvasBase.update();
});

var showPfd1 = func() {
	var dlg = canvas.Window.new([512, 400], "dialog").set("resize", 1);
	dlg.setCanvas(pfd1Display);
	dlg.set("title", "Captain's PFD");
}

var showPfd2 = func() {
	var dlg = canvas.Window.new([512, 400], "dialog").set("resize", 1);
	dlg.setCanvas(pfd2Display);
	dlg.set("title", "First Officers's PFD");
}
