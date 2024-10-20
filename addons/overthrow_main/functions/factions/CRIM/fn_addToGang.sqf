params ["_gangid",["_amt",1],["_spawn",true]];

private _count = 0;
private _gang = OT_civilians getVariable [format["gang%1",_gangid],[]];
private _town = _gang select 2;
private _townpos = server getVariable _town;

while {_count < _amt} do {
    private _civid = (OT_civilians getVariable ["autocivid",-1]) + 1;
    OT_civilians setVariable ["autocivid",_civid];
    (_gang select 0) pushBack _civid;

    private _identity = call OT_fnc_randomLocalIdentity;
    _identity set [1, selectRandom OT_CRIM_Clothes];
    _identity set [3, selectRandom OT_CRIM_Goggles];
    _identity pushBack (selectRandom OT_voices_local);

    private _civ = [_identity,_gangid];
    OT_civilians setVariable [format["%1",_civid],_civ];

    if(_spawn && [_townpos] call OT_fnc_inSpawnDistance) then {
          _pos = (_gang select 4);
          _group = spawner getVariable [format["gangspawn%1",_gangid],grpNull];
          //Spawn new gang member at camp

          private _pos = _pos getPos [10, random 360];
          private _civ = _group createUnit [OT_CRIM_Unit, _pos, [],0, "NONE"];
          [_civ] joinSilent nil;
          [_civ] joinSilent _group;

          [_civ,_town,_identity,_gangid] call OT_fnc_initCriminal;

          _civ setVariable ["OT_gangid",_gangid,true];
          _civ setVariable ["OT_civid",_civid,true];
          _civ setBehaviour "SAFE";
          _civ setVariable ["hometown",_town,true];

          {
              _x addCuratorEditableObjects [[_civ]];
          }forEach(allCurators);
    };
    _count = _count + 1;
};
