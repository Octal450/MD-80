# Honeywell Trimble HT9100 FMS
# Copyright (c) 2026 Josh Davidson (Octal450)

# Properties and Data
var Internal = {
	crzMax: 37000,
	engOn: 0,
	Messages: {
	},
	resetToggle: 0,
};

var Value = { # Local store of commonly accessed values
	active: 0,
	distanceRemainingNm: 0,
	wow: 0,
	wow0: 0,
	wpNum: 0,
};

# Logic
var CORE = {
	init: func(t = 0) {
		EditFlightData.reset();
		if (t == 1) {
			mcdu_ht9100.BASE.reset(); # Last
		}
	},
	loop: func() {
		Value.active = RouteManager.active.getBoolValue();
		Value.distanceRemainingNm = RouteManager.distanceRemainingNm.getValue();
		Value.wow = pts.Position.wow.getBoolValue();
		Value.wow0 = pts.Gear.wow[0].getBoolValue();
		Value.wpNum = RouteManager.num.getValue();
		
		if (systems.ENGINES.state[0].getValue() == 3 or systems.ENGINES.state[1].getValue() == 3) {
			Internal.engOn = 1;
		} else {
			Internal.engOn = 0;
		}
		
		EditFlightData.loop();
		
		# Reset system once engines shutdown
		if (Internal.engOn) {
			if (!Internal.resetToggle) {
				Internal.resetToggle = 1;
			}
		} else {
			if (Internal.resetToggle) {
				Internal.resetToggle = 0;
				me.init(1);
			}
		}
	},
};
