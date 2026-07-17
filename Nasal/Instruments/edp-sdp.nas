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
	ffFu: 0,
	ft: [0, 0],
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
			#if (find("_5x10B", me._key) != -1) me[me._key].setFont("MD80EDP5x10B.ttf");
			#else if (find("_5x10", me._key) != -1) me[me._key].setFont("MD80EDP5x10.ttf");
		}
		
		me.page = canvasGroup;
		
		return me;
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

var update = maketimer(0.1, func() {
	edpSdp.update();
});

# SVG Key List
var KeyList = [
	"EPRCmd1",
	"EPRCmd2",
	"EPRLimit",
	"FF1",
	"FF2",
	"FuelTempL",
	"FuelTempR",
	"HydPressL",
	"HydPressR",
	"HydQtyL",
	"HydQtyR",
	"OilPress1",
	"OilPress2",
	"OilQty1",
	"OilQty2",
	"OilTemp1",
	"OilTemp2",
	"RAT"
];
