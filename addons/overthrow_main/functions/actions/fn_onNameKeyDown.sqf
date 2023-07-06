params ["","_key"];
private _name = ctrltext 1400;

// Esc key, don't allow
if (_key == 1) exitWith {
	true
};

// Enter key, we'll close the dialog manually in onNameDone
if (_key == 28 && _name != "") exitWith {
	[] call OT_fnc_onNameDone;
	true
};