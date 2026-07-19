# McDonnell Douglas MD-80 EDP/SDP
# Copyright (c) 2026 Josh Davidson (Octal450)

var edpSdp = nil;
var edpSdpDisplay = nil;

var Value = {
	annunTest: 0,
	Bus: {
		dcL: 0,
		dcR: 0,
		dcTrans: 0,
		emerDc: 0,
	},
	egt: [0, 0],
	egtRound: [0, 0],
	epr: [0, 0],
	eprRound: [0, 0],
	ffFu: 0,
	ft: [0, 0],
	n1: [0, 0],
	n1Round: [0, 0],
	n2: [0, 0],
	n2Round: [0, 0],
	tat: 0,
};

var CanvasBase = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return "MD80EDP7Seg.ttf";
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
		
		foreach (var key; GroupMatrixKeys5x10B) {
			foreach (var child; me[key].getChildren()) {
				if (child.getType() == "group") {
					foreach (var grandchild; child.getChildren()) {
						if (grandchild.getType() == "text")
							grandchild.setFont("MD80EDP5x10B.ttf");
					}
				} else if (child.getType() == "text") {
					child.setFont("MD80EDP5x10B.ttf");
				}
			}
		}
		
		foreach (var key; GroupMatrixKeys5x10) {
			foreach (var child; me[key].getChildren()) {
				if (child.getType() == "group") {
					foreach (var grandchild; child.getChildren()) {
						if (grandchild.getType() == "text")
							grandchild.setFont("MD80EDP5x10.ttf");
					}
				} else if (child.getType() == "text") {
					child.setFont("MD80EDP5x10.ttf");
				}
			}
		}
		
		me.page = canvasGroup;
		
		return me;
	},
	update: func() {
		if (pts.Systems.Acconfig.Options.edpSdp.getBoolValue()) {
			edpSdp.update();
		}
	},
};

