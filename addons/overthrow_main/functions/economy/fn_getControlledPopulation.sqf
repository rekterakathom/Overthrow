private _totalpop = 0;
private _abandoned = server getVariable ["NATOabandoned",[]];
{
    _totalpop = _totalpop + (server getVariable [format["population%1",_x],0]);
} forEach _abandoned;
_totalpop
