private _veh = _this select 0;
private _pos = _this select 1;
private _fnc = _this select 2;
if((_fnc select [0,6]) != "OT_fnc") then {
    //Legacy building Init

    private _code = {};
    if("policeStation" in _fnc) then {
        _code = OT_fnc_initPoliceStation;
    };
    if("trainingCamp" in _fnc) then {
        _code = OT_fnc_initTrainingCamp;
    };
    if("warehouse" in _fnc) then {
        _code = OT_fnc_initWarehouse;
    };
    if("workshop" in _fnc) then {
        _code = OT_fnc_initWorkshop;
    };
    [_pos,_veh] spawn _code;
}else{
    [_pos,_veh] spawn (missionNamespace getVariable _fnc);
};
