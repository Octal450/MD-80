# Honeywell Trimble HT9100 MCDU
# Copyright (c) 2025 Josh Davidson (Octal450)

var Ident = {
	Common: {
		database: "JAN01JAN28/13",
		database2: "JAN29FEB26/13",
		databaseCode: "MD19801001",
		databaseCode2: "MD19801002",
		databaseSelected: 1,
		eng: "JT8D-" ~ props.globals.getNode("/options/eng").getValue(),
		swVer: "HT9100-007B",
	},
	new: func(n) {
		var m = {parents: [Ident]};
		
		m.id = n;
		
		m.Display = {
			CColor: ["white", "white", "white", "white", "white", "white"],
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
			
			LColor: ["white", "white", "white", "white", "white", "cyan"],
			LFont: [FONT.large, FONT.large, FONT.small, FONT.large, FONT.large, FONT.large],
			L1L: " MODEL",
			L1: pts.Options.type.getValue(),
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
			
			LBColor: ["white", "white", "white", "white", "white", "white"],
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RColor: ["white", "white", "white", "white", "white", "cyan"],
			RFont: [FONT.large, FONT.large, FONT.small, FONT.large, FONT.large, FONT.large],
			R1L: "ENGINES",
			R1: me.Common.eng,
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
			
			RBColor: ["white", "white", "white", "white", "white", "white"],
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
			mcdu_ht9100.unit[me.id].setPage("posInit");
		}
	},
};
