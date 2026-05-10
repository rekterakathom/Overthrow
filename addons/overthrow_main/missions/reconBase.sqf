params ["", "_jobparams"];
_jobparams params ["_base", "_markerPos"];

private _count = 0;
private _params = [_base, _count];
private _effect = localize "STR_MISSION_RECON_BASE_01";

//Build a mission description and title
private _description = format [localize "STR_MISSION_RECON_BASE_02", _base, _effect];
private _title = format [localize "STR_MISSION_RECON_BASE_03", _base];

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
        params ["_base", "_oldcount"];

        private _loc = server getVariable _base;
        private _players = [];
        {
            if (isPlayer _x && alive _x) then {
                _players pushBack _x;
            };
        } forEach (_loc nearEntities ["Man", OT_spawnDistance]);
        _players = _players apply { [_x distance _loc, _x] };
        _players sort true;

        if (_players isEqualTo []) exitWith { false };

        private _spawnid = spawner getVariable [format ["spawnid%1", _base], ""];
        if (_spawnid isEqualTo "") exitWith { false }; //Base has not been spawned yet
        //Get groups in spawn
        private _groups = spawner getVariable [_spawnid, []];
        if (_groups isEqualTo []) exitWith { false }; //Base is empty/not spawned atm

        private _count = 0;
        private _missedOne = false;
        {
            private _group = _x;
            if ((typeName _group isEqualTo "GROUP") && !isNull (leader _group)) then {
                if (isNull objectParent leader _group) then {
                    if ((independent knowsAbout (leader _x)) <= 1.2) then { _missedOne = true } else { _count = _count + (count units _group) }; //does the resistance know about the leader of this group?
                }; //Removed check for vehicles as static guns are sometimes unspottable
            };
        } forEach (_groups);

        if (_oldcount < _count) then {
            format [localize "STR_MISSION_RECON_BASE_04", _base, _count] remoteExec ["systemChat", _players select 0, false];
        };

        _this set [1, _count];
        !_missedOne;
    },
    {
        params ["_base", "", "_wassuccess"];

        //If mission was a success
        if (_wassuccess) then {
            private _loc = server getVariable _base;
            private _players = [];
            {
                if (isPlayer _x && alive _x) then {
                    _players pushBack _x;
                };
            } forEach (_loc nearEntities ["Man", OT_spawnDistance]);
            _players = _players apply { [_x distance _loc, _x] };
            _players sort true;

            if (_players isNotEqualTo []) then {
                [500] remoteExec ["OT_fnc_money", (_players select 0) select 1, false];
            };

            //Broadcast full recon report
            private _report = format [localize "STR_MISSION_RECON_BASE_05", _base];
            _report = _report + format [localize "STR_MISSION_RECON_BASE_06", server getVariable [format ["garrison%1", _base], 0]];
            private _allVehs = (server getVariable [format ["vehgarrison%1", _base], []]) + (server getVariable [format ["airgarrison%1", _base], []]);
            {
                _x params ["_cls", "_num"];
                _report = _report + format ["%1 x %2<br/>", _num, _cls call OT_fnc_vehicleGetName];
            } forEach (_allVehs call BIS_fnc_consolidateArray);
            _report remoteExec ["OT_fnc_notifyMinor", 0, false];
        };
    },
    _params
];
