params ["_sink"];

private _nozzle = _sink getVariable "ace_refuel_nozzle";
private _source = _nozzle getVariable "ace_refuel_source";

if ((typeOf _source) in OT_fuelPumps) then {
    private _last = _sink getVariable ["ot_lastFuel", fuel _sink];
    private _fueled = (fuel _sink) - _last;
    private _litresFueled = _fueled * getNumber (configOf _sink >> "fuelCapacity");

    private _pricePer = [OT_nation, "FUEL", 100] call OT_fnc_getPrice;
    private _total = round (_pricePer * _litresFueled);

    //take money from nearest player
    private _player = objNull;
    private _close = -1;
    {
        private _dis = (_x distance _sink);
        if (_close isEqualTo -1 || _dis < _close) then {
            _player = _x;
            _close = _dis;
        };
    } forEach (allPlayers);
    private _money = _player getVariable ["money", 0];
    if (_money < _total) then {
        _nozzle setVariable ["ace_refuel_lastTickMissionTime", nil];
        _nozzle setVariable ["ace_refuel_isRefueling", false, true];
        localize "STR_EVENT_REFUEL_HANDLER_01" remoteExec ["OT_fnc_notifyMinor", _player];
        _sink setFuel _last;
    } else {
        [-_total] remoteExec ["OT_fnc_money", _player];
    };

    _sink setVariable ["ot_lastFuel", fuel _sink, false];
};
