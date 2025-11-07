# McDonnell Douglas MD-80 Radios
# Copyright (c) 2025 Josh Davidson (Octal450)

var crp = [nil, nil];
var ettr = props.globals.getNode("/systems/acconfig/options/eight-three-three-radios");

var CRP = {
	new: func(n) {
		var m = {parents: [CRP]};
		
		m.activeSel = 0;
		m.num = n;
		m.power = props.globals.getNode("/systems/electrical/outputs/comm[" ~ n ~ "]", 1);
		m.selTemp = 0;
		m.stbyRight = 0;
		m.stbySel = 0;
		m.stbySplit = [0, 0];
		m.stbyVal = 0;
		m.stbyValRight = 0;
		
		return m;
	},
	adjustDec: func(d, s = 0, o = -1) {
		if (me.power.getValue() >= 24) {
			if (o > -1) {
				me.selTemp = o;
			} else {
				me.selTemp = me.num;
			}
			
			me.stbySplit = split(".", sprintf("%3.3f", pts.Instrumentation.Comm.Frequencies.standbyMhzFmt[me.selTemp].getValue()));
			me.stbyRight = right(me.stbySplit[1], 2);
			
			if (ettr.getBoolValue()) { # 8.33KHz/25KHz mixed
				# FG enforces 8.33KHz channel rounding
				if (s) me.stbyVal = sprintf("%03d", me.stbySplit[1] + (100 * d));
				else me.stbyVal = sprintf("%03d", me.stbySplit[1] + (5 * d));
				
				me.stbyValRight = right(me.stbyVal, 2);
				
				if (d > 0) {
					if (me.stbyVal > 990) { # 995 is skipped
						if (s) me.stbyVal = me.stbyRight; # Initial value
						else me.stbyVal = 0;
					} else if (me.stbyValRight == 20 or me.stbyValRight == 45 or me.stbyValRight == 70 or me.stbyValRight == 95) {
						me.stbyVal = me.stbyVal + 5;
					}
				} else if (d < 0) {
					if (me.stbyVal < 0) {
						if (s) me.stbyVal = "9" ~ me.stbyRight; # Initial value
						else me.stbyVal = 990; # 995 is skipped
					} else if (me.stbyValRight == 20 or me.stbyValRight == 45 or me.stbyValRight == 70 or me.stbyValRight == 95) {
						me.stbyVal = me.stbyVal - 5;
					}
				}
			} else { # 25KHz
				# Enforce 25KHz channel rounding because FG doesn't
				if (s) me.stbyVal = sprintf("%03d", math.round(me.stbySplit[1] + (100 * d), 25));
				else me.stbyVal = sprintf("%03d", math.round(me.stbySplit[1] + (25 * d), 25));
				
				if (d > 0) {
					if (me.stbyVal > 975) {
						if (s) me.stbyVal = me.stbyRight; # Initial value
						else me.stbyVal = 0;
					}
				} else if (d < 0) {
					if (me.stbyVal < 0) {
						if (s) me.stbyVal = "9" ~ me.stbyRight; # Initial value
						else me.stbyVal = 975;
					}
				}
			}
			
			me.stbyVal = sprintf("%03d", me.stbyVal);
			pts.Instrumentation.Comm.Frequencies.standbyMhz[me.selTemp].setValue(me.stbySplit[0] ~ "." ~ me.stbyVal);
		}
	},
	adjustInt: func(d, o = -1) {
		if (me.power.getValue() >= 24) {
			if (o > -1) {
				me.selTemp = o;
			} else {
				me.selTemp = me.num;
			}
			
			me.stbySplit = split(".", sprintf("%3.3f", pts.Instrumentation.Comm.Frequencies.standbyMhzFmt[me.selTemp].getValue()));
			me.stbyVal = me.stbySplit[0] + d;
			
			if (d > 0) {
				if (me.stbyVal > 136) me.stbyVal = 118;
			} else if (d < 0) {
				if (me.stbyVal < 118) me.stbyVal = 136;
			}
			
			pts.Instrumentation.Comm.Frequencies.standbyMhz[me.selTemp].setValue(me.stbyVal ~ "." ~ me.stbySplit[1]);
		}
	},
	swap: func(o = -1) {
		if (me.power.getValue() >= 24) {
			if (o > -1) {
				me.selTemp = o;
			} else {
				me.selTemp = me.num;
			}
			
			me.activeSel = pts.Instrumentation.Comm.Frequencies.selectedMhzFmt[me.selTemp].getValue();
			me.stbySel = pts.Instrumentation.Comm.Frequencies.standbyMhzFmt[me.selTemp].getValue();
			
			pts.Instrumentation.Comm.Frequencies.selectedMhz[me.selTemp].setValue(me.stbySel);
			pts.Instrumentation.Comm.Frequencies.standbyMhz[me.selTemp].setValue(me.activeSel);
		}
	},
};