var CanvasEdpSdp = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasEdpSdp, CanvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return KeyList;
	},
	update: func() {
		Value.annunTest = pts.Controls.Switches.annunTest.getBoolValue();
		Value.Bus.dcL = systems.ELECTRICAL.Bus.dcL.getValue() >= 24;
		Value.Bus.dcR = systems.ELECTRICAL.Bus.dcR.getValue() >= 24;
		Value.Bus.dcTrans = systems.ELECTRICAL.Bus.dcTrans.getValue() >= 24;
		Value.Bus.emerDc = systems.ELECTRICAL.Bus.emerDc.getValue() >= 24;
		Value.ffFu = systems.ENGINES.Controls.ffFu.getBoolValue();
		Value.ft[0] = math.round(systems.FUEL.Temp.tankL.getValue());
		Value.ft[1] = math.round(systems.FUEL.Temp.tankR.getValue());
		Value.tat = math.round(pts.Fdm.JSBSim.Propulsion.tatC.getValue());
		
		# EDP EPR
		if (Value.Bus.dcTrans) {
			if (Value.annunTest) {
				me["EPR1"].hide();
				me["EPR1_test"].show();
			} else {
				Value.epr[0] = systems.ENGINES.epr[0].getValue();
				Value.eprRound[0] = math.round(Value.epr[0], 0.001);
				
				me["EPR1_ones"].setTranslation(0, genevaEprOnes(num(right(sprintf("%05.2f", Value.eprRound[0] * 10), 5))) * 32.959);
				me["EPR1_tenths"].setTranslation(0, genevaEprTenths(num(right(sprintf("%04.2f", Value.eprRound[0] * 10), 4))) * 32.959);
				me["EPR1_hundreths"].setTranslation(0, 10 * (math.mod(Value.eprRound[0] * 10, 1) * 32.959));
				
				me["EPR1"].show();
				me["EPR1_test"].hide();
			}
		} else {
			me["EPR1"].hide();
			me["EPR1_test"].hide();
		}
		
		if (Value.Bus.emerDc) {
			if (Value.annunTest) {
				me["EPR2"].hide();
				me["EPR2_test"].show();
			} else {
				Value.epr[1] = systems.ENGINES.epr[1].getValue();
				Value.eprRound[1] = math.round(Value.epr[1], 0.001);
				
				me["EPR2_ones"].setTranslation(0, genevaEprOnes(num(right(sprintf("%05.2f", Value.eprRound[1] * 10), 5))) * 32.959);
				me["EPR2_tenths"].setTranslation(0, genevaEprTenths(num(right(sprintf("%04.2f", Value.eprRound[1] * 10), 4))) * 32.959);
				me["EPR2_hundreths"].setTranslation(0, 10 * (math.mod(Value.eprRound[1] * 10, 1) * 32.959));
				
				me["EPR2"].show();
				me["EPR2_test"].hide();
			}
		} else {
			me["EPR2"].hide();
			me["EPR2_test"].hide();
		}
		
		# EDP N1
		if (Value.Bus.emerDc) {
			if (Value.annunTest) {
				me["N11"].hide();
				me["N11_test"].show();
			} else {
				Value.n1[0] = systems.ENGINES.n1[0].getValue();
				Value.n1Round[0] = math.round(Value.n1[0], 0.1);
				
				if (Value.n1Round[0] < 99) { # Prepare to show the zero at 100
					me["N11_tens_zero"].hide();
				} else {
					me["N11_tens_zero"].show();
				}
				
				me["N11_hundreds"].setTranslation(0, genevaNHundreds(num(right(sprintf("%05.2f", Value.n1Round[0] / 10), 5))) * 32.959);
				me["N11_tens"].setTranslation(0, genevaNTens(num(right(sprintf("%04.2f", Value.n1Round[0] / 10), 4))) * 32.959);
				me["N11_ones"].setTranslation(0, 10 * (math.mod(Value.n1Round[0] / 10, 1) * 32.959));
				
				me["N11"].show();
				me["N11_test"].hide();
			}
		} else {
			me["N11"].hide();
			me["N11_test"].hide();
		}
		
		if (Value.Bus.dcTrans) {
			if (Value.annunTest) {
				me["N12"].hide();
				me["N12_test"].show();
			} else {
				Value.n1[1] = systems.ENGINES.n1[1].getValue();
				Value.n1Round[1] = math.round(Value.n1[1], 0.1);
				
				if (Value.n1Round[1] < 99) { # Prepare to show the zero at 100
					me["N12_tens_zero"].hide();
				} else {
					me["N12_tens_zero"].show();
				}
				
				me["N12_hundreds"].setTranslation(0, genevaNHundreds(num(right(sprintf("%05.2f", Value.n1Round[1] / 10), 5))) * 32.959);
				me["N12_tens"].setTranslation(0, genevaNTens(num(right(sprintf("%04.2f", Value.n1Round[1] / 10), 4))) * 32.959);
				me["N12_ones"].setTranslation(0, 10 * (math.mod(Value.n1Round[1] / 10, 1) * 32.959));
				
				me["N12"].show();
				me["N12_test"].hide();
			}
		} else {
			me["N12"].hide();
			me["N12_test"].hide();
		}
		
		# EDP EGT
		if (Value.Bus.emerDc) {
			if (Value.annunTest) {
				me["EGT1"].hide();
				me["EGT1_test"].show();
			} else {
				Value.egt[0] = systems.ENGINES.egt[0].getValue();
				Value.egtRound[0] = math.round(Value.egt[0], 0.1);
				
				if (Value.egtRound[0] < 999) { # Prepare to show the zero at 1000
					me["EGT1_hundreds_zero"].hide();
				} else {
					me["EGT1_hundreds_zero"].show();
				}
				
				if (Value.egtRound[0] < 99) { # Prepare to show the zero at 100
					me["EGT1_tens_zero"].hide();
				} else {
					me["EGT1_tens_zero"].show();
				}
				
				me["EGT1_thousands"].setTranslation(0, genevaEgtThousands(num(right(sprintf("%06.2f", Value.egtRound[0] / 10), 6))) * 32.959);
				me["EGT1_hundreds"].setTranslation(0, genevaEgtHundreds(num(right(sprintf("%05.2f", Value.egtRound[0] / 10), 5))) * 32.959);
				me["EGT1_tens"].setTranslation(0, genevaEgtTens(num(right(sprintf("%04.2f", Value.egtRound[0] / 10), 4))) * 32.959);
				me["EGT1_ones"].setTranslation(0, 10 * (math.mod(Value.egtRound[0] / 10, 1) * 32.959));
				
				me["EGT1"].show();
				me["EGT1_test"].hide();
			}
		} else {
			me["EGT1"].hide();
			me["EGT1_test"].hide();
		}
		
		if (Value.Bus.dcTrans) {
			if (Value.annunTest) {
				me["EGT2"].hide();
				me["EGT2_test"].show();
			} else {
				Value.egt[1] = systems.ENGINES.egt[1].getValue();
				Value.egtRound[1] = math.round(Value.egt[1], 0.1);
				
				if (Value.egtRound[1] < 999) { # Prepare to show the zero at 1000
					me["EGT2_hundreds_zero"].hide();
				} else {
					me["EGT2_hundreds_zero"].show();
				}
				
				if (Value.egtRound[1] < 99) { # Prepare to show the zero at 100
					me["EGT2_tens_zero"].hide();
				} else {
					me["EGT2_tens_zero"].show();
				}
				
				me["EGT2_thousands"].setTranslation(0, genevaEgtThousands(num(right(sprintf("%06.2f", Value.egtRound[1] / 10), 6))) * 32.959);
				me["EGT2_hundreds"].setTranslation(0, genevaEgtHundreds(num(right(sprintf("%05.2f", Value.egtRound[1] / 10), 5))) * 32.959);
				me["EGT2_tens"].setTranslation(0, genevaEgtTens(num(right(sprintf("%04.2f", Value.egtRound[1] / 10), 4))) * 32.959);
				me["EGT2_ones"].setTranslation(0, 10 * (math.mod(Value.egtRound[1] / 10, 1) * 32.959));
				
				me["EGT2"].show();
				me["EGT2_test"].hide();
			}
		} else {
			me["EGT2"].hide();
			me["EGT2_test"].hide();
		}
		
		# EDP N2
		if (Value.Bus.emerDc) {
			if (Value.annunTest) {
				me["N21"].hide();
				me["N21_test"].show();
			} else {
				Value.n2[0] = systems.ENGINES.n2[0].getValue();
				Value.n2Round[0] = math.round(Value.n2[0], 0.1);
				
				if (Value.n2Round[0] < 99) { # Prepare to show the zero at 100
					me["N21_tens_zero"].hide();
				} else {
					me["N21_tens_zero"].show();
				}
				
				me["N21_hundreds"].setTranslation(0, genevaNHundreds(num(right(sprintf("%05.2f", Value.n2Round[0] / 10), 5))) * 32.959);
				me["N21_tens"].setTranslation(0, genevaNTens(num(right(sprintf("%04.2f", Value.n2Round[0] / 10), 4))) * 32.959);
				me["N21_ones"].setTranslation(0, 10 * (math.mod(Value.n2Round[0] / 10, 1) * 32.959));
				
				me["N21"].show();
				me["N21_test"].hide();
			}
		} else {
			me["N21"].hide();
			me["N21_test"].hide();
		}
		
		if (Value.Bus.dcTrans) {
			if (Value.annunTest) {
				me["N22"].hide();
				me["N22_test"].show();
			} else {
				Value.n2[1] = systems.ENGINES.n2[1].getValue();
				Value.n2Round[1] = math.round(Value.n2[1], 0.1);
				
				if (Value.n2Round[1] < 99) { # Prepare to show the zero at 100
					me["N22_tens_zero"].hide();
				} else {
					me["N22_tens_zero"].show();
				}
				
				me["N22_hundreds"].setTranslation(0, genevaNHundreds(num(right(sprintf("%05.2f", Value.n2Round[1] / 10), 5))) * 32.959);
				me["N22_tens"].setTranslation(0, genevaNTens(num(right(sprintf("%04.2f", Value.n2Round[1] / 10), 4))) * 32.959);
				me["N22_ones"].setTranslation(0, 10 * (math.mod(Value.n2Round[1] / 10, 1) * 32.959));
				
				me["N22"].show();
				me["N22_test"].hide();
			}
		} else {
			me["N22"].hide();
			me["N22_test"].hide();
		}
		
		# EDP 7-Seg
		if (Value.Bus.dcTrans) {
			if (Value.annunTest) {
				me["EPRLimit"].setText("8.88");
				me["EPRCmd1"].setText("8.88");
				me["FF1"].setText("8888");
			} else {
				if (systems.THRLIM.Limit.activeModeInt.getValue() == -1) {
					me["EPRLimit"].setText("---");
				} else {
					me["EPRLimit"].setText(sprintf("%4.2f", math.round(systems.THRLIM.Limit.active.getValue(), 0.01)));
				}
				
				if (systems.ENGINES.Controls.manEprSet[0].getBoolValue()) {
					me["EPRCmd1"].setText(sprintf("%4.2f", math.round(systems.ENGINES.Controls.manEpr[0].getValue(), 0.01)));
					me["EPRCmd1"].show();
				} else {
					me["EPRCmd1"].hide();
				}
				
				if (Value.ffFu) {
					me["FF1"].setText(sprintf("%d", math.round(pts.Instrumentation.Ff.fu[0].getValue() / 10)));
				} else {
					me["FF1"].setText(sprintf("%d", math.round(systems.ENGINES.ff[0].getValue() / 10)));
				}
			}
			
			me["EPRLimit"].show();
			me["FF1"].show();
		} else {
			me["EPRCmd1"].hide();
			me["EPRLimit"].hide();
			me["FF1"].hide();
		}
		
		if (Value.Bus.emerDc) {
			if (Value.annunTest) {
				me["EPRCmd2"].setText("8.88");
				me["FF2"].setText("8888");
			} else {
				if (systems.ENGINES.Controls.manEprSet[1].getBoolValue()) {
					me["EPRCmd2"].setText(sprintf("%4.2f", math.round(systems.ENGINES.Controls.manEpr[1].getValue(), 0.01)));
					me["EPRCmd2"].show();
				} else {
					me["EPRCmd2"].hide();
				}
				
				if (Value.ffFu) {
					me["FF2"].setText(sprintf("%d", math.round(pts.Instrumentation.Ff.fu[1].getValue() / 10)));
				} else {
					me["FF2"].setText(sprintf("%d", math.round(systems.ENGINES.ff[1].getValue() / 10)));
				}
			}
			
			me["FF2"].show();
		} else {
			me["EPRCmd2"].hide();
			me["FF2"].hide();
		}
		
		# SDP 7-Seg
		if (Value.Bus.dcL) {
			if (Value.annunTest) {
				me["FuelTempL"].setText("-88");
				me["OilPress1"].setText("88");
				me["OilTemp1"].setText("188");
				me["OilQty1"].setText("88");
				me["HydPressL"].setText("88");
				me["HydQtyL"].setText("88");
			} else {
				if (Value.ft[0] < 0) {
					me["FuelTempL"].setText(sprintf("-%2d", abs(Value.ft[0])));
				} else {
					me["FuelTempL"].setText(sprintf("%3d", Value.ft[0]));
				}
				
				me["OilPress1"].setText(sprintf("%d", math.round(systems.ENGINES.oilPsi[0].getValue())));
				me["OilTemp1"].setText(sprintf("%d", math.round(systems.ENGINES.oilTemp[0].getValue())));
				me["OilQty1"].setText(sprintf("%d", math.round(systems.ENGINES.oilQty[0].getValue())));
				me["HydPressL"].setText(sprintf("%d", math.round(systems.HYDRAULICS.Psi.sysL.getValue() / 100)));
				me["HydQtyL"].setText(sprintf("%d", math.round(systems.HYDRAULICS.Qty.sysL.getValue())));
			}
			
			me["FuelTempL"].show();
			me["HydPressL"].show();
			me["HydQtyL"].show();
			me["OilPress1"].show();
			me["OilQty1"].show();
			me["OilTemp1"].show();
		} else {
			me["FuelTempL"].hide();
			me["HydPressL"].hide();
			me["HydQtyL"].hide();
			me["OilPress1"].hide();
			me["OilQty1"].hide();
			me["OilTemp1"].hide();
		}
		
		if (Value.Bus.dcR) {
			if (Value.annunTest) {
				me["RAT"].setText("-88");
				me["FuelTempR"].setText("-88");
				me["OilPress2"].setText("88");
				me["OilTemp2"].setText("188");
				me["OilQty2"].setText("88");
				me["HydPressR"].setText("88");
				me["HydQtyR"].setText("88");
			} else {
				if (Value.tat < 0) {
					me["RAT"].setText(sprintf("-%2d", abs(Value.tat)));
				} else {
					me["RAT"].setText(sprintf("%3d", Value.tat));
				}
				
				if (Value.ft[1] < 0) {
					me["FuelTempR"].setText(sprintf("-%2d", abs(Value.ft[1])));
				} else {
					me["FuelTempR"].setText(sprintf("%3d", Value.ft[1]));
				}
				
				me["OilPress2"].setText(sprintf("%d", math.round(systems.ENGINES.oilPsi[1].getValue())));
				me["OilTemp2"].setText(sprintf("%d", math.round(systems.ENGINES.oilTemp[1].getValue())));
				me["OilQty2"].setText(sprintf("%d", math.round(systems.ENGINES.oilQty[1].getValue())));
				me["HydPressR"].setText(sprintf("%d", math.round(systems.HYDRAULICS.Psi.sysR.getValue() / 100)));
				me["HydQtyR"].setText(sprintf("%d", math.round(systems.HYDRAULICS.Qty.sysR.getValue())));
			}
			
			me["FuelTempR"].show();
			me["HydPressR"].show();
			me["HydQtyR"].show();
			me["OilPress2"].show();
			me["OilQty2"].show();
			me["OilTemp2"].show();
			me["RAT"].show();
		} else {
			me["FuelTempR"].hide();
			me["HydPressR"].hide();
			me["HydQtyR"].hide();
			me["OilPress2"].hide();
			me["OilQty2"].hide();
			me["OilTemp2"].hide();
			me["RAT"].hide();
		}
	},
};

