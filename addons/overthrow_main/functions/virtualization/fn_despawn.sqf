params ["_i","_s","_e","_c","_p"];
private _groups = spawner getVariable [_i,[]];
spawner setVariable [_i,[],false];
{
    if(_x isEqualType grpNull) then {
        {
            if !(_x call OT_fnc_hasOwner) then {
                if (isNull objectParent _x) then {
                    deleteVehicle _x;
                } else {
                    [(objectParent _x), _x] remoteExec ["deleteVehicleCrew", _x, false];
                };
                sleep 0.3;
            };
        }foreach(units _x);
        deleteGroup _x;
    }else{
        if !(_x call OT_fnc_hasOwner) then {
            deleteVehicle _x;
        };
    };
    sleep 0.3;
}foreach(_groups);