var COMM = {
	setup: func() {
		crp[0] = CRP.new(0);
		crp[1] = CRP.new(1);
	},
	reset: func() {
		for (var i = 0; i < 2; i = i + 1) {
			crp[i].reset();
		}
	},
	toggle833: func() {
		if (!ettr.getBoolValue()) { # If 8.33KHz is off, make sure all frequencies are 25KHz
			for (var i = 0; i < 2; i = i + 1) {
				pts.Instrumentation.Comm.Frequencies.selectedMhz[i].setValue(math.round(pts.Instrumentation.Comm.Frequencies.selectedMhzFmt[i].getValue() * 1000, 25) / 1000);
				pts.Instrumentation.Comm.Frequencies.standbyMhz[i].setValue(math.round(pts.Instrumentation.Comm.Frequencies.standbyMhzFmt[i].getValue() * 1000, 25) / 1000);
			}
		}
	},
};

var NAV = {
	adjustCrs: func(n, d) {
		if (systems.ELECTRICAL.Outputs.fgcp.getValue() >= 24) {
			var val = pts.Instrumentation.Nav.Radials.selectedDeg[n].getValue() + d;
			
			if (d > 0) {
				if (val > 360) val = val - 360;
			} else if (d < 0) {
				if (val < 1) val = val + 360;
			}
			
			pts.Instrumentation.Nav.Radials.selectedDeg[n].setValue(val);
		}
	},
	adjustDec: func(n, d) {
		if (systems.ELECTRICAL.Outputs.fgcp.getValue() >= 24) {
			var input = split(".", sprintf("%3.2f", pts.Instrumentation.Nav.Frequencies.selectedMhzFmt[n].getValue()));
			var val = input[1] + (5 * d);
			
			if (d > 0) {
				if (val > 95) val = 0;
			} else if (d < 0) {
				if (val < 0) val = 95;
			}
			
			val = sprintf("%02d", val);
			pts.Instrumentation.Nav.Frequencies.selectedMhz[n].setValue(input[0] ~ "." ~ val);
		}
	},
	adjustInt: func(n, d) {
		if (systems.ELECTRICAL.Outputs.fgcp.getValue() >= 24) {
			var input = split(".", sprintf("%3.2f", pts.Instrumentation.Nav.Frequencies.selectedMhzFmt[n].getValue()));
			var val = input[0] + d;
			
			if (d > 0) {
				if (val > 117) val = 108;
			} else if (d < 0) {
				if (val < 108) val = 117;
			}
			
			val = sprintf("%02d", val);
			pts.Instrumentation.Nav.Frequencies.selectedMhz[n].setValue(val ~ "." ~ input[1]);
		}
	},
	roundCrs: func(n) {
		var val = math.round(pts.Instrumentation.Nav.Radials.selectedDeg[n].getValue());
		
		if (val > 360) val = val - 360;
		else if (val < 1) val = val + 360;
		
		pts.Instrumentation.Nav.Radials.selectedDeg[n].setValue(val);
	},
	roundFreq: func(n) {
		pts.Instrumentation.Nav.Frequencies.selectedMhz[n].setValue(math.round(pts.Instrumentation.Nav.Frequencies.selectedMhz[n].getValue(), 0.05));
	},
};

var ADF = {
	adjust: func(n, d) {
		if (systems.ELECTRICAL.Outputs.adf[n].getValue() >= 24) {
			var input = pts.Instrumentation.Adf.Frequencies.selectedKhz[n].getValue();
			var val = input + d;
			
			if (val > 1750) val = 1750;
			else if (val < 190) val = 190;
			
			pts.Instrumentation.Adf.Frequencies.selectedKhz[n].setValue(val);
		}
	},
};
