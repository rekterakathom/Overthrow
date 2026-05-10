params ["_obj"];

if (damage _obj isEqualTo 1) then {
    private _damaged = owners getVariable ["damagedBuildings", []];
    private _id = [_obj] call OT_fnc_getBuildID;
    if !(_id in _damaged) then {
        _damaged pushBack _id;
        owners setVariable ["damagedBuildings", _damaged, true];
        private _ty = typeOf _obj;

        if (_ty isEqualTo OT_warehouseBuilding) then {
            format [localize "STR_EVENT_BUILDING_DAMAGED_01", _obj call BIS_fnc_locationDescription] remoteExec ["OT_fnc_notifyMinor", 0, false];
        };
        if (_ty isEqualTo OT_policeStation) then {
            private _town = _obj call OT_fnc_nearestTown;
            private _abandoned = server getVariable ["NATOabandoned", []];
            server setVariable [format ["police%1", _town], 0, true];
            if (_town in _abandoned) then {
                [_town, -20] call OT_fnc_stability;
                format [localize "STR_EVENT_BUILDING_DAMAGED_02", _town] remoteExec ["OT_fnc_notifyMinor", 0, false];
            };
        };
    };
};
