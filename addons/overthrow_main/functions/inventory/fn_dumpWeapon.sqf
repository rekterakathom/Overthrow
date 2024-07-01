/*
    Description:
    Adds a weapon to the target container, with all of its attachments and magazines detached and
    added separately.

    Parameters:
        _weaponItems: ARRAY - Array of weapon items in the weaponsItems format: https://community.bistudio.com/wiki/weaponsItems
        _amount: NUMBER - How many copies of weapon items to add
        _target: OBJECT - Target container or vehicle where the weapon items are added

    Usage:
    [["hgun_P07_F", "muzzle_snds_L", "", "", ["16Rnd_9x21_Mag", 11], [], ""], 2, _ammoBox] call OT_fnc_dumpWeapon;

    Returns: Nothing
*/

params ["_weaponItems", "_amount", "_target"];

// Many weapon classes have some default attachments attached to them. Call BIS_fnc_baseWeapon to
// try to find the corresponding weapon class with least attachments. Note: some base weapons such
// as arifle_MX_SW_F do still have attachments, so we must explicitly set its attachments to none
// anyway.
_target addWeaponWithAttachmentsCargoGlobal [[(_weaponItems # 0 call BIS_fnc_baseWeapon), "", "", "", [], [], ""], _amount];
// suppressor
if (_weaponItems # 1 isNotEqualTo "") then {_target addItemCargoGlobal [(_weaponItems # 1), _amount]};
// pointer
if (_weaponItems # 2 isNotEqualTo "") then {_target addItemCargoGlobal [(_weaponItems # 2), _amount]};
// optics
if (_weaponItems # 3 isNotEqualTo "") then {_target addItemCargoGlobal [(_weaponItems # 3), _amount]};
// primary mag
if (_weaponItems # 4 isNotEqualTo []) then {_target addMagazineAmmoCargo [(_weaponItems # 4 # 0), _amount, (_weaponItems # 4 # 1)]};
// secondary mag
if (_weaponItems # 5 isNotEqualTo []) then {_target addMagazineAmmoCargo [(_weaponItems # 5 # 0), _amount, (_weaponItems # 5 # 1)]};
// bipod
if (_weaponItems # 6 isNotEqualTo "") then {_target addItemCargoGlobal [(_weaponItems # 6), _amount]};
