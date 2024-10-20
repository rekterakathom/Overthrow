OT_context = _this select 0;
OT_inputHandler = {
	_input = ctrlText 1400;
	if (_input isEqualType "" && count _input > 64) exitWith {hint "You can't deposit that much!"};
	_val = parseNumber _input;
	_cash = player getVariable ["money",0];
	if(_val > _cash) then {_val = _cash};
	if(_val > 0) then {
		[-_val] call OT_fnc_money;
		_in = OT_context getVariable ["money",0];
		OT_context setVariable ["money",_in + _val,true];
	};
};

["How much to put in this safe?",player getVariable ["money",100]] call OT_fnc_inputDialog;
