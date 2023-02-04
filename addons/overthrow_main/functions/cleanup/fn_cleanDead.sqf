{
    private _veh = _x;
    {
        if (!alive _x) then {
            [_x] remoteExecCall ["OT_fnc_cleanupUnit", _veh, false];
        };
    } foreach crew _veh;
    if (!alive _x) then {
        [_x] remoteExecCall ["OT_fnc_cleanupVehicle", _x, false];
    };
} foreach vehicles;

{
    [_x] remoteExecCall ["OT_fnc_cleanupUnit", _x, false];
} foreach allDeadMen;
