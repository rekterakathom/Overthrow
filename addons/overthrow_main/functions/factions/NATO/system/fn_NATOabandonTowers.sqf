/*
    Author: ThomasAngel, ARMAZac

    Description:
    Loops through all radio towers and checks if they should be abandoned

    Parameters:
        -

    Usage: [] call OT_fnc_NATOabandonTowers;

    Returns: Boolean - was a radio tower abandoned
*/

private _countered = false;
private _abandoned = server getVariable ["NATOabandoned", []];

{
	_x params ["_pos", "_name"];
	if !(_name in _abandoned) then {
		if ([_pos] call OT_fnc_inSpawnDistance) then {
			private _numMil = {side _x isEqualTo west} count (_pos nearEntities ["CAManBase", 300]);
			private _numRes = {side _x isEqualTo resistance || captive _x} count (_pos nearEntities ["CAManBase", 100]);
			if (_numMil < _numRes) then {
				_abandoned pushBack _name;
				_name setMarkerColor "ColorGUER";
				format ["Resistance has captured the %1 tower", _name] remoteExec ["OT_fnc_notifyGood", 0, false];
				_resources = _resources - 100;
				_countered = true;
				format ["%1_restrict", _name] setMarkerAlpha 0;
			};
		};
	};
	if(_countered) exitWith {};
} forEach OT_NATOComms;

server setVariable ["NATOabandoned", _abandoned, true];

_countered
