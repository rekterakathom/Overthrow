//This code is called by the gun dealer or faction rep to retrieve the description and parameters of the mission
private _title = localize "STR_MISSION_KILL_01";

private _groups = [allGroups, [], { (leader _x) distance2D player }, "ASCEND", { (side leader _x) isEqualTo blufor && (units _x) isNotEqualTo [] && ((leader _x) distance2D player) < 300 }] call BIS_fnc_sortBy;
if (_groups isEqualTo []) exitWith { [] };

private _group = _groups select 0;
private _numtokill = count units _group;

private _reward = _numtokill * 25;

//Build a mission description
private _description = format [localize "STR_MISSION_KILL_02", _numtokill, _reward];
private _params = [_group, _reward, _numtokill];

//The data below is what is returned to the gun dealer/faction rep, _markerPos is where to put the mission marker, the code in {} brackets is the actual mission code, only run if the player accepts
[
    [_title, _description],
    getPos player,
    {
        //No setup
        true;
    },
    {
        //No fail
        false;
    },
    {
        //Success Check
        params ["_group", "", "_numtokill"];
        private _numleft = { alive _x } count (units _group);
        hint format [localize "STR_MISSION_KILL_03", _numtokill - _numleft, _numtokill];
        _numleft isEqualTo 0;
    },
    {
        params ["", "_reward", "", "_wassuccess"];
        if (_wassuccess) then {
            [_reward] call OT_fnc_money;
        };
    },
    _params
];
