
// This file is responsible for handling item verification -
// for players, NPC item verification method is handled by-
// fn_verifyLoadoutFromWarehouse

params ["_unit","_newItems",["_correct",true]];

private _warehouse = _unit call OT_fnc_nearestWarehouse;
if (_warehouse == objNull) exitWith {hint "No warehouse near by!"};

private _ignore = ["ItemMap"];
{
    _x params [["_cls",""], ["_count",0]];

    if (_count < 0) then {["Item %1 was passed with negative count (%2)!", _cls, _count] call BIS_fnc_error};

    if !(_cls in _ignore) then {
        
        private _boxAmount = (_warehouse getVariable [format["item_%1",_cls],[_cls,0]]) select 1;

        if(_boxAmount < _count) then {
            //take off the difference
            call {
                if (binocular _unit isEqualTo _cls) exitWith {
                    if (_correct) then {_unit removeWeapon _cls};
                    _count = 0;
                    _missing pushback _cls;
                };

                if (_cls in primaryWeaponItems _unit) exitWith {
                     if (_correct) then {_unit removePrimaryWeaponItem _cls};
                    _count = 0;
                    _missing pushback _cls;
                };

                if (primaryWeapon _unit isEqualTo _cls) exitWith {
                    if (_correct) then {
                        //_ignore append primaryWeaponItems _unit;
                        _unit removeWeapon _cls;
                    };
                    _count = 0;
                    _missing pushback _cls;
                };

                if (_cls in secondaryWeaponItems _unit) exitWith {
                    if (_correct) then {_unit removeSecondaryWeaponItem _cls};
                    _count = 0;
                    _missing pushback _cls;
                };

                if (secondaryWeapon _unit isEqualTo _cls) exitWith {
                    if (_correct) then {
                        //_ignore append secondaryWeaponItems _unit;
                        _unit removeWeapon _cls;
                    };
                    _count = 0;
                    _missing pushback _cls;
                };

                if (_cls in handgunItems _unit) exitWith {
                    if (_correct) then {_unit removeHandgunItem _cls};
                    _count = 0;
                    _missing pushback _cls;
                };

                if (handgunWeapon _unit isEqualTo _cls) exitWith {
                    if (_correct) then {_unit removeWeapon _cls};
                    _count = 0;
                    _missing pushback _cls;
                };

                if (backpack _unit == _cls) exitWith {
                    if (_correct) then {
                        {
                            [_x, 1] call OT_fnc_addToWarehouse;
                        } foreach (backpackItems _unit);
                        removeBackpack _unit;
                    };
                    _count = 0;
                    _missing pushback _cls;
                };

                if (vest _unit == _cls) exitWith {
                    if (_correct) then {
                        {
                            [_x, 1] call OT_fnc_addToWarehouse;
                        } foreach (vestItems _unit);
                        removeVest _unit;
                    };
                    _count = 0;
                    _missing pushback _cls;
                };

                if (headgear _unit == _cls) exitWith {
                    if(_correct) then {removeHeadgear _unit};
                    _count = 0;
                    _missing pushback _cls;
                };

                if (goggles _unit == _cls) exitWith {
                    if(_correct) then {removeGoggles _unit};
                    _count = 0;
                    _missing pushback _cls;
                };

                if (_cls in assignedItems _unit) exitWith {
                    if(_correct) then {_unit unlinkItem _cls};
                    _count = 0;
                    _missing pushback _cls;
                };

                _totake = _count - _boxAmount;
                if (_cls isKindOf ["Default",configFile >> "CfgMagazines"]) exitWith {
                    while {_count > _boxAmount} do {
                        _count = _count - 1;
                        if (_correct) then {_unit removeMagazine _cls};
                        _missing pushback _cls;
                    };
                };
                while {_count > _boxAmount} do {
                    _count = _count - 1;
                    if (_correct) then {_unit removeItem _cls};
                    _missing pushback _cls;
                };
            };
        };

        if (_count > 0) then {
            [_cls, _count] call OT_fnc_removeFromWarehouse;
        };
    };
} forEach (_newItems);

/*
{
    if (_x isNotEqualTo "ItemMap" && _x in _newItems) then {
        if !([_x, 1] call OT_fnc_removeFromWarehouse) then {
            if(_correct) then {_unit unlinkItem _x};
            _missing pushback _x;
        };
    };
}foreach(assignedItems _unit);


private _unitBackpack = backpack _unit;
if (_unitBackpack isNotEqualTo "" && _unitBackpack in _newItems) then {
    if !([_unitBackpack, 1] call OT_fnc_removeFromWarehouse) then {
        _missing pushback _unitBackpack;
        if(_correct) then {
            //Put the items from the backpack back in the warehouse
            {
                [_x, 1] call OT_fnc_addToWarehouse;
            }foreach(backpackItems _unit);
            removeBackpack _unit;
        };
    };
};


private _unitVest = vest _unit;
if (_unitVest isNotEqualTo "" && _unitVest in _newItems) then {
    if !([_unitVest, 1] call OT_fnc_removeFromWarehouse) then {
        _missing pushback _unitVest;
        if(_correct) then {
            //Put the items from the vest back in the warehouse
            {
                [_x, 1] call OT_fnc_addToWarehouse;
            }foreach(vestItems _unit);
            removeVest _unit;
        };
    };
};


private _unitHelmet = headgear _unit;
if (_unitHelmet isNotEqualTo "" && _unitHelmet in _newItems) then {
    if !([_unitHelmet, 1] call OT_fnc_removeFromWarehouse) then {
        _missing pushback _unitHelmet;
        if(_correct) then {removeHeadgear _unit};
    };
};


private _unitGoggles = goggles _unit;
if (_unitGoggles isNotEqualTo "" && _unitGoggles in _newItems) then {
    if !([_unitGoggles, 1] call OT_fnc_removeFromWarehouse) then {
        _missing pushback _unitGoggles;
        if(_correct) then {removeGoggles _unit};
    };
};
*/

_missing
