# McDonnell Douglas MD-80 PFD
# Copyright (c) 2025 Josh Davidson (Octal450)

var pfd1 = nil;
var pfd1Display = nil;
var pfd2 = nil;
var pfd2Display = nil;

var Value = {
	Ai: {
		alpha: 0,
		center: nil,
		dualCueFd: 0,
		fd: [0, 0],
		pitch: 0,
		risingRunwayMultiplier: 0,
		risingRunwayOffset: 0,
		roll: 0,
		stallAlphaDeg: 0,
	},
	Misc: {
		dfgsBit: [0, 0],
		lat: 0,
	},
	Nav: {
		Freq: {
			selected: [0, 0],
			selectedInteger: [0, 0],
			selectedDecimal: [0, 0],
		},
		gsInRange: [0, 0],
		headingNeedleDeflectionNorm: [0, 0],
		inRange: [0, 0],
		isIls: [0, 0],
		signalQuality: [0, 0],
	},
	Ra: {
		agl: 0,
		dh: 0,
		dhLatch: 0,
	},
};

var canvasBase = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return "MD80DU.ttf";
		};
		
		canvas.parsesvg(canvasGroup, file, {"font-mapper": font_mapper});
		
		var svgKeys = me.getKeys();
		foreach(var key; svgKeys) {
			me[key] = canvasGroup.getElementById(key);
			
			var clip_el = canvasGroup.getElementById(key ~ "_clip");
			if (clip_el != nil) {
				clip_el.setVisible(0);
				var tranRect = clip_el.getTransformedBounds();
				
				var clip_rect = sprintf("rect(%d, %d, %d, %d)", 
					tranRect[1], # 0 ys
					tranRect[2], # 1 xe
					tranRect[3], # 2 ye
					tranRect[0] # 3 xs
				);
				
				# Coordinates are top, right, bottom, left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
				me[key].set("clip", clip_rect);
				me[key].set("clip-frame", canvas.Element.PARENT);
			}
		}
		
		Value.Ai.center = me["AI_center"].getCenter();
		
		me.aiBackgroundTrans = me["AI_background"].createTransform();
		me.aiBackgroundRot = me["AI_background"].createTransform();
		
		me.aiScaleTrans = me["AI_scale"].createTransform();
		me.aiScaleRot = me["AI_scale"].createTransform();
		
		me.fdVTrans = me["FD_v"].createTransform();
		me.fdVRot = me["FD_v"].createTransform();
		
		me.page = canvasGroup;
		
		return me;
	},
	getKeys: func() {
		return ["AI_arrow_dn", "AI_arrow_up", "AI_background", "AI_bank", "AI_center", "AI_dual_cue", "AI_error", "AI_group", "AI_group2", "AI_group3", "AI_PLI", "AI_PLI_dual_cue", "AI_PLI_single_cue", "AI_rising_runway", "AI_scale", "AI_scale_dc",
		"AI_single_cue", "DH_below", "DH_group", "DH_label", "DH_pointer", "DH_set", "FD_v", "FD_pitch", "FD_roll", "FS_pointer", "FS_scale", "Gndspd", "GS_group", "GS_no", "GS_pointer", "GS_scale", "ILS_group", "Inner_marker", "LOC_no", "LOC_pointer",
		"LOC_scale", "Middle_marker", "NAV_ILS", "NAV_pointer", "NAV_scale", "Outer_marker", "RA_bars", "RA_scale"];
	},
	setup: func() {
		# Hide the pages by default
		pfd1.page.hide();
		pfd2.page.hide();
	},
	update: func() {
		if (systems.DUController.updatePfd1) {
			pfd1.update();
		}
		if (systems.DUController.updatePfd2) {
			pfd2.update();
		}
	},
	updateBase: func(n) {
		Value.Ai.dualCueFd = pts.Systems.Acconfig.Options.dualCueFd.getBoolValue();
		if (n == 0) Value.Misc.dfgsBit[0] = dfgs.Main.bit1.getBoolValue();
		if (n == 1) Value.Misc.dfgsBit[1] = dfgs.Main.bit2.getBoolValue();
		if (n == 0) Value.Ai.fd[0] = dfgs.Output.fd1.getBoolValue();
		if (n == 1) Value.Ai.fd[1] = dfgs.Output.fd2.getBoolValue();
		Value.Misc.lat = dfgs.Output.lat.getValue();
		Value.Ra.agl = pts.Position.gearAglFt.getValue();
		
		# IRS
		if (systems.PLATFORM.Unit.attAvail[n].getBoolValue()) {
			if (Value.Ai.fd[n] and !Value.Misc.dfgsBit[n]) {
				if (Value.Ai.dualCueFd) {
					me["FD_v"].hide();
					
					me["FD_pitch"].setTranslation(0, dfgs.Fd.pitchBar.getValue() * -12.345);
					me["FD_roll"].setTranslation(dfgs.Fd.rollBar.getValue() * 2.6, 0);
					
					me["FD_pitch"].show();
					me["FD_roll"].show();
				} else {
					me.fdVTrans.setTranslation(0, dfgs.Fd.pitchBar.getValue() * -12.345);
					me.fdVRot.setRotation(dfgs.Fd.rollBar.getValue() * D2R, me["AI_center"].getCenter());
					
					me["FD_v"].show();
					
					me["FD_pitch"].hide();
					me["FD_roll"].hide();
				}
			} else {
				me["FD_v"].hide();
				me["FD_pitch"].hide();
				me["FD_roll"].hide();
			}
			
			me["AI_error"].hide();
			me["AI_group"].show();
			me["AI_group2"].show();
			me["AI_group3"].show();
		} else {
			me["AI_error"].show();
			me["AI_group"].hide();
			me["AI_group2"].hide();
			me["AI_group3"].hide();
		}
		
		# Fast Slow
		if (dfgs.Fma.thrA.getValue() == "RETD") {
			me["FS_scale"].hide();
		} else {
			me["FS_pointer"].setTranslation(0, dfgs.Output.fastSlow.getValue() * 13.1);
			me["FS_scale"].show();
		}
		
		# AI
		if (Value.Ai.dualCueFd) {
			me["AI_dual_cue"].show();
			me["AI_scale_dc"].show();
			me["AI_single_cue"].hide();
			me["FS_scale"].setTranslation(0, 0);
			me["GS_group"].setTranslation(0, 0);
			Value.Ai.risingRunwayMultiplier = 1.032375;
			Value.Ai.risingRunwayOffset = 0;
		} else {
			me["AI_dual_cue"].hide();
			me["AI_scale_dc"].hide();
			me["AI_single_cue"].show();
			me["FS_scale"].setTranslation(619.7825, 0);
			me["GS_group"].setTranslation(-619.7825, 0);
			Value.Ai.risingRunwayMultiplier = 0.972045;
			Value.Ai.risingRunwayOffset = 12.066; # Align it properly
		}
		
		Value.Ai.alpha = pts.Fdm.JSBSim.Aero.alphaDegDampedPli.getValue();
		Value.Ai.pitch = pts.Orientation.pitchDeg.getValue();
		Value.Ai.roll = pts.Orientation.rollDeg.getValue();
		Value.Ai.stallAlphaDeg = dfgs.Main.stallAlphaDeg.getValue();
		
		me.aiBackgroundTrans.setTranslation(0, math.clamp(Value.Ai.pitch * 12.345, -240, 240));
		me.aiBackgroundRot.setRotation(-Value.Ai.roll * D2R, Value.Ai.center);
		
		me.aiScaleTrans.setTranslation(0, Value.Ai.pitch * 12.345);
		me.aiScaleRot.setRotation(-Value.Ai.roll * D2R, Value.Ai.center);
		
		me["AI_bank"].setRotation(-Value.Ai.roll * D2R);
		
		if (pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue() >= 60 and systems.FCS.flapsInput.getValue() > 0) {
			me["AI_PLI"].setTranslation(0, math.clamp(Value.Ai.stallAlphaDeg - Value.Ai.alpha, -20, 20) * -12.345);
			if (Value.Ai.alpha >= Value.Ai.stallAlphaDeg) {
				me["AI_PLI_dual_cue"].setColor(1, 0, 0);
				me["AI_PLI_single_cue"].setColor(1, 0, 0);
			} else {
				me["AI_PLI_dual_cue"].setColor(1, 1, 1);
				me["AI_PLI_single_cue"].setColor(1, 1, 1);
			}
			
			if (Value.Ai.dualCueFd) {
				me["AI_PLI_dual_cue"].show();
				me["AI_PLI_single_cue"].hide();
			} else {
				me["AI_PLI_dual_cue"].hide();
				me["AI_PLI_single_cue"].show();
			}
		} else {
			me["AI_PLI_dual_cue"].hide();
			me["AI_PLI_single_cue"].hide();
		}
		
		if (Value.Ai.pitch > 30) {
			me["AI_arrow_dn"].show();
			me["AI_arrow_up"].hide();
		} else if (Value.Ai.pitch < -10) {
			me["AI_arrow_dn"].hide();
			me["AI_arrow_up"].show();
		} else {
			me["AI_arrow_dn"].hide();
			me["AI_arrow_up"].hide();
		}
		
		# Marker Beacons
		if (pts.Instrumentation.MarkerBeacon.inner.getBoolValue()) {
			me["Inner_marker"].show();
			me["Middle_marker"].hide();
			me["Outer_marker"].hide();
		} else if (pts.Instrumentation.MarkerBeacon.middle.getBoolValue()) {
			me["Inner_marker"].hide();
			me["Middle_marker"].show();
			me["Outer_marker"].hide();
		} else if (pts.Instrumentation.MarkerBeacon.outer.getBoolValue()) {
			me["Inner_marker"].hide();
			me["Middle_marker"].hide();
			me["Outer_marker"].show();
		} else {
			me["Inner_marker"].hide();
			me["Middle_marker"].hide();
			me["Outer_marker"].hide();
		}
		
		# RA and DH
		Value.Ra.dh = pts.Controls.Switches.minimums.getValue();
		if (Value.Ra.agl <= 3000) {
			if (Value.Ra.dh > 0) {
				me["DH_pointer"].setTranslation(0, (Value.Ra.agl - Value.Ra.dh) * 2.079);
				me["DH_pointer"].show();
			} else {
				me["DH_pointer"].hide();
			}
			me["RA_bars"].show();
			me["RA_scale"].setTranslation(0, math.clamp(Value.Ra.agl, 0, 3100) * 2.079);
			me["RA_scale"].show();
		} else {
			me["DH_pointer"].hide();
			me["RA_bars"].hide();
			me["RA_scale"].hide();
		}
		
		Value.Ra.dhLatch = pts.Systems.Misc.minimumsLatch.getBoolValue();
		if (Value.Ra.dh > 0) {
			if (Value.Ra.agl <= Value.Ra.dh and Value.Ra.dhLatch) {
				me["DH_below"].show();
				me["DH_label"].hide();
				me["DH_pointer"].setColor(0.9647, 0.8196, 0.0784);
				me["DH_pointer"].setColorFill(0.9647, 0.8196, 0.0784);
				me["DH_set"].hide();
			} else {
				me["DH_below"].hide();
				me["DH_label"].show();
				me["DH_pointer"].setColor(0, 0.7059, 0);
				me["DH_pointer"].setColorFill(0, 0.7059, 0);
				me["DH_set"].setText(sprintf("%d", Value.Ra.dh));
				me["DH_set"].show();
			}
			me["DH_group"].show();
		} else {
			me["DH_group"].hide();
		}
		
		# Groundspeed
		me["Gndspd"].setText(sprintf("%d", math.round(pts.Velocities.groundspeedKt.getValue())));
		
		# ILS
		Value.Nav.Freq.selected[n] = pts.Instrumentation.Nav.Frequencies.selectedMhzFmt[n].getValue() * 100;
		Value.Nav.Freq.selectedDecimal[n] = right("" ~ Value.Nav.Freq.selected[n], 2);
		Value.Nav.Freq.selectedInteger[n] = math.floor(Value.Nav.Freq.selected[n]);
		Value.Nav.gsInRange[n] = pts.Instrumentation.Nav.gsInRange[n].getBoolValue();
		Value.Nav.headingNeedleDeflectionNorm[n] = pts.Instrumentation.Nav.headingNeedleDeflectionNorm[n].getValue();
		Value.Nav.inRange[n] = pts.Instrumentation.Nav.inRange[n].getBoolValue();
		Value.Nav.isIls[n] = Value.Nav.Freq.selectedInteger[n] < 11200 and (Value.Nav.Freq.selectedDecimal[n] == 10 or Value.Nav.Freq.selectedDecimal[n] == 15 or Value.Nav.Freq.selectedDecimal[n] == 30 or Value.Nav.Freq.selectedDecimal[n] == 35 or Value.Nav.Freq.selectedDecimal[n] == 50 or Value.Nav.Freq.selectedDecimal[n] == 55 or Value.Nav.Freq.selectedDecimal[n] == 70 or Value.Nav.Freq.selectedDecimal[n] == 75 or Value.Nav.Freq.selectedDecimal[n] == 90 or Value.Nav.Freq.selectedDecimal[n] == 95);
		Value.Nav.signalQuality[n] = pts.Instrumentation.Nav.signalQualityNorm[n].getValue();
		
		if ((!Value.Nav.inRange[n] or !Value.Nav.isIls[n]) and Value.Misc.lat == 1) {
			me["AI_rising_runway"].hide();
			me["ILS_group"].hide();
			me["NAV_ILS"].setText("NAV");
			me["NAV_pointer"].setTranslation(pts.Instrumentation.Nav.headingNeedleDeflectionNorm[2].getValue() * 148, 0);
			me["NAV_scale"].show();
		} else if (Value.Nav.isIls[n]) {
			if (Value.Nav.inRange[n] and Value.Nav.signalQuality[n] > 0.99) {
				if (Value.Ra.agl <= 2500 and pts.Systems.Acconfig.Options.risingRunway.getBoolValue()) {
					me["AI_rising_runway"].setTranslation(Value.Nav.headingNeedleDeflectionNorm[n] * 156, (math.clamp(Value.Ra.agl, 0, 200) * Value.Ai.risingRunwayMultiplier) + Value.Ai.risingRunwayOffset);
					me["AI_rising_runway"].show();
				} else {
					me["AI_rising_runway"].hide();
				}
				
				me["LOC_pointer"].setTranslation(Value.Nav.headingNeedleDeflectionNorm[n] * 156, 0);
				me["LOC_pointer"].show();
				me["LOC_no"].hide();
				me["LOC_scale"].show();
			} else {
				me["AI_rising_runway"].hide();
				me["LOC_pointer"].hide();
				me["LOC_no"].show();
				me["LOC_scale"].hide();
			}
			
			if (Value.Nav.gsInRange[n] and Value.Nav.signalQuality[n] > 0.99 and pts.Instrumentation.Nav.hasGs[n].getBoolValue()) {
				me["GS_pointer"].setTranslation(0, pts.Instrumentation.Nav.gsNeedleDeflectionNorm[n].getValue() * -148);
				me["GS_pointer"].show();
				me["GS_no"].hide();
				me["GS_scale"].show();
			} else {
				me["GS_pointer"].hide();
				me["GS_no"].show();
				me["GS_scale"].hide();
			}
			
			me["ILS_group"].show();
			me["NAV_ILS"].setText("ILS");
			me["NAV_scale"].hide();
		} else {
			me["AI_rising_runway"].hide();
			me["ILS_group"].hide();
			me["NAV_ILS"].setText("");
			me["NAV_scale"].hide();
		}
	},
};

