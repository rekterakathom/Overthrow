/*
	Author: ThomasAngel
	Steam: https://steamcommunity.com/id/Thomasangel/
	Github: https://github.com/rekterakathom

	Description:
	Properly handles the deletion of a vehicle, along with its crew.

	Parameters:
		_this # 0: OBJECT - Vehicle to delete

	Usage: [_vehicle] call OT_fnc_cleanupVehicle;

	Returns: Boolean - was vehicle deleted
*/

params [
	["_vehicle", objNull, [objNull]]
];

// Run game with -debug on to see callstack of assert
if (!assert !(isNull _vehicle)) exitWith {diag_log "Overthrow: Tried to delete a null vehicle!"; false};

// Add debug information
#if __A3_DEBUG__
diag_log format ["Overthrow Debug: Attempting to delete vehicle %1, local: %2", _vehicle, local _vehicle];
#endif

// Vehicle is local and can be deleted
if (local _vehicle) exitWith {
	deleteVehicleCrew _vehicle;
	deleteVehicle _vehicle;
	true;
};

// Vehicle isn't local, execute where it is
[_vehicle] remoteExecCall ["OT_fnc_cleanupVehicle", _vehicle, false];
false
