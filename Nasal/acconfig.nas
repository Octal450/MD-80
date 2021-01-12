# Aircraft Config Center V2.0.0
# Copyright (c) 2021 Josh Davidson (Octal450)

var SYSTEM = {
	autoConfigRunning: props.globals.getNode("/systems/acconfig/autoconfig-running"),
	Error: {
		code: props.globals.initNode("/systems/acconfig/error-code", "0x000", "STRING"),
	},
};
