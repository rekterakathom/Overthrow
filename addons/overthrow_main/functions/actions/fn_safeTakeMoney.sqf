OT_context = _this select 0;

private _password = OT_context getVariable ["password",""];

if(_password isEqualTo "") exitWith {
	private _in = OT_context getVariable ["money",0];

	OT_inputHandler = {
		_input = ctrlText 1400;
		if (_input isEqualType "" && count _input > 64) exitWith {hint "You can't withdraw that much!"};
		_val = parseNumber _input;
		_cash = player getVariable ["money",0];
		_in = OT_context getVariable ["money",0];
		if(_val > _in) then {_val = _in};
		if(_val > 0) then {
			[_val] call OT_fnc_money;
			OT_context setVariable ["money",_in - _val,true];
		};
	};

	[format["How much to take? ($%1 Total)",[_in, 1, 0, true] call CBA_fnc_formatNumber],100] call OT_fnc_inputDialog;
};

OT_inputHandler = {
	private _password = OT_context getVariable ["password",""];
	private _pw = ctrlText 1400;
	if (_pw isEqualType "" && count _pw > 64) exitWith {hint "Password is too long!"};
	private _pwHash = hashValue _pw;
	if(_pwHash != _password) exitWith {"Wrong password" call OT_fnc_notifyMinor};
	private _in = OT_context getVariable ["money",0];

	OT_inputHandler = {
		_input = ctrlText 1400;
		if (_input isEqualType "" && count _input > 64) exitWith {hint "You can't withdraw that much!"};
		_val = parseNumber _input;
		_cash = player getVariable ["money",0];
		_in = OT_context getVariable ["money",0];
		if(_val > _in) then {_val = _in};
		if(_val > 0) then {
			[_val] call OT_fnc_money;
			OT_context setVariable ["money",_in - _val,true];
		};
	};

	[format["How much to take? ($%1 Total)",[_in, 1, 0, true] call CBA_fnc_formatNumber],100] call OT_fnc_inputDialog;
};

["Please enter password",""] call OT_fnc_inputDialog;