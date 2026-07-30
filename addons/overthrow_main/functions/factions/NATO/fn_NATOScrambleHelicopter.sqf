//Scramble a helicopter to take out a target
params ["_target", "_targetpos", ["_delay", 0]];

private _abandoned = server getVariable ["NATOabandoned", []];
private _from = nil;
{
    _x params ["_obpos", "_name"];
    if !((_name in _abandoned) || (_obpos distance _targetpos) < 300) exitWith {
        _from = _x;
    };
} forEach ([OT_airportData, [], { _targetpos distance (_x select 0) }, "ASCEND"] call BIS_fnc_sortBy);

if !(isNil "_from") then {
    if (_delay > 0) then { sleep _delay };
    diag_log "Overthrow: NATO Scrambling Helicopter";

    private _vehtype = selectRandom OT_NATO_Vehicles_AirSupport_Small;
    if ((typeOf _target) isKindOf "Tank") then { _vehtype = selectRandom OT_NATO_Vehicles_AirSupport };

    private _frompos = _from select 0;

    private _pos = _frompos findEmptyPosition [15, 100, _vehtype];
    if (_pos isEqualTo []) then { _pos = _frompos findEmptyPosition [8, 100, _vehtype] };

    private _group = createGroup blufor;
    private _veh = _vehtype createVehicle _pos;
    _veh setVariable ["garrison", "HQ", false];

    clearWeaponCargoGlobal _veh;
    clearMagazineCargoGlobal _veh;
    clearItemCargoGlobal _veh;
    clearBackpackCargoGlobal _veh;

    _group addVehicle _veh;
    createVehicleCrew _veh;
    {
        [_x] joinSilent _group;
        _x setVariable ["garrison", "HQ", false];
        _x setVariable ["NOAI", true, false];
    } forEach (crew _veh);

    {
        _x addCuratorEditableObjects [[_veh], true];
    } forEach (allCurators);

    sleep 1;

    private _dir = (_targetpos getDir _frompos);
    private _attackpos = _targetpos getPos [(100 + random 300), _dir];

    private _wp = _group addWaypoint [_attackpos, 50];
    _wp setWaypointType "SAD";
    _wp setWaypointBehaviour "COMBAT";
    _wp setWaypointSpeed "FULL";
    _wp setWaypointTimeout [500, 600, 700];

    private _timeout = time + 600;

    waitUntil {
        sleep 10;
        alive _veh && time > _timeout;
    };

    while { (waypoints _group) isNotEqualTo [] } do {
        deleteWaypoint ((waypoints _group) select 0);
    };

    sleep 1;

    _wp = _group addWaypoint [_frompos, 50];
    _wp setWaypointType "MOVE";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "FULL";

    waitUntil {
        sleep 10;
        (alive _veh && (_veh distance _frompos) < 150) || !alive _veh;
    };

    if (alive _veh) then {
        while { (waypoints _group) isNotEqualTo [] } do {
            deleteWaypoint ((waypoints _group) select 0);
        };
        _veh land "LAND";
        // Sometimes helicopters land just briefly and take off again, so checking this every second
        waitUntil {
            sleep 1;
            (getPos _veh) # 2 < 2;
        };
    };
    _veh call OT_fnc_cleanup;
    _group call OT_fnc_cleanup;
};
