params ["_i","_s","_e","_c","_p"];
private _groups = spawner getVariable [_i,[]];
spawner setVariable [_i,[],false];
{
    // Cleanup a group
    if (_x isEqualType grpNull) then {
		private _units = units _x;
        if (count _units isEqualTo 0) then {
            _x call OT_fnc_cleanupEmptyGroup;
        };
        {
            if !(_x call OT_fnc_hasOwner) then {
                [_x] call OT_fnc_cleanupUnit;
                sleep 0.1;
            };
        }forEach(_units);
        continue;
    };

    // Cleanup a vehicle / object
    if (_x isEqualType objNull) then {
        if !(_x call OT_fnc_hasOwner) then {
            [_x] call OT_fnc_cleanupVehicle;
        };
        continue;
    };

    // Cleanup a marker
    if (_x isEqualType "") then {
        deleteMarker _x;
        continue;
    };

    // We don't know what it is
    diag_log format ["Overthrow: Failed to despawn %1", _x];
} forEach (_groups);