var canvasPfd1 = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPfd1, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	update: func() {
		me.updateBase(0);
	},
};

var canvasPfd2 = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPfd2, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	update: func() {
		me.updateBase(1);
	},
};

var setup = func() {
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
	
	pfd1 = canvasPfd1.new(pfd1Group, "Aircraft/MD-80/Nasal/Displays/res/PFD.svg");
	pfd2 = canvasPfd2.new(pfd2Group, "Aircraft/MD-80/Nasal/Displays/res/PFD.svg");
	
	canvasBase.setup();
	update.start();
	
	if (pts.Systems.Acconfig.Options.Du.pfdFps.getValue() != 20) {
		rateApply();
	}
}

var rateApply = func() {
	update.restart(1 / pts.Systems.Acconfig.Options.Du.pfdFps.getValue());
}

var update = maketimer(0.05, func() { # 20FPS
	canvasBase.update();
});

var showPfd1 = func() {
	var dlg = canvas.Window.new([512, 400], "dialog", nil, 0).set("resize", 1);
	dlg.setCanvas(pfd1Display);
	dlg.set("title", "Captain's PFD");
}

var showPfd2 = func() {
	var dlg = canvas.Window.new([512, 400], "dialog", nil, 0).set("resize", 1);
	dlg.setCanvas(pfd2Display);
	dlg.set("title", "First Officer's PFD");
}
