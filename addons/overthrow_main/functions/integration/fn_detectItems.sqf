private _categorize = {
    params ["_c","_cat"];
    private _done = false;
    {
        if((_x select 0) isEqualTo _cat) exitWith {
            (_x select 1) pushBackUnique _c;
            _done = true;
        };
    }foreach(OT_items);
    if !(_done) then {
        OT_items pushback [_cat,[_c]];
    };
};

private _getprice = {
    params ["_x","_primaryCategory"];
    private _cls = configName _x;
    private _mass = 0;

    // Not every item has ItemInfo, for example RHS binoculars
    if (isNumber (_x >> "ItemInfo" >> "mass")) then {
        _mass = getNumber (_x >> "ItemInfo" >> "mass");
    } else {
        _mass = getNumber (_x >> "WeaponSlotsInfo" >> "mass");
    };

    if (_mass isEqualTo 0) then {
        diag_log format ["Overthrow: Failed to get mass for %1", _cls];
        _mass = 10; // Set the mass to something to avoid free items
    };

    private _price = round(_mass * 1.5);
    private _steel = 0;
    private _wood = 0;
    private _plastic = 0;
    private _steel = ceil(_mass * 0.2);

    if(_mass isEqualTo 1) then {
        _steel = 0.1;
    };

    if(_primaryCategory == "Pharmacy") then {
        _steel = 0;
        _plastic = ceil(_mass * 0.2);
        if(_mass isEqualTo 1) then {
            _plastic = 0.1;
        };
        private _res = [_mass] call {
            params ["_mass"];
            _price = _mass * 4;
            if("blood" in _cls) exitWith {
                _price = round(_price * 1.3);
            };
            if("saline" in _cls) exitWith {
                _price = round(_price * 0.3);
            };
            if("fieldDressing" in _cls) exitWith {
                _price = 1;
            };
            if("epinephrine" in _cls) exitWith {
                _price = 30;
                _plastic = 0;
            };
            if("bodybag" in _cls) exitWith {
                _price = 2;
                _plastic = 0.1;
            };
        };
    };

    if(_primaryCategory == "Electronics") then {
        _steel = 0;
        _plastic = ceil(_mass * 0.2);
        _price = _mass * 4;
        private _factor = [] call {
            if("altimeter" in _cls) exitWith {3};
            if("DAGR" in _cls) exitWith {7};
            if("GPS" in _cls) exitWith {1.5};
            if("_dagr" in _cls) exitWith {2};
            1
        };
        _price = round (_price * _factor);
    };

    if(_primaryCategory == "Hardware") then {
        _price = _mass;
    };

    if(_cls == "ToolKit") then {
        _price = 80;
    };

    [_price,_wood,_steel,_plastic];
};

{
    private _cls = configName _x;
    private _name = getText (_x >> "displayName");
    private _desc = getText (_x >> "descriptionShort");

    private _categorized = false;
    private _primaryCategory = "";
    {
        _x params ["_category","_types"];
        {
            if(_x in _cls || _x in _name || _x in _desc) exitWith {
                [_cls,_category] call _categorize;
                _categorized = true;
                if(_category != "General") then {
                    _primaryCategory = _category;
                };
            };
        }foreach(_types);
    }foreach(OT_itemCategoryDefinitions);

    if(_categorized) then {
        if(isServer && isNil {cost getVariable _cls}) then {
            cost setVariable [_cls,[_x,_primaryCategory] call _getprice,true];
        };

        OT_allItems pushback _cls;
    };
}foreach("
    (getNumber (_x >> 'scope') isEqualTo 2) &&
    {(configName _x call BIS_fnc_itemType) # 0 isEqualTo 'Item'}
" configClasses ( configFile >> "CfgWeapons" ));

//add Bags
{
    private _cls = configName _x;
    [_cls,"Surplus"] call _categorize;
    if (isServer && {isNil {cost getVariable _cls}}) then {
        private _mass = getNumber (_x >> "mass");
        cost setVariable [_cls,[_mass,0,0,1],true]; // the price of a bag is its mass, unless otherwise stated in prices.sqf.
    };
}foreach("
    (getNumber (_x >> 'scope') isEqualTo 2) &&
    {
        _parents = ([_x,true] call BIS_fnc_returnParents);
        'Bag_Base' in _parents &&
        {getText (_x >> 'Faction') isEqualTo 'Default'} &&
        {!('Weapon_Bag_Base' in _parents)} &&
        {count (_x >> 'TransportItems') isEqualTo 0} &&
        {count (_x >> 'TransportMagazines') isEqualTo 0} &&
        {count (_x >> 'TransportWeapons') isEqualTo 0}
    }
" configClasses ( configFile >> "CfgVehicles" )); // Bags that do not have a faction (weapon and tripod bags do), and carry no content.
//add craftable magazines
{
    private _cls = configName _x;
    private _recipe = call compileFinal getText (_x >> "ot_craftRecipe");
    private _qty = getNumber ( _x >> "ot_craftQuantity" );
    OT_craftableItems pushback [_cls,_recipe,_qty];
}foreach("getNumber (_x >> ""ot_craftable"") isEqualTo 1" configClasses ( configFile >> "CfgMagazines" ));
//add craftable weapons
{
    private _cls = configName _x;
    private _recipe = call compileFinal getText (_x >> "ot_craftRecipe");
    private _qty = getNumber ( _x >> "ot_craftQuantity" );
    OT_craftableItems pushback [_cls,_recipe,_qty];
}foreach("getNumber (_x >> ""ot_craftable"") isEqualTo 1" configClasses ( configFile >> "CfgWeapons" ));
