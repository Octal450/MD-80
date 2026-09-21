# McDonnell Douglas MD-80 Load Manager
# Copyright (c) 2026 Josh Davidson (Octal450)

var LoadManager = {
	defaultFuel: 0,
	defaultWeight: [0, 0, 0, 0, 0],
	Fuel: {
		tank: [props.globals.getNode("/systems/load-manager/fuel/tank[0]"), props.globals.getNode("/systems/load-manager/fuel/tank[1]"), props.globals.getNode("/systems/load-manager/fuel/tank[2]"), props.globals.getNode("/systems/load-manager/fuel/tank[3]"), props.globals.getNode("/systems/load-manager/fuel/tank[4]")],
	},
	modelInt: pts.Options.modelInt.getValue(),
	pax: [props.globals.getNode("/systems/load-manager/pax[0]"), props.globals.getNode("/systems/load-manager/pax[1]")],
	tankCapacity: [props.globals.getNode("/systems/load-manager/tank-capacity[0]"), props.globals.getNode("/systems/load-manager/tank-capacity[1]"), props.globals.getNode("/systems/load-manager/tank-capacity[2]"), props.globals.getNode("/systems/load-manager/tank-capacity[3]"), props.globals.getNode("/systems/load-manager/tank-capacity[4]")],
	totalFuel80: props.globals.getNode("/systems/load-manager/total-fuel-80"),
	totalFuel83: props.globals.getNode("/systems/load-manager/total-fuel-83"),
	weight80: [props.globals.getNode("/systems/load-manager/weight-80[0]"), props.globals.getNode("/systems/load-manager/weight-80[1]"), props.globals.getNode("/systems/load-manager/weight-80[2]"), props.globals.getNode("/systems/load-manager/weight-80[3]"), props.globals.getNode("/systems/load-manager/weight[4]")], # 4 is placeholder
	weight87: [props.globals.getNode("/systems/load-manager/weight-87[0]"), props.globals.getNode("/systems/load-manager/weight-87[1]"), props.globals.getNode("/systems/load-manager/weight-87[2]"), props.globals.getNode("/systems/load-manager/weight-87[3]"), props.globals.getNode("/systems/load-manager/weight[4]")], # 4 is retardant tank
	init: func() {
		me.getCapacities();
		me.getDefault();
		me.getLoad();
	},
	getCapacities: func() {
		for (var i = 0; i < 5; i = i + 1) {
			me.tankCapacity[i].setValue(math.round(pts.Consumables.Fuel.Tank.capacityGalUs[i].getValue() * pts.Consumables.Fuel.Tank.densityPpg[i].getValue()));
		}
	},
	getDefault: func() {
		me.defaultFuel = math.round(pts.Consumables.Fuel.totalFuelActual.getValue(), 100);
		
		for (var i = 0; i < 5; i = i + 1) {
			me.defaultWeight[i] = math.round(pts.Payload.Weight.weightLb[i].getValue(), 100);
		}
	},
	getLoad: func() {
		if (me.modelInt == 3) {
			me.totalFuel83.setValue(math.round(pts.Consumables.Fuel.totalFuelActual.getValue(), 100));
		} else {
			me.totalFuel80.setValue(math.round(pts.Consumables.Fuel.totalFuelActual.getValue(), 100));
		}
		
		for (var i = 0; i < 5; i = i + 1) {
			if (me.modelInt == 7) {
				me.weight87[i].setValue(math.round(pts.Payload.Weight.weightLb[i].getValue(), 100));
			} else {
				me.weight80[i].setValue(math.round(pts.Payload.Weight.weightLb[i].getValue(), 100));
			}
		}
	},
	openDialog: func() {
		fgcommand("dialog-show", props.Node.new({"dialog-name": "load-manager"}));
	},
	setDefault: func() {
		if (me.modelInt == 3) {
			me.totalFuel83.setValue(me.defaultFuel);
		} else {
			me.totalFuel80.setValue(me.defaultFuel);
		}
		
		for (var i = 0; i < 5; i = i + 1) {
			if (me.modelInt == 7) {
				me.weight87[i].setValue(me.defaultWeight[i]);
			} else {
				me.weight80[i].setValue(me.defaultWeight[i]);
			}
		}
	},
	setLoad: func(t = 0) { # 0 = All, 1 = Fuel, 2 = Payload
		settimer(func() {
			if (t != 2) {
				for (var i = 0; i < 5; i = i + 1) {
					pts.Consumables.Fuel.Tank.levelLbs[i].setValue(me.Fuel.tank[i].getValue());
				}
			}
			
			if (t != 1) {
				for (var i = 0; i < 5; i = i + 1) {
					if (me.modelInt == 7) {
						pts.Payload.Weight.weightLb[i].setValue(math.round(me.weight87[i].getValue(), 100));
					} else {
						pts.Payload.Weight.weightLb[i].setValue(math.round(me.weight80[i].getValue(), 100));
					}
				}
			}
			
			gui.popupTip("Load Manager: Fuel and payload have been applied to the aircraft!");
		}, 0.1); # Make sure the JSBSim side has refreshed
	},
	updatePax: func(n) {
		if (me.modelInt == 7) {
			me.pax[n].setValue(math.round(me.weight87[n].getValue() / 200));
		} else {
			me.pax[n].setValue(math.round(me.weight80[n].getValue() / 200));
		}
	},
};

