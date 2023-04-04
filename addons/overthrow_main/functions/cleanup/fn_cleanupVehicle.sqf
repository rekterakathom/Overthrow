/*
	Author: ThomasAngel
	Steam: https://steamcommunity.com/id/Thomasangel/
	Github: https://github.com/rekterakathom

	Description:
	Properly handles the deletion of a vehicle, along with its crew.

	Parameters:
		_this # 0: OBJECT - Vehicle to delete

	Usage: [_vehicle] remoteExecCall ["OT_fnc_cleanupVehicle", _vehicle, false];

	Returns: Boolean - was vehicle deleted
*/

if !(params [
	["_vehicle", objNull, [objNull]]
]) exitWith {diag_log format ["Overthrow: Tried to delete a null vehicle: %1", _vehicle]; false};

// Vehicle is local and can be deleted
if (local _vehicle) exitWith {
	deleteVehicleCrew _vehicle;
	deleteVehicle _vehicle;
	true;
};

// Vehicle isn't local, execute where it is
[_vehicle] remoteExecCall ["OT_fnc_cleanupVehicle", _vehicle, false];
false
