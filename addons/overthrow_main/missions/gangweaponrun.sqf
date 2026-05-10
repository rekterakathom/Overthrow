params ["", "_jobparams"];
_jobparams params ["_gangid"];
private _gang = OT_civilians getVariable [format ["gang%1", _gangid], []];

private _startpos = getPos player;
private _destination = [];
private _destinationName = "";
private _gangname = _gang select 8;
private _gangtown = _gang select 2;
private _guncls = selectRandom OT_allHandguns;
private _gunname = _guncls call OT_fnc_weaponGetName;

{
    private _town = _x;
    private _posTown = server getVariable _town;
    if ([_posTown, _startpos] call OT_fnc_regionIsConnected) exitWith {
        _destinationName = _town;
        private _building = [_posTown, OT_allHouses] call OT_fnc_getRandomBuilding;
        _destination = selectRandom (_building call BIS_fnc_buildingPositions);
        if (isNil "_destination") then {
            _destination = _posTown findEmptyPosition [5, 100, OT_civType_local];
        };
    };
} forEach ([OT_allTowns, [], { random 100 }, "ASCEND", { _x isNotEqualTo _gangtown }] call BIS_fnc_sortBy);

private _reward = floor ((_startpos distance2D _destination) * 0.04);

private _markerPos = _destination;
private _params = [_destination, _gangid, _guncls, _reward];

//Build a mission description and title
private _description = format [localize "STR_MISSION_GANG_WEAPON_RUN_01", _gunname, _destinationName, _gangname, _reward];
private _title = format [localize "STR_MISSION_GANG_WEAPON_RUN_02", _gangname, _gunname];

//The data below is what is returned to the gun dealer/faction rep, _markerPos is where to put the mission marker, the code in {} brackets is the actual mission code, only run if the player accepts
[
    [_title, _description],
    _markerPos,
    {
        params ["_destination", "", "_guncls"];
        if !(player canAdd _guncls) exitWith {
            localize "STR_MISSION_GANG_WEAPON_RUN_03" call OT_fnc_notifyMinor;
            false;
        };
        private _group = createGroup civilian;
        _group setBehaviour "CARELESS";
        private _civ = _group createUnit [OT_civType_local, _destination, [], 0, "NONE"];
        _civ disableAI "MOVE";
        _civ setVariable ["OT_delivery", [_guncls, 1], true];

        private _identity = call OT_fnc_randomLocalIdentity;
        _identity pushBack (selectRandom OT_voices_local);
        [_civ, _identity] call OT_fnc_applyIdentity;

        //Make sure hes in the group
        [_civ] joinSilent nil;
        [_civ] joinSilent _group;
        _civ setVariable ["NOAI", true, false];
        _group setVariable ["Vcm_Disable", true, true];
        _this pushBack _civ;

        //give the items to the player
        player addItem _guncls;
        format [localize "STR_MISSION_GANG_WEAPON_RUN_04", _guncls call OT_fnc_weaponGetName] call OT_fnc_notifyMinor;
        true;
    },
    {
        //Fail check... is customer ded?
        params ["", "", "", "", "_civ"];
        !alive _civ;
    },
    {
        //Success Check.. items were delivered
        params ["", "", "", "", "_civ"];
        _civ getVariable ["OT_deliveryDone", false];
    },
    {
        params ["", "_gangid", "_guncls", "_reward", "_civ", "_wassuccess"];
        _civ call OT_fnc_cleanup;

        //If mission was a success
        if (_wassuccess) then {
            _player = _civ getVariable ["OT_deliveredBy", objNull];
            //apply standing and pay money
            [
                _reward,
                format [
                    localize "STR_MISSION_GANG_WEAPON_RUN_05",
                    _guncls call OT_fnc_weaponGetName
                    //,_gang select 8
                ]
            ] remoteExec ["OT_fnc_money", _player, false];
            [_player, _gangid, 5] call OT_fnc_gangRep;
            //Give resources to the gang
            private _gang = OT_civilians getVariable [format ["gang%1", _gangid], []];
            _gang params ["", "", "", "", "", "", "_resources"];
            _gang set [6, _resources + 100];
            OT_civilians setVariable [format ["gang%1", _gangid], _gang, true];
        } else {
            [_player, _gangid, -5, format [localize "STR_MISSION_GANG_WEAPON_RUN_06", _guncls call OT_fnc_weaponGetName]] call OT_fnc_gangRep;
        };
    },
    _params
];
