private _name = ctrltext 1400;
if(_name != "") then {
    closeDialog 0;

    private _base = (player nearObjects [OT_flag_IND,50]) select 0;

    private _bases = server getVariable ["bases",[]];
    private _basePos = getPosASL _base;
    _basePos set [2, 0];
    _bases pushback [_basePos,_name,getplayeruid player];
    server setVariable ["bases",_bases,true];
    _base setVariable ["name",_name];
    private _mrkid = format["%1-base",_basePos];
    createMarkerLocal [_mrkid,_basePos];
    _mrkid setMarkerShapeLocal "ICON";
    _mrkid setMarkerTypeLocal "mil_Flag";
    _mrkid setMarkerColorLocal "ColorWhite";
    _mrkid setMarkerAlphaLocal 1;
    _mrkid setMarkerText _name;
    private _builder = name player;
    {
        [
            _x,
            format["New Base: %1",_name],
            format["%1 created a new base for resistance efforts %2",_builder,_basePos call BIS_fnc_locationDescription]
        ] call BIS_fnc_createLogRecord;
    }foreach([] call CBA_fnc_players);
} else {
    closeDialog 0;
    private _base = (player nearObjects [OT_flag_IND,50]) select 0;
    deleteVehicle _base;
    hint "You must give a name for the base!\nYour money has been refunded.";
    [250] call OT_fnc_money;
};
