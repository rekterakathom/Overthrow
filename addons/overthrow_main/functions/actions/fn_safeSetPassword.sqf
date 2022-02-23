OT_context = _this select 0;
OT_inputHandler = {
	_val = ctrltext 1400;
	_password = hashValue _val;
	OT_context setVariable ["password",_password,true];
};

["Set password (blank to remove)",""] call OT_fnc_inputDialog;