# McDonnell Douglas MD-80 Property Tree Setup
# Copyright (c) 2022 Josh Davidson (Octal450)
# Nodes organized like property tree, except when lots of identical (example: Gear wow), where vectors are used to make it easier
# Anything that says Temp is set by another file to avoid multiple getValue calls
# Usage Example: pts.Class.SubClass.node.getValue()

var Controls = {
	Dfgs: {
		Switches: {
			art: props.globals.getNode("/controls/dfgs/switches/art"),
		},
	},
	Flight: {
		aileronDrivesTiller: props.globals.getNode("/controls/flight/aileron-drives-tiller"),
		autoCoordination: props.globals.getNode("/controls/flight/auto-coordination", 1),
		dialAFlap: props.globals.getNode("/controls/flight/dial-a-flap"),
		elevatorTrim: props.globals.getNode("/controls/flight/elevator-trim"),
		flaps: props.globals.getNode("/controls/flight/flaps"),
		flapsTemp: 0,
		flapsInput: props.globals.getNode("/controls/flight/flaps-input"),
		speedbrake: props.globals.getNode("/controls/flight/speedbrake"),
		speedbrakeArm: props.globals.getNode("/controls/flight/speedbrake-arm"),
		speedbrakeTemp: 0,
	},
	Gear: {
		brakeParking: props.globals.getNode("/controls/gear/brake-parking"),
		brakeLeft: props.globals.getNode("/controls/gear/brake-left"),
		brakeRight: props.globals.getNode("/controls/gear/brake-right"),
		lever: props.globals.getNode("/controls/gear/lever"),
		leverCockpit: props.globals.getNode("/controls/gear/lever-cockpit"),
	},
	Lighting: {
		beacon: props.globals.getNode("/controls/lighting/beacon"),
		captDigitalKnb: props.globals.getNode("/controls/lighting/capt-digital-knb"),
		fgcpDigitalKnb: props.globals.getNode("/controls/lighting/fgcp-digital-knb"),
		foDigitalKnb: props.globals.getNode("/controls/lighting/fo-digital-knb"),
		landingLightL: props.globals.getNode("/controls/lighting/landing-light-l"),
		landingLightN: props.globals.getNode("/controls/lighting/landing-light-n"),
		landingLightR: props.globals.getNode("/controls/lighting/landing-light-r"),
		logoLights: props.globals.getNode("/controls/lighting/logo-lights"),
		pedestalDigitalKnb: props.globals.getNode("/controls/lighting/pedestal-digital-knb"),
		positionStrobeLight: props.globals.getNode("/controls/lighting/position-strobe-light"),
		taxiLight: props.globals.getNode("/controls/lighting/taxi-light"),
		wingLights: props.globals.getNode("/controls/lighting/wing-lights"),
	},
	Misc: {
		minimumsLatch: props.globals.getNode("/controls/misc/minimums-latch"),
	},
	Switches: {
		annunTest: props.globals.getNode("/controls/switches/annun-test"),
		minimums: props.globals.getNode("/controls/switches/minimums"),
		noSmokingSign: props.globals.getNode("/controls/switches/no-smoking-sign"),
		seatbeltSign: props.globals.getNode("/controls/switches/seatbelt-sign"),
	},
};

var Engines = {
	Engine: {
		egtActual: [props.globals.getNode("/engines/engine[0]/egt-actual"), props.globals.getNode("/engines/engine[1]/egt-actual")],
		eprActual: [props.globals.getNode("/engines/engine[0]/epr-actual"), props.globals.getNode("/engines/engine[1]/epr-actual")],
		ffActual: [props.globals.getNode("/engines/engine[0]/ff-actual"), props.globals.getNode("/engines/engine[1]/ff-actual")],
		n1Actual: [props.globals.getNode("/engines/engine[0]/n1-actual"), props.globals.getNode("/engines/engine[1]/n1-actual")],
		n2Actual: [props.globals.getNode("/engines/engine[0]/n2-actual"), props.globals.getNode("/engines/engine[1]/n2-actual")],
		oilPsi: [props.globals.getNode("/engines/engine[0]/oil-psi"), props.globals.getNode("/engines/engine[1]/oil-psi")],
		oilQty: [props.globals.getNode("/engines/engine[0]/oil-qty"), props.globals.getNode("/engines/engine[1]/oil-qty")],
		oilQtyInput: [props.globals.getNode("/engines/engine[0]/oil-qty-input"), props.globals.getNode("/engines/engine[1]/oil-qty-input")],
		state: [props.globals.getNode("/engines/engine[0]/state"), props.globals.getNode("/engines/engine[1]/state")],
	},
};


