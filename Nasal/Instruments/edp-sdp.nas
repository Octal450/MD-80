# McDonnell Douglas MD-80 EDP/SDP
# Copyright (c) 2026 Josh Davidson (Octal450)

var edpSdp = nil;
var edpSdpDisplay = nil;

var Value = {
};

var CanvasBase = {
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
	update: func() {
	},
};

var CanvasEdpSdp = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasEdpSdp, CanvasBase]};
		m.init(canvasGroup, file);

		return m;
	},
	getKeys: func() {
		return [];
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
	CanvasBase.update();
});
