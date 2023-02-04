private _data = _this call OT_fnc_getBusinessData;
private _pos = _data select 0;
private _group = spawner getVariable [format["employees%1",_this],grpNull];
{
    [_x] remoteExecCall ["OT_fnc_cleanupUnit", _x, false];
}foreach(units _group);
deleteGroup _group;
