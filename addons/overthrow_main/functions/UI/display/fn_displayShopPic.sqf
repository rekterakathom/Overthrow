disableSerialization;
params ["_ctrl", "_index"];

private _cls = _ctrl lbData _index;
private _price = _ctrl lbValue _index;

private _pic = "";
private _txt = "";
private _desc = "";
if (_price > -1) then {
    ctrlEnable [1600, true];

    // Special cases
    if (_cls == "Set_HMG") exitWith {
        _pic = getText (configFile >> "CfgVehicles" >> "C_Quadbike_01_F" >> "editorPreview");
        _txt = localize "STR_DISPLAY_DISPLAY_SHOP_PIC_01";
        _desc = localize "STR_DISPLAY_DISPLAY_SHOP_PIC_02";
    };
    if (_cls isKindOf "CAManBase") exitWith {
        private _soldier = _cls call OT_fnc_getSoldier;
        private _bought = _soldier select 5;
        _price = _soldier select 0;

        _txt = _cls call OT_fnc_vehicleGetName;

        {
            _x params ["_cls", "_qty"];
            private _name = _cls call OT_fnc_getClassDisplayName;
            private _cost = (([OT_nation, _cls, 30] call OT_fnc_getPrice) * _qty);
            _desc = format ["%1%2 x %3 = $%4<br/>", _desc, _qty, _name, [_cost, 1, 0, true] call CBA_fnc_formatNumber];
        } forEach (_bought);

        if (_desc isEqualTo "") then {
            _desc = localize "STR_DISPLAY_DISPLAY_SHOP_PIC_03";
        } else {
            _desc = format [localize "STR_DISPLAY_DISPLAY_SHOP_PIC_04", _desc];
        };
    };
    if (_cls in OT_allSquads) exitWith {
        private _squad = _cls call OT_fnc_getSquad;
        _price = _squad param [0, 0];
        ctrlEnable [1601, false];

        _txt = _cls;
        _desc = localize "STR_DISPLAY_DISPLAY_SHOP_PIC_05";
    };

    // General case
    ([_cls, true] call OT_fnc_getClassDisplayInfo) params ["_rPic", "_rTxt", "_rDesc"];
    _pic = _rPic;
    _txt = _rTxt;
    _desc = _rDesc;

    if (_cls isEqualTo "C_Quadbike_01_F") exitWith {
        _desc = localize "STR_DISPLAY_DISPLAY_SHOP_PIC_06";
    };
    if (_cls in OT_allExplosives) then {
        private _cost = cost getVariable _cls;
        private _chems = server getVariable ["reschems", 0];
        _desc = format [localize "STR_DISPLAY_DISPLAY_SHOP_PIC_07", _cost select 3, _chems, _desc];
    };
} else {
    ctrlEnable [1600, false];
    _txt = localize "STR_DISPLAY_DISPLAY_SHOP_PIC_08";
    _desc = _cls;
    _price = "";
};

ctrlSetText [1200, _pic];

private _textctrl = (findDisplay 8000) displayCtrl 1100;

if (_price isEqualType 0) then {
    _price = "$" + ([_price, 1, 0, true] call CBA_fnc_formatNumber);
} else {
    _price = "";
};

_textctrl ctrlSetStructuredText parseText format [
    "
	<t align='center' size='1.5'>%1</t><br/>
	<t align='center' size='1.2'>%3</t><br/><br/>
	<t align='center' size='0.8'>%2</t>
",
    _txt,
    _desc,
    _price
];
