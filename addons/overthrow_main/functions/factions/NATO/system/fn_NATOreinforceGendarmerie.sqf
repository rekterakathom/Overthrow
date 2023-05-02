/*
    Author: ThomasAngel, ARMAZac

    Description:
    Reinforce gendarmerie patrols

    Parameters:
        _spend - The current spending limit

    Usage: [_spend] call OT_fnc_NATOreinforceGendarmerie;

    Returns: Scalar - How much is left to spend
*/

params ["_spend"];

private _resources = server getVariable ["NATOresources", 2000];
private _abandoned = server getVariable ["NATOabandoned", []];

{
	private _town = _x;
	private _townPos = server getVariable _town;
	private _current = server getVariable format ["garrison%1",_town];;
	private _stability = server getVariable format ["stability%1",_town];
	private _population = server getVariable format ["population%1",_town];
	if !(_town in _abandoned) then {
		_max = round(_population / 40);
		if(_max < 4) then {_max = 4};
		_garrison = 2+round((1-(_stability / 100)) * _max);
		if(_town in OT_NATO_priority) then {
			_garrison = round(_garrison * 2);
		};
		_need = _garrison - _current;
		if(_need < 0) then {_need = 0};
		if(_need > 1 && {_spend >= 20}) then {
			_spend = _spend - 20;
			_resources = _resources - 20;
			_x spawn OT_fnc_NATOsendGendarmerie;
		};
	};
	if(_spend < 20) exitWith {};
} forEach (OT_townsSortedByPopulation call BIS_fnc_arrayShuffle);

server setVariable ["NATOresources", _resources];

_spend
