private _shortest = 1e39; // Infinity
private _town = "";
private _searchPos = if (_this isEqualType objNull) then {getPosASL _this} else {_this};
_searchPos set [2,0]; // Z-value must be zero for accurate results
private ["_dis"];
{
    // We don't assign the variables, because in benchmarks that alone takes up 30% of execution time
    // params ["_pos", "_name"];
    // vectorDistanceSqr is the fastest possible method.
    // It doesn't need to check for objects, and omits the square root instruction
    _dis = _x # 0 vectorDistanceSqr _searchPos;
    if (_dis < _shortest) then {
        _shortest = _dis;
        _town = _x # 1;
    };
} forEach OT_townData;
_town
