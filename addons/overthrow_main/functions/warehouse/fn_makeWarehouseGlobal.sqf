/*
	Author: ThomasAngel
	Steam: https://steamcommunity.com/id/Thomasangel/
	Github: https://github.com/rekterakathom

	Description:
	Makes a warehouse global. Merges inventory with the global inventory

	Parameters:
		_this # 0: POSITION OR OBJECT
		_this # 1: OBJECT

	Usage: _this call OT_fnc_makeWarehouseGlobal;

	Returns: True if successful
*/

params [
	["_position", [0,0,0], [[], objNull]],
	["_caller", objNull, [objNull]]
];

private _callerMoney = _caller getVariable ["money", 0];
if (_callerMoney < 10000) exitWith {hint "You don't have enough money!"; false};

private _warehouse = [_position] call OT_fnc_nearestWarehouse;

// We convert to hashmap for easier handling of data.
private _warehouseItems = createHashMapFromArray ((allVariables _warehouse) select {(toLower _x select [0,5]) isEqualTo "item_"} apply {_warehouse getVariable [_x, ["", 0]]});
private _globalItems = createHashMapFromArray ((allVariables warehouse_shared) select {(toLower _x select [0,5]) isEqualTo "item_"} apply {warehouse_shared getVariable [_x, ["", 0]]});
private _result = createHashMap;

// Handle most of the merge here, including common items and items unique to the warehouse
{
	private _key = _x;
	private _value = _y;
	if (_key in _globalItems) then {
		_result set [_key, (_globalItems get _key) + _value];
		continue;
	};
	_result set [_key, _value];
} forEach _warehouseItems;

// Handle what's left, items unique to global items
{
	private _key = _x;
	private _value = _y;
	if !(_key in _warehouseItems) then {
		_result set [_key, _value];
	};
} forEach _globalItems;

// Apply the result
{
	private _key = _x;
	private _value = _y;
	warehouse_shared setVariable [format["item_%1", _key], [_key, _value], true];
} forEach _result;

// Set all the current variables to nil so the save system (hopefully) clears them up
{
	private _key = _x;
	private _value = _y;
	_warehouse setVariable [format["item_%1", _key], nil, true];
} forEach _warehouseItems;

playSound "3DEN_notificationDefault";
_caller setVariable ["money", _callerMoney - 10000, true];
_warehouse setVariable ["is_shared", true, true];
true
