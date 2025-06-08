# Honeywell Trimble HT9100 MCDU
# Copyright (c) 2025 Josh Davidson (Octal450)

var unit = [nil];

var MCDU = {
	new: func(n, ps) {
		var m = {parents: [MCDU]};
		
		m.delete = 0;
		m.exec = 0;
		m.id = n;
		m.lastFmcPage = "none";
		m.message = std.Vector.new();
		
		m.PageList = {
			dataIndex: DataIndex.new(n),
			fallback: Fallback.new(n),
			ident: Ident.new(n),
			menu: Menu.new(n),
			posRef: PosRef.new(n),
		};
		
		m.page = m.PageList.ident;
		m.powerSource = ps;
		m.scratchpad = "";
		m.scratchpadDecimal = nil;
		m.scratchpadOld = "";
		m.scratchpadSize = 0;
		
		return m;
	},
	reset: func() {
		me.delete = 0;
		me.exec = 0;
		me.lastFmcPage = "none";
		me.message.clear();
		me.page = me.PageList.ident;
		
		me.PageList.ident.reset();
		
		me.scratchpad = "";
		me.scratchpadDecimal = nil;
		me.scratchpadOld = "";
		me.scratchpadSize = 0;
	},
	loop: func() {
		if (me.powerSource.getValue() < 24) {
			if (me.page != me.PageList.ident) {
				me.page = me.PageList.ident;
			}
		}
		
		me.page.loop();
	},
	alphaNumKey: func(k) {
		if (me.powerSource.getValue() < 24) {
			return;
		}
		
		if (k == "CLR") {
			if (me.message.size() > 0) { # Clear message
				me.delete = 0;
				me.clearMessage(0);
			} else if (size(me.scratchpad) > 0) { # Clear letter
				me.delete = 0;
				me.scratchpad = left(me.scratchpad, size(me.scratchpad) - 1);
			} else if (me.delete) { # Clear DELETE character
				me.delete = 0;
			} else { # Set DELETE character
				me.delete = 1;
			}
		} else if (k == "+/-") {
			me.delete = 0;
			if (me.message.size() > 0) {
				me.clearMessage(1);
			}
			if (right(me.scratchpad, 1) == "-") {
				me.scratchpad = left(me.scratchpad, size(me.scratchpad) - 1) ~ "+";
			} else if (right(me.scratchpad, 1) == "+") {
				me.scratchpad = left(me.scratchpad, size(me.scratchpad) - 1) ~ "-";
			} else if (size(me.scratchpad) < 23) {
				me.scratchpad = me.scratchpad ~ "-";
			}
		} else {
			me.delete = 0;
			if (me.message.size() > 0) {
				me.clearMessage(1);
			}
			if (size(me.scratchpad) < 24) {
				me.scratchpad = me.scratchpad ~ k;
			}
		}
	},
	clearMessage: func(a) {
		me.delete = 0;
		
		if (a == 2) { # Clear all and set scratchpad to stored value
			me.message.clear();
			if (size(me.scratchpadOld) > 0) {
				me.scratchpad = me.scratchpadOld;
			} else {
				me.scratchpad = "";
			}
		} else if (a == 1) { # Clear all and blank scratchpad
			me.message.clear();
			me.scratchpad = "";
			me.scratchpadOld = "";
		} else { # Clear single message
			if (me.message.size() > 1) {
				me.message.pop(0);
				me.scratchpad = me.message.vector[0];
			} else if (me.message.size() > 0) {
				me.message.pop(0);
				if (size(me.scratchpadOld) > 0) {
					me.scratchpad = me.scratchpadOld;
				} else {
					me.scratchpad = "";
				}
			}
		}
	},
	execKey: func() {
		if (me.powerSource.getValue() < 24) {
			return;
		}
	},
	nextPageKey: func() {
		if (me.powerSource.getValue() < 24) {
			return;
		}
		
		if (me.page.nextPage == "handled") { # Page handles it itself
			me.page.nextPage(); 
		} else if (me.page.nextPage != "none") { # Has next page
			me.setPage(me.page.nextPage);
		}
	},
	pageKey: func(p) {
		if (me.powerSource.getValue() < 24) {
			return;
		}
		
		if (p == "initRef") p = "refIndex";
		me.setPage(p);
	},
	prevPageKey: func() {
		if (me.powerSource.getValue() < 24) {
			return;
		}
		
		if (me.page.prevPage == "handled") { # Page handles it itself
			me.page.prevPage(); 
		} else if (me.page.prevPage != "none") { # Has prev page
			me.setPage(me.page.prevPage);
		}
	},
	removeMessage: func(m) {
		me.delete = 0;
		
		if (me.message.contains(m)) {
			if (me.message.size() > 1) {
				me.message.pop(me.message.index(m));
				me.scratchpad = me.message.vector[0];
			} else if (me.message.size() > 0) {
				me.message.pop(me.message.index(m));
				if (size(me.scratchpadOld) > 0) {
					me.scratchpad = me.scratchpadOld;
				} else {
					me.scratchpad = "";
				}
			}
		}
	},
	scratchpadClear: func() {
		me.clearMessage(1); # Also clears scratchpad and delete
	},
	scratchpadSet: func(t) {
		me.clearMessage(1);
		me.scratchpad = t;
	},
	scratchpadState: func() {
		if (me.delete) { # DELETE character
			return 0;
		} else if (size(me.scratchpad) > 0 and me.message.size() == 0) { # Entry
			return 2;
		} else { # Empty or Message
			return 1;
		}
	},
	setMessage: func(m) {
		me.delete = 0;
		
		if (me.message.size() > 0) {
			if (me.message.vector[0] != m) { # Don't duplicate top message
				me.removeMessage(m); # Remove duplicate if it exists
				me.message.insert(0, m);
				me.scratchpad = m;
			}
		} else {
			me.message.insert(0, m);
			me.scratchpadOld = me.scratchpad;
			me.scratchpad = m;
		}
	},
	setPage: func(p) {
		if (!contains(me.PageList, p)) { # Fallback logic
			p = "fallback";
		}
		
		if (me.page.group == "fmc") { # Store last FMC group page
			me.lastFmcPage = me.page.name;
		}
		
		if (me.message.size() > 0) { # Clear messages
			me.clearMessage(2);
		}
		
		me.page = me.PageList[p]; # Set page
		me.page.setup();
		
		# Update everything now to make sure it all transitions at once
		me.page.loop(); 
		canvas_ht9100.updateMcdu(me.id);
	},
	softKey: func(k) {
		if (me.powerSource.getValue() < 24) {
			return;
		}
		
		me.page.softKey(k);
	},
	# String checking functions - if no test string is provided, they will check the scratchpad
	stringContains: func(c, test = nil) { # Checks if the test contains the string provided
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (find(c, test) != -1) {
			return 1;
		} else {
			return 0;
		}
	},
	stringDecimalLengthInRange: func(min, max, test = nil) { # Checks if the test is a decimal number with place length in the range provided
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (int(test) != nil) {
			if (find(".", test) != -1) {
				if (max == 0) {
					return 0;
				} else {
					me.scratchpadDecimal = split(".", test);
					if (size(me.scratchpadDecimal[1]) >= min and size(me.scratchpadDecimal[1]) <= max) {
						return 1;
					} else {
						return 0;
					}
				}
			} else {
				if (min == 0) {
					return 1;
				} else {
					return 0;
				}
			}
		} else {
			return 0;
		}
	},
	stringIsInt: func(test = nil) { # Checks if the test is an integer number
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (int(test) != nil) {
			if (test - int(test) != 0) {
				return 0;
			} else {
				return 1;
			}
		} else {
			return 0;
		}
	},
	stringIsNumber: func(test = nil) { # Checks if the test is a number, integer or decimal
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (int(test) != nil) {
			return 1;
		} else {
			return 0;
		}
	},
	stringLengthInRange: func(min, max, test = nil) { # Checks if the test string length is in the range provided
		if (test == nil) {
			test = me.scratchpad;
		}
		
		me.scratchpadSize = size(sprintf("%s", string.replace(test, "-", ""))); # Always string, and negatives don't affect
		
		if (me.scratchpadSize >= min and me.scratchpadSize <= max) {
			return 1;
		} else {
			return 0;
		}
	},
};

