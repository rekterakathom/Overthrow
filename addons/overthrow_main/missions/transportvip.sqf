//This code is called by the gun dealer or faction rep to retrieve the description and parameters of the mission
params ["", "_jobparams"];
_jobparams params ["_faction"];

private _factionName = server getVariable format ["factionname%1", _faction];
private _pickupTown = "";
private _startpos = getPos player;
private _pickup = [];
private _destinationTown = "";
private _destination = [];

//Here is where we might randomize the parameters a bit
//Find a pickup town
{
    private _town = _x;
    private _posTown = server getVariable _town;
    if ([_posTown, _startpos] call OT_fnc_regionIsConnected) exitWith {
        _pickupTown = _town;
        private _building = [_posTown, OT_allHouses] call OT_fnc_getRandomBuilding;
        _pickup = selectRandom (_building call BIS_fnc_buildingPositions);
        if (isNil "_pickup") then {
            _pickup = _posTown findEmptyPosition [5, 100, OT_civType_local];
        };
    };
} forEach ([OT_allTowns, [], { random 100 }, "ASCEND"] call BIS_fnc_sortBy);

//Find a destination town
{
    private _town = _x;
    private _posTown = server getVariable _town;
    if ([_posTown, _pickup] call OT_fnc_regionIsConnected) exitWith {
        _destinationTown = _town;
        private _building = [_posTown, OT_allHouses] call OT_fnc_getRandomBuilding;
        _destination = getPos _building;
        if (isNil "_destination") then {
            _destination = _posTown findEmptyPosition [5, 100, OT_civType_local];
        };
    };
} forEach ([OT_allTowns, [], { random 100 }, "ASCEND"] call BIS_fnc_sortBy);

//Give our VIP an identity
private _identity = call OT_fnc_randomLocalIdentity;
_identity pushBack (selectRandom OT_voices_local);

private _firstname = OT_firstNames_local # (_identity # 2 # 0);
private _lastname = OT_lastNames_local # (_identity # 2 # 1);
private _fullname = format ["%1 %2", _firstname, _lastname];

private _params = [_faction, _pickup, _destination, _identity];
private _markerPos = _destination;

//Build a mission description and title
private _description = format [localize "STR_MISSION_TRANSPORT_VIP_01", _fullname, _pickupTown, _destinationTown, _factionName];
private _title = format [localize "STR_MISSION_TRANSPORT_VIP_02", _factionName];

//The data below is what is returned to the gun dealer/faction rep, _markerPos is where to put the mission marker, the code in {} brackets is the actual mission code, only run if the player accepts
[
    [_title, _description],
    _markerPos,
    {
        params ["", "_pickup", "", "_identity"];

        //Spawn the dude
        private _civ = (group player) createUnit [OT_civType_gunDealer, _pickup, [], 0, "NONE"];
        _civ setVariable ["notalk", true, true]; //Tells Overthrow this guy cannot be recruited etc

        [_civ, _identity] call OT_fnc_applyIdentity;

        //Make sure hes in our group
        [_civ] joinSilent nil;
        [_civ] joinSilent (group player);
        commandStop _civ;

        //And not wanted
        _civ setCaptive true;
        _civ addItem "ItemRadio";

        //Save him for access later
        _this pushBack _civ;
        true;
    },
    {
        //Fail check...
        //If target is dead
        params ["", "", "", "", "_civ"];
        !alive _civ;
    },
    {
        //Success Check
        params ["", "", "_destination", "", "_civ"];
        //near the destination and not in a vehicle
        ((_civ distance _destination) < 50) && isNull objectParent _civ;
    },
    {
        //Cleanup
        params ["_faction", "", "", "", "_civ", "_wassuccess"];

        private _group = createGroup civilian;
        [_civ] joinSilent nil;
        [_civ] joinSilent _group;
        [_group] call OT_fnc_cleanup;

        if (_wassuccess) then {
            [
                {
                    params ["_faction"];
                    private _factionName = server getVariable format ["factionname%1", _faction];
                    format [localize "STR_MISSION_TRANSPORT_VIP_03", _factionName] remoteExec ["OT_fnc_notifyMinor", 0, false];
                    server setVariable [format ["standing%1", _faction], (server getVariable [format ["standing%1", _faction], 0]) + 5, true];
                    [250] call OT_fnc_money;
                },
                [_faction],
                2
            ] call CBA_fnc_waitAndExecute;
        } else {
            private _factionName = server getVariable format ["factionname%1", _faction];
            format [localize "STR_MISSION_TRANSPORT_VIP_04", _factionName] remoteExec ["OT_fnc_notifyMinor", 0, false];
            server setVariable [format ["standing%1", _faction], (server getVariable [format ["standing%1", _faction], 0]) - 10, true];
        };
    },
    _params
];
