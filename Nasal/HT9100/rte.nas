# Honeywell Trimble HT9100 MCDU
# Copyright (c) 2025 Josh Davidson (Octal450)

var Rte = {
	new: func(n) {
		var m = {parents: [Rte]};
		
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
			
			LColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.green, COLOR.green],
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: " ORIGIN",
			L1: "",
			L2L: " RUNWAY",
			L2: "-----",
			L3L: "",
			L3: "",
			L4L: "",
			L4: "",
			L5L: "",
			L5: "<RTE COPY",
			L6L: "",
			L6: "<RTE 2",
			
			LBColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "1/2",
			
			RColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.green],
			RFont: [FONT.large, FONT.small, FONT.small, FONT.large, FONT.large, FONT.large],
			R1L: "DEST",
			R1: "",
			R2L: "FLT NO",
			R2: "",
			R3L: "CO ROUTE",
			R3: "----------",
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
			
			title: "RTE 1",
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "rte";
		m.nextPage = "rte2";
		m.prevPage = "rte2";
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		if (fms_ht9100.flightData.airportFrom != "") {
			me.Display.L1 = fms_ht9100.flightData.airportFrom;
			me.Display.LColor[0] = COLOR.white;
		} else {
			me.Display.L1 = "____";
			me.Display.LColor[0] = COLOR.amber;
		}
		if (fms_ht9100.flightData.airportTo != "") {
			me.Display.R1 = fms_ht9100.flightData.airportTo;
			me.Display.RColor[0] = COLOR.white;
		} else {
			me.Display.R1 = "____";
			me.Display.RColor[0] = COLOR.amber;
		}
		
		if (fms_ht9100.flightData.flightNumber != "") {
			me.Display.R2 = fms_ht9100.flightData.flightNumber;
		} else {
			me.Display.R2 = "----------";
		}
		
		#if () {
		#	me.Display.R6 = "ACTIVATE>";
		#} else {
			me.Display.R6 = "PERF INIT>";
		#}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l1") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(3, 4, me.scratchpad)) {
					if (size(findAirportsByICAO(me.scratchpad)) == 1) {
						fms_ht9100.EditFlightData.insertFrom(me.scratchpad);
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("NOT IN DATA BASE");
					}
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			} else if (me.scratchpadState == 0) {
				unit[me.id].setMessage("INVALID CLEAR");
			}
		} else if (k == "r1") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(3, 4, me.scratchpad)) {
					if (size(findAirportsByICAO(me.scratchpad)) == 1) {
						fms_ht9100.EditFlightData.insertTo(me.scratchpad);
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("NOT IN DATA BASE");
					}
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			} else if (me.scratchpadState == 0) {
				unit[me.id].setMessage("INVALID CLEAR");
			}
		} else if (k == "r2") {
			if (me.scratchpadState == 0) {
				fms_ht9100.flightData.flightNumber = "";
				unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 10)) {
					fms_ht9100.flightData.flightNumber = me.scratchpad;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			}
		} else if (k == "r6") {
			if (me.Display.R6 != "ACTIVATE>") {
				unit[me.id].setPage("perfInit");
			}
		}
	},
};
