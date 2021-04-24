# McDonnell Douglas MD-80 Property Tree Setup
# Copyright (c) 2021 Josh Davidson (Octal450)
# Nodes organized like property tree, except when lots of identical (example: Gear wow), where vectors are used to make it easier
# Anything that says Temp is set by another file to avoid multiple getValue calls
# Usage Example: pts.Class.SubClass.node.getValue()

var Controls = {
	Engines: {
		Engine: {
			reverseLever: [props.globals.getNode("/controls/engines/engine[0]/reverse-lever"), props.globals.getNode("/controls/engines/engine[1]/reverse-lever")],
			reverseLeverTemp: [0, 0],
			throttle: [props.globals.getNode("/controls/engines/engine[0]/throttle"), props.globals.getNode("/controls/engines/engine[1]/throttle")],
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
	Misc: {
		minimumsLatch: props.globals.getNode("/controls/misc/minimums-latch"),
	},
	Switches: {
		minimums: props.globals.getNode("/controls/switches/minimums"),
		noSmokingSign: props.globals.getNode("/controls/switches/no-smoking-sign"),
		seatbeltSign: props.globals.getNode("/controls/switches/seatbelt-sign"),
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
			Limit: {
				flexTemp: props.globals.getNode("/fdm/jsbsim/engine/limit/flex-temp"),
			},
			throttleLever: [props.globals.getNode("/fdm/jsbsim/engine/throttle-lever[0]"), props.globals.getNode("/fdm/jsbsim/engine/throttle-lever[1]")],
		},
		Position: {
			wow: props.globals.getNode("/fdm/jsbsim/position/wow"),
			wowTemp: 0,
		},
		Propulsion: {
			tatC: props.globals.getNode("/fdm/jsbsim/propulsion/tat-c"),
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
		headingNeedleDeflectionNorm: [props.globals.getNode("/instrumentation/nav[0]/heading-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[1]/heading-needle-deflection-norm")],
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

var Sim = {
	CurrentView: {
		fieldOfView: props.globals.getNode("/sim/current-view/field-of-view", 1),
		headingOffsetDeg: props.globals.getNode("/sim/current-view/heading-offset-deg", 1),
		name: props.globals.getNode("/sim/current-view/name", 1),
		pitchOffsetDeg: props.globals.getNode("/sim/current-view/pitch-offset-deg", 1),
		rollOffsetDeg: props.globals.getNode("/sim/current-view/roll-offset-deg", 1),
		type: props.globals.getNode("/sim/current-view/type", 1),
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
		btn3: props.globals.initNode("/sim/sound/btn3", 0, "BOOL"),
		flapsClick: props.globals.initNode("/sim/sound/flaps-click", 0, "BOOL"),
		knb1: props.globals.initNode("/sim/sound/knb1", 0, "BOOL"),
		noSmokingSign: props.globals.initNode("/sim/sound/no-smoking-sign", 0, "BOOL"),
		noSmokingSignInhibit: props.globals.initNode("/sim/sound/no-smoking-sign-inhibit", 0, "BOOL"),
		ohBtn: props.globals.initNode("/sim/sound/oh-btn", 0, "BOOL"),
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

var Services = {
	Chocks: {
		enable: props.globals.getNode("/services/chocks/enable"),
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