gui.menuBind("fuel-and-payload", "core.LoadManager.openDialog()");

setlistener("/systems/load-manager/weight-80[0]", func() {
	LoadManager.updatePax(0);
}, 0, 0);
setlistener("/systems/load-manager/weight-80[1]", func() {
	LoadManager.updatePax(1);
}, 0, 0);
setlistener("/systems/load-manager/weight-87[0]", func() {
	LoadManager.updatePax(0);
}, 0, 0);
setlistener("/systems/load-manager/weight-87[1]", func() {
	LoadManager.updatePax(1);
}, 0, 0);

# SimBrief Import Add-On Support
globals.simbriefFuelCallback = func(blockFuel) {
	if (LoadManager.modelInt == 3) {
		LoadManager.totalFuel83.setValue(math.round(blockFuel * KG2LB, 100));
	} else {
		LoadManager.totalFuel80.setValue(math.round(blockFuel * KG2LB, 100));
	}
	LoadManager.setLoad(1);
};

var payloadCapacityLb = [pts.Payload.Weight.maxLb[0].getValue(), pts.Payload.Weight.maxLb[1].getValue(), pts.Payload.Weight.maxLb[2].getValue(), pts.Payload.Weight.maxLb[3].getValue()];
globals.simbriefPayloadCallback = func(cargoWeight, paxWeight, paxCount) {
	var totalPaxCapacityLb = 0;
	var totalCargoCapacityLb = 0;
	
	# Passengers
	for (var i = 0; i < 2; i += 1) {
		totalPaxCapacityLb += payloadCapacityLb[i];
	}
	
	for (var i = 0; i < 2; i += 1) {
		var weight = math.round(paxWeight * KG2LB * (payloadCapacityLb[i] / totalPaxCapacityLb), 200);
		if (LoadManager.modelInt == 7) {
			LoadManager.weight87[i].setValue(weight);
		} else {
			LoadManager.weight80[i].setValue(weight);
		}
	}
	
	# Lower Cargo
	for (var i = 2; i < 4; i += 1) {
		totalCargoCapacityLb += payloadCapacityLb[i];
	}
	
	for (var i = 2; i < 4; i += 1) {
		var weight = math.round(cargoWeight * KG2LB * (payloadCapacityLb[i] / totalCargoCapacityLb), 100);
		if (LoadManager.modelInt == 7) {
			LoadManager.weight87[i].setValue(weight);
		} else {
			LoadManager.weight80[i].setValue(weight);
		}
	}
	
	# Reset retardant tank
	if (LoadManager.modelInt == 7) {
		LoadManager.weight87[4].setValue(0);
	} else {
		LoadManager.weight80[4].setValue(0); # Placeholder but we'll reset it anyways
	}
	
	LoadManager.setLoad(2);
}
