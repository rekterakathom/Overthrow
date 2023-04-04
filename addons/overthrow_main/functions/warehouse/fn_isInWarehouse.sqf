private _warehouse = [player] call OT_fnc_nearestWarehouse;
if (_warehouse == objNull) exitWith {hint "No warehouse near by!"};

params ["_cls","_num"];
private _ret = false;
private _d = _warehouse getVariable [format["item_%1",_cls],[_cls,0,[0]]];
if(_d isEqualType []) then {
	_d params ["","_in"];
	if(_num <= _in) then {
		__ret = true;
	};
};
_ret
