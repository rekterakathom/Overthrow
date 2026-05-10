//Let's find some wrecks to salvage

private _done = player getVariable ["OT_tutesDone", []];
_done pushBackUnique "Economy";
player setVariable ["OT_tutesDone", _done, true];

private _actualMission = {
    private _targets = [];

    //Is there some already spawned within spawn distance?
    {
        if (damage _x > 0.9) then {
            _targets pushBack _x;
        };
    } forEach (player nearObjects ["Car", OT_spawnDistance]);

    //No? well where is the closest town?
    if (_targets isEqualTo []) exitWith {
        private _towns = [OT_townData, [], { (_x select 0) distance player }, "ASCEND"] call BIS_fnc_sortBy;
        private _town = _towns select 1;
        private _destination = _town select 0;
        _town = _town select 1;

        if (_destination isNotEqualTo []) then {
            //give waypoint
            [player, _destination, _town] call OT_fnc_givePlayerWaypoint;

            format [localize "STR_MISSION_TUTORIAL_ECONOMY_01", _town] call OT_fnc_notifyMinor;

            [
                {
                    player distance _this < 200;
                },
                {
                    //If the player fast travelled, give time to spawn
                    [
                        {
                            //loop and hope we find a target
                            [] call (OT_tutorialMissions select 2);
                        },
                        0,
                        10
                    ] call CBA_fnc_waitAndExecute;
                },
                _destination
            ] call CBA_fnc_waitUntilAndExecute;
        } else {
            //I guess resistance controls the entire map, gg
        };
    };

    localize "STR_MISSION_TUTORIAL_ECONOMY_02" call OT_fnc_notifyMinor;

    private _sorted = [_targets, [], { _x distance player }, "ASCEND"] call BIS_fnc_sortBy;
    private _veh = _sorted select 0;
    player reveal [_veh, 4];

    //give waypoint
    [player, getPos _veh, "Wreck"] call OT_fnc_givePlayerWaypoint;

    private _loopCode = {
        params ["_loopCode", "_veh"];
        if (player distance _veh < 10 && "ToolKit" in items player) then {
            localize "STR_MISSION_TUTORIAL_ECONOMY_03" call OT_fnc_notifyMinor;
            call OT_fnc_clearPlayerWaypoint;
        } else {
            [_loopCode, _this, 0.5] call CBA_fnc_waitAndExecute;
        };
    };
    [_loopCode, _veh] call _loopCode;
};

//First do we have a toolkit?
if !("ToolKit" in items player) then {
    localize "STR_MISSION_TUTORIAL_ECONOMY_04" call OT_fnc_notifyMinor;
    private _home = player getVariable "home";
    [player, _home, "Grab Toolkit"] call OT_fnc_givePlayerWaypoint;
    private _loop = {
        params ["_loop", "_actualMission"];
        if ("ToolKit" in items player) then {
            call _actualMission;
        } else {
            [_loop, _this, 5] call CBA_fnc_waitAndExecute;
        };
    };
    [_loop, _actualMission] call _loop;
} else {
    call _actualMission;
};
