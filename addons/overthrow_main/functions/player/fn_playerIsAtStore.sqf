private _building = nearestBuilding player;
if (player distance _building > 20) exitWith {false};
if (_building getVariable ["OT_shopCategory",""] == "") exitWith {false};
true
