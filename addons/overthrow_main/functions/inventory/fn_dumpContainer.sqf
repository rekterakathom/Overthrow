/*
    Description:
    Adds the entire content of the origin container to the target container, detaching every
    attachment and magazine from weapons, unloading all contents from subcontainers (backpacks,
    vests, uniforms) and replacing all vanilla medical items with ACE ones. The origin container is
    not emptied, so after execution the items can be found in both containers.

    Parameters:
        _origin: OBJECT - Origin container or vehicle which has the content to add
        _target: OBJECT - Target container or vehicle where the content is added

    Usage:
    [vehicle player, _ammoBox] call OT_fnc_dumpContainer;

    Returns: Nothing
*/

params ["_origin", "_target"];

// Vehicle inventory management in Arma is so full of weird edge cases, such as 4 separate item
// types with separate commands, containers inside containers, backpacks being vehicles instead of
// weapons, weapons having default attachments etc. This monster of a code is required simply to
// transfer everything from one container to another.

// Transfer weapons and their attachments and magazines separately
{
    // Binocular and disposable launcher magazines cannot be changed in game, so keep them attached.
    // For other weapons, detach all attachments and magazines.
    if (_x # 0 isKindOf ["Binocular", configFile >> "CfgWeapons"] || isArray (configFile >> "CBA_DisposableLaunchers" >> _x # 0)) then {
        _target addWeaponWithAttachmentsCargoGlobal [_x, 1];
    } else {
        [_x, 1, _target] call OT_fnc_dumpWeapon;
    };
} forEach (weaponsItemsCargo _origin);

// Transfer magazines with correct ammo counts
{
    _target addMagazineAmmoCargo [(_x # 0), 1, (_x # 1)];
} forEach (magazinesAmmoCargo _origin);

// Transfer backpacks as empty
(getBackpackCargo _origin) params ["_backpacks", "_amounts"];
{
    // Many backpack classes have some default items in their inventory. Call BIS_fnc_basicBackpack
    // to find the corresponding backpack class with no items.
    _target addBackpackCargoGlobal [(_x call BIS_fnc_basicBackpack), (_amounts # _forEachIndex)];
} forEach (_backpacks);

// Transfer other items, including uniforms and vests as empty
(getItemCargo _origin) params ["_items", "_amounts"];
{
    [_x, (_amounts # _forEachIndex), _target] call OT_fnc_dumpItem;
} forEach (_items);

// Transfer subcontainers' (uniforms, vests, backpacks) contents
{
    // Call this function recursively on the subcontainer object
    [_x # 1, _target] call OT_fnc_dumpContainer;
} forEach (everyContainer _origin);
