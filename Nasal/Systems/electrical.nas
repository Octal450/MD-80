# McDonnell Douglas MD-80 Electrical System
# Copyright (c) 2020 Josh Davidson (Octal450)

var ELEC = {
	Generic: {
		fgcpPower: props.globals.initNode("/systems/electrical/outputs/fgcp-power", 0, "DOUBLE"),
		fmaPower: props.globals.initNode("/systems/electrical/outputs/fma-power", 0, "DOUBLE"),
	},
};
