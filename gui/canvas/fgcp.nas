# McDonnell Douglas MD-80 FGCP Dialog
# Copyright (c) 2022 Josh Davidson (Octal450)

var fgcpCanvas = {
	new: func() {
		var m = {parents: [fgcpCanvas]};
		m._title = "FGCP Panel";
		m._dialog = nil;
		m._canvas = nil;
		m._svg = nil;
		m._root = nil;
		m._svgKeys = nil;
		m._key = nil;
		m._dialogUpdate = maketimer(0.07, m, fgcpCanvas._update);
		m._ovrd = [0, 0];
		m._vert = 0;
		
		return m;
	},
	getKeys: func() {
		return ["AltHold", "AutoLand", "EprLim", "IasMach", "Ils", "MachSel", "Nav", "Perf", "SpdSel", "Turb", "VertSpd", "VorLoc"];
	},
	close: func() {
		me._dialogUpdateT.stop();
		me._dialog.del();
		me._dialog = nil;
	},
	open: func() {
		me._dialog = canvas.Window.new([735, 125], "dialog");
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
		}
		
		# Set up clickspots
		# Left Buttons
		me["SpdSel"].addEventListener("click", func(e) {
			libraries.apPanel.spd();
			libraries.Sound.btn1();
		});
		me["MachSel"].addEventListener("click", func(e) {
			libraries.apPanel.mach();
			libraries.Sound.btn1();
		});
		me["EprLim"].addEventListener("click", func(e) {
			libraries.apPanel.eprLim();
			libraries.Sound.btn1();
		});
		
		# Center Buttons
		me["Nav"].addEventListener("click", func(e) {
			libraries.apPanel.nav();
			libraries.Sound.btn1();
		});
		me["VorLoc"].addEventListener("click", func(e) {
			libraries.apPanel.vorLoc();
			libraries.Sound.btn1();
		});
		me["Ils"].addEventListener("click", func(e) {
			libraries.apPanel.ils();
			libraries.Sound.btn1();
		});
		me["AutoLand"].addEventListener("click", func(e) {
			libraries.apPanel.autoLand();
			libraries.Sound.btn1();
		});
		
		# Right Buttons
		me["VertSpd"].addEventListener("click", func(e) {
			libraries.apPanel.vertSpd();
			libraries.Sound.btn1();
		});
		me["IasMach"].addEventListener("click", func(e) {
			libraries.apPanel.iasMach();
			libraries.Sound.btn1();
		});
		me["AltHold"].addEventListener("click", func(e) {
			libraries.apPanel.altHold();
			libraries.Sound.btn1();
		});
		me["Turb"].addEventListener("click", func(e) {
			libraries.apPanel.turb();
			libraries.Sound.btn1();
		});
		
		me._update();
		me._dialogUpdate.start();
	},
	_update: func() {
		
	},
};

var fgcpDialog = fgcpCanvas.new();
