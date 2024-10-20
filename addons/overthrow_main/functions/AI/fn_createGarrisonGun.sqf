// This function should only be called on the server

params ["_baseCode", "_gun"];

private _group = spawner getVariable [format ["resgarrison%1", _baseCode], grpNull];
if (isNull _group) then {
    _group = createGroup resistance;
    _group setVariable ["VCM_TOUGHSQUAD", true, true];
    _group setVariable ["VCM_NORESCUE", true, true];
    spawner setVariable [format ["resgarrison%1", _baseCode], _group, true];
};

createVehicleCrew _gun;
crew _gun joinSilent _group;
