private _pos = _this;
([server getvariable ["NATOobjectives",[]],[],{(_x select 0) distance2D _pos},"ASCEND"] call BIS_fnc_SortBy) select 0