var Fdm = {
	JSBsim: {
		Dfgs: {
			Speeds: {
				vmin: props.globals.getNode("/fdm/jsbsim/dfgs/speeds/vmin"),
				vminMach: props.globals.getNode("/fdm/jsbsim/dfgs/speeds/vmin-mach"),
			},
			StickPusher: {
				active: props.globals.getNode("/fdm/jsbsim/dfgs/stick-pusher/active"),
			},
		},
		Engine: {
			atsCmdRawPid: props.globals.initNode("/fdm/jsbsim/engine/ats-cmd-raw-pid", 0, "DOUBLE"),
			throttleLever: [props.globals.getNode("/fdm/jsbsim/engine/throttle-lever[0]"), props.globals.getNode("/fdm/jsbsim/engine/throttle-lever[1]")],
		},
		Position: {
			wow: props.globals.getNode("/fdm/jsbsim/position/wow"),
			wowTemp: 0,
		},
		Propulsion: {
			setRunning: props.globals.getNode("/fdm/jsbsim/propulsion/set-running"),
			Tank: {
				contentLbs: [props.globals.getNode("/fdm/jsbsim/propulsion/tank[0]/contents-lbs"), props.globals.getNode("/fdm/jsbsim/propulsion/tank[1]/contents-lbs"), props.globals.getNode("/fdm/jsbsim/propulsion/tank[2]/contents-lbs")], 
			},
			tatC: props.globals.getNode("/fdm/jsbsim/propulsion/tat-c"),
		},
		Spoilers: {
			mainGearAnd: props.globals.getNode("/fdm/jsbsim/spoilers/main-gear-and"),
		},
	},
};

var Gear = {
	rollspeedMs: [props.globals.getNode("/gear/gear[0]/rollspeed-ms"), props.globals.getNode("/gear/gear[1]/rollspeed-ms"), props.globals.getNode("/gear/gear[2]/rollspeed-ms")],
	wow: [props.globals.getNode("/gear/gear[0]/wow"), props.globals.getNode("/gear/gear[1]/wow"), props.globals.getNode("/gear/gear[2]/wow")],
};

var Instrumentation = {
	AirspeedIndicator: {
		indicatedMach: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-mach"),
		indicatedSpeedKt: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-speed-kt"),
	},
	Altimeter: {
		oldQnh: props.globals.getNode("/instrumentation/altimeter/oldqnh"),
		settingInhg: props.globals.getNode("/instrumentation/altimeter/setting-inhg"),
		std: props.globals.getNode("/instrumentation/altimeter/std"),
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
	Pfd: {
		fastSlow: props.globals.initNode("/instrumentation/pfd/fast-slow", 0, "DOUBLE"),
	},
};

var Options = {
	panel: props.globals.getNode("/options/panel"),
};

var Orientation = {
	pitchDeg: props.globals.getNode("/orientation/pitch-deg"),
	rollDeg: props.globals.getNode("/orientation/roll-deg"),
};

var Position = {
	gearAglFt: props.globals.getNode("/position/gear-agl-ft"),
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
		zOffsetDefault: props.globals.getNode("/sim/current-view/z-offset-default", 1),
		xOffsetM: props.globals.getNode("/sim/current-view/x-offset-m", 1),
		yOffsetM: props.globals.getNode("/sim/current-view/y-offset-m", 1),
		zOffsetM: props.globals.getNode("/sim/current-view/z-offset-m", 1),
		zOffsetMaxM: props.globals.getNode("/sim/current-view/z-offset-max-m", 1),
		zOffsetMinM: props.globals.getNode("/sim/current-view/z-offset-min-m", 1),
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
		switch1: props.globals.initNode("/sim/sound/switch1", 0, "BOOL"),
	},
	Time: {
		deltaRealtimeSec: props.globals.getNode("/sim/time/delta-realtime-sec"),
		elapsedSec: props.globals.getNode("/sim/time/elapsed-sec"),
	},
	View: {
		Config: {
			defaultFieldOfViewDeg: props.globals.getNode("/sim/view/config/default-field-of-view-deg", 1),
		},
	},
};

var Systems = {
	Acconfig: {
		autoConfigRunning: props.globals.getNode("/systems/acconfig/autoconfig-running"),
		Options: {
			flightDirector: props.globals.getNode("/systems/acconfig/options/flight-director"),
			Du: {
				ndFps: props.globals.getNode("/systems/acconfig/options/du/nd-fps"),
				pfdFps: props.globals.getNode("/systems/acconfig/options/du/pfd-fps"),
			},
		},
	},
	Shake: {
		effect: props.globals.getNode("/systems/shake/effect"),
		shaking: props.globals.initNode("/systems/shake/shaking", 0, "DOUBLE"),
	},
};

var Velocities = {
	groundspeedKt: props.globals.getNode("/velocities/groundspeed-kt"),
	groundspeedKtTemp: 0,
};

setprop("/systems/acconfig/property-tree-setup-loaded", 1);
