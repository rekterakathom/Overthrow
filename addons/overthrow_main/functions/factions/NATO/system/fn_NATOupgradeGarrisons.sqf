/*
    Author: ThomasAngel, ARMAZac

    Description:
    Try to upgrade garrisons

    Parameters:
        _spend - The current spending limit
        _chance - The current random threshold

    Usage: [_spend, _chance] call OT_fnc_NATOupgradeGarrisons;

    Returns: Scalar - How much is left to spend
*/

params ["_spend", "_chance"];

private _resources = server getVariable ["NATOresources", 2000];
private _abandoned = server getVariable ["NATOabandoned", []];

{
    _x params ["_pos", "_name", "_pri"];
    if !(_name in _abandoned) then {
        private _garrison = server getVariable [format ["garrison%1", _name], 0];
        private _max = 8;
        if (_pri > 300) then {
            _max = 12;
        };
        if (_pri > 800) then {
            _max = 24;
        };
        if (_pri > 1200) then {
            _max = 32;
        };
        if ((_garrison < _max) && { (_spend > 150) } && { (random 100 > _chance) } && { !([_pos] call OT_fnc_inSpawnDistance) }) then {
            server setVariable [format ["garrison%1", _name], _garrison + 4, true];
            _spend = _spend - 150;
            _resources = _resources - 150;
        };
    };
} forEach (OT_objectiveData);

server setVariable ["NATOresources", _resources];

_spend;
