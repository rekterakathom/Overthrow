private _funds = server getVariable ["money",0];
if(count _this > 0) then {
    _funds = _funds + (_this select 0);
    server setVariable ["money",_funds,true];
};
_funds;
