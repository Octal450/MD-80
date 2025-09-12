# Honeywell Trimble HT9100 MCDU
# Copyright (c) 2025 Josh Davidson (Octal450) and Jonathan Redpath (legoboyvdlp)

var NearestIndex = {
	new: func(n) {
		var m = {parents: [NearestIndex]};
		
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
			
			LColor: [COLOR.green, COLOR.green, COLOR.green, COLOR.green, COLOR.white, COLOR.white],
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "",
			L1: "<AIRPORT",
			L2L: "",
			L2: "<VOR/DME",
			L3L: "",
			L3: "<ADF",
			L4L: "",
			L4: "<WAYPOINT",
			L5L: "",
			L5: "",
			L6L: "",
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
			
			RColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
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
			
			RBColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "NEAREST INDEX",
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "nearestIndex";
		m.nextPage = "none";
		m.prevPage = "none";
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
	},
	softKey: func(k) {
		if (k == "l1") {
			unit[me.id].setPage("nearestAirports");
		}
	},
};

var NearestAirports = {
	new: func(n) {
		var m = {parents: [NearestAirports]};
		
		m.id = n;
		
		m.Display = {
			CColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1L: "CRS /DIST",
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
			
			LColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.green],
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "",
			L1: "",
			L2L: "",
			L2: "",
			L3L: "",
			L3: "",
			L4L: "",
			L4: "",
			L5L: "",
			L5: "",
			L6L: "",
			L6: "<NEAREST INDEX",
			
			LBColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "1/4",
			
			RColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
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
			
			RBColor: [COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white, COLOR.white],
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "NEAREST AIRPORTS",
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "nearestAirports";
		m.nextPage = "nearestVorDme";
		m.prevPage = "none";
		
		m.Value = {
			airports: nil,
			cdVector: [nil, nil, nil, nil, nil],
			magVar: nil,
			range: 10,
		};
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
		me.Value.cdVector = [nil, nil, nil, nil, nil];
		me.Value.range = 10;
		
		# Loop and search for airports in range
		me.Value.airports = findAirportsWithinRange(me.Value.range);
		while (size(me.Value.airports) < 5 and me.Value.range < 4000) {
			me.Value.airports = findAirportsWithinRange(me.Value.range);
			if (me.Value.range < 100) {
				me.Value.range += 10;
			} elsif (me.Value.range < 500) {
				me.Value.range += 50;
			} elsif (me.Value.range < 1000) {
				me.Value.range += 100;
			} elsif (me.Value.range < 2000) {
				me.Value.range += 250;
			}  else {
				me.Value.range += 500;
			}
		}
	},
	loop: func() {
		if (size(me.Value.airports) == 0) {
			me.Display.L1 = "";
			me.Display.L2 = "";
			me.Display.L3 = "";
			me.Display.L4 = "";
			me.Display.L5 = "";
			me.Display.C1 = "NONE WITHIN 4000NM";
			me.Display.C2 = "";
			me.Display.C3 = "";
			me.Display.C4 = "";
			me.Display.C5 = "";
		} else {
			me.Value.magVar = magvar();
			
			if (size(me.Value.airports) >= 1) {
				me.Display.L1 = me.Value.airports[0].id;
				me.Value.cdVector[0] = courseAndDistance(me.Value.airports[0]);
				me.Display.C1 = sprintf("%03.0fg/%4.0fNM", math.round(me.Value.cdVector[0][0] - me.Value.magVar), math.round(me.Value.cdVector[0][1]));
			}
			
			if (size(me.Value.airports) >= 2) {
				me.Display.L2 = me.Value.airports[1].id;
				me.Value.cdVector[1] = courseAndDistance(me.Value.airports[1]);
				me.Display.C2 = sprintf("%03.0fg/%4.0fNM", math.round(me.Value.cdVector[1][0] - me.Value.magVar), math.round(me.Value.cdVector[1][1]));
			}
			
			if (size(me.Value.airports) >= 3) {
				me.Display.L3 = me.Value.airports[2].id;
				me.Value.cdVector[2] = courseAndDistance(me.Value.airports[2]);
				me.Display.C3 = sprintf("%03.0fg/%4.0fNM", math.round(me.Value.cdVector[2][0] - me.Value.magVar), math.round(me.Value.cdVector[2][1]));
			}
			
			if (size(me.Value.airports) >= 4) {
				me.Display.L4 = me.Value.airports[3].id;
				me.Value.cdVector[3] = courseAndDistance(me.Value.airports[3]);
				me.Display.C4 = sprintf("%03.0fg/%4.0fNM", math.round(me.Value.cdVector[3][0] - me.Value.magVar), math.round(me.Value.cdVector[3][1]));
			}
			
			if (size(me.Value.airports) >= 4) {
				me.Display.L4 = me.Value.airports[3].id;
				me.Value.cdVector[3] = courseAndDistance(me.Value.airports[3]);
				me.Display.C4 = sprintf("%03.0fg/%4.0fNM", math.round(me.Value.cdVector[3][0] - me.Value.magVar), math.round(me.Value.cdVector[3][1]));
			}
			
			if (size(me.Value.airports) >= 5) {
				me.Display.L5 = me.Value.airports[4].id;
				me.Value.cdVector[4] = courseAndDistance(me.Value.airports[4]);
				me.Display.C5 = sprintf("%03.0fg/%4.0fNM", math.round(me.Value.cdVector[4][0] - me.Value.magVar), math.round(me.Value.cdVector[4][1]));
			}
		}
	},
	softKey: func(k) {
		if (k == "l6") {
			unit[me.id].setPage("nearestIndex");
		}
	},
};
