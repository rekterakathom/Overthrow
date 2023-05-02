/*
    Author: ThomasAngel, ARMAZac

    Description:
    Loops through all FOBs

    Parameters:
        -

    Usage: [] call OT_fnc_NATOabandonTowers;

    Returns: Boolean - was a FOB cleared
*/

private _countered = false;
private _clearedFOBs = [];
private _fobs = server getVariable ["NATOfobs", []];

{
	_x params ["_pos","_garrison"];
	private _numMil = {side _x isEqualTo west} count (_pos nearEntities ["CAManBase",300]);
	private _numRes = {side _x isEqualTo resistance || captive _x} count (_pos nearEntities ["CAManBase",50]);
	if (_numMil isEqualTo 0 && {_numRes > 0}) then {
		_countered = true;
		_clearedFOBs pushBack _x;
		"Cleared NATO FOB" remoteExec ["OT_fnc_notifyMinor", 0, false];
		private _flag = _pos nearObjects [OT_flag_NATO, 50];
		if (count _flag > 0) then {
			deleteVehicle (_flag select 0);
		};
		deleteMarker format["natofob%1", str _pos];
	};
} forEach _fobs;

{
	_fobs deleteAt (_fobs find _x);
} forEach _clearedFOBs;

_countered