var BASE = {
	setup: func() {
		unit[0] = MCDU.new(0, systems.ELECTRICAL.Bus.emerDc);
	},
	loop: func() {
		unit[0].loop();
	},
	# Only one unit is simulated currently, so the for loops aren't needed
	reset: func() {
		#for (var i = 0; i < 2; i = i + 1) {
		#	unit[i].reset();
		#}
		unit[0].reset();
	},
	removeGlobalMessage: func(m) {
		#for (var i = 0; i < 2; i = i + 1) {
		#	unit[i].removeMessage(m);
		#}
		unit[0].removeMessage(m);
	},
	setGlobalMessage: func(m) {
		#for (var i = 0; i < 2; i = i + 1) {
		#	unit[i].setMessage(m);
		#}
		unit[0].setMessage(m);
	},
};

var FONT = { # Matches Boeing font, letter separation in Canvas: 40.559
	large: "BoeingMCDULarge.ttf",
	small: "BoeingMCDUSmall.ttf",
};

var FORMAT = {
	Position: {
		degrees: [nil, nil],
		dms: nil,
		minutes: [nil, nil],
		sign: [nil, nil],
		formatGhost: func(ghost) {
			me.dms = ghost.lat;
			me.degrees[0] = int(me.dms);
			me.minutes[0] = sprintf("%.1f",abs((me.dms - me.degrees[0]) * 60));
			me.sign[0] = me.degrees[0] >= 0 ? "N" : "S";
			me.dms = ghost.lon;
			me.degrees[1] = int(me.dms);
			me.minutes[1] = sprintf("%.1f",abs((me.dms - me.degrees[1]) * 60));
			me.sign[1] = me.degrees[1] >= 0 ? "E" : "W";
			return sprintf("%s%02sg%.1f %s%03sg%.1f", me.sign[0], abs(me.degrees[0]), me.minutes[0], me.sign[1], abs(me.degrees[1]), me.minutes[1]);
		},
		formatNode: func(node) {
			me.dms = node.getChild("latitude-deg").getValue();
			me.degrees[0] = int(me.dms);
			me.minutes[0] = sprintf("%.1f",abs((me.dms - me.degrees[0]) * 60));
			me.sign[0] = me.degrees[0] >= 0 ? "N" : "S";
			me.dms = node.getChild("longitude-deg").getValue();
			me.degrees[1] = int(me.dms);
			me.minutes[1] = sprintf("%.1f",abs((me.dms - me.degrees[1]) * 60));
			me.sign[1] = me.degrees[1] >= 0 ? "E" : "W";
			return sprintf("%s%02sg%.1f %s%03sg%.1f", me.sign[0], abs(me.degrees[0]), me.minutes[0], me.sign[1], abs(me.degrees[1]), me.minutes[1]);
		},
	},
};
