{
    private _veh = _x;
    {
        if (!alive _x) then {
            moveOut _x;
            deleteVehicle _x;
        };
    } foreach crew _veh;
    if (!alive _x) then {
        deleteVehicle _x;
    };
} foreach vehicles;

{
    moveOut _x;
    deleteVehicle _x;
} foreach allDeadMen;
