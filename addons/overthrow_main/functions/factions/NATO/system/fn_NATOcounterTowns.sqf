/*
    Author: ThomasAngel, ARMAZac

    Description:
    NATO checks if it can try to capture a town for itself

    Parameters:
        _chance - The current random threshold

    Usage: [_chance] call OT_fnc_NATOcounterTowns;

    Returns: Boolean - was a town counter-attacked
*/

params [
    ["_chance", 0, [0]]
];

if (isNil "OT_townsSortedByPopulation") then {
    OT_townsSortedByPopulation = [OT_allTowns, [], { server getVariable format ["population%1", _x] }, "DESCEND"] call BIS_fnc_sortBy;
};

private _countered = false;
private _popControl = call OT_fnc_getControlledPopulation;
private _lastCounter = server getVariable ["NATOlastcounter", ""];
private _abandoned = server getVariable ["NATOabandoned", []];
private _resources = server getVariable ["NATOresources", 2000];
private _lastAttack = time - (server getVariable ["NATOlastattack", 0]);

{
    private _town = _x;
    if (_town in _abandoned) then { continue };
    private _pos = server getVariable [_town, [0, 0, 0]];
    private _population = server getVariable [format ["population%1", _town], 100];
    if (_town != _lastCounter) then {
        if ([_pos] call OT_fnc_inSpawnDistance) then {
            private _numMil = { side _x isEqualTo blufor } count (_pos nearEntities ["CAManBase", 300]);
            private _numRes = { side _x isEqualTo independent || captive _x } count (_pos nearEntities ["CAManBase", 200]);
            if (_numMil < 3 && { _numRes > 0 }) then {
                if ((time - _lastAttack) > 1200 && { (_resources > _population) } && { (random 100) > _chance }) then {
                    // Counter a town
                    diag_log format ["Overthrow: Counter-attacking %1", _town];
                    private _multiplier = 3;
                    if (_popControl > 1000) then { _multiplier = 4 };
                    if (_popControl > 2000) then { _multiplier = 5 };
                    private _cost = _population * _multiplier;
                    if (_resources < _cost) then { _cost = _resources };
                    [_town, _cost] spawn OT_fnc_NATOCounterTown;
                    server setVariable ["NATOlastcounter", _town, true];
                    server setVariable ["NATOattacking", _town, true];
                    server setVariable ["NATOattackstart", time, true];
                    server setVariable ["NATOlastattack", time, true];
                    _resources = _resources - _cost;
                    _countered = true;
                };
            };
        };
    };
    if (_countered) exitWith {};
} forEach OT_townsSortedByPopulation;

server setVariable ["NATOresources", _resources];

_countered;
