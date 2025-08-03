# Honeywell Trimble HT9100 FMS
# Copyright (c) 2025 Josh Davidson (Octal450)
# Where needed + 0 is used to force a string to a number

# Properties and Data
var FlightData = {
	new: func() {
		var m = {parents: [FlightData]};
		
		m.airportFrom = "";
		m.airportFromAlt = -2000;
		m.airportPosRef = "";
		m.airportTo = "";
		m.airportToAlt = -2000;
		m.costIndex = -1;
		m.cruiseAlt = 0;
		m.cruiseFl = 0;
		m.flightNumber = "";
		m.reserveLbs = -1;
		m.transAlt = 18000;
		m.zfwLbs = 0;
		
		return m; 
	},
	reset: func() {
		var blankData = FlightData.new();
		foreach(var key; keys(me)) {
			me[key] = blankData[key];
		}
	},
};

var flightData = FlightData.new();

var FlightDataOut = {
};

var RouteManager = {
	active: props.globals.getNode("/autopilot/route-manager/active"),
	alternateAirport: props.globals.getNode("/autopilot/route-manager/alternate/airport"),
	cruiseAlt: props.globals.getNode("/autopilot/route-manager/cruise/altitude-ft"),
	currentWp: props.globals.getNode("/autopilot/route-manager/current-wp"),
	departureAirport: props.globals.getNode("/autopilot/route-manager/departure/airport"),
	destinationAirport: props.globals.getNode("/autopilot/route-manager/destination/airport"),
	distanceRemainingNm: props.globals.getNode("/autopilot/route-manager/distance-remaining-nm"),
	num: props.globals.getNode("/autopilot/route-manager/route/num"),
};

# Logic
var EditFlightData = {
	loop: func() {
		# Status Sync
		if (flightData.airportFrom == "" and flightData.airportTo == "") {
			if (Value.active) {
				flightplan().cleanPlan();
				gui.popupTip("You need to initialize the MCDU before a route can be activated");
			}
		}
		
		# Write out values for JSBSim to use
		#me.writeOut();
		#me.checkPreFltComplete();
	},
	reset: func() {
		# Reset Route Manager
		flightplan().cleanPlan(); # Clear List function in Route Manager
		RouteManager.alternateAirport.setValue("");
		RouteManager.cruiseAlt.setValue(0);
		RouteManager.departureAirport.setValue("");
		RouteManager.destinationAirport.setValue("");
		
		# Clear FlightData
		me.activateNeeded = 0;
		me.executeNeeded = 0;
		flightData.reset();
		me.writeOut();
	},
	writeOut: func() { # Write out relevant parts of the FlightData object to property tree as required so that JSBSim can access it
	},
	insertCruise: func(alt, type) { # Type 0: FL, 1: Alt
		if (type) {
			alt = math.round(alt, 100);
			flightData.cruiseAlt = int(alt);
			flightData.cruiseFl = alt / 100;
			RouteManager.cruiseAlt.setValue(alt);
		} else {
			flightData.cruiseAlt = alt * 100;
			flightData.cruiseFl = int(alt);
			RouteManager.cruiseAlt.setValue(alt * 100);
		}
	},
	insertFrom: func(arpt) { # Assumes validation is already done
		if (flightData.airportFrom != "" and flightData.airportTo != "") {
			flightData.airportTo = "";
			flightData.airportToAlt = -2000;
		}
		
		flightData.airportFrom = arpt;
		flightData.airportFromAlt = math.round(airportinfo(flightData.airportFrom).elevation * M2FT);
		me.insertToAlts();
		
		me.newFlightplan(flightData.airportFrom, flightData.airportTo); # Does not matter if one is blank still
	},
	insertTo: func(arpt) { # Assumes validation is already done
		if (flightData.airportFrom != "" and flightData.airportTo != "") {
			flightData.airportFrom = "";
			flightData.airportFromAlt = -2000;
		}
		
		flightData.airportTo = arpt;
		flightData.airportToAlt = math.round(airportinfo(flightData.airportTo).elevation * M2FT);
		
		me.newFlightplan(flightData.airportFrom, flightData.airportTo); # Does not matter if one is blank still
	},
	insertToAlts: func(t = 0) {
		if (flightData.airportFromAlt > -2000) {
			flightData.climbThrustAlt = math.max(flightData.airportFromAlt + 1500, 0);
		} else {
			flightData.climbThrustAlt = -2000;
		}
	},
	newFlightplan: func(from, to) { # Assumes validation is already done
		flightplan().cleanPlan(); # Clear List function in Route Manager
		
		if (from != "") {
			RouteManager.departureAirport.setValue(from);
		}
		if (to != "") {
			RouteManager.destinationAirport.setValue(to);
		}
		
		if (from != "" and to != "") {
			if (!RouteManager.active.getBoolValue()) {
				fgcommand("activate-flightplan", props.Node.new({"activate": 1}));
			}
			if (RouteManager.currentWp.getValue() == -1) { # This fixes a weird issue where the Route Manager sets it to -1
				RouteManager.currentWp.setValue(1);
			}
		}
	},
	setNpsPhnlTest: func() { # For developer use/testing ONLY!
		me.insertFrom("NPS");
		me.insertTo("PHNL");
		me.insertCruise(100, 0);
	},
};