var setup = func() {
	edpSdpDisplay = canvas.new({
		"name": "edpSdp",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	
	edpSdpDisplay.addPlacement({"node": "EDPSDP.Canvas"});
	
	var edpSdpGroup = edpSdpDisplay.createGroup();
	edpSdp = CanvasEdpSdp.new(edpSdpGroup, "Aircraft/MD-80/Nasal/Instruments/res/edp-sdp.svg");
	
	update.start();
}

var update = maketimer(0.05, func() { # 20FPS
	CanvasBase.update();
});

var m = 0;
var s = 0;

var genevaEprOnes = func(input) {
	m = math.floor(input / 10);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	if (math.mod(input / 10, 1) < 0.9) s = 0;
	return m + s;
}

var genevaEprTenths = func(input) {
	m = math.floor(input);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	return m + s;
}

var genevaNHundreds = func(input) {
	m = math.floor(input / 10);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	if (math.mod(input / 10, 1) < 0.9) s = 0;
	return m + s;
}

var genevaNTens = func(input) {
	m = math.floor(input);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	return m + s;
}

var genevaEgtThousands = func(input) {
	m = math.floor(input / 100);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	if (math.mod(input / 10, 1) < 0.9 or math.mod(input / 100, 1) < 0.9) s = 0;
	return m + s;
}

var genevaEgtHundreds = func(input) {
	m = math.floor(input / 10);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	if (math.mod(input / 10, 1) < 0.9) s = 0;
	return m + s;
}

var genevaEgtTens = func(input) {
	m = math.floor(input);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	return m + s;
}

# SVG Key List
var KeyList = [
	"EGT1",
	"EGT1_hundreds",
	"EGT1_hundreds_zero",
	"EGT1_ones",
	"EGT1_tens",
	"EGT1_tens_zero",
	"EGT1_thousands",
	"EGT1_test",
	"EGT2",
	"EGT2_hundreds",
	"EGT2_hundreds_zero",
	"EGT2_ones",
	"EGT2_tens",
	"EGT2_tens_zero",
	"EGT2_thousands",
	"EGT2_test",
	"EPRCmd1",
	"EPRCmd2",
	"EPRLimit",
	"EPR1",
	"EPR1_hundreths",
	"EPR1_ones",
	"EPR1_tenths",
	"EPR1_test",
	"EPR2",
	"EPR2_hundreths",
	"EPR2_ones",
	"EPR2_tenths",
	"EPR2_test",
	"FF1",
	"FF2",
	"FuelTempL",
	"FuelTempR",
	"HydPressL",
	"HydPressR",
	"HydQtyL",
	"HydQtyR",
	"N11",
	"N11_hundreds",
	"N11_ones",
	"N11_tens",
	"N11_tens_zero",
	"N11_test",
	"N12",
	"N12_hundreds",
	"N12_ones",
	"N12_tens",
	"N12_tens_zero",
	"N12_test",
	"N21",
	"N21_hundreds",
	"N21_ones",
	"N21_tens",
	"N21_tens_zero",
	"N21_test",
	"N22",
	"N22_hundreds",
	"N22_ones",
	"N22_tens",
	"N22_tens_zero",
	"N22_test",
	"OilPress1",
	"OilPress2",
	"OilQty1",
	"OilQty2",
	"OilTemp1",
	"OilTemp2",
	"RAT"
];

# Matrix 5x10B Font List
var GroupMatrixKeys5x10B = [
	"EPR1",
	"EPR1_test",
	"EPR2",
	"EPR2_test"
];

# Matrix 5x10 Font List
var GroupMatrixKeys5x10 = [
	"EGT1",
	"EGT1_test",
	"EGT2",
	"EGT2_test",
	"N11",
	"N11_test",
	"N12",
	"N12_test",
	"N21",
	"N21_test",
	"N22",
	"N22_test"
];
