private _idx = lbCurSel 1501;
private _name = lbData [1501,_idx];
private _rate = server getVariable [format["%1employ",_name],0];
_rate = _rate - 1;
if(_rate < 0) exitWith {};
server setVariable [format["%1employ",_name],_rate,true];

_name remoteExec ["OT_fnc_deleteEmployee", 2];

[] call OT_fnc_showBusinessInfo;
