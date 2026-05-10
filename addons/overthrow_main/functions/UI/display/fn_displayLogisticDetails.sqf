disableSerialization;
params ["_ctrl", "_index"];

private _netId = _ctrl lbData _index;
private _veh = _netId call BIS_fnc_objectFromNetId;
private _cls = typeOf _veh;

([_cls, true] call OT_fnc_getClassDisplayInfo) params ["_pic", "_name"];

private _owner = players_NS getVariable ("name" + (_veh call OT_fnc_getOwner));
if (isNil "_owner") then { _owner = localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS" };

ctrlSetText [1200, _pic];

private _txt = "<br/>";

private _fuel = round ((fuel _veh) * 100);

private _loadPounds = (loadAbs _veh) / 10;
private _loadKg = 0;
if (_loadPounds > 0) then {
    _loadKg = (_loadPounds / 2.205) toFixed 1;
};

//get wheel state
private _wheelsNeeded = 0;
private _tracksNeeded = 0;
private _hasWheels = false;
private _hasTracks = false;
private _engineOut = false;
private _fuelTankOut = false;
private _rotorOutV = false;
private _rotorOutH = false;
private _gunOut = false;
{
    private _hit = configName _x;
    if ("Wheel" in _hit) then {
        _hasWheels = true;
        if (_veh getHitPointDamage _hit >= 1) then {
            _wheelsNeeded = _wheelsNeeded + 1;
        };
    };
    if ("Track" in _hit) then {
        _hasTracks = true;
        if (_veh getHitPointDamage _hit >= 1) then {
            _tracksNeeded = _tracksNeeded + 1;
        };
    };
    if (_hit isEqualTo "HitEngine") then {
        if (_veh getHitPointDamage _hit >= 1) then {
            _engineOut = true;
        };
    };
    if (_hit isEqualTo "HitFuel") then {
        if (_veh getHitPointDamage _hit >= 1) then {
            _fuelTankOut = true;
        };
    };
    if (_hit isEqualTo "HitVRotor") then {
        if (_veh getHitPointDamage _hit >= 1) then {
            _rotorOutV = true;
        };
    };
    if (_hit isEqualTo "HitHRotor") then {
        if (_veh getHitPointDamage _hit >= 1) then {
            _rotorOutH = true;
        };
    };
    if (_hit isEqualTo "HitGun") then {
        if (_veh getHitPointDamage _hit >= 1) then {
            _gunOut = true;
        };
    };
} forEach (configProperties [configFile >> "CfgVehicles" >> _cls >> "HitPoints"]);

if !(_cls isKindOf "StaticWeapon") then {
    _txt = format [localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_01", _txt, _fuel, "%"];
    _txt = format [localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_02", _txt, _loadKg];
    if (_hasWheels) then {
        if (_wheelsNeeded isEqualTo 0) then {
            _txt = format [localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_03", _txt];
        } else {
            _txt = format [localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_04", _txt, _wheelsNeeded];
        };
    };

    if (_hasTracks) then {
        if (_tracksNeeded isEqualTo 0) then {
            _txt = format [localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_05", _txt];
        } else {
            _txt = format [localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_06", _txt, _tracksNeeded];
        };
    };

    if (_engineOut) then {
        _txt = format [localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_07", _txt];
    };

    if (_fuelTankOut) then {
        _txt = format [localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_08", _txt];
    };

    if (_rotorOutV) then {
        _txt = format [localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_09", _txt];
    };
    if (_rotorOutH) then {
        _txt = format [localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_10", _txt];
    };
};

if (_gunOut) then {
    _txt = format [localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_11", _txt];
};

private _totalAmmo = 0;
private _turrets = "((configName _x) select [0, 5] != 'Cargo') && (getArray (_x >> 'magazines') isNotEqualTo [])" configClasses (configFile >> "CfgVehicles" >> _cls >> "Turrets");
private _hasAmmo = _turrets isNotEqualTo [];
private _ammotxt = "";
{
    _x params ["_ammocls", "_num"];
    _totalAmmo = _totalAmmo + _num;
    _ammotxt = format ["%1%2 x %3<br/>", _ammotxt, _num, _ammocls call OT_fnc_getClassDisplayName];
} forEach (magazinesAmmo _veh);

if (_totalAmmo > 0) then {
    _txt = format [localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_12", _txt, _ammotxt];
} else {
    if (_hasAmmo) then {
        _txt = format [localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_13", _txt];
    };
};

private _textctrl = (findDisplay 8000) displayCtrl 1100;

_textctrl ctrlSetStructuredText parseText format [
    localize "STR_DISPLAY_DISPLAY_LOGISTICS_DETAILS_PARSED_14",
    _name,
    _owner,
    _txt
];
