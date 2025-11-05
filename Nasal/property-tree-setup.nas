# McDonnell Douglas MD-80 Property Tree Setup
# Copyright (c) 2025 Josh Davidson (Octal450)
# Nodes organized like property tree, except when lots of identical (example: Gear wow), where vectors are used to make it easier
# Anything that says Temp is set by another file to avoid multiple getValue calls
# Usage Example: pts.Class.SubClass.node.getValue()

var Controls = {
	Flight: {
		aileronDrivesTiller: props.globals.getNode("/controls/flight/aileron-drives-tiller"),
		aileronTrim: props.globals.getNode("/controls/flight/aileron-trim"),
		autoCoordination: props.globals.getNode("/controls/flight/auto-coordination", 1),
		dialAFlap: props.globals.getNode("/controls/flight/dial-a-flap"),
		elevatorTrim: props.globals.getNode("/controls/flight/elevator-trim"),
		flaps: props.globals.getNode("/controls/flight/flaps"),
		flapsTemp: 0,
		rudderTrim: props.globals.getNode("/controls/flight/rudder-trim"),
		speedbrake: props.globals.getNode("/controls/flight/speedbrake"),
		speedbrakeArm: props.globals.getNode("/controls/flight/speedbrake-arm"),
		speedbrakeTemp: 0,
	},
	Lighting: {
		beacon: props.globals.getNode("/controls/lighting/beacon"),
		captDigital: props.globals.getNode("/controls/lighting/capt-digital"),
		emerLt: props.globals.getNode("/controls/lighting/emer-lt"),
		fgcpDigital: props.globals.getNode("/controls/lighting/fgcp-digital"),
		foDigital: props.globals.getNode("/controls/lighting/fo-digital"),
		landingLightL: props.globals.getNode("/controls/lighting/landing-light-l"),
		landingLightN: props.globals.getNode("/controls/lighting/landing-light-n"),
		landingLightR: props.globals.getNode("/controls/lighting/landing-light-r"),
		logoLights: props.globals.getNode("/controls/lighting/logo-lights"),
		pedestalDigitalKnb: props.globals.getNode("/controls/lighting/pedestal-digital"),
		positionStrobeLight: props.globals.getNode("/controls/lighting/position-strobe-lights"),
		taxiLight: props.globals.getNode("/controls/lighting/taxi-light"),
		thunderstorm: props.globals.getNode("/controls/lighting/thunderstorm"),
		wingLights: props.globals.getNode("/controls/lighting/wing-lights"),
	},
	Switches: {
		annunTest: props.globals.getNode("/controls/switches/annun-test"),
		annunTest5Sec: props.globals.getNode("/controls/switches/annun-test-5sec"),
		gpws: props.globals.getNode("/controls/switches/gpws"),
		gpwsCover: props.globals.getNode("/controls/switches/gpws-cover"),
		maxSpdWarnTest: props.globals.getNode("/controls/switches/max-spd-warn-test"),
		minimums: props.globals.getNode("/controls/switches/minimums"),
		noSmokingSign: props.globals.getNode("/controls/switches/no-smoking-sign"),
		seatbeltSign: props.globals.getNode("/controls/switches/seatbelt-sign"),
		stallTest: props.globals.getNode("/controls/switches/stall-test"),
		wipers: props.globals.getNode("/controls/switches/wipers"),
	},
};

