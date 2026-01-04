# McDonnell Douglas MD-80 IRS and AHRS
# Copyright (c) 2026 Josh Davidson (Octal450)

var IRS = {
	Iru: {
		alignTimer: [props.globals.getNode("/systems/iru[0]/align-timer"), props.globals.getNode("/systems/iru[1]/align-timer")],
		alignTimeRemainingMinutes: [props.globals.getNode("/systems/iru[0]/align-time-remaining-minutes"), props.globals.getNode("/systems/iru[1]/align-time-remaining-minutes")],
		attAvail: [props.globals.getNode("/systems/iru[0]/att-avail"), props.globals.getNode("/systems/iru[1]/att-avail")],
		mainAvail: [props.globals.getNode("/systems/iru[0]/main-avail"), props.globals.getNode("/systems/iru[1]/main-avail")],
	},
	Controls: {
		knob: [props.globals.getNode("/controls/iru[0]/knob"), props.globals.getNode("/controls/iru[1]/knob")],
	},
	init: func() {
		me.Controls.knob[0].setValue(0);
		me.Controls.knob[1].setValue(0);
	},
};

# Platform Select
var PLATFORM = {
	Unit: {
		aligned: [props.globals.getNode("/systems/platform[0]/aligned"), props.globals.getNode("/systems/platform[1]/aligned")],
		attAvail: [props.globals.getNode("/systems/platform[0]/att-avail"), props.globals.getNode("/systems/platform[1]/att-avail")],
	},
};
