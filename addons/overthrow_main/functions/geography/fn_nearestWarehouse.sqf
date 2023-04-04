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

params [
	["_searchPos", [0, 0, 0], [objNull, []], [2, 3]]
];

private _warehouse = objNull;

if (_searchPos isEqualType objNull) then {
	_searchPos = getPosASL _searchPos;
	_searchPos = [_searchPos # 0, _searchPos # 1]; // Convert to 2D to increase chances of match in cache
};

// Check the cache for _searchPos. Function will often get called from same position multiple times
if (_searchPos in OT_warehouseLocationCache) then {
	_warehouse = OT_warehouseLocationCache get _searchPos;
} else {
	private _owned = warehouse getVariable ["owned", []];
	if (_owned isNotEqualTo []) then {
		private _closestWarehouse = ([_owned, [], {_x distance2D _searchPos}, "ASCEND"] call BIS_fnc_sortBy) # 0;
		if ((_closestWarehouse distance2D _searchPos) < 2000) then {_warehouse = _closestWarehouse};

		// If this warehouse has paid the sum, then return the shared warehouse container object
		if (_closestWarehouse getVariable ["is_shared", false]) then {_warehouse = warehouse_shared};

		// Update cache
		OT_warehouseLocationCache set [_searchPos, _warehouse];
	} else {
		// Last resort
		private _range = 50;
		private _found = false;
		while {!_found && _range < 1550} do {
			private _objects = nearestObjects [_searchPos, [OT_warehouse], _range];
			if (count _objects > 0) then {
				_warehouse = _objects # 0;
				_found = true;
			};
			_range = _range + 100;
		};
	};
};

if (_warehouse isEqualTo objNull) then {
	diag_log "Overthrow: Couldn't find warehouse, defaulted to objNull";
};

_warehouse
