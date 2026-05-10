params ["_jobid", "_jobparams"];
_jobparams params ["_town"];

private _markerPos = server getVariable [_town, []];

private _effect = localize "STR_MISSION_TAGGING_01";

//Build a mission description and title
private _description = format [localize "STR_MISSION_TAGGING_02", _town, _effect];
private _title = format [localize "STR_MISSION_TAGGING_03", _town];
private _startValue = server getVariable [format ["tagsin%1", _town], 0];
private _params = [_town, _startValue];

//The data below is what is returned to the gun dealer/faction rep, _markerPos is where to put the mission marker, the code in {} brackets is the actual mission code, only run if the player accepts
[
    [_title, _description],
    _markerPos,
    {
        //No setup required for this mission
        true;
    },
    {
        //Fail check...
        false;
    },
    {
        //Success Check
        params ["_town", "_startValue"];

        (server getVariable [format ["tagsin%1", _town], 0]) == _startValue + 5;
    },
    {
        params ["_town", "_startValue", "_wassuccess"];

        //If mission was a success
        if (_wassuccess) then {
            private _player = spawner getVariable [format ["lasttagin%1", _town], player];
            [
                200
            ] remoteExec ["OT_fnc_money", _player, false];
            [_town, 5] call OT_fnc_support;
        };
    },
    _params
];
