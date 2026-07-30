private _target = objNull;
private _cop = objNull;

if ((count _this) isEqualTo 3) then {
    //its a position
    {
        private _c = leader (group _x);
        if (side _c isEqualTo blufor && !(_c getVariable ["OT_searching", false])) exitWith { _cop = _c };
    } forEach (_this nearEntities ["CAManBase", 300]);
    if (isNil "_cop") exitWith {};
    {
        if !(side _x == blufor || side _x == opfor) exitWith { _target = _x };
    } forEach (_cop nearEntities ["CAManBase", 50]);
} else {
    _target = _this select 0;
    if ((count _this) > 1) then {
        _cop = _this select 1;
    } else {
        {
            private _c = leader (group _x);
            if (side _c isEqualTo blufor && !(_c getVariable ["OT_searching", false])) exitWith { _cop = _c };
        } forEach (_target nearEntities ["CAManBase", 150]);
    };
};
if (isNil "_cop" || isNil "_target") exitWith {};

_cop setVariable ["OT_searching", true, true];

if ((isPlayer _target) && !(captive _target)) exitWith {};

private _group = group _cop;
private _hdl = objNull;

// Store old group parameters
// Assuming every unit in the group has the same behaviour as _cop. Mapping behaviours individually would be too complex.
private _behaviour = behaviour _cop;
private _speedMode = speedMode _group;
private _currentWaypoint = currentWaypoint _group;

// Inject a temporary waypoint as the current one. Waypoint type HOLD so the group stays there until told otherwise.
private _wp = _group addWaypoint [ASLToAGL (getPosASL _target), 0, _currentWaypoint];
_wp setWaypointType "HOLD";

_group setBehaviour "AWARE";
if (isPlayer _target) then {
    [_cop, (["Stop right there!", "Halt, citizen!", "HALT!", "Stay right there, citizen"] call BIS_fnc_selectRandom)] remoteExec ["globalChat", _target, false];
    _group setSpeedMode "FULL";
    _hdl = _target addEventHandler [
        "InventoryOpened",
        {
            hint "NATO search is in progress, you cannot open your inventory";
            true; //<-- inventory override
        }
    ];
} else {
    [_target, "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon"] remoteExec ["playMove", _target, false];
    [_target, "MOVE"] remoteExec ["disableAI", _target, false];
};
private _posnow = getPos _target;
private _timenow = time;

private _cleanup = {
    params ["_group", "_cop", "_target", "_handler"];
    [_target, ""] remoteExec ["switchMove", _target, false];
    if (!isNil "_group") then {
        // Restore old group parameters
        _group setBehaviour _behaviour;
        _group setSpeedMode _speedMode;
        // Delete the temporary waypoint to allow the group to continue normally
        deleteWaypoint [_group, _currentWaypoint];
    };
    if (!isNil "_cop") then {
        _cop setVariable ["OT_searching", false, true];
        [_cop, ""] remoteExec ["switchMove", _cop, false];
    };
    if (isPlayer _target) then {
        _target removeEventHandler ["InventoryOpened", _handler];
    } else {
        [_target, "MOVE"] remoteExec ["enableAI", _target, false];
    };
};
_cop doMove ASLToAGL (getPosASL _target);
waitUntil {
    sleep 1;
    (_cop distance _target) < 7 || (_target distance _posnow) > 2 || (time - _timenow) > 120;
};
if (isNil "_cop" || isNil "_target") exitWith { [_group, _cop, _target, _hdl] call _cleanup };
if (!alive _cop || !alive _target) exitWith { [_group, _cop, _target, _hdl] call _cleanup };

if ((isPlayer _target && !captive _target) || (!alive _cop) || ((time - _timenow) > 120)) exitWith { [_group, _cop, _target, _hdl] call _cleanup };

if ((_target distance _posnow) > 2) then {
    if (isPlayer _target) then {
        [_cop, "I said stop! move again and we WILL open fire"] remoteExec ["globalChat", _target, false];
        "sectorLost" remoteExec ["playSound", _target, false];

        sleep 3;

        // Replace one temporary waypoint with another
        deleteWaypoint [_group, _currentWaypoint];
        _wp = _group addWaypoint [ASLToAGL (getPosASL _target), 0, _currentWaypoint];
        _group setBehaviour "COMBAT";

        _posnow = getPos _target;
        _timenow = time;
        _cop doMove ASLToAGL (getPosASL _target);
        waitUntil {
            sleep 2;
            (_cop distance _target) < 7 || (_target distance _posnow) > 2 || (time - _timenow) > 120;
        };
        if ((_target distance _posnow) > 2) then {
            _target setCaptive false;
            [_group, _cop, _target, _hdl] call _cleanup;
        };
    };
};
if (isNil "_cop" || isNil "_target") exitWith { [_group, _cop, _target, _hdl] call _cleanup };
if (!alive _cop || !alive _target) exitWith { [_group, _cop, _target, _hdl] call _cleanup };
[_cop, "Amovpknlmstpsraswrfldnon_gear"] remoteExec ["playMove", _cop, false];
if (isPlayer _target) then {
    [_cop, "This is a random search, stay perfectly still"] remoteExec ["globalChat", _target, false];
    sleep 5;
} else {
    sleep 15;
};

if ((isPlayer _target && !captive _target) || (!alive _cop) || ((time - _timenow) > 120)) exitWith { [_group, _cop, _target, _hdl] call _cleanup };

if ((_target distance _posnow) > 2) exitWith {
    if (isPlayer _target) then {
        "You tried to escape a NATO search" remoteExecCall ["hint", _target, false];
    };
    [_group, _cop, _target, _hdl] call _cleanup;
    _target setCaptive false;

    [_target] call OT_fnc_revealToNATO;
};

if (isPlayer _target) then {
    private _foundillegal = false;
    private _foundweapons = false;
    {
        private _cls = _x select 0;
        if (_cls in OT_allWeapons + OT_allMagazines + OT_illegalHeadgear + OT_illegalVests + OT_allStaticBackpacks + OT_allOptics) then {
            private _count = _x select 1;
            for "_i" from 1 to _count do {
                _target removeItem _cls;
                _cop addItem _cls;
            };
            _foundweapons = true;
        };
        if (_cls in OT_illegalItems) then {
            private _count = _x select 1;
            for "_i" from 1 to _count do {
                _target removeItem _cls;
                _cop addItem _cls;
            };
            _foundillegal = true;
        };
    } forEach (_target call OT_fnc_getSearchStock);

    if (_foundillegal || _foundweapons) then {
        if (_foundweapons) then {
            if (isPlayer _target) then {
                [_cop, "What's this!?"] remoteExec ["globalChat", _target, false];
                "NATO found weapons" remoteExecCall ["hint", _target, false];
            };
            _target setCaptive false;
            [_target] call OT_fnc_revealToNATO;
        } else {
            if (isPlayer _target) then {
                private _stealth = _target getVariable ["OT_stealth", 1];
                private _chance = 100;
                if (_stealth > 1) then {
                    _chance = 100 - (_stealth * 20);
                };
                if ((random 100) < _chance) then {
                    [_cop, "We found some illegal items and confiscated them, be on your way"] remoteExec ["globalChat", _target, false];
                    "NATO confiscated illegal items" remoteExecCall ["hint", _target, false];
                } else {
                    [_cop, "Thank you for your co-operation"] remoteExec ["globalChat", _target, false];
                };
            };
        };
    } else {
        [_cop, "Thank you for your co-operation"] remoteExec ["globalChat", _target, false];
    };
};
[_group, _cop, _target, _hdl] call _cleanup;
