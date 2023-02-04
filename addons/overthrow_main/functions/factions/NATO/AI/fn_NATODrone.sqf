/*
File: fn_NATODrone.sqf 

Description:
Loop that checks if a drone sees anything that it should report.

PARAMS:
_this # 0 - The drone object.
_this # 1 - The spawner object(?).
*/

params ["_drone","_obname"];
private _targets = [];

while {sleep 10; alive _drone} do {
    if (((getPos _drone) # 2) < 2) exitWith {
        //Drone has landed?
        [_drone] remoteExecCall ["OT_fnc_cleanupVehicle", _drone, false];
        spawner setVariable [format ["drone%1", _obname], objNull, false];
    };

    {
        if (alive _x) then {
            [_x, _drone, _targets] spawn {
                params ["_x", "_drone", "_targets"];
                private _type = typeOf _x;
                private _position = getPosASL _x;

                if ((_x isKindOf "StaticWeapon") && {(side _x != west)}) exitWith {
                    if (([_drone, "VIEW"] checkVisibility [getPosASL _drone, _position]) > 0.01) then {
                        _targets pushBack ["SW", ASLtoAGL _position, 100, _x];
                    };
                };

                if (_type isEqualTo OT_warehouse) exitWith {
                    if (_x call OT_fnc_hasOwner) then {
                        _targets pushBack ["WH", ASLtoAGL _position, 80, _x];
                    };
                };

                if (_type isEqualTo OT_flag_IND) exitWith {
                    _targets pushBack ["FOB", ASLtoAGL _position, 50, _x];
                };

                if (_type isEqualTo OT_item_Storage) exitWith {
                    if (([_drone, "VIEW"] checkVisibility [getPosASL _drone, _position]) > 0.01) then {
                        _targets pushBack ["AMMO", ASLtoAGL _position, 25, _x];
                    };
                };

                if ((count crew _x) > 0 && {((_x isKindOf "Car") || (_x isKindOf "Air") || (_x isKindOf "Ship")) && !(_type in (OT_allVehicles + OT_allBoats + OT_helis))}) exitWith {
                    if (side _x != west) then {
                        if (([_drone, "VIEW"] checkVisibility [getPosASL _drone, _position]) > 0.01) then {

                            //Determine threat
                            private _targetType = "V";
                            private _threat = 0;

                            call {
                                if (_type in OT_allVehicleThreats) exitWith {
                                    _threat = 150;
                                };

                                if (_x getVariable ["OT_attachedClass",""] isNotEqualTo "") exitWith {
                                    _threat = 100;
                                };

                                if (_type in OT_allPlaneThreats) exitWith {
                                    _targetType = "P";
                                    _threat = 500;
                                };

                                if (_type in OT_allHeliThreats) exitWith {
                                    _targetType = "H";
                                    _threat = 300;
                                };
                            };

                            _targets pushBack [_targetType, ASLtoAGL _position, _threat, _x];
                        };
                    };
                };
            };
        };
    } forEach ((_drone nearObjects ["Static", 500]) + (_drone nearEntities ["AllVehicles", 500]));

    //look for concentrations of troops
    private _nearMen = _drone nearEntities ["CAManBase", 200];
    private _numMil = {side _x isEqualTo west} count _nearMen;
    private _numRes = {side _x isEqualTo resistance} count _nearMen;;

    if (_numRes > 7 && {_numMil isEqualTo 0}) then {
        _targets pushBack ["INF", getPos _drone, 100, _drone];
    };

    _drone setVariable ["OT_seenTargets", _targets, false];
};
