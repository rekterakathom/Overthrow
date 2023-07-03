/*
    Author: ThomasAngel

    Description:
    Starts destroying a resistance FOB

    Parameters:
        _group - The group doing the dirty work

    Usage: [] call OT_fnc_NATOsiegeFOB;

    Returns: Boolean - was an aircraft scrambled
*/

params ["_leader"];

private _group = group _leader;
private _targetPos = _leader getVariable ["OT_targetPos", objNull];

private _gotExplosives = (units _group) select -1;
private _demoExpert = objNull;
{
    if ("DemoCharge_Remote_Mag" in (magazines _x)) then {
        _gotExplosives = true;
        _demoExpert = _x;
    };
} forEach (units _group);

if (isNull _demoExpert) then {
	_demoExpert = _leader;
};

// Targets:
// All buildables at the FOB
// All vehicles parked at the FOB
private _targets = _targetPos nearObjects ["Building", 30] select {(typeOf _x) in [OT_flag_IND, OT_refugeeCamp, OT_trainingCamp, OT_workshopBuilding]};
_targets append (_targetPos nearEntities [["LandVehicle", "Air"], 50]);

private _charges = [];
{
	private _pos = getPosATL _x;
	_demoExpert commandMove _pos;
	waitUntil {unitReady _demoExpert};
	if (alive _demoExpert) then {
		_demoExpert removeMagazineGlobal "DemoCharge_Remote_Mag";
		private _charge = "DemoCharge_Remote_Ammo" createVehicle _pos;
		_charge setPosATL _pos;
		_charges pushBack _charge;
		sleep 1; // Time it takes to "plant the bomb"
	} else {
		// He is dead
		break;
	};
} forEach _targets;

// Run away! (not into water preferably)
private _runto = [0,0,0];
for "_i" from 0 to 30 do {
	if (_i >= 30) exitWith {_runto = _targetPos getPos [(1000 + random 1000), random 360]};
	_testPos = _targetPos getPos [(1000 + random 1000), random 360];
	if !(surfaceIsWater _testPos) exitWith {_runTo = _testPos};
};
_wp = _group addWaypoint [_runto, 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "COMBAT";
_wp setWaypointSpeed "FULL";
_wp setWaypointStatements ["true","[group this] call OT_fnc_cleanup"];
_demoExpert setVariable ["NOAI", false, true];

sleep (5 * 60);
[_charges, -3] call ace_explosives_fnc_scriptedExplosive;
