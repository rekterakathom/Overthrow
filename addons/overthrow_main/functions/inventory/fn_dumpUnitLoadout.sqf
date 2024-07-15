/*
    Description:
    Adds the entire loadout of the unit to the target container, detaching every attachment and
    magazine from weapons, unloading all contents from backpack, vest and uniform and replacing all
    vanilla medical items with ACE ones, except the unit's uniform is not added. The unit's loadout
    is not cleared, so after execution the items can be found both in the container and the unit.

    Parameters:
        _unit: OBJECT - Unit which has the loadout to add
        _target: OBJECT - Target container or vehicle where the content is added

    Usage:
    [player, _ammoBox] call OT_fnc_dumpUnitLoadout;

    Returns: Nothing
*/

params ["_unit", "_target"];

// Helper function for dumping uniform, vest and backpack contents in the format given by
// getUnitLoadout
private _fnc_dumpLoadoutContainer = {
    params ["_content", "_target"];

    {
        if (count _x isEqualTo 3) then {
            // Magazine in format ["class", amount, ammo]
            _target addMagazineAmmoCargo _x;
        } else {
            if (_x # 0 isEqualType []) then {
                // Weapon in format [[weaponItems], amount]
                // Binocular and disposable launcher magazines cannot be changed in game, so keep
                // them attached. For other weapons, detach all attachments and magazines.
                if ((_x # 0 # 0) isKindOf ["Binocular", configFile >> "CfgWeapons"] || isArray (configFile >> "CBA_DisposableLaunchers" >> (_x # 0 # 0))) then {
                    _target addWeaponWithAttachmentsCargoGlobal _x;
                } else {
                    [(_x # 0), (_x # 1), _target] call OT_fnc_dumpWeapon;
                };
            } else {
                if (_x # 1 isEqualType 0) then {
                    // Item in format ["class", amount]
                    [(_x # 0), (_x # 1), _target] call OT_fnc_dumpItem;
                } else {
                    // Subcontainer in format ["class", isBackpack]
                    // Subcontainers are not allowed to contain items (e.g. items inside a backpack
                    // inside soldier's backpack) so we don't need to check its contents.
                    if (_x # 1) then {
                        // Many backpack classes have some default items in their inventory. Call
                        // BIS_fnc_basicBackpack to find the corresponding backpack class with no
                        // items.
                        _target addBackpackCargoGlobal [((_x # 0) call BIS_fnc_basicBackpack), 1];
                    } else {
                        _target addItemCargoGlobal [(_x # 0), 1];
                    };
                };
            };
        };
    } forEach (_content);
};

private _loadout = getUnitLoadout _unit;

private _primaryWeapon = _loadout # 0;
if (_primaryWeapon isNotEqualTo []) then {
    [_primaryWeapon, 1, _target] call OT_fnc_dumpWeapon;
};

private _secondaryWeapon = _loadout # 1;
if (_secondaryWeapon isNotEqualTo []) then {
    // Disposable launcher magazines cannot be changed in game, so keep them attached. For other
    // launchers, detach all attachments and magazines.
    if (isArray (configFile >> "CBA_DisposableLaunchers" >> _secondaryWeapon # 0)) then {
        _target addWeaponWithAttachmentsCargoGlobal [_secondaryWeapon, 1];
    } else {
        [_secondaryWeapon, 1, _target] call OT_fnc_dumpWeapon;
    };
};

private _handWeapon = _loadout # 2;
if (_handWeapon isNotEqualTo []) then {
    [_handWeapon, 1, _target] call OT_fnc_dumpWeapon;
};

private _uniform = _loadout # 3;
if (_uniform isNotEqualTo []) then {
    // Do not add the uniform itself
    [_uniform # 1, _target] call _fnc_dumpLoadoutContainer;
};

private _vest = _loadout # 4;
if (_vest isNotEqualTo []) then {
    _target addItemCargoGlobal [(_vest # 0), 1];
    [_vest # 1, _target] call _fnc_dumpLoadoutContainer;
};

private _backpack = _loadout # 5;
if (_backpack isNotEqualTo []) then {
    // Many backpack classes have some default items in their inventory. Call BIS_fnc_basicBackpack
    // to find the corresponding backpack class with no items.
    _target addBackpackCargoGlobal [((_backpack # 0) call BIS_fnc_basicBackpack), 1];
    [_backpack # 1, _target] call _fnc_dumpLoadoutContainer;
};

private _headgear = _loadout # 6;
if (_headgear isNotEqualTo "") then {
    _target addItemCargoGlobal [_headgear, 1];
};

private _goggles = _loadout # 7;
if (_goggles isNotEqualTo "") then {
    _target addItemCargoGlobal [_goggles, 1];
};

private _binocular = _loadout # 8;
if (_binocular isNotEqualTo []) then {
    // Binocular magazines cannot be changed in game, so keep them attached.
    _target addWeaponWithAttachmentsCargoGlobal [_binocular, 1];
};

private _assignedItems = _loadout # 9;
{
    if (_x isNotEqualTo "") then {
        _target addItemCargoGlobal [_x, 1];
    };
} forEach (_assignedItems);