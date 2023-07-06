/*
	Author: ThomasAngel
	Steam: https://steamcommunity.com/id/Thomasangel/
	Github: https://github.com/rekterakathom

	Description:
	Properly handles the deletion of an unit, including units in vehicles.

	Parameters:
		_this # 0: OBJECT - Unit to be deleted

	Usage: [_unit] call OT_fnc_cleanupUnit;

	Returns: Boolean - was unit deleted
*/

params [
	["_unit", objNull, [objNull]]
];

if (isNull _unit) exitWith {diag_log "Overthrow: Tried to delete a null unit"};

// objectParent is more reliable than vehicle, see biki.
private _unitObjectParent = objectParent _unit;

// Unit is not in a vehicle and can be deleted.
if (isNull _unitObjectParent) exitWith {
	private _group = group _unit;

	deleteVehicle _unit;

	// If unit's group becomes empty, delete the group too.
	if (count units _group isEqualTo 0) then {
		_group call OT_fnc_cleanupEmptyGroup;
	};
	true;
};

// Unit is in a local vehicle and can be deleted.
if (local _unitObjectParent) exitWith {
	private _group = group _unit;

	_unitObjectParent deleteVehicleCrew _unit;

	// If unit's group becomes empty, delete the group too.
	if (count units _group isEqualTo 0) then {
		_group call OT_fnc_cleanupEmptyGroup;
	};
	true;
};

// Vehicle isn't local, execute where it is.
[_unit] remoteExecCall ["OT_fnc_cleanupUnit", _unitObjectParent, false];
false
