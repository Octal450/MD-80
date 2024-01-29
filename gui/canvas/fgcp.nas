# McDonnell Douglas MD-80 FGCP Dialog
# Copyright (c) 2024 Josh Davidson (Octal450)

var fgcpCanvas = {
	new: func() {
		var m = {parents: [fgcpCanvas]};
		m._title = "FGCP";
		m._dialog = nil;
		m._canvas = nil;
		m._svg = nil;
		m._root = nil;
		m._svgKeys = nil;
		m._key = nil;
		m._dialogUpdate = maketimer(0.05, m, m._update);
		m._alt = 0;
		m._blim = 0;
		m._pitch = 0;
		m._pitchD = 0;
		m._vert = 0;
		m._vs = 0;
		m._vsD = 0;
		
		return m;
	},
	getKeys: func() {
		return ["Ap", "ApSel", "AltHold", "AltKnob", "Alt_7seg", "Alt_thousand_7seg", "AutoLand", "AutoThrot", "BankLimit", "BankLimitKnob","Display", "EprLim", "Fd1", "Fd2", "HdgKnob", "Hdg_7seg", "IasMach", "Ils", "MachSel", "Nav", "Perf", "PitchMode_16seg",
		"PitchKnob", "Pitch_7seg", "SpdKnob", "SpdSel", "Spd_7seg", "Toga", "Turb", "VertSpd", "VorLoc"];
	},
	close: func() {
		me._dialogUpdate.stop();
		me._dialog.del();
		me._dialog = nil;
	},
	open: func() {
		me._dialog = canvas.Window.new([735, 125], "dialog", nil, 0);
		me._dialog._onClose = func() {
			fgcpCanvas._onClose();
		}
		
		me._dialog.set("title", me._title);
		me._canvas  = me._dialog.createCanvas();
		me._root = me._canvas.createGroup();
		
		me._svg = me._root.createChild("group");
		canvas.parsesvg(me._svg, "Aircraft/MD-80/gui/canvas/fgcp.svg", {"font-mapper": font_mapper});
		
		me._svgKeys = me.getKeys();
		foreach(me._key; me._svgKeys) {
			me[me._key] = me._svg.getElementById(me._key);
			if (find("_7seg", me._key) != -1) me[me._key].setFont("Std7SegCustom.ttf");
			else if (find("_16seg", me._key) != -1) me[me._key].setFont("Std16SegCustom.ttf");
		}
		
		# Set up clickspots
		me["Toga"].addEventListener("click", func(e) {
			libraries.apPanel.toga();
		});
		
		# Left Buttons
		me["SpdSel"].addEventListener("click", func(e) {
			libraries.apPanel.spd();
		});
		me["MachSel"].addEventListener("click", func(e) {
			libraries.apPanel.mach();
		});
		me["EprLim"].addEventListener("click", func(e) {
			libraries.apPanel.eprLim();
		});
		
		me["Fd1"].addEventListener("click", func(e) {
			dfgs.Input.fd1.setBoolValue(!dfgs.Input.fd1.getBoolValue());
		});
		me["AutoThrot"].addEventListener("click", func(e) {
			dfgs.Input.athr.setBoolValue(!dfgs.Input.athr.getBoolValue());
		});
		
		# Center Buttons
		me["Nav"].addEventListener("click", func(e) {
			libraries.apPanel.nav();
		});
		me["VorLoc"].addEventListener("click", func(e) {
			libraries.apPanel.vorLoc();
		});
		me["Ils"].addEventListener("click", func(e) {
			libraries.apPanel.ils();
		});
		me["AutoLand"].addEventListener("click", func(e) {
			libraries.apPanel.autoLand();
		});
		
		# Right Buttons
		me["VertSpd"].addEventListener("click", func(e) {
			libraries.apPanel.vertSpd();
		});
		me["IasMach"].addEventListener("click", func(e) {
			libraries.apPanel.iasMach();
		});
		me["AltHold"].addEventListener("click", func(e) {
			libraries.apPanel.altHold();
		});
		me["Turb"].addEventListener("click", func(e) {
			libraries.apPanel.turb();
		});
		
		me["Ap"].addEventListener("click", func(e) {
			libraries.apPanel.apSwitch();
		});
		me["ApSel"].addEventListener("click", func(e) {
			libraries.apPanel.apSelector();
		});
		me["Fd2"].addEventListener("click", func(e) {
			dfgs.Input.fd2.setBoolValue(!dfgs.Input.fd2.getBoolValue());
		});
		
		# Speed Knob
		me["SpdKnob"].addEventListener("click", func(e) {
			if (e.shiftKey or e.button == 1) {
				libraries.apPanel.spdPull();
			} else if (e.button == 0) {
				libraries.apPanel.spdPush();
			}
		});
		me["SpdKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				libraries.apPanel.spdAdjust(10 * e.deltaY);
			} else {
				libraries.apPanel.spdAdjust(1 * e.deltaY);
			}
		});
		
		# Heading Knob
		me["HdgKnob"].addEventListener("click", func(e) {
			if (e.shiftKey or e.button == 1) {
				libraries.apPanel.hdgPull();
			} else if (e.button == 0) {
				libraries.apPanel.hdgPush();
			}
		});
		me["HdgKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				libraries.apPanel.hdgAdjust(10 * e.deltaY);
			} else {
				libraries.apPanel.hdgAdjust(1 * e.deltaY);
			}
		});
		
		# Bank Limit
		me["BankLimitKnob"].addEventListener("click", func(e) {
			me._blim = dfgs.Input.bankLimitSw.getValue();
			if (e.shiftKey or e.button == 1) {
				if (me._blim > 0) {
					dfgs.Input.bankLimitSw.setValue(me._blim - 1);
				} else {
					dfgs.Input.bankLimitSw.setValue(4);
				}
			} else {
				if (me._blim < 4) {
					dfgs.Input.bankLimitSw.setValue(me._blim + 1);
				} else {
					dfgs.Input.bankLimitSw.setValue(0);
				}
			}
		});
		
		# Pitch Knob
		me["PitchKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				libraries.apPanel.vsAdjust(-10 * e.deltaY); # Inverted
			} else {
				libraries.apPanel.vsAdjust(-1 * e.deltaY); # Inverted
			}
		});
		
		# Altitude Knob
		me["AltKnob"].addEventListener("click", func(e) {
			if (e.shiftKey or e.button == 1) {
				libraries.apPanel.altPull();
			} else if (e.button == 0) {
				libraries.apPanel.altPush();
			}
		});
		me["AltKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				libraries.apPanel.altAdjust(1 * e.deltaY);
			} else {
				libraries.apPanel.altAdjust(10 * e.deltaY);
			}
		});
		
		me._update();
		me._dialogUpdate.start();
	},
	_update: func() {
		if (systems.ELEC.Generic.fgcp.getValue() >= 24) {
			if (pts.Controls.Switches.annunTest.getBoolValue()) {
				me["Hdg_7seg"].setText("888");
				me["Spd_7seg"].setText(".888");
				me["PitchMode_16seg"].setText("¤"); # Shows all segments
				me["Pitch_7seg"].setText("-8888");
			} else {
				# Speed
				if (dfgs.Input.ktsMach.getBoolValue()) {
					me["Spd_7seg"].setText("." ~ sprintf("%03d", dfgs.Input.mach.getValue() * 1000));
				} else {
					me["Spd_7seg"].setText(sprintf("%03d", dfgs.Input.kts.getValue()));
				}
				
				# Heading
				me["Hdg_7seg"].setText(sprintf("%03d", dfgs.Input.hdg.getValue()));
				
				# Pitch
				me._vert = dfgs.Output.vert.getValue();
				if (me._vert == 4) {
					if (dfgs.Input.ktsMachFlch.getBoolValue()) {
						me["PitchMode_16seg"].setText("M");
						me["Pitch_7seg"].setText("." ~ sprintf("%03d", dfgs.Input.machFlch.getValue() * 1000));
					} else {
						me["PitchMode_16seg"].setText("S");
						me["Pitch_7seg"].setText(sprintf("%03d", dfgs.Input.ktsFlch.getValue()));
					}
				} else if (me._vert == 8) {
					me._pitch = dfgs.Input.pitch.getValue();
					me._pitchD = math.round(abs(me._pitch), 0.1);
					
					me["PitchMode_16seg"].setText("P");
					if (me._pitch < 0 and me._pitchD > 0) {
						me["Pitch_7seg"].setText("-" ~ sprintf("%02d", abs(me._pitchD)));
					} else {
						me["Pitch_7seg"].setText(sprintf("%02d", abs(me._pitchD)));
					}
				} else {
					me._vs = dfgs.Input.vs.getValue();
					me._vsD = math.round(abs(me._vs), 100);
					
					me["PitchMode_16seg"].setText("V");
					if (me._vs < 0 and me._vsD > 0) {
						me["Pitch_7seg"].setText("-" ~ sprintf("%04d", me._vsD));
					} else {
						me["Pitch_7seg"].setText(sprintf("%04d", me._vsD));
					}
				}
				
				# Altitude
				me._alt = dfgs.Input.alt.getValue();
				me["Alt_7seg"].setText(right(sprintf("%03d", me._alt), 3));
				if (me._alt < 1000) {
					me["Alt_thousand_7seg"].setText("==");
				} else if (me._alt < 10000) {
					me["Alt_thousand_7seg"].setText("=" ~ sprintf("%d", math.floor(me._alt / 1000)));
				} else {
					me["Alt_thousand_7seg"].setText(sprintf("%d", math.floor(me._alt / 1000)));
				}
			}
			
			me["Display"].show();
		} else {
			me["Display"].hide();
		}
		
		# Bank Limit
		me["BankLimit"].setRotation(((dfgs.Input.bankLimitSw.getValue() * 27.5) - 55) * D2R);
		
		# On/Off Controls
		me["Fd1"].setRotation(dfgs.Output.fd1.getValue() * 180 * D2R);
		me["Fd2"].setRotation(dfgs.Output.fd2.getValue() * 180 * D2R);
		me["AutoThrot"].setRotation(dfgs.Output.athr.getValue() * 180 * D2R);
		me["Ap"].setRotation(math.max(dfgs.Output.ap1.getValue(), dfgs.Output.ap2.getValue()) * 180 * D2R);
		me["ApSel"].setRotation((((dfgs.Input.activeAp.getValue() - 1) * -60) + 30) * D2R);
	},
};

var fgcpDialog = fgcpCanvas.new();
