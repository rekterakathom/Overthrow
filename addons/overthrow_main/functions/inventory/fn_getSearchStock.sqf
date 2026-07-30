private _items = [];
private _done = [];

private _myitems = [];

if (_this isKindOf "CAManBase") then {
    _myitems = (items _this) + (magazines _this);
} else {
    _myitems = (itemCargo _this) + (weaponCargo _this) + (magazineCargo _this) + (backpackCargo _this);
};
if !(isNil "_myitems") then {
    {
        if !(_x in _done) then {
            _done pushBack _x;
            _items pushBack [_x, 1];
        } else {
            private _cls = _x;
            {
                if ((_x select 0) isEqualTo _cls) then {
                    _x set [1, (_x select 1) + 1];
                };
            } forEach (_items);
        };
    } forEach (_myitems);
};
_items;
