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
		
		# EDP
		if (Value.Bus.dcTrans) {
			me["EPRCmd1"].show();
			me["EPRLimit"].show();
			me["FF1"].show();
		} else {
			me["EPRCmd1"].hide();
			me["EPRLimit"].hide();
			me["FF1"].hide();
		}
		
		if (Value.Bus.emerDc) {
			me["EPRCmd2"].show();
			me["FF2"].show();
		} else {
			me["EPRCmd2"].hide();
			me["FF2"].hide();
		}
		
		# SDP
		if (Value.Bus.dcL) {
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

var update = maketimer(0.2, func() {
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
