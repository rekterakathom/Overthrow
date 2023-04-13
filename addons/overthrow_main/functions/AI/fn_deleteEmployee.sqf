// This function should only be called on the server

params ["_businessName"];

private _group = spawner getVariable [format ["employees%1", _businessName], grpNull];
if (!isNull _group && count units _group > 0) then {
    // Delete the last unit in the group
    [units _group # -1] call OT_fnc_cleanupUnit;
};
