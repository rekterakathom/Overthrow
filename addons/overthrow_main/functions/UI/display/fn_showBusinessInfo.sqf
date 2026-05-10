disableSerialization;
private _name = "";
private _data = [];
if (_this isEqualTo []) then {
    private _idx = lbCurSel 1501;
    _name = lbData [1501, _idx];
} else {
    params ["_ctrl", "_index"];
    _name = _ctrl lbData _index;
    _data = _name call OT_fnc_getBusinessData;
};
_data = _name call OT_fnc_getBusinessData;

private _anum = server getVariable [format [localize "STR_DISPLAY_DISPLAY_BUSINESS_INFO_01", _name], 0];
private _num = _anum;
if (_num > 20) then {
    _num = 20;
};
private _perhr = [OT_nation, "WAGE", 0] call OT_fnc_getPrice;
if (_name isEqualTo "Factory") then { _perhr = _perhr * 2 };

private _wages = _anum * _perhr;

private _innum = _num * 2;
private _outnum = _num * 2;

private _amgen = (getPlayerUID player) in (server getVariable ["generals", []]);

private _text = format ["<t size='0.8'>%1</t><br/>", _name];
_text = _text + format [localize "STR_DISPLAY_DISPLAY_BUSINESS_INFO_02", _anum];
_text = _text + format [localize "STR_DISPLAY_DISPLAY_BUSINESS_INFO_03", _wages];

_amgen = (getPlayerUID player) in (server getVariable ["generals", []]);
private _nexthr = ((date select 3) + 1);
if (_nexthr < 10) then { _nexthr = format ["0%1", _nexthr] };

if (_amgen) then {
    ctrlEnable [1602, true];
    ctrlEnable [1603, true];
};

if (count _data > 2) then {
    private _input = _data select 2;
    private _output = _data select 3;
    if (_input != "") then {
        _text = _text + format [localize "STR_DISPLAY_DISPLAY_BUSINESS_INFO_04", _innum, _input call OT_fnc_weaponGetName];
    };
    if (_output != "") then {
        _text = _text + format [localize "STR_DISPLAY_DISPLAY_BUSINESS_INFO_05", _outnum, _output call OT_fnc_weaponGetName];
    } else {
        private _sellprice = round (([OT_nation, _input, 0] call OT_fnc_getSellPrice) * 1.2);
        _text = _text + format [localize "STR_DISPLAY_DISPLAY_BUSINESS_INFO_06", round (_innum * _sellprice)];
    };
} else {
    _text = _text + format [localize "STR_DISPLAY_DISPLAY_BUSINESS_INFO_06", round (_num * 200)];
};
_text = _text + format [localize "STR_DISPLAY_DISPLAY_BUSINESS_INFO_07", _nexthr];

private _textctrl = (findDisplay 8000) displayCtrl 1104;
_textctrl ctrlSetStructuredText parseText _text;
