params ["_start", "_name", "_spawnid"];
sleep random 0.2;

private _numNATO = server getVariable format ["garrison%1", _name];
if (isNil "_numNATO") then {
    //New checkpoint was added
    _numNATO = 6 + round (random 4);
    server setVariable [format ["garrison%1", _name], _numNATO, true];
};
if (_numNATO <= 0) exitWith { [] };

private _road = [_start] call BIS_fnc_nearestRoad;
if (isNil "_road") exitWith {
    diag_log format ["Overthrow: WARNING: Couldnt find road for %1 %2", _name, _start];
    [];
};

_start = getPos _road;

if (_start isEqualTo [] || _start # 1 isEqualTo 0) exitWith {
    diag_log format ["Overthrow: WARNING: Couldnt find road for %1 %2", _name, _start];
    [];
};

private _roadscon = roadsConnectedTo _road;
private _dir = (_road getDir (_roadscon select 0));
if (isNil "_dir") then { _dir = 90 };

private _vehs = [_start, _dir, OT_tpl_checkpoint] call BIS_fnc_objectsMapper;

private _groups = [];

private _count = 0;

private _group = createGroup blufor;
_group setVariable ["VCM_TOUGHSQUAD", true, true];
_group setVariable ["VCM_NORESCUE", true, true];
_groups pushBack _group;
private _groupcount = 1;

_start = _start getPos [7, _dir - 90];

private _civ = _group createUnit [OT_NATO_Unit_TeamLeader, _start, [], 0, "NONE"];
_civ setVariable ["garrison", _name, false];
_civ setRank "MAJOR";
[_civ, _name] call OT_fnc_initMilitary;
_civ setBehaviour "SAFE";
sleep 0.5;

{
    if (_x isKindOf "StaticWeapon") then {
        _group addVehicle _x;
        createVehicleCrew _x;
        ((crew _x) select 0) setVariable ["NOAI", true, false];
        (crew _x) joinSilent _group;

        {
            _x addCuratorEditableObjects [[_x], true];
        } forEach (allCurators);

        sleep 0.5;
    };
    _groups pushBack _x;
} forEach (_vehs);

_count = _count + 1;
sleep 0.3;
while { _count < _numNATO } do {
    _start = _start getPos [2, _dir - 180];
    _civ = _group createUnit [selectRandom OT_NATO_Units_LevelTwo, _start, [], 0, "NONE"];
    _civ setVariable ["garrison", _name, false];
    _civ setRank "CAPTAIN";
    [_civ, _name] call OT_fnc_initMilitary;
    _civ setBehaviour "SAFE";
    sleep 0.5;
    _count = _count + 1;
    _groupcount = _groupcount + 1;
    if (_count isEqualTo 2) then {
        _start = _start getPos [20, _dir + 90];
    };
};
_group spawn OT_fnc_initNATOCheckpoint;
{
    _x addCuratorEditableObjects [units _group, true];
} forEach (allCurators);

spawner setVariable [_spawnid, _groups, false];
