{
    private _veh = _x;
    {
        if (!alive _x) then {
            [_x] call OT_fnc_cleanupUnit;
        };
    } forEach crew _veh;
    if (!alive _x) then {
        [_x] call OT_fnc_cleanupVehicle;
    };
} forEach vehicles;

{
    [_x] call OT_fnc_cleanupUnit;
} forEach allDeadMen;
