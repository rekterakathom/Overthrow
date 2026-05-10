params ["_ctrl", "_index"];

disableSerialization;

private _cls = _ctrl lbData _index;
private _price = [_ctrl lbValue _index, 1, 0, true] call CBA_fnc_formatNumber;

([_cls, true] call OT_fnc_getClassDisplayInfo) params ["_pic", "_txt", "_desc"];

ctrlSetText [1200, _pic];

private _textctrl = (findDisplay 8000) displayCtrl 1100;

_textctrl ctrlSetStructuredText parseText format [
    localize "STR_DISPLAY_DISPLAY_WAREHOUSE_PIC_01",
    _txt,
    _desc,
    _price
];
