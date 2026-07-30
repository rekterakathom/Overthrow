private _town = _this;
private _townPos = server getVariable _town;

private _police = [];
private _groups = [];

private _close = nil;
private _dist = 8000;
private _abandoned = server getVariable ["NATOabandoned", []];
private _attacking = server getVariable ["NATOattacking", ""];
{
    _x params ["_pos", "_name"];
    if (_name != _attacking) then {
        if (([_pos, _townPos] call OT_fnc_regionIsConnected) && !(_name in _abandoned)) then {
            private _d = (_pos distance _townPos);
            if (_d < _dist) then {
                _dist = _d;
                _close = _pos;
            };
        };
    };
} forEach (OT_NATOobjectives);

if (!isNil "_close") then {
    private _current = server getVariable [format ["garrison%1", _town], 0];
    server setVariable [format ["garrison%1", _town], _current + 4, true];
    if !([_townPos] call OT_fnc_inSpawnDistance) exitWith {};

    // Group may not be moved into a vehicle, so it also needs space to spawn
    private _start = [_close, 50, 200, 1, 0, 0, 0] call BIS_fnc_findSafePos;
    private _group = createGroup blufor;
    _groups pushBack _group;
    private _usecar = false;
    private _veh = objNull;

    if (((_close distance _townPos) > 2000) && (random 100) > 50) then {
        private _spawnpos = _close findEmptyPosition [10, 100, OT_NATO_Vehicle_Police];
        if (_spawnpos isEqualTo []) then { _spawnpos = _close findEmptyPosition [0, 100, OT_NATO_Vehicle_Police] };
        _veh = OT_NATO_Vehicle_Police createVehicle _spawnpos;
        _veh setDir (random 360);
        _group addVehicle _veh;
        _usecar = true;
        _groups pushBack _veh;
    };

    private _civ = _group createUnit [OT_NATO_Unit_PoliceCommander_Heavy, _start, [], 0, "NONE"];
    _police pushBack _civ;
    [_civ, _town] call OT_fnc_initGendarm;
    _civ setBehaviour "SAFE";
    sleep 0.01;

    _start = _start findEmptyPosition [1, 100, OT_NATO_Unit_Police_Heavy];
    _civ = _group createUnit [OT_NATO_Unit_Police_Heavy, _start, [], 0, "NONE"];

    _police pushBack _civ;
    [_civ, _town] call OT_fnc_initGendarm;
    _civ setBehaviour "SAFE";

    _start = _start findEmptyPosition [1, 100, OT_NATO_Unit_Police_Heavy];
    _civ = _group createUnit [OT_NATO_Unit_Police_Heavy, _start, [], 0, "NONE"];

    _police pushBack _civ;
    [_civ, _town] call OT_fnc_initGendarm;
    _civ setBehaviour "SAFE";

    _start = _start findEmptyPosition [1, 100, OT_NATO_Unit_Police_Heavy];
    _civ = _group createUnit [OT_NATO_Unit_Police_Heavy, _start, [], 0, "NONE"];

    _police pushBack _civ;
    [_civ, _town] call OT_fnc_initGendarm;
    _civ setBehaviour "SAFE";

    if (_usecar) then {
        {
            _x moveInAny _veh;
        } forEach (units _group);

        private _drop = (([_townPos, 50, 350, 1, 0, 0, 0] call BIS_fnc_findSafePos) nearRoads 500) select 0;

        private _move = _group addWaypoint [_drop, 0];
        _move setWaypointType "MOVE";
        _move setWaypointBehaviour "CARELESS";

        _move = _group addWaypoint [_drop, 0];
        _move setWaypointType "GETOUT";
        _move setWaypointBehaviour "AWARE";

        {
            _x addCuratorEditableObjects [[_veh], true];
        } forEach allCurators;
    };

    {
        _x addCuratorEditableObjects [units _group, true];
    } forEach allCurators;

    sleep 1;

    _group call OT_fnc_initGendarmPatrol;
};

_groups;