var Fdm = {
	JSBSim: {
		Aero: {
			alphaDegDamped: props.globals.getNode("/fdm/jsbsim/aero/alpha-deg-damped"),
			alphaDegDampedPli: props.globals.getNode("/fdm/jsbsim/aero/alpha-deg-damped-pli"),
		},
		Inertia: {
			cgPercentMac: props.globals.getNode("/fdm/jsbsim/inertia/cg-percent-mac"),
			weightLbs: props.globals.getNode("/fdm/jsbsim/inertia/weight-lbs"),
			zfwLbs: props.globals.getNode("/fdm/jsbsim/inertia/zfw-lbs"),
		},
		Propulsion: {
			Engine: {
				n1: [props.globals.getNode("/fdm/jsbsim/propulsion/engine[0]/n1"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[1]/n1"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[2]/n1")],
				n2: [props.globals.getNode("/fdm/jsbsim/propulsion/engine[0]/n2"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[1]/n2"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[2]/n2")],
			},
			setRunning: props.globals.getNode("/fdm/jsbsim/propulsion/set-running"),
			Tank: {
				contentLbs: [props.globals.getNode("/fdm/jsbsim/propulsion/tank[0]/contents-lbs"), props.globals.getNode("/fdm/jsbsim/propulsion/tank[1]/contents-lbs"), props.globals.getNode("/fdm/jsbsim/propulsion/tank[2]/contents-lbs")], 
			},
			tatC: props.globals.getNode("/fdm/jsbsim/propulsion/tat-c"),
		},
	},
};

var Gear = {
	rollspeedMs: [props.globals.getNode("/gear/gear[0]/rollspeed-ms"), props.globals.getNode("/gear/gear[1]/rollspeed-ms"), props.globals.getNode("/gear/gear[2]/rollspeed-ms")],
	wow: [props.globals.getNode("/gear/gear[0]/wow"), props.globals.getNode("/gear/gear[1]/wow"), props.globals.getNode("/gear/gear[2]/wow")],
};

