/*
    Author: ThomasAngel, ARMAZac

    Description:
    Checks types of known threats and scrambles either jet or helo to intercept

    Parameters:
        -

    Usage: [] call OT_fnc_NATOscrambleAircraft;

    Returns: Boolean - was an aircraft scrambled
*/

private _knownTargets = spawner getVariable ["NATOknownTargets", []];
private _popControl = call OT_fnc_getControlledPopulation;
private _resources = server getVariable ["NATOresources", 2000];
private _diff = server getVariable ["OT_difficulty", 1];
private _countered = false;

{
	_x params ["_ty", "_pos", "_threat", "_target", ["_done", false]];
	if (!_done) then {
		private _chance = 85;
		if (_diff > 1) then {_chance = 80};
		if (_diff < 1) then {_chance = 90};
		if (_popControl > 1000) then {_chance = _chance - 5};
		if (_popControl > 2000) then {_chance = _chance - 10};

		if (_ty isEqualTo "P" || _ty isEqualTo "H") then {
			if (_resources > 500 && ((random 100) > _chance)) then {
				[_target, _pos] spawn OT_fnc_NATOScrambleJet;
				_resources = _resources - 500;
				_x set [4, true];
				if (([OT_nation] call OT_fnc_support) > (random 250)) then {
					format ["Intel reports that NATO has scrambled a jet to intercept %1", (typeOf _target) call OT_fnc_vehicleGetName]
				};
				_countered = true;
			};
		};
		if (_ty isEqualTo "V" && _threat > 100) then {
			if (_resources > 500 && ((random 100) > _chance)) then {
				[_target, _pos] spawn OT_fnc_NATOScrambleHelicopter;
				_resources = _resources - 350;
				_x set [4,true];
				if (([OT_nation] call OT_fnc_support) > (random 250)) then {
					format ["Intel reports that NATO has scrambled a helicopter to intercept %1", (typeof _target) call OT_fnc_vehicleGetName]
				};
				_countered = true;
			};
		};
	};
	if (_countered) exitWith {};
} forEach _knownTargets;

_countered
