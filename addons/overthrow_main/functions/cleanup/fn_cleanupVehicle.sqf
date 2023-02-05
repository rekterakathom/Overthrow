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

params [
	["_vehicle", objNull, [objNull]]
];

if (isNull _vehicle) exitWith {diag_log "Overthrow: Tried to delete a null vehicle"};

// Vehicle is local and can be deleted
if (local _vehicle) exitWith {
	//deleteVehicleCrew _vehicle;
	// deleteVehicleCrew is currently bugged (as of 2.10) so use moveOut instead
	{moveOut _x; deleteVehicle _x} forEach crew _vehicle;
	deleteVehicle _vehicle;
	true;
};

// Vehicle isn't local, execute where it is
[_vehicle] remoteExecCall ["OT_fnc_cleanupVehicle", _vehicle, false];
false
