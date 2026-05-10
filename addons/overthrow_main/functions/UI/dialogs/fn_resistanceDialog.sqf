createDialog 'OT_dialog_resistance';

ctrlEnable [1600, false];
ctrlEnable [1601, false];

private _amgen = (getPlayerUID player) in (server getVariable ["generals", []]);

if (!_amgen) then {
    ctrlEnable [1605, false];
    ctrlEnable [1602, false];
    ctrlEnable [1603, false];
};

lbClear 1500;
{
    private _uid = _x;
    private _name = players_NS getVariable [format ["name%1", _uid], "Player"];
    private _idx = lbAdd [1500, _name];
    private _pic = "\A3\Ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
    if (_uid in (server getVariable ["generals", []])) then {
        _pic = "\A3\Ui_f\data\GUI\Cfg\Ranks\general_gs.paa";
    };
    private _col = [0.8, 0.8, 0.8, 1];
    {
        if (getPlayerUID _x isEqualTo _uid) exitWith { _col = [1, 1, 1, 1] };
    } forEach (allPlayers);

    lbSetColor [1500, _idx, _col] lbSetPicture [1500, _idx, _pic];
    lbSetData [1500, _idx, _uid];
} forEach (players_NS getVariable ["OT_allplayers", []]);

lbClear 1501;
{

    private _name = _x select 1;
    if (_name in (server getVariable ["GEURowned", []])) then {
        private _idx = lbAdd [1501, format ["%1", _name]];
        lbSetData [1501, _idx, _name];
    };
} forEach (OT_economicData);

private _tax = server getVariable ["taxrate", 0];
private _damaged = owners getVariable ["damagedBuildings", []];
private _lease = 0;
{
    _x params ["_id", "_cls", "", "_town"];
    if !(_id in _damaged) then {
        private _data = [_cls, _town] call OT_fnc_getRealEstateData;
        private _tl = (_data select 2);
        _lease = _lease + _tl;
    };
} forEach (player getVariable ["leasedata", []]);

if (_lease > 0) then {
    private _tt = 0;
    if (_tax > 0) then {
        _tt = round (_lease * (_tax / 100));
    };
    _lease = _lease - _tt;
};

private _t = call OT_fnc_getTaxIncome;
private _taxtotal = _t select 0;
private _totax = 0;

if (_tax > 0) then {
    _totax = round (_taxtotal * (_tax / 100));
};
private _numPlayers = count ([] call CBA_fnc_players);
private _taxper = round (_taxtotal / _numPlayers);
private _totaxper = round (_totax / _numPlayers);

private _perhr = ([OT_nation, "WAGE", 0] call OT_fnc_getPrice) * 6;
private _wages = 0;
private _income = 0;
{
    if (_x != "Factory") then {
        private _num = server getVariable [format ["%1employ", _x], 0];
        _wages = _wages + (_num * _perhr);
        if (_num > 20) then { _num = 20 };
        private _data = _x call OT_fnc_getBusinessData;
        if (count _data isEqualTo 2) then {
            _income = _income + ((_num * 200) * 6);
        };
    };
} forEach (server getVariable ["GEURowned", []]);

private _balance = _totax - _wages;
private _text = localize "STR_DISPLAY_DISPLAY_RESISTANCE_DIAG_01";

if ((getPlayerUID player) in (server getVariable ["generals", []])) then {
    _text = _text + format [localize "STR_DISPLAY_DISPLAY_RESISTANCE_DIAG_02", [server getVariable ["money", 0], 1, 0, true] call CBA_fnc_formatNumber];
};

_text = _text + format [localize "STR_DISPLAY_DISPLAY_RESISTANCE_DIAG_03", [_lease, 1, 0, true] call CBA_fnc_formatNumber];

_text = _text + format [localize "STR_DISPLAY_DISPLAY_RESISTANCE_DIAG_04", [_taxtotal - _totax, 1, 0, true] call CBA_fnc_formatNumber, [_taxper - _totaxper, 1, 0, true] call CBA_fnc_formatNumber];
if ((getPlayerUID player) in (server getVariable ["generals", []])) then {
    _text = _text + format [localize "STR_DISPLAY_DISPLAY_RESISTANCE_DIAG_05", _tax, "%", [_totax, 1, 0, true] call CBA_fnc_formatNumber, [_totaxper, 1, 0, true] call CBA_fnc_formatNumber];
};
_text = _text + format [localize "STR_DISPLAY_DISPLAY_RESISTANCE_DIAG_06", [_income, 1, 0, true] call CBA_fnc_formatNumber];

private _minus = "";
if (_wages > 0) then { _minus = "-" };
_text = _text + format [localize "STR_DISPLAY_DISPLAY_RESISTANCE_DIAG_07", _minus, [_wages, 1, 0, true] call CBA_fnc_formatNumber];
_text = _text + format [localize "STR_DISPLAY_DISPLAY_RESISTANCE_DIAG_08", [_balance + _income, 1, 0, true] call CBA_fnc_formatNumber];
_text = _text + format [localize "STR_DISPLAY_DISPLAY_RESISTANCE_DIAG_09", [_lease + (_taxper - _totaxper), 1, 0, true] call CBA_fnc_formatNumber];

disableSerialization;
private _textctrl = (findDisplay 8000) displayCtrl 1106;
_textctrl ctrlSetStructuredText parseText _text;
