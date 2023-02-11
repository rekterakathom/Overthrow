{
    private _veh = _x;
    {
        if (!alive _x) then {
            [_x] call OT_fnc_cleanupUnit;
        };
    } foreach crew _veh;
    if (!alive _x) then {
        [_x] call OT_fnc_cleanupVehicle;
    };
} foreach vehicles;

{
    [_x] call OT_fnc_cleanupUnit;
} foreach allDeadMen;
