params ["_cls","_num"];
private _warehouse = [player] call OT_fnc_nearestWarehouse;
if (_warehouse == objNull) exitWith {hint "No warehouse near by!"};

private _d = _warehouse getVariable [format["item_%1",_cls],[_cls,0,[0]]];
if(_d isEqualType []) then {
	_d params ["","_in"];
	private _newnum = _in + _num;
	_warehouse setVariable [format["item_%1",_cls],[_cls,_newnum],true];
};