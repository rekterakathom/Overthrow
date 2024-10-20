params ["_target","_unit",["_ammobox",false]];

if(_ammobox isEqualTo false) then {
    _ammobox = _target;
};

private _weapons = [];
private _magazines = [];
private _items = ["ItemMap"];
private _backpacks = [];

private _closed = -1;

private _missing = [];

if(_target isEqualType "") then {
    private _warehouse = [_unit] call OT_fnc_nearestWarehouse;
    if (_warehouse == objNull) exitWith {hint "No warehouse near by!"};

    // Old method, remove all items and then verify the new loadout
    //[_unit,true] call OT_fnc_dumpIntoWarehouse;
    //_unit linkItem "ItemMap";
    {
        if(_x select [0,5] isEqualTo "item_") then {
            private _d = _warehouse getVariable [_x,[_x select [5],0,[0]]];
            if(_d isEqualType [] && {_d # 1 != 0}) then {
                _items pushBack _d # 0;
            };
        };
    }forEach(allVariables _warehouse);

    // The items the unit has BEFORE they get to use the warehouse.
    private _oldUnitItems = uniqueUnitItems [_unit, 2, 2, 2, 2, true];

    _closed = ["ace_arsenal_displayClosed", {
        _thisArgs params ["_unit", "_oldUnitItems"];

        // The items the unit has AFTER they have used the warehouse.
        private _newItems = uniqueUnitItems [_unit, 2, 2, 2, 2, true];
        private _toVerify = [];
        {

            // Unit has a new item -> they took it from the warehouse!
            if !(_x in _oldUnitItems) then {
                _toVerify pushBack [_x, _y];
            } else {
                private _oldItemCount = (_oldUnitItems get _x);
                // Amount of items has changed
                if (_oldItemCount != _y) then {
                    if ((_y - _oldItemCount) > 0) then {
                        // The unit took the items!
                        _toVerify pushBack [_x, _y - _oldItemCount];
                    } else {
                        // The unit put some items in the warehouse.
                        [_x, _oldItemCount - _y] call OT_fnc_addToWarehouse;
                    };
                };
            };
        } forEach _newItems;

        // Check if units put anything in the warehouse.
        {
            // They put it in the warehouse.
            if !(_x in _newItems) then {
                [_x, _y] call OT_fnc_addToWarehouse;
            }
        } forEach _oldUnitItems;

        // Verify the item differences
        [_unit, _toVerify] call OT_fnc_verifyFromWarehouse;

        [_thisType, _thisId] call CBA_fnc_removeEventHandler;
    },[_unit, _oldUnitItems]] call CBA_fnc_addEventHandlerArgs;
}else{
    [_unit,_ammobox,true] call OT_fnc_dumpStuff;
    _unit linkItem "ItemMap";
    _weapons = weaponCargo _ammobox;
    _weapons = _weapons arrayIntersect _weapons;
    _magazines = magazineCargo _ammobox;
    _magazines = _magazines arrayIntersect _magazines;
    _items = itemCargo _ammobox;
    _items pushBack "ItemMap";
    _items = _items arrayIntersect _items;
    _backpacks = backpackCargo _ammobox;
    _backpacks = _backpacks arrayIntersect _backpacks;

    _closed = ["ace_arsenal_displayClosed", {
        _thisArgs params ["_target","_unit","_ammobox"];
        private _ignore = [];
        _boxstock = _ammobox call OT_fnc_unitStock;
        {
			_x params [["_cls",""], ["_count",0]];
            diag_log _cls;
            if !(_cls in _ignore) then {
                private _boxAmount = 0;
                {
                    if(_x#0 isEqualTo _cls) exitWith {
                        _boxAmount = _x#1;
                    };
                }forEach(_boxstock);

                if(_boxAmount < _count) then {
                    //take off the difference
                    call {
                        if(binocular _unit isEqualTo _cls) exitWith {
                            _unit removeWeapon _cls;
                            _count = 0;
                            _missing pushBack _cls;
                        };
                        if(primaryWeapon _unit isEqualTo _cls) exitWith {
                            _ignore append primaryWeaponItems _unit;
                            _unit removeWeapon _cls;
                            _count = 0;
                            _missing pushBack _cls;
                        };
                        if(secondaryWeapon _unit isEqualTo _cls) exitWith {
                            _ignore append secondaryWeaponItems _unit;
                            _unit removeWeapon _cls;
                            _count = 0;
                            _missing pushBack _cls;
                        };
                        if(handgunWeapon _unit isEqualTo _cls) exitWith {
                            _unit removeWeapon _cls;
                            _count = 0;
                            _missing pushBack _cls;
                        };
                        _totake = _count - _boxAmount;
                        if(_cls isKindOf ["Default",configFile >> "CfgMagazines"]) exitWith {
                            while{_count > _boxAmount} do {
                                _count = _count - 1;
                                _unit removeMagazine _cls;
                                _missing pushBack _cls;
                            };
    					};
                        while{_count > _boxAmount} do {
                            _count = _count - 1;
                            _unit removeItem _cls;
                            _missing pushBack _cls;
                        };
                    }
                };

                if(_count > 0) then {
                    call {
        				if(_cls isKindOf "Bag_Base") exitWith {
        					[_ammobox, _cls, _count] call CBA_fnc_removeBackpackCargo;
        				};
        				if(_cls isKindOf ["Rifle",configFile >> "CfgWeapons"]) exitWith {
        					[_ammobox, _cls, _count] call CBA_fnc_removeWeaponCargo;
        				};
        				if(_cls isKindOf ["Launcher",configFile >> "CfgWeapons"]) exitWith {
        					[_ammobox, _cls, _count] call CBA_fnc_removeWeaponCargo;
        				};
        				if(_cls isKindOf ["Pistol",configFile >> "CfgWeapons"]) exitWith {
        					[_ammobox, _cls, _count] call CBA_fnc_removeWeaponCargo;
        				};
        				if(_cls isKindOf ["Default",configFile >> "CfgMagazines"]) exitWith {
        					[_ammobox, _cls, _count] call CBA_fnc_removeMagazineCargo;
        				};
        				[_ammobox, _cls, _count] call CBA_fnc_removeItemCargo;
        			};
                };
            };
		}forEach(_unit call OT_fnc_unitStock);

        {
            if !(_x isEqualTo "ItemMap") then {
                if !([_ammobox, _x, 1] call CBA_fnc_removeItemCargo) then {
                    _unit unlinkItem _x;
                    _missing pushBack _x;
                };
            };
        }forEach(assignedItems _unit);

        private _backpack = backpack _unit;
        if !(_backpack isEqualTo "") then {
            if !(_backpack in backpackCargo _ammobox) then {
                _missing pushBack _backpack;
                //Put the items from the backpack back in the ammobox
                {
                    call {
        				if(_x isKindOf "Bag_Base") exitWith {
        					[_ammobox, _x, 1] call CBA_fnc_addBackpackCargo;
        				};
        				if(_x isKindOf ["Rifle",configFile >> "CfgWeapons"]) exitWith {
        					[_ammobox, _x, 1] call CBA_fnc_addWeaponCargo;
        				};
        				if(_x isKindOf ["Launcher",configFile >> "CfgWeapons"]) exitWith {
        					[_ammobox, _x, 1] call CBA_fnc_addWeaponCargo;
        				};
        				if(_x isKindOf ["Pistol",configFile >> "CfgWeapons"]) exitWith {
        					[_ammobox, _x, 1] call CBA_fnc_addWeaponCargo;
        				};
        				if(_x isKindOf ["Default",configFile >> "CfgMagazines"]) exitWith {
        					[_ammobox, _x, 1] call CBA_fnc_addMagazineCargo;
        				};
        				[_ammobox, _x, 1] call CBA_fnc_removeItemCargo;
        			};
                }forEach(backpackItems _unit);
                removeBackpack _unit;
            }else{
                [_ammobox, _backpack, 1] call CBA_fnc_removeBackpackCargo;
            };
        };

        private _vest = vest _unit;
        if !(_vest isEqualTo "") then {
            if !(_vest in itemCargo _ammobox) then {
                _missing pushBack _vest;
                //Put the items from the vest back in the ammobox
                {
                    call {
        				if(_x isKindOf "Bag_Base") exitWith {
        					[_ammobox, _x, 1] call CBA_fnc_addBackpackCargo;
        				};
        				if(_x isKindOf ["Rifle",configFile >> "CfgWeapons"]) exitWith {
        					[_ammobox, _x, 1] call CBA_fnc_addWeaponCargo;
        				};
        				if(_x isKindOf ["Launcher",configFile >> "CfgWeapons"]) exitWith {
        					[_ammobox, _x, 1] call CBA_fnc_addWeaponCargo;
        				};
        				if(_x isKindOf ["Pistol",configFile >> "CfgWeapons"]) exitWith {
        					[_ammobox, _x, 1] call CBA_fnc_addWeaponCargo;
        				};
        				if(_x isKindOf ["Default",configFile >> "CfgMagazines"]) exitWith {
        					[_ammobox, _x, 1] call CBA_fnc_addMagazineCargo;
        				};
        				[_ammobox, _x, 1] call CBA_fnc_removeItemCargo;
        			};
                }forEach(vestItems _unit);
                removeVest _unit;
            }else{
                [_ammobox, _vest, 1] call CBA_fnc_removeItemCargo;
            };
        };

        private _helmet = headgear _unit;
        if !(_helmet isEqualTo "") then {
            if !(_helmet in itemCargo _ammobox) then {
                _missing pushBack _helmet;
                removeHeadgear _unit;
            }else{
                [_ammobox, _helmet, 1] call CBA_fnc_removeItemCargo;
            };
        };

        private _goggles = goggles _unit;
        if !(_goggles isEqualTo "") then {
            if !(_goggles in itemCargo _ammobox) then {
                _missing pushBack _goggles;
                removeGoggles _unit;
            }else{
                [_ammobox, _goggles, 1] call CBA_fnc_removeItemCargo;
            };
        };

        [_thisType, _thisId] call CBA_fnc_removeEventHandler;
    },[_target,_unit,_ammobox]] call CBA_fnc_addEventHandlerArgs;
};

[_ammobox, true, false] call ace_arsenal_fnc_removeVirtualItems;
[_ammobox,_weapons+_magazines+_items+_backpacks,false] call ace_arsenal_fnc_addVirtualItems;

[_ammobox, _unit] call ace_arsenal_fnc_openBox;