var Instrumentation = {
	Adf: {
		Frequencies: {
			selectedKhz: [props.globals.getNode("/instrumentation/adf[0]/frequencies/selected-khz"), props.globals.getNode("/instrumentation/adf[1]/frequencies/selected-khz")],
		},
	},
	AirspeedIndicator: {
		indicatedMach: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-mach"),
		indicatedSpeedKt: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-speed-kt"),
		pointer1Input: props.globals.getNode("/instrumentation/airspeed-indicator/pointer-1-input"),
		pointer2Input: props.globals.getNode("/instrumentation/airspeed-indicator/pointer-2-input"),
		pointer3Input: props.globals.getNode("/instrumentation/airspeed-indicator/pointer-3-input"),
	},
	Comm: {
		Frequencies: {
			selectedMhz: [props.globals.getNode("/instrumentation/comm[0]/frequencies/selected-mhz"), props.globals.getNode("/instrumentation/comm[1]/frequencies/selected-mhz"), props.globals.getNode("/instrumentation/comm[2]/frequencies/selected-mhz")],
			selectedMhzFmt: [props.globals.getNode("/instrumentation/comm[0]/frequencies/selected-mhz-fmt"), props.globals.getNode("/instrumentation/comm[1]/frequencies/selected-mhz-fmt"), props.globals.getNode("/instrumentation/comm[2]/frequencies/selected-mhz-fmt")],
			standbyMhz: [props.globals.getNode("/instrumentation/comm[0]/frequencies/standby-mhz"), props.globals.getNode("/instrumentation/comm[1]/frequencies/standby-mhz"), props.globals.getNode("/instrumentation/comm[2]/frequencies/standby-mhz")],
			standbyMhzFmt: [props.globals.getNode("/instrumentation/comm[0]/frequencies/standby-mhz-fmt"), props.globals.getNode("/instrumentation/comm[1]/frequencies/standby-mhz-fmt"), props.globals.getNode("/instrumentation/comm[2]/frequencies/standby-mhz-fmt")],
		},
	},
	Du: {
		ndDimmer: [props.globals.getNode("/instrumentation/du/nd1-dimmer"), props.globals.getNode("/instrumentation/du/nd2-dimmer")],
		pfdDimmer: [props.globals.getNode("/instrumentation/du/pfd1-dimmer"), props.globals.getNode("/instrumentation/du/pfd2-dimmer")],
	},
	Efis: {
		hdgTrkSelected: [props.globals.initNode("/instrumentation/efis[0]/hdg-trk-selected", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/hdg-trk-selected", 0, "BOOL")],
		Inputs: {
			arpt: [props.globals.initNode("/instrumentation/efis[0]/inputs/arpt", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/arpt", 0, "BOOL")],
			data: [props.globals.initNode("/instrumentation/efis[0]/inputs/data", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/data", 0, "BOOL")],
			lhVorAdf: [props.globals.initNode("/instrumentation/efis[0]/inputs/lh-vor-adf", 0, "INT"), props.globals.initNode("/instrumentation/efis[1]/inputs/lh-vor-adf", 0, "INT")],
			ndCentered: [props.globals.initNode("/instrumentation/efis[0]/inputs/nd-centered", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/nd-centered", 0, "BOOL")],
			rangeNm: [props.globals.initNode("/instrumentation/efis[0]/inputs/range-nm", 10, "INT"), props.globals.initNode("/instrumentation/efis[1]/inputs/range-nm", 10, "INT")],
			rhVorAdf: [props.globals.initNode("/instrumentation/efis[0]/inputs/rh-vor-adf", 0, "INT"), props.globals.initNode("/instrumentation/efis[1]/inputs/rh-vor-adf", 0, "INT")],
			sta: [props.globals.initNode("/instrumentation/efis[0]/inputs/sta", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/sta", 0, "BOOL")],
			tfc: [props.globals.initNode("/instrumentation/efis[0]/inputs/tfc", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/tfc", 0, "BOOL")],
			wpt: [props.globals.initNode("/instrumentation/efis[0]/inputs/wpt", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/wpt", 0, "BOOL")],
		},
		Mfd: {
			displayMode: [props.globals.initNode("/instrumentation/efis[0]/mfd/display-mode", "MAP", "STRING"), props.globals.initNode("/instrumentation/efis[1]/mfd/display-mode", "MAP", "STRING")],
			trueNorth: [props.globals.initNode("/instrumentation/efis[0]/mfd/true-north", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/mfd/true-north", 0, "BOOL")],
		},
		mode: [props.globals.initNode("/instrumentation/efis[0]/mode", 2, "INT"), props.globals.initNode("/instrumentation/efis[1]/mode", 2, "INT")],
	},
	Epr: {
		powerAvail: [props.globals.getNode("/instrumentation/epr[0]/power-avail"), props.globals.getNode("/instrumentation/epr[1]/power-avail")],
	},
	Ff: {
		fuResetTrim: [props.globals.getNode("/instrumentation/ff[0]/fu-reset-trim"), props.globals.getNode("/instrumentation/ff[1]/fu-reset-trim")],
	},
	Hsi: {
		slavedToGps: [props.globals.getNode("/instrumentation/hsi[0]/slaved-to-gps"), props.globals.getNode("/instrumentation/hsi[1]/slaved-to-gps")],
	},
	MarkerBeacon: {
		inner: props.globals.getNode("/instrumentation/marker-beacon/inner"),
		middle: props.globals.getNode("/instrumentation/marker-beacon/middle"),
		outer: props.globals.getNode("/instrumentation/marker-beacon/outer"),
	},
	Nav: {
		Frequencies: {
			selectedMhz: [props.globals.getNode("/instrumentation/nav[0]/frequencies/selected-mhz"), props.globals.getNode("/instrumentation/nav[1]/frequencies/selected-mhz")],
			selectedMhzFmt: [props.globals.getNode("/instrumentation/nav[0]/frequencies/selected-mhz-fmt"), props.globals.getNode("/instrumentation/nav[1]/frequencies/selected-mhz-fmt")],
			selectedMhzFmtX100: [props.globals.getNode("/instrumentation/nav[0]/frequencies/selected-mhz-fmt-x100"), props.globals.getNode("/instrumentation/nav[1]/frequencies/selected-mhz-fmt-x100")],
		},
		headingNeedleDeflectionNorm: [props.globals.getNode("/instrumentation/nav[0]/heading-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[1]/heading-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[2]/heading-needle-deflection-norm")],
		gsInRange: [props.globals.getNode("/instrumentation/nav[0]/gs-in-range"), props.globals.getNode("/instrumentation/nav[1]/gs-in-range")],
		gsNeedleDeflectionNorm: [props.globals.getNode("/instrumentation/nav[0]/gs-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[1]/gs-needle-deflection-norm")],
		hasGs: [props.globals.getNode("/instrumentation/nav[0]/has-gs"), props.globals.getNode("/instrumentation/nav[1]/has-gs")],
		inRange: [props.globals.getNode("/instrumentation/nav[0]/in-range"), props.globals.getNode("/instrumentation/nav[1]/in-range")],
		navLoc: [props.globals.getNode("/instrumentation/nav[0]/nav-loc"), props.globals.getNode("/instrumentation/nav[1]/nav-loc")],
		signalQualityNorm: [props.globals.getNode("/instrumentation/nav[0]/signal-quality-norm"), props.globals.getNode("/instrumentation/nav[1]/signal-quality-norm")],
	},
};

var Orientation = {
	pitchDeg: props.globals.getNode("/orientation/pitch-deg"),
	rollDeg: props.globals.getNode("/orientation/roll-deg"),
};

var Position = {
	gearAglFt: props.globals.getNode("/position/gear-agl-ft"),
	node: props.globals.getNode("/position"),
	wow: props.globals.getNode("/position/wow"),
	wowTemp: 0,
};

var Services = {
	Chocks: {
		enable: props.globals.getNode("/services/chocks/enable"),
		enableTemp: 1,
	},
};

var Sim = {
	CurrentView: {
		fieldOfView: props.globals.getNode("/sim/current-view/field-of-view", 1),
		headingOffsetDeg: props.globals.getNode("/sim/current-view/heading-offset-deg", 1),
		name: props.globals.getNode("/sim/current-view/name", 1),
		pitchOffsetDeg: props.globals.getNode("/sim/current-view/pitch-offset-deg", 1),
		rollOffsetDeg: props.globals.getNode("/sim/current-view/roll-offset-deg", 1),
		viewNumber: props.globals.getNode("/sim/current-view/view-number", 1),
		viewNumberRaw: props.globals.getNode("/sim/current-view/view-number-raw", 1),
		xOffsetM: props.globals.getNode("/sim/current-view/x-offset-m", 1),
		yOffsetM: props.globals.getNode("/sim/current-view/y-offset-m", 1),
		zOffsetDefault: props.globals.getNode("/sim/current-view/z-offset-default", 1),
		zOffsetM: props.globals.getNode("/sim/current-view/z-offset-m", 1),
		zOffsetMaxM: props.globals.getNode("/sim/current-view/z-offset-max-m", 1),
		zOffsetMinM: props.globals.getNode("/sim/current-view/z-offset-min-m", 1),
	},
	Gui: {
		Dialogs: {
			AcconfigMain: {
				afms: props.globals.initNode("/sim/gui/dialogs/acconfig-main/afms", 0, "BOOL"),
				ht9100: props.globals.initNode("/sim/gui/dialogs/acconfig-main/ht9100", 0, "BOOL"),
			},
		},
	},
	Rendering: {
		Headshake: {
			enabled: props.globals.getNode("/sim/rendering/headshake/enabled"),
		},
	},
	Replay: {
		replayState: props.globals.getNode("/sim/replay/replay-state"),
		wasActive: props.globals.initNode("/sim/replay/was-active", 0, "BOOL"),
	},
	Sound: {
		btn1: props.globals.initNode("/sim/sound/btn1", 0, "BOOL"),
		btn2: props.globals.initNode("/sim/sound/btn2", 0, "BOOL"),
		btn3: props.globals.initNode("/sim/sound/btn3", 0, "BOOL"),
		flapsClick: props.globals.initNode("/sim/sound/flaps-click", 0, "BOOL"),
		knb1: props.globals.initNode("/sim/sound/knb1", 0, "BOOL"),
		noSmokingSign: props.globals.initNode("/sim/sound/no-smoking-sign", 0, "BOOL"),
		noSmokingSignInhibit: props.globals.initNode("/sim/sound/no-smoking-sign-inhibit", 0, "BOOL"),
		seatbeltSign: props.globals.initNode("/sim/sound/seatbelt-sign", 0, "BOOL"),
		speedbrakeArmClick: props.globals.initNode("/sim/sound/speedbrake-arm-click", 0, "BOOL"),
		switch1: props.globals.initNode("/sim/sound/switch1", 0, "BOOL"),
	},
	Time: {
		deltaRealtimeSec: props.globals.getNode("/sim/time/delta-realtime-sec"),
		elapsedSec: props.globals.getNode("/sim/time/elapsed-sec"),
		Utc: {
			hour: props.globals.getNode("/sim/time/utc/hour"),
			minute: props.globals.getNode("/sim/time/utc/minute"),
			second: props.globals.getNode("/sim/time/utc/second"),
		},
	},
	View: {
		Config: {
			defaultFieldOfViewDeg: props.globals.getNode("/sim/view/config/default-field-of-view-deg", 1),
		},
	},
};

var Systems = {
	Acconfig: {
		Options: {
			afms: props.globals.getNode("/systems/acconfig/options/afms"),
			armedAltAsFl: props.globals.getNode("/systems/acconfig/options/armed-alt-as-fl"),
			autoArmAlt: props.globals.getNode("/systems/acconfig/options/auto-arm-alt"),
			Du: {
				mcduFps: props.globals.getNode("/systems/acconfig/options/du/mcdu-fps"),
				ndFps: props.globals.getNode("/systems/acconfig/options/du/nd-fps"),
				pfdFps: props.globals.getNode("/systems/acconfig/options/du/pfd-fps"),
			},
			dualCueFd: props.globals.getNode("/systems/acconfig/options/dual-cue-fd"),
			edpSdp: props.globals.getNode("/systems/acconfig/options/edp-sdp"),
			efis: props.globals.getNode("/systems/acconfig/options/efis"),
			firetank: props.globals.getNode("/systems/acconfig/options/firetank"),
			firetankWater: props.globals.getNode("/systems/acconfig/options/firetank-water"),
			nav: props.globals.getNode("/systems/acconfig/options/nav"),
			risingRunway: props.globals.getNode("/systems/acconfig/options/rising-runway"),
		},
	},
	Misc: {
		minimumsLatch: props.globals.getNode("/systems/misc/minimums-latch"),
	},
	Performance: {
		flapRetract: props.globals.getNode("/systems/performance/flap-retract"),
		landFlaps: props.globals.getNode("/systems/performance/land-flaps"),
		landNoSlats: props.globals.getNode("/systems/performance/land-no-slats"),
		minManeuver: props.globals.getNode("/systems/performance/min-maneuver"),
		slatRetract: props.globals.getNode("/systems/performance/slat-retract"),
		stabilizerDeg: props.globals.getNode("/systems/performance/stabilizer-deg"),
		toCg: props.globals.getNode("/systems/performance/to-cg"),
		toFlaps: props.globals.getNode("/systems/performance/to-flaps"),
		v1: props.globals.getNode("/systems/performance/v1"),
		vapp: props.globals.getNode("/systems/performance/vapp"),
	},
	Shake: {
		shaking: props.globals.getNode("/systems/shake/shaking"),
	},
};

var Velocities = {
	groundspeedKt: props.globals.getNode("/velocities/groundspeed-kt"),
	groundspeedKtTemp: 0,
};
