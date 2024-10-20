private _p = _this;
private _region = "";
{
    if(_p inArea _x) exitWith {_region = _x};
}forEach(OT_regions);
_region;
