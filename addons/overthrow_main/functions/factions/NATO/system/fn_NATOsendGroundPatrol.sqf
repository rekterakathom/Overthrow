/*
    Author: ThomasAngel, ARMAZac

    Description:
    Send a ground patrol

    Parameters:
        _spend - The current spending limit
        _chance - The current random threshold

    Usage: [_spend, _chance] call OT_fnc_NATOsendGroundPatrol;

    Returns: Scalar - How much is left to spend
*/

params ["_spend", "_chance"];

private _resources = server getVariable ["NATOresources", 2000];
private _abandoned = server getVariable ["NATOabandoned", []];

private _done = false;
{
    private _town = _x;
    private _stability = server getVariable format ["stability%1", _town];
    private _townPos = server getVariable _town;
    if ([_townPos] call OT_fnc_inSpawnDistance) then {
        private _base = _townPos call OT_fnc_nearestObjective;
        _base params ["_basePos", "_baseName"];
        if !(_baseName in OT_allComms) then {
            private _baseregion = _basePos call OT_fnc_getRegion;
            private _townregion = _townPos call OT_fnc_getRegion;
            private _dist = _basePos distance2D _townPos;
            if (!(_baseName in _abandoned) && _baseregion isEqualTo _townregion && _dist < 5000 && _stability < 50 && (random 100) > _chance) exitWith {
                _spend = _spend - 150;
                _done = true;
                _resources = _resources - 150;
                [_baseName, _townPos] spawn OT_fnc_NATOGroundPatrol;
                spawner setVariable ["NATOlastpatrol", time, false];
            };
        };
    };
    if (_done) exitWith {};
} forEach (OT_townsSortedByPopulation call BIS_fnc_arrayShuffle);

server setVariable ["NATOresources", _resources];

_spend;
