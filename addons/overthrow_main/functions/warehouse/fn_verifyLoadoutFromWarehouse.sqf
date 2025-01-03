
// This file is responsible for handling item verification -
// for NPC's, player item verification method was updated -
// and is now handled by fn_verifyFromWarehouse

params ["_unit",["_correct",true]];

private _warehouse = [_unit] call OT_fnc_nearestWarehouse;
if (_warehouse == objNull) exitWith {hint "No warehouse near by!"};

private _ignore = [];
{
    _x params [["_cls",""], ["_count",0]];
    if !(_cls in _ignore) then {
        private _boxAmount = (_warehouse getVariable [format["item_%1",_cls],[_cls,0]]) select 1;
        if(_boxAmount < _count) then {
            //take off the difference
            call {
                if(binocular _unit isEqualTo _cls) exitWith {
                    if(_correct) then {_unit removeWeapon _cls};
                    _count = 0;
                    _missing pushBack _cls;
                };
                if(primaryWeapon _unit isEqualTo _cls) exitWith {
                    if(_correct) then {
                        _ignore append primaryWeaponItems _unit;
                        _unit removeWeapon _cls;_unit removeWeapon _cls;
                    };
                    _count = 0;
                    _missing pushBack _cls;
                };
                if(secondaryWeapon _unit isEqualTo _cls) exitWith {
                    if(_correct) then {
                        _ignore append secondaryWeaponItems _unit;
                        _unit removeWeapon _cls;
                    };
                    _count = 0;
                    _missing pushBack _cls;
                };
                if(handgunWeapon _unit isEqualTo _cls) exitWith {
                    if(_correct) then {_unit removeWeapon _cls};
                    _count = 0;
                    _missing pushBack _cls;
                };
                _totake = _count - _boxAmount;
                if(_cls isKindOf ["Default",configFile >> "CfgMagazines"]) exitWith {
                    while{_count > _boxAmount} do {
                        _count = _count - 1;
                        if(_correct) then {_unit removeMagazine _cls};
                        _missing pushBack _cls;
                    };
                };
                while{_count > _boxAmount} do {
                    _count = _count - 1;
                    if(_correct) then {_unit removeItem _cls};
                    _missing pushBack _cls;
                };
            }
        };

        if(_count > 0) then {
            [_cls, _count] call OT_fnc_removeFromWarehouse;
        };
    };
}forEach(_unit call OT_fnc_unitStock);

{
    if !(_x isEqualTo "ItemMap") then {
        if !([_x, 1] call OT_fnc_removeFromWarehouse) then {
            if(_correct) then {_unit unlinkItem _x};
            _missing pushBack _x;
        };
    };
}forEach(assignedItems _unit);

private _backpack = backpack _unit;
if !(_backpack isEqualTo "") then {
    if !([_backpack, 1] call OT_fnc_removeFromWarehouse) then {
        _missing pushBack _backpack;
        if(_correct) then {
            //Put the items from the backpack back in the warehouse
            {
                [_x, 1] call OT_fnc_addToWarehouse;
            }forEach(backpackItems _unit);
            removeBackpack _unit;
        };
    };
};

private _vest = vest _unit;
if !(_vest isEqualTo "") then {
    if !([_vest, 1] call OT_fnc_removeFromWarehouse) then {
        _missing pushBack _vest;
        if(_correct) then {
            //Put the items from the vest back in the warehouse
            {
                [_x, 1] call OT_fnc_addToWarehouse;
            }forEach(vestItems _unit);
            removeVest _unit;
        };
    };
};

private _helmet = headgear _unit;
if !(_helmet isEqualTo "") then {
    if !([_helmet, 1] call OT_fnc_removeFromWarehouse) then {
        _missing pushBack _helmet;
        if(_correct) then {removeHeadgear _unit};
    };
};

private _goggles = goggles _unit;
if !(_goggles isEqualTo "") then {
    if !([_goggles, 1] call OT_fnc_removeFromWarehouse) then {
        _missing pushBack _goggles;
        if(_correct) then {removeGoggles _unit};
    };
};

_missing
