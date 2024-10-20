OT_context = _this select 0;
OT_inputHandler = {
	_val = ctrlText 1400;
	if (_val isEqualType "" && count _val > 64) exitWith {hint "Password is too long!"};
	_password = hashValue _val;
	OT_context setVariable ["password",_password,true];
};

["Set password (blank to remove)",""] call OT_fnc_inputDialog;