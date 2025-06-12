# Honeywell Trimble HT9100 MCDU
# Copyright (c) 2025 Josh Davidson (Octal450)

var PerfInit = {
	new: func(n) {
		var m = {parents: [PerfInit]};
		
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
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "",
			L1: "",
			L2L: "",
			L2: "",
			L3L: " ZFW",
			L3: "",
			L4L: " RESERVES",
			L4: "",
			L5L: " TRANS ALT",
			L5: "",
			L6L: "------------------------",
			L6: "",
			
			LBColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			LBFont: [FONT.large, FONT.small, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			RFont: [FONT.large, FONT.large, FONT.small, FONT.large, FONT.large, FONT.large],
			R1L: "CRZ ALT",
			R1: "",
			R2L: "CLIMB",
			R2: "",
			R3L: "CRUISE",
			R3: "",
			R4L: "DESCENT",
			R4: "",
			R5L: "SPD TRANS",
			R5: "",
			R6L: "",
			R6: "",
			
			RBColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "PERF INIT",
			titleTranslate: 0,
		};
		
		m.fromPage = "";
		m.group = "fmc";
		m.name = "perfInit";
		m.nextPage = "none";
		m.prevPage = "none";
		m.scratchpad = "";
		m.scratchpadState = 0;
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		
	},
};
