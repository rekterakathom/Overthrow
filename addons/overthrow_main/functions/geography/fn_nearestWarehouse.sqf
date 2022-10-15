/*
	Author: ThomasAngel
	Steam: https://steamcommunity.com/id/Thomasangel/
	Github: https://github.com/rekterakathom
	Description:
	Returns the nearest (owned) warehouse object
	Parameters:
		_this # 0: POSITION OR OBJECT
	Usage: [player] call OT_fnc_nearestWarehouse;
	Returns: Warehouse object, objNull if not found.
*/

private _searchPos = _this;

private _objects = nearestObjects [_searchPos, [OT_warehouse], 100];

private _return = objNull;
if (_objects isNotEqualTo []) then {
	//if ((_objects # 0) call OT_fnc_hasOwner) then {
		_return = _objects # 0;
	//};
};

if (_return == objNull) then {
	["Couldn't find warehouse, defaulted to objNull"] call BIS_fnc_error;
};

_return