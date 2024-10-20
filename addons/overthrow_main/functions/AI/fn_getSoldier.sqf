private _cls = _this;
private _loadout = [];

if(_cls == "Police") then {
	_loadout = OT_Loadout_Police;
}else{
	private _data = [];
	{
		if((_x select 0) isEqualTo _cls) exitWith {_data = _x};
	}forEach(OT_recruitables);
	_loadout = _data select 1;
};

//calculate cost
private _cost = floor(([OT_nation,"CIV",0] call OT_fnc_getPrice) * 1.5);

_loadout params ["_primary","_secondary","_handgun","_uniform","_vest","_backpack","_helmet","_goggles","_bino","_assigned"];

private _allitems = [];
{
	if(_x isEqualType "") then {_allitems pushBack _x} else {_allitems pushBack _x#0};
}forEach(_primary);
{
	if(_x isEqualType "") then {_allitems pushBack _x} else {_allitems pushBack _x#0};
}forEach(_secondary);
{
	if(_x isEqualType "") then {_allitems pushBack _x} else {_allitems pushBack _x#0};
}forEach(_handgun);
private _clothes = "";
if(count _uniform > 0) then {
	_uniform params ["_item","_items"];
	_clothes = _item;
	{
		_x params ["_cls","_num"];
		private _t = 0;
		while{_t < _num} do {
			_allitems pushBack _cls;
			_t = _t + 1;
		}
	}forEach(_items);
};
if(count _vest > 0) then {
	_vest params ["_item","_items"];
	_allitems pushBack _item;
	{
		_x params ["_cls","_num"];
		private _t = 0;
		while{_t < _num} do {
			_allitems pushBack _cls;
			_t = _t + 1;
		}
	}forEach(_items);
};
if(count _backpack > 0) then {
	_backpack params ["_item","_items"];
	_allitems pushBack _item;
	{
		_x params ["_cls","_num"];
		private _t = 0;
		while{_t < _num} do {
			_allitems pushBack _cls;
			_t = _t + 1;
		}
	}forEach(_items);
};
_allitems pushBack _helmet;
_allitems pushBack _goggles;
_allitems append _assigned;
_allitems = _allitems - [""];

private _itemqty = _allitems call BIS_fnc_consolidateArray;
private _bought = [];
{
	_x params ["_cls","_num"];
	if !(_cls isEqualTo "ItemMap") then {
	 	_whqty = _cls call OT_fnc_qtyInWarehouse;
	 	if(_whqty < _num) then {_num = _num - _whqty} else {_num = 0};
	 	if(_num > 0) then {
			_cost = _cost + (([OT_nation,_cls,30] call OT_fnc_getPrice) * _num);
			_bought pushBack [_cls,_num];
	 	};
	};
}forEach(_itemqty);

[_cost,_cls,_loadout,_clothes,_allitems,_bought]
