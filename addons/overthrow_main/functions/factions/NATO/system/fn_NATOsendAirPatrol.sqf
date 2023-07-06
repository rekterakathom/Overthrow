/*
    Author: ThomasAngel, ARMAZac

    Description:
    Try to send an air patrol

    Parameters:
        _spend - The current spending limit

    Usage: [_spend] call OT_fnc_NATOsendAirPatrol;

    Returns: Scalar - How much is left to spend
*/

params ["_spend"];

private _resources = server getVariable ["NATOresources", 2000];
private _abandoned = server getVariable ["NATOabandoned", []];
private _fobs = server getVariable ["NATOfobs", []];

private _frombase = "";
{
	_x params ["_obpos","_name"];
	if !(_name in _abandoned) then {
		_frombase = _name;
	};
} forEach (OT_airportData call BIS_fnc_arrayShuffle);

if (_frombase isNotEqualTo "" && {(random 100) > _chance}) then {
	private _waypoints = [];
	{
		_x params ["_pos"];
		_waypoints pushBack _pos;
	} forEach (_fobs);

	{
		if((server getVariable [format ["garrison%1",_x],-1]) > 0) then {
			private _pos = markerPos _x;
			_waypoints pushBack _pos;
		};
		if((count _waypoints) > 6) exitWith {};
	} forEach (OT_NATO_control call BIS_fnc_arrayShuffle);

	if ((count _waypoints) > 0) then {
		_spend = _spend - 250;
		_resources = _resources - 250;
		spawner setVariable ["NATOlastairpatrol", time, false];
		[_frombase, _waypoints] spawn OT_fnc_NATOAirPatrol;
	};
};

server setVariable ["NATOresources", _resources];

_spend