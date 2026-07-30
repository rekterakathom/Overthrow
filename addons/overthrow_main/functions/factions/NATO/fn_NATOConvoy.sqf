params ["_vehtypes", "_hvts", "_from", "_to", ["_missionid", "CONVOY"]];

private _abandoned = server getVariable ["NATOabandoned", []];
if (_from in _abandoned) exitWith {};

private _frompos = server getVariable _from;
private _fromregion = _frompos call OT_fnc_getRegion;
private _topos = server getVariable _to;

private _dir = (_frompos getDir _topos);

private _group = createGroup blufor;
spawner setVariable [format ["spawn%1", _missionid], _group, false];
_group setFormation "COLUMN";
private _track = objNull;

if ([_topos, _fromregion] call OT_fnc_regionIsConnected) then {
    private _convoypos = _frompos getPos [120, random 360];
    private _road = [_convoypos, 150] call BIS_fnc_nearestRoad;
    if (!isNull _road) then {
        private _roadscon = roadsConnectedTo _road;
        if (count _roadscon isEqualTo 2) then {
            _convoypos = getPosATL _road;
            _dir = (_road getDir (_roadscon select 0));
        };
    };
    {
        private _pos = _convoypos findEmptyPosition [10, 100, _x];
        if (_pos isEqualTo []) then { _pos = _convoypos findEmptyPosition [0, 100, _x] };
        private _veh = createVehicle [_x, _pos, [], 0, ""];
        _veh setVariable ["garrison", "HQ", false];

        _veh setDir (_dir);
        _group addVehicle _veh;
        createVehicleCrew _veh;
        private _driver = driver _veh;
        _driver disableAI "AUTOCOMBAT";
        _veh setConvoySeparation 20;
        {
            [_x] joinSilent _group;
            _x setVariable ["garrison", "HQ", false];
        } forEach (crew _veh);
        _driver assignAsCommander _veh;
        _convoypos = _convoypos getPos [20, _dir + 180];
        {
            _x addCuratorEditableObjects [[_veh], true];
        } forEach (allCurators);
        sleep 0.3;
    } forEach (_vehtypes);

    {
        private _pos = _convoypos findEmptyPosition [10, 100, OT_NATO_Vehicle_HVT];
        if (_pos isEqualTo []) then { _pos = _convoypos findEmptyPosition [0, 100, OT_NATO_Vehicle_HVT] };
        private _veh = createVehicle [OT_NATO_Vehicle_HVT, _pos, [], 0, ""];
        _veh setVariable ["garrison", "HQ", false];

        _veh setDir (_dir);
        _group addVehicle _veh;
        createVehicleCrew _veh;

        private _driver = driver _veh;
        _driver disableAI "AUTOCOMBAT";
        _veh setConvoySeparation 20;
        {
            [_x] joinSilent _group;
            _x setVariable ["garrison", "HQ", false];
        } forEach (crew _veh);
        _driver assignAsCommander _veh;
        _driver setVariable ["hvt", true, true];
        _driver setVariable ["hvt_id", _x select 0, true];
        _driver setRank "COLONEL";
        if (isNull _track) then { _track = _driver };

        _convoypos = _convoypos getPos [20, _dir];

        {
            _x addCuratorEditableObjects [[_veh], true];
        } forEach (allCurators);

        sleep 0.3;
        _x set [2, "CONVOY"];
    } forEach (_hvts);

    private _numsupport = 2;

    if (_hvts isNotEqualTo []) then {
        private _count = 0;
        while { _count < _numsupport } do {
            private _vehtype = selectRandom OT_NATO_Vehicles_GroundSupport;
            private _pos = _convoypos findEmptyPosition [10, 100, _vehtype];
            if (_pos isEqualTo []) then { _pos = _convoypos findEmptyPosition [0, 100, _vehtype] };
            private _veh = createVehicle [_vehtype, _pos, [], 0, ""];
            _veh setVariable ["garrison", "HQ", false];
            _veh setDir (_dir);
            _group addVehicle _veh;
            createVehicleCrew _veh;
            private _driver = driver _veh;
            _driver disableAI "AUTOCOMBAT";
            _veh setConvoySeparation 20;
            {
                [_x] joinSilent _group;
                _x setVariable ["garrison", "HQ", false];
            } forEach (crew _veh);
            _driver assignAsCommander _veh;
            _convoypos = _convoypos getPos [20, -_dir];
            _count = _count + 1;

            {
                _x addCuratorEditableObjects [[_veh], true];
            } forEach (allCurators);

            sleep 0.3;
        };
    };
    sleep 5;
    private _wp = _group addWaypoint [ASLToATL _topos, 50];
    _wp setWaypointType "MOVE";
    _wp setWaypointFormation "COLUMN";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
    _wp setWaypointCompletionRadius 50;
    _wp setWaypointTimeout [60, 60, 60];

    _wp = _group addWaypoint [_topos, 500];
    _wp setWaypointType "SCRIPTED";
    _wp setWaypointStatements ["true", "[group this] call OT_fnc_cleanup"];
};

if (isNull _track) exitWith {};
waitUntil { (_track distance _topos) < 100 || !alive _track };

if (alive _track) then {
    {
        _x set [2, ""];
        _x set [1, _to];
    } forEach (_hvts);
};
