private _handled = false;

if (!dialog) then {
    if ((player nearObjects [OT_workshopBuilding, 10]) isNotEqualTo []) then {
        [] call OT_fnc_workshopDialog;
    } else {
        if (!isNull objectParent player && (nearestObjects [player, OT_portBuilding, 30]) isNotEqualTo []) then {
            createDialog "OT_dialog_vehicleport";
            private _ft = server getVariable ["OT_fastTravelType", 1];
            if (!OT_adminMode && _ft > 1) then {
                ctrlEnable [1600, false];
            };
        } else {
            if (player getVariable ["OT_tute_trigger", false]) then {
                player setVariable ["OT_tute_trigger", false, true];
                [] spawn {
                    hint format [localize "STR_EVENT_KEY_HANDLER_01", "ShowMap" call OT_fnc_getAssignedKey];

                    private _acekey = "Left Windows (default)";
                    private _acebind = ["ACE3 Common", "ace_interact_menu_InteractKey"] call CBA_fnc_getKeybind;
                    if (_acebind isNotEqualTo []) then {
                        _acekey = (cba_keybinding_keynames) getVariable [str ((_acebind select 5) select 0), _acekey];
                    };

                    sleep 3;
                    [
                        format [localize "STR_EVENT_KEY_HANDLER_02", "ShowMap" call OT_fnc_getAssignedKey
                        ],
                        0,
                        0.2,
                        120,
                        1,
                        0,
                        2
                    ] call OT_fnc_dynamicText;

                    waitUntil {
                        uiSleep 1;
                        visibleMap;
                    };

                    hint format [
                        localize "STR_EVENT_KEY_HANDLER_03"
                    ];
                    sleep 3;
                    [
                        format [
                            localize "STR_EVENT_KEY_HANDLER_04"
                        ],
                        -0.5,
                        0.5,
                        240,
                        1,
                        0,
                        2
                    ] call OT_fnc_dynamicText;

                    waitUntil {
                        uiSleep 1;
                        !visibleMap;
                    };
                    hint "";
                    sleep 3;

                    [
                        format [
                            localize "STR_EVENT_KEY_HANDLER_05",
                            _acekey
                        ],
                        0,
                        0.2,
                        20,
                        1,
                        0,
                        2
                    ] call OT_fnc_dynamicText;

                    sleep 20;
                    private _gundealer = spawner getVariable format ["gundealer%1", player call OT_fnc_nearestTown];
                    [player, getPos _gundealer, "Gun Dealer"] call OT_fnc_givePlayerWaypoint;
                    sleep 3;
                    hint localize "STR_EVENT_KEY_HANDLER_06";

                    waitUntil {
                        uiSleep 1;
                        (player distance2D getPosASL _gundealer) < 5;
                    };

                    private _lines = [
                        localize "STR_EVENT_KEY_HANDLER_07",
                        format [localize "STR_EVENT_KEY_HANDLER_08", name player],
                        localize "STR_EVENT_KEY_HANDLER_09"
                    ];

                    _gundealer = spawner getVariable format ["gundealer%1", player call OT_fnc_nearestTown];
                    private _done = {
                        private _options = [
                            [
                                localize "STR_EVENT_KEY_HANDLER_10",
                                {
                                    private _gundealer = spawner getVariable format ["gundealer%1", player call OT_fnc_nearestTown];
                                    [
                                        player,
                                        _gundealer,
                                        [
                                            (_this select 0),
                                            localize "STR_EVENT_KEY_HANDLER_11",
                                            localize "STR_EVENT_KEY_HANDLER_12",
                                            localize "STR_EVENT_KEY_HANDLER_13",
                                            localize "STR_EVENT_KEY_HANDLER_14",
                                            localize "STR_EVENT_KEY_HANDLER_15"
                                        ],
                                        {
                                            hint format [localize "STR_EVENT_KEY_HANDLER_16", "Gear" call OT_fnc_getAssignedKey];
                                            [
                                                {
                                                    playSound "3DEN_notificationDefault";
                                                    [] call (OT_tutorialMissions select 0);
                                                    hint localize "STR_EVENT_KEY_HANDLER_17";
                                                    player setVariable ["OT_tute_inProgress", false];
                                                },
                                                0,
                                                10
                                            ] call CBA_fnc_waitAndExecute;
                                        }
                                    ] call OT_fnc_doConversation;
                                    player addItemToUniform OT_item_BasicGun;
                                    player addItemToUniform OT_item_BasicAmmo;
                                    player addItemToUniform OT_item_BasicAmmo;
                                    player addItemToUniform OT_item_BasicAmmo;
                                }
                            ],
                            [
                                format [localize "STR_EVENT_KEY_HANDLER_18", OT_nation],
                                {
                                    private _gundealer = spawner getVariable format ["gundealer%1", player call OT_fnc_nearestTown];
                                    [
                                        player,
                                        _gundealer,
                                        [
                                            (_this select 0),
                                            localize "STR_EVENT_KEY_HANDLER_19",
                                            localize "STR_EVENT_KEY_HANDLER_20",
                                            localize "STR_EVENT_KEY_HANDLER_21",
                                            localize "STR_EVENT_KEY_HANDLER_12",
                                            format [
                                                localize "STR_EVENT_KEY_HANDLER_22",
                                                OT_nation
                                            ],
                                            localize "STR_EVENT_KEY_HANDLER_23",
                                            localize "STR_EVENT_KEY_HANDLER_24"
                                        ],
                                        {
                                            hint format [ localize "STR_EVENT_KEY_HANDLER_25", "Gear" call OT_fnc_getAssignedKey];
                                            [
                                                {
                                                    playSound "3DEN_notificationDefault";
                                                    // No mission here, so just clear the gun dealer waypoint.
                                                    call OT_fnc_clearPlayerWaypoint;
                                                    hint localize "STR_EVENT_KEY_HANDLER_17";
                                                    player setVariable ["OT_tute_inProgress", false];
                                                },
                                                1,
                                                10
                                            ] call CBA_fnc_waitAndExecute;
                                        }
                                    ] call OT_fnc_doConversation;
                                    player addItemToUniform OT_item_BasicGun;
                                    player addItemToUniform OT_item_BasicAmmo;
                                    player addItemToUniform OT_item_BasicAmmo;
                                    player addItemToUniform OT_item_BasicAmmo;
                                }
                            ],
                            [
                                localize "STR_EVENT_KEY_HANDLER_26",
                                {
                                    private _gundealer = spawner getVariable format ["gundealer%1", player call OT_fnc_nearestTown];
                                    [
                                        player,
                                        _gundealer,
                                        [
                                            (_this select 0),
                                            localize "STR_EVENT_KEY_HANDLER_27",
                                            localize "STR_EVENT_KEY_HANDLER_12",
                                            localize "STR_EVENT_KEY_HANDLER_28",
                                            localize "STR_EVENT_KEY_HANDLER_14",
                                            localize "STR_EVENT_KEY_HANDLER_29"
                                        ],
                                        {
                                            hint format [localize "STR_EVENT_KEY_HANDLER_30", "Gear" call OT_fnc_getAssignedKey];
                                            [
                                                {
                                                    playSound "3DEN_notificationDefault";
                                                    [] call (OT_tutorialMissions select 1);
                                                    hint localize "STR_EVENT_KEY_HANDLER_17";
                                                    player setVariable ["OT_tute_inProgress", false];
                                                },
                                                2,
                                                10
                                            ] call CBA_fnc_waitAndExecute;
                                        }
                                    ] call OT_fnc_doConversation;
                                    player addItemToUniform "OT_Ganja";
                                }
                            ],
                            [
                                localize "STR_EVENT_KEY_HANDLER_31",
                                {
                                    private _gundealer = spawner getVariable format ["gundealer%1", player call OT_fnc_nearestTown];
                                    [
                                        player,
                                        _gundealer,
                                        [
                                            (_this select 0),
                                            localize "STR_EVENT_KEY_HANDLER_32",
                                            localize "STR_EVENT_KEY_HANDLER_33",
                                            localize "STR_EVENT_KEY_HANDLER_34"
                                        ],
                                        {
                                            hint format [
                                                localize "STR_EVENT_KEY_HANDLER_35"
                                            ];
                                            [
                                                {
                                                    playSound "3DEN_notificationDefault";
                                                    [] call (OT_tutorialMissions select 2);
                                                    localize "STR_EVENT_KEY_HANDLER_17";
                                                    player setVariable ["OT_tute_inProgress", false];
                                                },
                                                3,
                                                10
                                            ] call CBA_fnc_waitAndExecute;
                                        }
                                    ] call OT_fnc_doConversation;
                                }
                            ]
                        ];

                        _options call OT_fnc_playerDecision;
                    };
                    [_gundealer, player, _lines, _done] call OT_fnc_doConversation;
                };
            };
            if (hcShownBar && (hcSelected player) isNotEqualTo []) exitWith {
                createDialog "OT_dialog_squad";
            };
            if (!hcShownBar && ((groupSelectedUnits player) findIf { !isPlayer _x } != -1)) exitWith {
                {
                    if (isPlayer _x) then {
                        player groupSelectUnit [_x, false];
                    };
                } forEach (groupSelectedUnits player);
                createDialog "OT_dialog_command";
            };
            if (!isNull objectParent player) exitWith {
                private _ferry = player getVariable ["OT_ferryDestination", []];
                if (count _ferry isEqualTo 3) exitWith {
                    private _veh = vehicle player;

                    disableUserInput true;
                    private _town = _ferry call OT_fnc_nearestTown;

                    private _cost = player getVariable ["OT_ferryCost", 0];
                    if ((player getVariable ["money", 0]) < _cost) exitWith {
                        localize "STR_EVENT_KEY_HANDLER_36" call OT_fnc_notifyMinor;
                        disableUserInput false;
                    };
                    [-_cost] call OT_fnc_money;
                    cutText [format ["Skipping ferry to %1", _town], "BLACK", 2];
                    player setVariable ["OT_ferryDestination", [], false];
                    [_ferry, _veh] spawn {
                        params ["_pos", "_veh"];
                        sleep 2;
                        private _driver = driver _veh;
                        private _e = [];
                        {
                            private _p = _pos getPos [random 50, random 360];
                            moveOut _x;
                            _x allowDamage false;
                            _x setPos _p;
                            _e pushBack _x;
                        } forEach (crew vehicle player);
                        sleep 2;
                        disableUserInput false;
                        cutText ["", "BLACK IN", 3];
                        [_veh] call OT_fnc_cleanupVehicle;
                        [_driver] call OT_fnc_cleanupUnit;
                        {
                            _x allowDamage true;
                        } forEach (_e);
                    };
                };
                call {
                    if (driver vehicle player != player) exitWith {
                        [] spawn OT_fnc_mainMenu;
                    };
                    if (call OT_fnc_playerIsAtWarehouse) exitWith {
                        createDialog "OT_dialog_vehiclewarehouse";
                    };
                    if (call OT_fnc_playerIsAtHardwareStore) exitWith {
                        createDialog "OT_dialog_vehiclehardware";
                    };
                    if (call OT_fnc_playerIsAtStore) exitWith {
                        createDialog "OT_dialog_vehiclestore";
                    };
                    createDialog "OT_dialog_vehicle";
                    [] spawn OT_fnc_vehicleDialog;
                };
            };

            private _cTarget = cursorTarget;
            if ((_cTarget isKindOf "CAManBase") && (alive _cTarget) && (!isPlayer _cTarget) && (side _cTarget isNotEqualTo blufor) && (_cTarget distance player) < 10) exitWith {
                _cTarget call OT_fnc_talkToCiv;
            };
            [] spawn OT_fnc_mainMenu;
        };
    };
} else {
    closeDialog 0;
};
_handled = true;

_handled;
