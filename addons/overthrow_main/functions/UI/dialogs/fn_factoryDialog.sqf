createDialog 'OT_dialog_factory';

private _cursel = lbCurSel 1500;
lbClear 1500;
private _done = [];

{
	if (isClass (configFile >> "CfgWeapons" >> _x)) then {
		_x = [_x] call BIS_fnc_baseWeapon;
		if (_x in _done) then {continue}; // base weapons may be duplicates
	};

	_done pushBack _x;

	(_x call OT_fnc_getClassDisplayInfo) params ["_pic", "_name"];

	private _idx = lbAdd [1500,format["%1",_name]];
	lbSetPicture [1500,_idx,_pic];
	lbSetData [1500,_idx,_x];
}forEach(server getVariable ["GEURblueprints",[]]);

if(_cursel >= count _done) then {_cursel = 0};
lbSetCurSel [1500, _cursel];

[] call OT_fnc_factoryRefresh;
