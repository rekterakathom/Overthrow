params ["_town","_standing","_s",["_multiplier", 1]];

private _sorted = [_s,[],{_x select 0},"ASCEND"] call BIS_fnc_SortBy;

lbClear 1500;
{
	_x params ["_cls", "_num", ["_enabled", true], ["_disabledText", "Not Available"]];
	
	private _price = [_town,_cls,_standing] call OT_fnc_getPrice;
	_price = _price * _multiplier;

	(_cls call OT_fnc_getClassDisplayInfo) params ["_pic", "_name"];

	private _text = format["%1 x %2",_num,_name];
	if(_num isEqualTo -1) then {_text = _name};
	private _idx = lbAdd [1500,_text];
	lbSetPicture [1500,_idx,_pic];
	if !(_enabled) then {
		lbSetColor [1500,_idx,[0.3,0.3,0.3,1]];
		_price = -1;
		_cls = _disabledText;
	};
	lbSetValue [1500,_idx,_price];
	lbSetData [1500,_idx,_cls];
}foreach(_sorted);
