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

deleteVehicleCrew _vehicle;
deleteVehicle _vehicle;
true
