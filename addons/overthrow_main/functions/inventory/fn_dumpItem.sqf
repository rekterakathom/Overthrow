/*
    Description:
    Adds an item to the target container and does ACE item replacements on it, such as replacing
    first aid kits with ACE medical items. This is basically just a fancy addItemCargoGlobal
    command.

    Parameters:
        _item: STRING - Class name of the item to add, it cannot be a backpack
        _amount: NUMBER - How many items to add
        _target: OBJECT - Target container or vehicle where the item is added

    Usage:
    ["FirstAidKit", 2, _ammoBox] call OT_fnc_dumpItem;

    Returns: Nothing
*/

params ["_item", "_amount", "_target"];

private _itemType = format ["$%1", getNumber (configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "type")];

// Replace vanilla medical items with corresponding ACE ones. Hack: ACE does not have a stable
// function for finding replacement items so using a semi-stable internal ACE variable
// ACE_common_itemReplacements to find them. For performance reasons we only support direct and type
// replacements, not inherited replacements as they might be slow and ACE does not currently use
// them. Related ACE code here:
// https://github.com/acemod/ACE3/blob/5c8ea65f7cd0a290e7ff6f8d0c44347617e77955/addons/medical_treatment/CfgReplacementItems.hpp
// https://github.com/acemod/ACE3/blob/5c8ea65f7cd0a290e7ff6f8d0c44347617e77955/addons/common/functions/fnc_replaceRegisteredItems.sqf
//
// ACE variables are being converted from CBA namespaces to hashmaps in a future ACE version, so
// right now we have to support both types.
// https://github.com/acemod/ACE3/commit/59af3e1f6d66ee08a1f8e4fd847efd45bb9ef73e#diff-3962a6b36168378fa5277c4012de0b4510de1122deb8afe38064a6cb574a29cfR25
// In the future when that commit has been released, this code can be simplified.
private "_directReplacements";
private "_typeReplacements";
if (ACE_common_itemReplacements isEqualType locationNull) then {
    // ACE_common_itemReplacements is a CBA namespace
    _directReplacements = ACE_common_itemReplacements getVariable _item;
    _typeReplacements = ACE_common_itemReplacements getVariable _itemType;
} else {
    // ACE_common_itemReplacements is a hashmap
    _directReplacements = ACE_common_itemReplacements get _item;
    _typeReplacements = ACE_common_itemReplacements get _itemType;
};

// If replacements were found, add them. If not, add the item as it is.
if (!isNil "_directReplacements" || !isNil "_typeReplacements") then {
    if (!isNil "_directReplacements") then {
        {
            _target addItemCargoGlobal [_x, _amount];
        } forEach (_directReplacements);
    };
    if (!isNil "_typeReplacements") then {
        {
            _target addItemCargoGlobal [_x, _amount];
        } forEach (_typeReplacements);
    };
} else {
    _target addItemCargoGlobal [_item, _amount];
};
