/*
Author: ThomasAngel
Steam: https://steamcommunity.com/id/Thomasangel/
Github: https://github.com/rekterakathom

Description:
	Handles all healing

Parameters:
	"_caller",
	"_target",
	"_selectionName",
	"_className",
	"_itemUser",
	"_usedItem"

Usage: [] call OT_fnc_healedHandler;

Returns: Boolean - success
*/

params [
	"_caller",
	"_target",
	"_selectionName",
	"_className",
	"_itemUser",
	"_usedItem"
];

// If players use drugs on opposing factions, make them turn hostile.
if (isPlayer _itemUser && {side _itemUser != side _target}) then {
	if !(_usedItem in ["ACE_epinephrine", "ACE_morphine", "ACE_adenosine"]) exitWith {};
	_itemUser setCaptive false;
	_target reveal _itemUser;
	"You have been seen drugging people" remoteExec ["OT_fnc_notifyMinor", _itemUser, false];
};

true
