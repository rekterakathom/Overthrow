// This function should only be called on the server

params ["_baseCode", "_pos", "_soldier", "_charge"];

private _group = spawner getVariable [format ["resgarrison%1", _baseCode], grpNull];
private _doinit = false;
if (isNull _group) then {
    _group = creategroup resistance;
    _group setVariable ["VCM_TOUGHSQUAD", true, true];
    _group setVariable ["VCM_NORESCUE", true, true];
    spawner setVariable [format ["resgarrison%1", _baseCode], _group, true];
    _doinit = true;
};

private _unit = [_soldier, _pos, _group] call OT_fnc_createSoldier;

if (_doinit) then {
    _group call OT_fnc_initMilitaryPatrol;
};
if (_charge) then {
    private _cls = _soldier # 1;
    private _loadout = getUnitLoadout _unit;
    private _garrison = server getVariable [format ["resgarrison%1", _baseCode],[]];
    _garrison pushback [_cls, _loadout];
    server setVariable [format ["resgarrison%1", _baseCode], _garrison, true];
};
