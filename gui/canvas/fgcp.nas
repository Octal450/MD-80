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
		return ["Ap", "ApDisc", "ApSel", "AltHold", "AltKnob", "AltMinus", "AltPlus", "Alt_7seg", "Alt_thousand_7seg", "AtsDisc", "AutoLand", "AutoThrot", "Bank10", "Bank15", "Bank20", "Bank25", "Bank30", "BankLimit", "Display", "EprLim", "Fd1", "Fd2",
		"FmsOvrd", "HdgKnob", "HdgMinus", "HdgPlus", "Hdg_7seg", "IasMach", "Ils", "MachSel", "Nav", "PerfVnav", "PerfVnavText", "PitchMode_16seg", "PitchKnob", "PitchMinus", "PitchPlus", "Pitch_7seg", "SpdKnob", "SpdMinus", "SpdPlus", "SpdSel", "Spd_7seg",
		"Toga", "Turb", "VertSpd", "VorLoc"];
	},
	close: func() {
		me._dialogUpdate.stop();
		me._dialog.del();
		me._dialog = nil;
	},
	open: func() {
		if (me._dialog != nil and singleInstance) return; # Prevent more than one open
		
		me._dialog = canvas.Window.new([735, 125], "dialog", nil, 0);
		me._dialog.set("title", me._title);
		me._dialog.onClose = func() { panel2d.fgcpDialog.close(); };
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
		
		if (pts.Options.fms.getValue() != "Honeywell") {
			me["FmsOvrd"].hide();
			me["PerfVnavText"].setText("PERF");
		}
		
		# Set up clickspots
		# Extra
		me["Toga"].addEventListener("click", func(e) {
			cockpit.ApPanel.toga();
		});
		me["AtsDisc"].addEventListener("click", func(e) {
			cockpit.ApPanel.atDisc();
		});
		me["ApDisc"].addEventListener("click", func(e) {
			cockpit.ApPanel.apDisc();
		});
		
		# Left Buttons
		me["SpdSel"].addEventListener("click", func(e) {
			cockpit.ApPanel.spdSel();
		});
		me["MachSel"].addEventListener("click", func(e) {
			cockpit.ApPanel.machSel();
		});
		me["EprLim"].addEventListener("click", func(e) {
			cockpit.ApPanel.eprLim();
		});
		
		me["Fd1"].addEventListener("click", func(e) {
			dfgs.Input.fd1.setBoolValue(!dfgs.Input.fd1.getBoolValue());
		});
		me["AutoThrot"].addEventListener("click", func(e) {
			dfgs.Input.athr.setBoolValue(!dfgs.Input.athr.getBoolValue());
		});
		
		# Center Buttons
		me["Nav"].addEventListener("click", func(e) {
			cockpit.ApPanel.nav();
		});
		me["VorLoc"].addEventListener("click", func(e) {
			cockpit.ApPanel.vorLoc();
		});
		me["Ils"].addEventListener("click", func(e) {
			cockpit.ApPanel.ils();
		});
		me["AutoLand"].addEventListener("click", func(e) {
			cockpit.ApPanel.autoLand();
		});
		
		# Right Buttons
		me["VertSpd"].addEventListener("click", func(e) {
			cockpit.ApPanel.vertSpd();
		});
		me["IasMach"].addEventListener("click", func(e) {
			cockpit.ApPanel.iasMach();
		});
		me["AltHold"].addEventListener("click", func(e) {
			cockpit.ApPanel.altHold();
		});
		me["Turb"].addEventListener("click", func(e) {
			cockpit.ApPanel.turb();
		});
		
		me["Ap"].addEventListener("click", func(e) {
			cockpit.ApPanel.apSwitch();
		});
		me["ApSel"].addEventListener("click", func(e) {
			cockpit.ApPanel.apSelector();
		});
		me["Fd2"].addEventListener("click", func(e) {
			dfgs.Input.fd2.setBoolValue(!dfgs.Input.fd2.getBoolValue());
		});
		
		# Speed Knob
		me["SpdKnob"].addEventListener("click", func(e) {
			cockpit.ApPanel.spdPush();
		});
		me["SpdKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.spdAdjust(10 * e.deltaY);
			} else {
				cockpit.ApPanel.spdAdjust(e.deltaY);
			}
		});
		me["SpdMinus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.spdAdjust(-10);
			} else {
				cockpit.ApPanel.spdAdjust(-1);
			}
		});
		me["SpdPlus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.spdAdjust(10);
			} else {
				cockpit.ApPanel.spdAdjust(1);
			}
		});
		
		# Heading Knob
		me["HdgKnob"].addEventListener("click", func(e) {
			if (e.shiftKey or e.button == 1) {
				cockpit.ApPanel.hdgPull();
			} else if (e.button == 0) {
				cockpit.ApPanel.hdgPush();
			}
		});
		me["HdgKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.hdgAdjust(10 * e.deltaY);
			} else {
				cockpit.ApPanel.hdgAdjust(e.deltaY);
			}
		});
		me["HdgMinus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.hdgAdjust(-10);
			} else {
				cockpit.ApPanel.hdgAdjust(-1);
			}
		});
		me["HdgPlus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.hdgAdjust(10);
			} else {
				cockpit.ApPanel.hdgAdjust(1);
			}
		});
		
		# Bank Limit
		me["Bank10"].addEventListener("click", func(e) {
			dfgs.Input.bankLimitSw.setValue(0);
		});
		me["Bank15"].addEventListener("click", func(e) {
			dfgs.Input.bankLimitSw.setValue(1);
		});
		me["Bank20"].addEventListener("click", func(e) {
			dfgs.Input.bankLimitSw.setValue(2);
		});
		me["Bank25"].addEventListener("click", func(e) {
			dfgs.Input.bankLimitSw.setValue(3);
		});
		me["Bank30"].addEventListener("click", func(e) {
			dfgs.Input.bankLimitSw.setValue(4);
		});
		
		# Pitch Knob
		me["PitchKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.vsAdjust(-10 * e.deltaY); # Inverted
			} else {
				cockpit.ApPanel.vsAdjust(-1 * e.deltaY); # Inverted
			}
		});
		me["PitchMinus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.vsAdjust(-10);
			} else {
				cockpit.ApPanel.vsAdjust(-1);
			}
		});
		me["PitchPlus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.vsAdjust(10);
			} else {
				cockpit.ApPanel.vsAdjust(1);
			}
		});
		
		# Altitude Knob
		me["AltKnob"].addEventListener("click", func(e) {
			if (e.shiftKey or e.button == 1) {
				cockpit.ApPanel.altPull();
			} else if (e.button == 0) {
				cockpit.ApPanel.altPush();
			}
		});
		me["AltKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.altAdjust(e.deltaY);
			} else {
				cockpit.ApPanel.altAdjust(10 * e.deltaY);
			}
		});
		me["AltMinus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.altAdjust(-10);
			} else {
				cockpit.ApPanel.altAdjust(-1);
			}
		});
		me["AltPlus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.altAdjust(10);
			} else {
				cockpit.ApPanel.altAdjust(1);
			}
		});
		
		me._update();
		me._dialogUpdate.start();
	},
	_update: func() {
		if (systems.ELECTRICAL.Outputs.fgcp.getValue() >= 24) {
			if (pts.Controls.Switches.annunTest.getBoolValue()) {
				me["Hdg_7seg"].setText("888");
				me["Spd_7seg"].setText(".888");
				me["PitchMode_16seg"].setText("#"); # Shows all segments
				me["Pitch_7seg"].setText("-8.888");
			} else {
				# Speed
				if (dfgs.Input.ktsMachFgcp.getBoolValue()) {
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
				} else if (me._vert == 10) {
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
