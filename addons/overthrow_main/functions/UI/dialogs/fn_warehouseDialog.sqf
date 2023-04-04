buttonSetAction [1604, '[] spawn OT_fnc_warehouseDialog'];
private _cursel = lbCurSel 1500;
lbClear 1500;
_SearchTerm = ctrlText 1700;

private _warehouse = [player] call OT_fnc_nearestWarehouse;
if (_warehouse == objNull) exitWith {hint "No warehouse near by!"};

private _itemVars = (allVariables _warehouse) select {((toLowerANSI _x select [0,5]) isEqualTo "item_")};
_itemVars sort true;
private _numitems = 0;
{
	private _d = _warehouse getVariable [_x,false];
	if(_d isEqualType []) then {
		_d params [["_cls","",[""]], ["_num",0,[0]]];
		if (_num > 0) then {
			(_cls call OT_fnc_getClassDisplayInfo) params ["_pic", "_name"];

			if (toLowerANSI _name find toLowerANSI _SearchTerm > -1) then {
				_numitems = _numitems + 1;

				private _idx = lbAdd [1500,format["%1 x %2",_num,_name]];
				lbSetPicture [1500,_idx,_pic];
				lbSetValue [1500,_idx,_num];
				lbSetData [1500,_idx,_cls];
			};
		};
	};
}foreach(_itemVars);

if(_cursel >= _numitems) then {_cursel = 0};
lbSetCurSel [1500, _cursel];