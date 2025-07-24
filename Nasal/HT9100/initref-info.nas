# Honeywell Trimble HT9100 MCDU
# Copyright (c) 2025 Josh Davidson (Octal450)

var Ident = {
	Common: {
		database: "JAN01JAN28/13",
		database2: "JAN29FEB26/13",
		databaseCode: "MD19801001",
		databaseCode2: "MD19801002",
		databaseSelected: 1,
		engines: props.globals.getNode("/systems/ht9100/options/engines"),
		swVer: "HT9100-007B",
		type: props.globals.getNode("/systems/ht9100/options/type"),
	},
	new: func(n) {
		var m = {parents: [Ident]};
		
		m.id = n;
		
		m.Display = {
			CColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1L: "",
			C1: "",
			C2L: "",
			C2: "",
			C3L: "",
			C3: "",
			C4L: "",
			C4: "",
			C5L: "",
			C5: "",
			C6L: "",
			C6: "",
			
			LColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			LFont: [FONT.large, FONT.large, FONT.small, FONT.large, FONT.large, FONT.large],
			L1L: " MODEL",
			L1: me.Common.type.getValue(),
			L2L: " NAV DATA",
			L2: "",
			L3L: "",
			L3: "",
			L4L: " SOFTWARE",
			L4: me.Common.swVer,
			L5L: "",
			L5: "",
			L6L: "------------------------",
			L6: "",
			
			LBColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.green],
			RFont: [FONT.large, FONT.large, FONT.small, FONT.large, FONT.large, FONT.large],
			R1L: "ENGINES",
			R1: me.Common.engines.getValue(),
			R2L: "ACTIVE",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "",
			R6: "POS REF>",
			
			RBColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "IDENT",
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "ident";
		m.nextPage = "none";
		m.prevPage = "none";
		
		return m;
	},
	reset: func() {
		me.Common.databaseSelected = 1;
	},
	setup: func() {
	},
	loop: func() {
		if (me.Common.databaseSelected) {
			me.Display.L2 = me.Common.databaseCode2;
			me.Display.L3 = me.Common.databaseCode;
			me.Display.R2 = me.Common.database2;
			me.Display.R3 = me.Common.database;
		} else {
			me.Display.L2 = me.Common.databaseCode;
			me.Display.L3 = me.Common.databaseCode2;
			me.Display.R2 = me.Common.database;
			me.Display.R3 = me.Common.database2;
		}
	},
	softKey: func(k) {
		if (k == "r6") {
			unit[me.id].setPage("posRef");
		}
	},
};


var PosRef = {
	new: func(n) {
		var m = {parents: [PosRef]};
		
		m.id = n;
		
		m.Display = {
			CColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, -8, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1L: "",
			C1: "",
			C2L: "",
			C2: "",
			C3L: "",
			C3: "",
			C4L: "",
			C4: "",
			C5L: "INTEGRITY PREDICTION",
			C5: "",
			C6L: "",
			C6: "",
			
			LColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.green, COLOR.green, COLOR.white],
			LFont: [FONT.large, FONT.large, FONT.small, FONT.large, FONT.large, FONT.large],
			L1L: " POS (GPS)",
			L1: "",
			L2L: " UTC (GPS)",
			L2: "",
			L3L: " RNP/ACTUAL",
			L3: "1.00/0.05",
			L4L: "",
			L4: "<DR",
			L5L: "",
			L5: "<ACT RTE",
			L6L: "------------------------",
			L6: "",
			
			LBColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			LBFont: [FONT.large, FONT.small, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "      Z",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.green, COLOR.green],
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "",
			R1: "",
			R2L: "GS",
			R2: "",
			R3L: "SV USED",
			R3: "7",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "DEST RAIM>",
			R6L: "",
			R6: "ROUTE>",
			
			RBColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			RBFont: [FONT.large, FONT.small, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "KT",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "POS REF",
			titleTranslate: 0,
		};
		
		m.fromPage = "";
		m.group = "fmc";
		m.name = "posRef";
		m.nextPage = "none";
		m.prevPage = "none";
		m.scratchpad = "";
		m.scratchpadState = 0;
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		me.Display.L1 = FORMAT.Position.formatNode(pts.Position.node);
		me.Display.L2 = sprintf("%02d%02d.%d", pts.Sim.Time.Utc.hour.getValue(), pts.Sim.Time.Utc.minute.getValue(), math.floor(pts.Sim.Time.Utc.second.getValue() / 10));
		me.Display.R2 = sprintf("%d", math.round(pts.Velocities.groundspeedKt.getValue())) ~ "  ";
	},
	softKey: func(k) {
		if (k == "r6") {
			unit[me.id].setPage("rte");
		}
	},
};
