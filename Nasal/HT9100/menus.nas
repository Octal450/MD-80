# Honeywell Trimble HT9100 MCDU
# Copyright (c) 2025 Josh Davidson (Octal450)

var Menu = {
	new: func(n) {
		var m = {parents: [Menu]};
		
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
			
			LColor: ["white", "white", "white", "white", "white", "white"],
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "",
			L1: "",
			L2L: "",
			L2: "<HT9100",
			L3L: "",
			L3: "",
			L4L: "",
			L4: "",
			L5L: "",
			L5: "",
			L6L: "",
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
			
			RColor: ["white", "white", "white", "white", "white", "white"],
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "",
			R6: "",
			
			RBColor: ["white", "white", "white", "white", "white", "white"],
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "MENU",
			titleTranslate: 0,
		};
		
		m.group = "base";
		m.name = "menu";
		m.nextPage = "none";
		m.prevPage = "none";
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
	},
	softKey: func(k) {
		if (k == "l2") {
			if (mcdu_ht9100.unit[me.id].lastFmcPage == "none") {
				mcdu_ht9100.unit[me.id].setPage("ident");
			} else {
				mcdu_ht9100.unit[me.id].setPage(mcdu_ht9100.unit[me.id].lastFmcPage);
			}
		}
	},
};

var DataIndex = {
	new: func(n) {
		var m = {parents: [DataIndex]};
		
		m.id = n;
		
		m.Display = {
			CColor: ["white", "white", "white", "white", "white", "white"],
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [-7, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1L: "FLIGHT PLAN XFER",
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
			
			LColor: ["white", "white", "white", "white", "white", "white"],
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "",
			L1: "<TRANSMIT",
			L2L: "",
			L2: "<POS REF",
			L3L: "",
			L3: "",
			L4L: "",
			L4: "",
			L5L: "",
			L5: "",
			L6L: "",
			L6: "<IDENT",
			
			LBColor: ["white", "white", "white", "white", "white", "white"],
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RColor: ["white", "white", "white", "white", "white", "white"],
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "",
			R1: "RECEIVE>",
			R2L: "",
			R2: "NAV DATA>",
			R3L: "",
			R3: "NEAREST>",
			R4L: "",
			R4: "FIX>",
			R5L: "",
			R5: "",
			R6L: "",
			R6: "MAINTENANCE>",
			
			RBColor: ["white", "white", "white", "white", "white", "white"],
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "DATA INDEX",
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "dataIndex";
		m.nextPage = "none";
		m.prevPage = "none";
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
	},
	softKey: func(k) {
		if (k == "l2") {
			mcdu_ht9100.unit[me.id].setPage("posRef");
		} else if (k == "l6") {
			mcdu_ht9100.unit[me.id].setPage("ident");
		}
	},
};
