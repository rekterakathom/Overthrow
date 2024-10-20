disableSerialization;
private _amt = _this;

private _town = player call OT_fnc_nearestTown;
private _money = player getVariable ["money",0];

private _soldier = "Police" call OT_fnc_getSoldier;
private _price = _soldier select 0;

if(_money < (_amt * _price)) exitWith {"You cannot afford that" call OT_fnc_notifyMinor};

if !(_town in (server getVariable ["NATOabandoned",[]])) exitWith {"This police station is under NATO control" call OT_fnc_notifyMinor};

[_town,5 * _amt] call OT_fnc_support;

private _garrison = server getVariable [format['police%1',_town],0];
_garrison = _garrison + _amt;
server setVariable [format["police%1",_town],_garrison,true];

_mrkid = format["%1-police",_town];
_mrkid setMarkerText format["%1",_garrison];

[-(_amt*_price)] call OT_fnc_money;

_effect = floor(_garrison / 2);
if(_effect isEqualTo 0) then {_effect = "None"} else {_effect = format["+%1 Stability/10 mins",_effect]};

((findDisplay 9000) displayCtrl 1101) ctrlSetStructuredText parseText format["<t size=""1.5"" align=""center"">Police: %1</t>",_garrison];
((findDisplay 9000) displayCtrl 1104) ctrlSetStructuredText parseText format["<t size=""1.2"" align=""center"">Effects</t><br/><br/><t size=""0.8"" align=""center"">%1</t>",_effect];

[_town, _soldier, _amt] remoteExec ["OT_fnc_createPoliceGroup", 2];
