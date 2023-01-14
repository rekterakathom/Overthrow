disableSerialization;
params ["_ctrl","_index"];

private _cls = _ctrl lbData _index;
private _price = _ctrl lbValue _index;

private _pic = "";
private _txt = "";
private _desc = "";
if (_price > -1) then {
    ctrlEnable [1600,true];

	// Special cases
    if (_cls == "Set_HMG") exitWith {
        _pic = getText(configFile >> "cfgVehicles" >> "C_Quadbike_01_F" >> "editorPreview");
        _txt = "Quad Bike w/ HMG Backpacks";
        _desc = "A Quad-bike containing the backpacks required to set up a Static HMG";
    };
    if (_cls isKindOf "CAManBase") exitWith {
        private _soldier = _cls call OT_fnc_getSoldier;
        private _bought = _soldier select 5;
        _price = _soldier select 0;

        _txt = _cls call OT_fnc_vehicleGetName;

        {
            _x params ["_cls","_qty"];
            private _name = _cls call OT_fnc_getClassDisplayName;
            private _cost = (([OT_nation,_cls,30] call OT_fnc_getPrice) * _qty);
            _desc = format["%1%2 x %3 = $%4<br/>",_desc,_qty,_name,[_cost, 1, 0, true] call CBA_fnc_formatNumber];
        } foreach (_bought);

        if (_desc isEqualTo "") then {
            _desc = "All items required for this unit are available in the warehouse";
        } else {
            _desc = format["These items are not in the warehouse and must be purchased:<br/>%1",_desc];
        };
    };
    if (_cls in OT_allSquads) exitWith {
        private _squad = _cls call OT_fnc_getSquad;
        _price = _squad param [0,0];
        ctrlEnable [1601,false];

        _txt = _cls;
        _desc = "Will recruit this squad into your High-Command bar, accessible with ctrl-space.";
    };

	// General case
    ([_cls, true] call OT_fnc_getClassDisplayInfo) params ["_rPic", "_rTxt", "_rDesc"];
	_pic = _rPic;
	_txt = _rTxt;
	_desc = _rDesc;

    if (_cls isEqualTo "C_Quadbike_01_F") exitWith {
        _desc = "Gets you from A to B, not guaranteed to stay upright.";
    };
	if(_cls in OT_allExplosives) then {
		_cost = cost getVariable _cls;
		_chems = server getVariable ["reschems",0];
		_desc = format["Required: %1 x chemicals (%2 available)<br/>%3",_cost select 3,_chems,_desc];
	};
} else {
    ctrlEnable [1600,false];
    _txt = "Not Available";
    _desc = _cls;
    _price = "";
};

ctrlSetText [1200, _pic];

_textctrl = (findDisplay 8000) displayCtrl 1100;

if(_price isEqualType 0) then {
    _price = "$" + ([_price, 1, 0, true] call CBA_fnc_formatNumber);
}else{
    _price = "";
};

_textctrl ctrlSetStructuredText parseText format["
	<t align='center' size='1.5'>%1</t><br/>
	<t align='center' size='1.2'>%3</t><br/><br/>
	<t align='center' size='0.8'>%2</t>
",_txt,_desc,_price];
