params ["_i","_s","_e","_c","_p"];
private _groups = spawner getVariable [_i,[]];
spawner setVariable [_i,[],false];
{
    if(_x isEqualType grpNull) then {
        {
            if !(_x call OT_fnc_hasOwner) then {
                moveOut _x;
                deleteVehicle _x;
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
