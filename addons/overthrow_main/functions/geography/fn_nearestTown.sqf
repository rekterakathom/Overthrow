private _shortest = 99999;
private _town = "";
private _searchPos = _this;
{
    _x params ["_pos", "_name"];
    private _dis = _pos distance2D _searchPos;
    if (_dis < _shortest) then {
        _shortest = _dis;
        _town = _name;
    };
} forEach OT_townData;
_town
