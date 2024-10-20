{
    _veh = vehicle player;
    _squad = _x;
    (units _x) allowGetIn true;
    if !(isNull _veh || _veh isEqualTo player) then {
        _squad addVehicle _veh;
        (units _x) orderGetIn true;
        {
            _x assignAsCargo _veh;
        }forEach(units _squad);
    };
    player hcSelectGroup [_squad,false];
}forEach(hcSelected player);
