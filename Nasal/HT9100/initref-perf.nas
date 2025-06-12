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

var ThrLim = {
	new: func(n) {
		var m = {parents: [ThrLim]};
		
		m.id = n;
		
		m.Display = {
			CLFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.small, FONT.small],
			CFont: [FONT.small, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1L: "EPR",
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
			
			LLFont: [FONT.large, FONT.small, FONT.small, FONT.small, FONT.small, FONT.small],
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "",
			L1: "",
			L2L: "",
			L2: "",
			L3L: "",
			L3: "<CLB",
			L4L: "",
			L4: "<MCT",
			L5L: "",
			L5: "<CRZ",
			L6L: "",
			L6: "<INDEX",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RLFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.small, FONT.small],
			RFont: [FONT.large, FONT.large, FONT.small, FONT.large, FONT.large, FONT.large],
			R1L: "",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "RATING",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "L/R MAN EPR",
			R5: "-.--->",
			R6L: "",
			R6: "TAKEOFF>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "",
			titleTranslate: 0,
		};
		
		m.fromPage = "";
		m.group = "fmc";
		m.name = "thrLim";
		m.nextPage = "none";
		m.prevPage = "none";
		m.scratchpad = "";
		m.scratchpadState = 0;
		
		m. Value = {
			auto: 0,
			mode: 0,
			rating28k: 0,
			toPhase: 0,
		};
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		me.Value.auto = systems.FADEC.auto.getBoolValue();
		me.Value.mode = systems.THRLIM.Limit.activeModeInt.getValue();
		me.Value.rating28k = systems.FADEC.rating28k.getBoolValue();
		
		if ((fms.Internal.phase >= 2 and me.Value.mode != 0) or me.Value.mode == 1) { # Temporary
			me.Value.toPhase = 0;
		} else {
			me.Value.toPhase = 1;
		}
		
		if (me.Value.auto) {
			me.Display.title = "AUTO THRUST LIMITS";
			me.Display.R4 = "";
		} else {
			me.Display.title = "MANUAL THRUST LIMITS";
			me.Display.R4 = "AUTO>";
		}
		
		if (me.Value.toPhase) {
			me.Display.L1 = "<T/O";
			
			if (me.Value.mode == 5) {
				me.Display.L2L = " TO FLX";
				me.Display.L2 = " " ~ sprintf("%d", systems.THRLIM.Limit.flexTemp.getValue()) ~ "g";
			} else if (!me.Value.rating28k) {
				me.Display.L2L = " TO FLX";
				me.Display.L2 = " ---g";
			} else {
				me.Display.L2L = "";
				me.Display.L2 = "";
			}
		} else {
			me.Display.L1 = "<G/A";
			me.Display.L2L = "";
			me.Display.L2 = "";
		}
		
		if (me.Value.rating28k) {
			me.Display.L1L = " 28K";
			me.Display.R3 = "25K>";
		} else {
			me.Display.L1L = " 25K";
			me.Display.R3 = "28K>";
		}
		
		if (me.Value.mode == 0 or me.Value.mode == 1) {
			me.Display.LFont = [FONT.large, FONT.small, FONT.small, FONT.small, FONT.small, FONT.large];
		} else if (me.Value.mode == 5) {
			me.Display.LFont = [FONT.small, FONT.large, FONT.small, FONT.small, FONT.small, FONT.large];
		} else if (me.Value.mode == 2) {
			me.Display.LFont = [FONT.small, FONT.small, FONT.small, FONT.large, FONT.small, FONT.large];
		} else if (me.Value.mode == 3) {
			me.Display.LFont = [FONT.small, FONT.small, FONT.large, FONT.small, FONT.small, FONT.large];
		} else if (me.Value.mode == 4) {
			me.Display.LFont = [FONT.small, FONT.small, FONT.small, FONT.small, FONT.large, FONT.large];
		}
		
		me.Display.C1 = sprintf("%4.2f", math.round(systems.THRLIM.Limit.active.getValue(), 0.01));
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l1") {
			systems.FADEC.auto.setBoolValue(0);
			if (me.Value.toPhase == 1) {
				systems.THRLIM.setMode(0);
			} else {
				systems.THRLIM.setMode(1);
			}
		} else if (k == "l2") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 2) and unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 0 and me.scratchpad <= 99) {
						systems.FADEC.rating28k.setBoolValue(0); # Just in case it isn't
						systems.THRLIM.setMode(5);
						systems.THRLIM.Limit.flexTemp.setValue(int(me.scratchpad));
						fms.EditFlightData.resetVspeeds();
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("INVALID ENTRY");
					}
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			} else if (me.scratchpadState == 0) {
				if (systems.THRLIM.Limit.activeModeInt.getValue() == 5) {
					systems.THRLIM.setMode(0);
					fms.EditFlightData.resetVspeeds();
					unit[me.id].scratchpadClear();
				}
			}
		} else if (k == "l3") {
			systems.FADEC.auto.setBoolValue(0);
			systems.THRLIM.setMode(3);
		} else if (k == "l4") {
			systems.FADEC.auto.setBoolValue(0);
			systems.THRLIM.setMode(2);
		} else if (k == "l5") {
			systems.FADEC.auto.setBoolValue(0);
			systems.THRLIM.setMode(4);
		} else if (k == "l6") {
			unit[me.id].setPage("refIndex");
		} else if (k == "r3") {
			systems.FADEC.rating28k.setBoolValue(!systems.FADEC.rating28k.getBoolValue());
		} else if (k == "r4") {
			if (me.Display.R4 != "") {
				systems.FADEC.auto.setBoolValue(1);
			}
		} else if (k == "r6") {
			unit[me.id].setPage("takeoff");
		}
	},
};
