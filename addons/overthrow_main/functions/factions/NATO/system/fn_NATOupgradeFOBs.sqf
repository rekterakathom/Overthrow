/*
    Author: ThomasAngel, ARMAZac

    Description:
    Try to send an air patrol

    Parameters:
        _spend - The current spending limit

    Usage: [_spend] call OT_fnc_NATOsendAirPatrol;

    Returns: Scalar - How much is left to spend
*/

params ["_spend", "_chance"];

private _resources = server getVariable ["NATOresources", 2000];
private _fobs = server getVariable ["NATOfobs", []];

{
	_x params ["_pos","_garrison","_upgrades"];
	_max = 16;
	if((_garrison < _max) && {(_spend > 150)} &&  {(random 100 > _chance)}) exitWith {
		_x set [1,_garrison + 4];
		_spend = _spend - 150;
		_resources = _resources - 150;
		_group = createGroup blufor;
		_group deleteGroupWhenEmpty true;
		_count = 0;
		while {_count < 4} do {
			_start = [[[_pos,50]]] call BIS_fnc_randomPos;

			_civ = _group createUnit [selectRandom OT_NATO_Units_LevelOne, _start, [],0, "NONE"];
			_civ setVariable ["garrison","HQ",false];
			_civ setRank "LIEUTENANT";
			_civ setVariable ["VCOM_NOPATHING_Unit",true,false];
			_civ setBehaviour "SAFE";

			_count = _count + 1;
		};
		_group call OT_fnc_initMilitaryPatrol;
	};

	if (!("Mortar" in _upgrades) && {(_spend > 300)} && {(random 100 > _chance)}) exitWith {
		_spend = _spend - 300;
		_resources = _resources - 300;
		_upgrades pushback "Mortar";
		[_pos,["Mortar"]] spawn OT_fnc_NATOupgradeFOB;
	};
	if (!("Barriers" in _upgrades) && {(_spend > 50)} && {(random 100 > _chance)}) exitWith {
		_spend = _spend - 50;
		_resources = _resources - 50;
		_upgrades pushback "Barriers";
		[_pos,["Barriers"]] spawn OT_fnc_NATOupgradeFOB;
	};
	if (!("HMG" in _upgrades) && {(_spend > 150)} && {(random 100 > _chance)}) exitWith {
		_spend = _spend - 150;
		_resources = _resources - 150;
		_upgrades pushback "HMG";
		[_pos,["HMG"]] spawn OT_fnc_NATOupgradeFOB;
	};
}foreach(_fobs);

server setVariable ["NATOresources", _resources];

_spend
