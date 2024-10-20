/*
    Author: ThomasAngel, ARMAZac

    Description:
    Try to schedule a convoy

    Parameters:
        _spend - The current spending limit

    Usage: [_spend] call OT_fnc_NATOscheduleConvoy;

    Returns: Scalar - How much is left to spend
*/

params ["_spend"];

private _resources = server getVariable ["NATOresources", 2000];
private _abandoned = server getVariable ["NATOabandoned", []];
_schedule = server getVariable ["NATOschedule",[]];

private _start = selectRandom (OT_objectiveData + OT_airportData);
_start params ["_startPos", "_startName"];

if(_startName in _abandoned) exitWith {};
private _end = [];
{
	_x params ["_p","_n"];
	if ((_n != _startName) && {!(_n in _abandoned)} && {([_p,_startPos] call OT_fnc_regionIsConnected)}) exitWith {
		_end = _x;
	};
} forEach(OT_objectiveData call BIS_fnc_arrayShuffle);
if (_end isNotEqualTo []) then {
	//Schedule a convoy
	private _id = format["CONVOY%1",round(random 99999)];
	_hour = (date select 3) + 2;
	if (_hour > 5 && _hour < 17) then {
		spawner setVariable ["NATOlastconvoy",time,false];
		_spend = _spend - 500;
		_resources = _resources - 500;
		_schedule pushBack [_id, "CONVOY", _start, _end, _hour];
	};
};

server setVariable ["NATOresources", _resources];
server setVariable ["NATOschedule", _schedule];

_spend