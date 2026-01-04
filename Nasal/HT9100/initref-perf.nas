# Honeywell Trimble HT9100 MCDU
# Copyright (c) 2026 Josh Davidson (Octal450)

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
			L1L: " TRANS ALT",
			L1: "",
			L2L: "",
			L2: "",
			L3L: "",
			L3: "",
			L4L: "",
			L4: "",
			L5L: "",
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
		me.Display.L1 = sprintf("%d", fms_ht9100.flightData.transAlt);
		
		if (fms_ht9100.flightData.cruiseFl > 0) {
			me.Display.R1 = "FL" ~ sprintf("%2d", fms_ht9100.flightData.cruiseFl);
			me.Display.RColor[0] = COLOR.white;
		} else {
			me.Display.R1 = "_____";
			me.Display.RColor[0] = COLOR.amber;
		}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l1") {
			if (me.scratchpadState == 2) {
				if (!unit[me.id].stringIsInt()) {
					unit[me.id].setMessage("INVALID ENTRY");
				} else if (unit[me.id].stringLengthInRange(2, 3)) {
					if (me.scratchpad > 180) {
						unit[me.id].setMessage("INVALID ENTRY");
						return;
					}
					
					fms_ht9100.flightData.transAlt = me.scratchpad * 100;
					unit[me.id].scratchpadClear();
				} else if (unit[me.id].stringLengthInRange(4, 5)) {
					if (me.scratchpad > 18000) {
						unit[me.id].setMessage("INVALID ENTRY");
						return;
					}
					
					fms_ht9100.flightData.transAlt = me.scratchpad + 0;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			} else if (me.scratchpadState == 0) {
				unit[me.id].setMessage("INVALID CLEAR");
			}
		} else if (k == "r1") {
			if (me.scratchpadState == 2) {
				if (!unit[me.id].stringIsInt()) {
					unit[me.id].setMessage("INVALID ENTRY");
				} else if (unit[me.id].stringLengthInRange(2, 3)) {
					if (me.scratchpad > fms_ht9100.Internal.crzMax / 100) {
						unit[me.id].setMessage("INVALID ENTRY");
						return;
					}
					
					fms_ht9100.EditFlightData.insertCruise(me.scratchpad, 0);
					unit[me.id].scratchpadClear();
				} else if (unit[me.id].stringLengthInRange(4, 5)) {
					if (me.scratchpad > fms_ht9100.Internal.crzMax) {
						unit[me.id].setMessage("INVALID ENTRY");
						return;
					}
					
					fms_ht9100.EditFlightData.insertCruise(me.scratchpad, 1);
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			} else if (me.scratchpadState == 0) {
				unit[me.id].setMessage("INVALID CLEAR");
			}
		}
	},
};
