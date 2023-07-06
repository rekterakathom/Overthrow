/*
    Author: ThomasAngel

    Description:
    Iterate through known targets and if possible, raid them

    Parameters:
        _spend - The current spending limit
		_chance - The current random threshold

    Usage: [_spend] call OT_fnc_NATOsendRaid;

    Returns: Scalar - How much is left to spend
*/

params ["_spend", "_chance"];

private _resources = server getVariable ["NATOresources", 2000];

{
	_x params ["_ty", "_pos", "_threat", "_target", ["_done", false]];
	if (!_done) then {
		private _chance = 85;
		if (_diff > 1) then {_chance = 80};
		if (_diff < 1) then {_chance = 90};
		if (_popControl > 1000) then {_chance = _chance - 5};
		if (_popControl > 2000) then {_chance = _chance - 10};

		if (_ty == "FOB") then {
			if ((random 100) > _chance) then {
				[_pos, "[this] spawn OT_fnc_NATOsiegeFOB"] call OT_fnc_NATOMissionReconInsert;
				_spend = _spend - 250;
				_resources = _resources - 250;
				break;
			};
		};
	};
} forEach _knownTargets;

server setVariable ["NATOresources", _resources];

_spend
