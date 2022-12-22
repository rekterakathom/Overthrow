params ["_f","_t"];
private _por = "";
private _region = "";
if(_f isEqualType []) then {
    _por = _f call OT_fnc_getRegion;
}else{
    _por = _f;
};
if(_t isEqualType []) then {
    _region = _t call OT_fnc_getRegion;
}else{
    _region = _t;
};
if(_por isEqualTo _region) exitWith {true};
private _ret = false;
{
    if(((_x select 0) == _por) && ((_x select 1) == _region)) exitWith {_ret = true};
}foreach(OT_connectedRegions);
_ret;
