# McDonnell Douglas MD-80 Pressurization
# Copyright (c) 2026 Josh Davidson (Octal450)

var PRESSURIZATION = {
	Cabin: {
		altFt: props.globals.getNode("/systems/pressurization/cabin-alt-ft"),
		diffPsi: props.globals.getNode("/systems/pressurization/cabin-diff-psi"),
		psi: props.globals.getNode("/systems/pressurization/cabin-psi"),
		rateFpm: props.globals.getNode("/systems/pressurization/cabin-rate-fpm"),
	},
	OutflowValve: {
		pos: props.globals.getNode("/systems/pressurization/outflow-valve/pos"),
	},
	Controls: {
		auto: props.globals.getNode("/controls/pressurization/auto"),
		autoSel: props.globals.getNode("/controls/pressurization/auto-sel"),
		landingAlt: props.globals.getNode("/controls/pressurization/landing-alt"),
		landingBaro: props.globals.getNode("/controls/pressurization/landing-baro"),
		rateLimit: props.globals.getNode("/controls/pressurization/rate-limit"),
	},
	Failures: {
		auto1: props.globals.getNode("/systems/failures/pressurization/auto-1"),
		auto2: props.globals.getNode("/systems/failures/pressurization/auto-2"),
		depressurization: props.globals.getNode("/systems/failures/pressurization/depressurization"),
	},
	init: func() {
		me.resetFailures();
		me.Controls.auto.setBoolValue(1);
		me.Controls.autoSel.setBoolValue(0);
		me.Controls.landingAlt.setValue(1000);
		if (!pts.Systems.Acconfig.Options.syncLandingBaro.getBoolValue()) me.Controls.landingBaro.setValue(29.92);
		me.Controls.rateLimit.setValue(0);
	},
	resetFailures: func() {
		me.Failures.auto1.setBoolValue(0);
		me.Failures.auto2.setBoolValue(0);
		me.Failures.depressurization.setBoolValue(0);
	},
};
