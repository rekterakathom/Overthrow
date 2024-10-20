private ["_items","_myitems"];

_items = [];
_done = [];

_myitems = [];

if(_this isKindOf "CAManBase") then {
	_myitems = (items _this) + (magazines _this);
}else{
	_myitems = (itemCargo _this) + (weaponCargo _this) + (magazineCargo _this) + (backpackCargo _this);
	{
		_myitems = _myitems append ((items _this) + (magazines _this));
	}forEach(units _this);		
};
if !(isNil "_myitems") then {
	{
		if !(_x in _done) then {
			_done pushBack _x;
			_items pushBack [_x,1];
		}else {
			_cls = _x;
			{
				if((_x select 0) isEqualTo _cls) then {
					_x set [1,(_x select 1)+1];				
				};
			}forEach(_items);
		};
	}forEach(_myitems);
};
_items;