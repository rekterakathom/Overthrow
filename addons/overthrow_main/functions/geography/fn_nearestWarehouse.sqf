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

private _range = 50;
private _found = false;
private _warehouse = objNull;
while {!_found && _range < 1550} do {
	private _objects = nearestObjects [_searchPos, [OT_warehouse], _range];
	if (count _objects > 0) then {
		_warehouse = _objects # 0;
		_found = true;
	};
	_range = _range + 100;
};

if (_warehouse == objNull) then {
	["Couldn't find warehouse, defaulted to objNull"] call BIS_fnc_error;
};

_warehouse
