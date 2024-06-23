params ["_user"];

private _range = 150;
private _time = 15;

private _veh = vehicle _user;
if (_veh == _user) exitWith {};
if ((driver _veh) != _user) exitWith {
    "Loot must be initiated by the driver of this vehicle" call OT_fnc_notifyMinor;
};
if ((typeOf _veh) != "OT_I_Truck_recovery") exitWith {
    "This command is only available when using a Recovery truck" call OT_fnc_notifyMinor;
};

if (isPlayer _user) then {
    _veh enableSimulation false;
    _veh spawn {
        sleep (_time + 5);
        _this enableSimulation true;
        //Fail safe for user input disabled.
    };
    format ["Looting all bodies within %1m",_range] call OT_fnc_notifyMinor;
    [_time, false] call OT_fnc_progressBar;
} else {
    _user globalchat format["Looting bodies within %1m using Recovery vehicle",_range];
};

sleep _time;

private _fnc_dumpWeapon = {
    params ["_weaponItems", "_amount", "_target"];

    // Many weapon classes have some default attachments attached to them. Call BIS_fnc_baseWeapon
    // to try to find the corresponding weapon class with least attachments. Note: some base weapons
    // such as arifle_MX_SW_F do still have attachments, so we must explicitly set its attachments
    // to none anyway.
    _target addWeaponWithAttachmentsCargoGlobal [[(_weaponItems # 0 call BIS_fnc_baseWeapon), "", "", "", [], [], ""], _amount];
    if (count (_weaponItems # 1) > 0) then {_target addItemCargoGlobal [(_weaponItems # 1), _amount]};
    if (count (_weaponItems # 2) > 0) then {_target addItemCargoGlobal [(_weaponItems # 2), _amount]};
    if (count (_weaponItems # 3) > 0) then {_target addItemCargoGlobal [(_weaponItems # 3), _amount]};
    if (count (_weaponItems # 4) > 0) then {_target addMagazineAmmoCargo [(_weaponItems # 4 # 0), _amount, (_weaponItems # 4 # 1)]};
    if (count (_weaponItems # 5) > 0) then {_target addMagazineAmmoCargo [(_weaponItems # 5 # 0), _amount, (_weaponItems # 5 # 1)]};
    if (count (_weaponItems # 6) > 0) then {_target addItemCargoGlobal [(_weaponItems # 6), _amount]};
};

// Vehicle inventory management in Arma is so full of weird edge cases, such as 4 separate item
// types with separate commands, containers inside containers, backpacks being vehicles instead of
// weapons, weapons having default attachments etc. This monster of a code is required simply to
// transfer everything from one container to another.
private _fnc_transferContainer = {
    params ["_origin", "_target"];

    // Transfer weapons and their attachments and magazines separately
    {
        // Binocular and disposable launcher magazines cannot be changed in game, so keep them
        // attached. For other weapons, detach all attachments and magazines.
        if (_x # 0 isKindOf "Binocular" || !isNull (configFile >> "CBA_DisposableLaunchers" >> _x # 0)) then {
            _target addWeaponWithAttachmentsCargoGlobal [_x, 1];
        } else {
            [_x, 1, _target] call _fnc_dumpWeapon;
        };
    } forEach (weaponsItemsCargo _origin);

    // Transfer magazines with correct ammo counts
    {
        _target addMagazineAmmoCargo [(_x # 0), 1, (_x # 1)];
    } forEach (magazinesAmmoCargo _origin);

    // Transfer backpacks as empty
    {
        // Many backpack classes have some default items in their inventory. Call
        // BIS_fnc_basicBackpack to find the corresponding backpack class with no items.
        _target addBackpackCargoGlobal [(_x call BIS_fnc_basicBackpack), 1];
    } forEach (backpackCargo _origin);

    // Transfer other items, including uniforms and vests as empty
    {
        _target addItemCargoGlobal [_x, 1];
    } forEach (itemCargo _origin);

    // Transfer subcontainers' (uniforms, vests, backpacks) contents
    {
        // Call this function recursively on the subcontainer object
        [_x # 1, _target] call _fnc_transferContainer;
    } forEach (everyContainer _origin);
};

// Get loose weapons and items
private _countWeaponHolders = 0;
private _weaponHolders = (_veh nearObjects ["WeaponHolder", _range]) + (_veh nearEntities ["WeaponHolderSimulated", _range]);
{
    private _weaponHolder = _x;

    // Weapon holder may be any pile of stuff on the ground, not just weapons dropped from corpses,
    // so we have to treat it as a generic container that might contain any items.
    [_weaponHolder, _veh] call _fnc_transferContainer;

    deleteVehicle _weaponHolder;
    _countWeaponHolders = _countWeaponHolders + 1;
} foreach _weaponHolders;

private _fnc_dumpLoadoutContainer = {
    params ["_content", "_target"];

    {
        if (count _x isEqualTo 3) then {
            // Magazine in format ["class", amount, ammo]
            _target addMagazineAmmoCargo _x;
        } else {
            if (_x # 0 isEqualType []) then {
                // Weapon in format [["class", "suppressor", "pointer", "optics", ["mag", ammo], ["grenade", ammo], "bipod"], amount]
                // Binocular and disposable launcher magazines cannot be changed in game, so keep
                // them attached. For other weapons, detach all attachments and magazines.
                if ((_x # 0 # 0) isKindOf "Binocular" || !isNull (configFile >> "CBA_DisposableLaunchers" >> (_x # 0 # 0))) then {
                    _target addWeaponWithAttachmentsCargoGlobal _x;
                } else {
                    [(_x # 0), (_x # 1), _target] call _fnc_dumpWeapon;
                };
            } else {
                if (_x # 1 isEqualType 0) then {
                    // Item in format ["class", amount]
                    _target addItemCargoGlobal _x;
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

private _fnc_dumpLoadout = {
    params ["_unit", "_target"];

    private _loadout = getUnitLoadout _unit;

    private _primaryWeapon = _loadout # 0;
    if (count _primaryWeapon > 0) then {
        [_primaryWeapon, 1, _target] call _fnc_dumpWeapon;
    };
    
    private _secondaryWeapon = _loadout # 1;
    if (count _secondaryWeapon > 0) then {
        // Disposable launcher magazines cannot be changed in game, so keep them attached. For other
        // launchers, detach all attachments and magazines.
        if (!isNull (configFile >> "CBA_DisposableLaunchers" >> _secondaryWeapon # 0)) then {
            _target addWeaponWithAttachmentsCargoGlobal [_secondaryWeapon, 1];
        } else {
            [_secondaryWeapon, 1, _target] call _fnc_dumpWeapon;
        };
    };

    private _handWeapon = _loadout # 2;
    if (count _handWeapon > 0) then {
        [_handWeapon, 1, _target] call _fnc_dumpWeapon;
    };

    private _uniform = _loadout # 3;
    if (count _uniform > 0) then {
        _target addItemCargoGlobal [(_uniform # 0), 1];
        [_uniform # 1, _target] call _fnc_dumpLoadoutContainer;
    };

    private _vest = _loadout # 4;
    if (count _vest > 0) then {
        _target addItemCargoGlobal [(_vest # 0), 1];
        [_vest # 1, _target] call _fnc_dumpLoadoutContainer;
    };

    private _backpack = _loadout # 5;
    if (count _vest > 0) then {
        // Many backpack classes have some default items in their inventory. Call
        // BIS_fnc_basicBackpack to find the corresponding backpack class with no items.
        _target addBackpackCargoGlobal [((_backpack # 0) call BIS_fnc_basicBackpack), 1];
        [_backpack # 1, _target] call _fnc_dumpLoadoutContainer;
    };

    private _headgear = _loadout # 6;
    if (count _headgear > 0) then {
        _target addItemCargoGlobal [_headgear, 1];
    };

    private _goggles = _loadout # 7;
    if (count _goggles > 0) then {
        _target addItemCargoGlobal [_goggles, 1];
    };

    private _binocular = _loadout # 8;
    if (count _binocular > 0) then {
        // Binocular magazines cannot be changed in game, so keep them attached.
        _target addWeaponWithAttachmentsCargoGlobal [_binocular, 1];
    };

    private _assignedItems = _loadout # 9;
    {
        if (count _x > 0) then {
            _target addItemCargoGlobal [_x, 1];
        };
    } forEach (_assignedItems);
};

// Get the bodies
private _countBodies = 0;
{
    // Some bodies are inside vehicles, so we search through the crew of every vehicle we find.
    // Luckily every man is crew of itself so the same code also works for bodies on the ground.
    private _vehicleOrMan = _x;
    {
        private _body = _x;
        if (!alive _body) then {
            [_body, _veh] call _fnc_dumpLoadout;

            [_body] call OT_fnc_cleanupUnit;
            _countBodies = _countBodies + 1;
        };
    } forEach crew _vehicleOrMan;
} forEach (_veh nearObjects ["AllVehicles", _range]);

if(isPlayer _user) then {
    _veh enableSimulation true;
    format["Looted %1 weapons and %2 bodies into this truck", _countWeaponHolders, _countBodies] call OT_fnc_notifyMinor;
}else {
    _user globalchat format["All done! Looted %1 weapons and %2 bodies", _countWeaponHolders, _countBodies];
};
