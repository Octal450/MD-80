# McDonnell Douglas MD-80 Ignition
# Copyright (c) 2025 Josh Davidson (Octal450)

var IGNITION = {
	cutoff1: props.globals.getNode("/systems/ignition/cutoff-1"),
	cutoff2: props.globals.getNode("/systems/ignition/cutoff-2"),
	starter1: props.globals.getNode("/systems/ignition/starter-1"),
	starter2: props.globals.getNode("/systems/ignition/starter-2"),
	Controls: {
		ign: props.globals.getNode("/controls/ignition/ign"),
	},
	init: func() {
		me.Controls.ign.setBoolValue(0);
	},
	fastStart: func(n) {
		ENGINES.Controls.cutoff[n].setBoolValue(0);
		pts.Fdm.JSBSim.Propulsion.setRunning.setValue(n);
	},
	fastStop: func(n) {
		ENGINES.Controls.cutoff[n].setBoolValue(1);
		settimer(func() { # Required delay
			if (systems.ENGINES.n2[n].getValue() > 1) {
				pts.Fdm.JSBSim.Propulsion.Engine.n1[n].setValue(0.1);
				pts.Fdm.JSBSim.Propulsion.Engine.n2[n].setValue(0.1);
			}
		}, 0.1);
	},
};
