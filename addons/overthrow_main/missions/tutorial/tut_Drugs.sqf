//Let's find some civs to sell drugs to

private _done = player getVariable ["OT_tutesDone", []];
_done pushBackUnique "Drugs";
player setVariable ["OT_tutesDone", _done, true];

private _targets = [];

//Is there some already spawned within spawn distance?
{
    if (side _x isEqualTo civilian && !(captive _x) && !(_x getVariable ["gundealer", false]) && !(_x call OT_fnc_hasOwner)) then {
        _targets pushBack _x;
    };
} forEach (player nearEntities ["CAManBase", OT_spawnDistance]);

//No? well where is the closest town?
if (_targets isEqualTo []) exitWith {
    private _towns = [OT_townData, [], { (_x select 0) distance player }, "ASCEND"] call BIS_fnc_sortBy;
    private _town = _towns select 1;
    private _destination = _town select 0;
    _town = _town select 1;

    if (_destination isNotEqualTo []) then {
        //give waypoint
        [player, _destination, _town] call OT_fnc_givePlayerWaypoint;

        format [localize "STR_MISSION_TUTORIAL_DRUGS_01", _town] call OT_fnc_notifyMinor;

        [
            {
                player distance _this < 200;
            },
            {
                //If the player fast travelled, give time to spawn
                [
                    {
                        //loop and hope we find a target
                        [] call (OT_tutorialMissions select 1);
                    },
                    0,
                    10
                ] call CBA_fnc_waitAndExecute;
            },
            _destination
        ] call CBA_fnc_waitUntilAndExecute;
    };
};

localize "STR_MISSION_TUTORIAL_DRUGS_02" call OT_fnc_notifyMinor;
//pick the closest group and reveal

private _sorted = [_targets, [], { _x distance player }, "ASCEND"] call BIS_fnc_sortBy;
private _group = group (_sorted select 0);
player reveal [leader _group, 4];

//give waypoint
private _wp = [player, getPos leader _group, "Customer"] call OT_fnc_givePlayerWaypoint;

private _loopCode = {
    params ["_loopCode", "_wp", "_group"];
    if (!isNil "_wp") then {
        //update waypoint
        OT_missionMarker = getPosATLVisual leader _group;
        _wp setWaypointPosition [OT_missionMarker, 0];
    };
    if (player distance (leader _group) < 30) then {
        localize "STR_MISSION_TUTORIAL_DRUGS_03" call OT_fnc_notifyMinor;

        call OT_fnc_clearPlayerWaypoint;
    } else {
        [_loopCode, _this, 0.5] call CBA_fnc_waitAndExecute;
    };
};

[_loopCode, _wp, _group] call _loopCode;
