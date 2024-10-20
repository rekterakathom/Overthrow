createDialog 'OT_dialog_reverse';

private _playerstock = player call OT_fnc_unitStock;
private _cursel = lbCurSel 1500;
lbClear 1500;
private _numitems = 0;
private _blueprints = server getVariable ["GEURblueprints",[]];
{
	_x params ["_cls"];
	if !((_cls in _blueprints) || (_cls in OT_allExplosives)) then {
		(_cls call OT_fnc_getClassDisplayInfo) params ["_pic", "_name"];

		private _idx = lbAdd [1500,_name];
		lbSetPicture [1500,_idx,_pic];
		lbSetData [1500,_idx,_cls];
		_numitems = _numitems + 1;
	};
}forEach(_playerstock);

{
	if (!(_x isKindOf "Animal") && !(_x isKindOf "CaManBase") && alive _x && (damage _x) isEqualTo 0) then {
		private _cls = typeOf _x;
		(_cls call OT_fnc_getClassDisplayInfo) params ["_pic", "_name"];

		private _idx = lbAdd [1500,_name];
		lbSetPicture [1500,_idx,_pic];
		lbSetData [1500,_idx,_cls];
		_numitems = _numitems + 1;
	};
}forEach(OT_factoryPos nearObjects ["AllVehicles", 100]);

if(_cursel >= _numitems) then {_cursel = 0};
lbSetCurSel [1500, _cursel];
