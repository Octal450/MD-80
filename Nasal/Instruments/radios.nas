# McDonnell Douglas MD-80 Radios
# Copyright (c) 2023 Josh Davidson (Octal450)

var COMM = {
	adjustDecimal: func(n, d) {
		var input = split(".", sprintf("%3.2f", pts.Instrumentation.Comm.Frequencies.selectedMhzFmt[n].getValue()));
		var val = input[1] + (5 * d);
		
		if (d > 0) {
			if (val > 95) val = 0;
		} else if (d < 0) {
			if (val < 0) val = 95;
		}
		
		val = sprintf("%02d", val);
		pts.Instrumentation.Comm.Frequencies.standbyMhz[n].setValue(input[0] ~ "." ~ val);
	},
};

var NAV = {
	adjustDecimal: func(n, d) {
		var input = split(".", sprintf("%3.2f", pts.Instrumentation.Nav.Frequencies.selectedMhzFmt[n].getValue()));
		var val = input[1] + (5 * d);
		
		if (d > 0) {
			if (val > 95) val = 0;
		} else if (d < 0) {
			if (val < 0) val = 95;
		}
		
		val = sprintf("%02d", val);
		pts.Instrumentation.Nav.Frequencies.selectedMhz[n].setValue(input[0] ~ "." ~ val);
	},
};
