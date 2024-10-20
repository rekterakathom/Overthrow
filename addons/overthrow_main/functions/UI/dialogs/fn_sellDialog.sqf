private ["_playerstock","_town","_standing"];

_playerstock = _this select 0;
_town = _this select 1;
_standing = _this select 2;

private _cursel = lbCurSel 1500;
lbClear 1500;
private _numitems = 0;
{
	_cls = _x select 0;
	_num = _x select 1;
	_price = [_town,_cls,_standing] call OT_fnc_getSellPrice;

	private _cansell = !(_cls isKindOf "Bag_Base" || {_cls in OT_allClothing});
	if(_cansell) then {
		(_cls call OT_fnc_getClassDisplayInfo) params ["_pic", "_name"];

		_idx = lbAdd [1500,format["%1 x %2 ($%3)",_num,_name,_price]];
		lbSetPicture [1500,_idx,_pic];
		lbSetValue [1500,_idx,_price];
		lbSetData [1500,_idx,_cls];
		_numitems = _numitems + 1;
	};
}forEach(_playerstock);
if(_cursel >= _numitems) then {_cursel = 0};
lbSetCurSel [1500, _cursel];
