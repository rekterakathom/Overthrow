{
    private _veh = _x;
    {
        if (!alive _x) then {
            [_veh, _x] remoteExecCall ["deleteVehicleCrew", _x];
        };
    } foreach crew _veh;
    if (!alive _x) then {
        deleteVehicle _x;
    };
} foreach vehicles;

{
    if (isNull objectParent _x) then {
            deleteVehicle _x;
        } else {
            [(objectParent _x), _x] remoteExec ["deleteVehicleCrew", _x, false];
        };
} foreach allDeadMen;
