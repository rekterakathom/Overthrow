params ["_ctrl","_index"];

disableSerialization;

_cls = _ctrl lbData _index;
_price = [_ctrl lbValue _index, 1, 0, true] call CBA_fnc_formatNumber;

([_cls, true] call OT_fnc_getClassDisplayInfo) params ["_pic", "_txt", "_desc"];

ctrlSetText [1200, _pic];

_textctrl = (findDisplay 8000) displayCtrl 1100;

_textctrl ctrlSetStructuredText parseText format["
	<t align='center' size='1.5'>%1</t><br/>
	<t align='center' size='1.2'>%3 in stock</t><br/><br/>
	<t align='center' size='0.8'>%2</t>
",_txt,_desc,_price];
