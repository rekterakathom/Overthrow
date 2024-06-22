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
            // Many weapon classes have some default attachments attached to them. Call
            // BIS_fnc_baseWeapon to try to find the corresponding weapon class with least
            // attachments. Note: some base weapons such as arifle_MX_SW_F do still have
            // attachments, so we must explicitly set its attachments to none anyway.
            _target addWeaponWithAttachmentsCargoGlobal [[(_x # 0 call BIS_fnc_baseWeapon), "", "", "", [], [], ""], 1];
            if (count (_x # 1) > 0) then {_target addItemCargoGlobal [(_x # 1), 1]};
            if (count (_x # 2) > 0) then {_target addItemCargoGlobal [(_x # 2), 1]};
            if (count (_x # 3) > 0) then {_target addItemCargoGlobal [(_x # 3), 1]};
            if (count (_x # 4) > 0) then {_target addMagazineAmmoCargo [(_x # 4 # 0), 1, (_x # 4 # 1)]};
            if (count (_x # 5) > 0) then {_target addMagazineAmmoCargo [(_x # 5 # 0), 1, (_x # 5 # 1)]};
            if (count (_x # 6) > 0) then {_target addItemCargoGlobal [(_x # 6), 1]};
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

//Get the bodies
private _count_bodies = 0;
{
    // Some bodies are inside vehicles, so we search through the crew of every vehicle we find.
    // Luckily every man is crew of itself so the same code also works for bodies on the ground.
    private _vehicleOrMan = _x;
    {
        private _body = _x;
        if (!alive _body) then {
            [_body, _veh] call OT_fnc_dumpStuff;
            _count_bodies = _count_bodies + 1;
            [_body] call OT_fnc_cleanupUnit;
        };
    } forEach crew _vehicleOrMan;
} forEach (_veh nearObjects ["AllVehicles", _range]);

if(isPlayer _user) then {
    _veh enableSimulation true;
    format["Looted %1 weapons and %2 bodies into this truck", _count_weapons, _count_bodies] call OT_fnc_notifyMinor;
}else {
    _user globalchat format["All done! Looted %1 weapons and %2 bodies", _count_weapons, _count_bodies];
};
