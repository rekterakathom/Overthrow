params ["_p","_create",["_charge",true]];

private _b = _p call OT_fnc_nearestBase;
private _pos = _b select 0;
private _code = format["fob%1",_pos];
if((_pos distance _p) > 250) then {
    _b = _p call OT_fnc_nearestObjective;
    _pos = _b select 0;
    _code = _b select 1;
};

if(
    ((_pos nearEntities ["CAManBase", 50]) findIf {side _x isEqualTo west || side _x isEqualTo east} != -1)
    &&
    _charge
) exitWith {
    "You cannot garrison with enemies nearby" call OT_fnc_notifyMinor;
};

if(_create isEqualType 1) then {
    private _sol = OT_recruitables select _create;
    _sol params ["_cls"];
    private _soldier = _cls call OT_fnc_getSoldier;

    private _money = player getVariable ["money",0];
    private _cost = _soldier select 0;
    if(_money < _cost && _charge) exitWith {
        format ["You need $%1",_cost] call OT_fnc_notifyMinor;
    };
    if(_charge) then {
        [-_cost] call OT_fnc_money;
    };

    [_code, _pos, _soldier, _charge] remoteExec ["OT_fnc_createGarrisonUnit", 2];
}else{
    if(_create == "HMG" || _create == "GMG") then {
        private _buildings = nearestObjects [_pos, OT_garrisonBuildings, 250];
        private _done = false;
        private _dir = 0;
        private _p = [];
    	{
    		private _res = (_x call {
                params ["_building"];
                private _type = typeof _building;
    			if((damage _building) > 0.95) exitWith { []; };
    			if(
                    (_type == "Land_Cargo_HQ_V1_F")
                    || (_type == "Land_Cargo_HQ_V2_F")
                    || (_type == "Land_Cargo_HQ_V3_F")
                    || (_type == "Land_Cargo_HQ_V4_F")
                ) exitWith {
                    private _p = (_building buildingPos 8);
                    private _guns = ({alive _x} count (nearestObjects [_p, ["I_HMG_01_high_F","I_GMG_01_high_F"], 5]));
                    if(_guns == 0) then {
                        [getDir _building, _p];
                    } else {
                        [];
                    };
                };
                if(
                    (_type == "Land_Cargo_Patrol_V1_F")
                    || (_type == "Land_Cargo_Patrol_V2_F")
                    || (_type == "Land_Cargo_Patrol_V3_F")
                    || (_type == "Land_Cargo_Patrol_V4_F")
                ) exitWith {
                    private _ang = (getDir _building) - 190;
                    private _p = (_building buildingPos 1) getPos [2.3, _ang];
    				private _dir = (getDir _building) - 180;

                    private _guns = {alive _x} count(nearestObjects [_p, ["I_HMG_01_high_F","I_GMG_01_high_F"], 5]);
                    if(_guns == 0) then {
                        [ getDir _building, _p ];
                    } else {
                        [];
                    };
                };

                private _p = _building buildingPos 11;
                private _guns = {alive _x} count(nearestObjects [_p, ["I_HMG_01_high_F","I_GMG_01_high_F"], 5]);
                if(_guns isEqualTo 0) exitWith {
                    [getDir _building, _p];
                };

                _p = _building buildingPos 13;
                _guns = {alive _x} count(nearestObjects [_p, ["I_HMG_01_high_F","I_GMG_01_high_F"], 5]);
                if(_guns isEqualTo 0) exitWith {
                    [getDir _building, _p];
                };

                []
            });
            if!(_res isEqualTo []) exitWith{
                _done = true;
                _dir = _res select 0;
                _p = _res select 1;
            };
        }foreach(_buildings);

        private _class_obj = "";
        private _class_price = "";
        if (_create == "HMG") then {
            _class_obj = "I_HMG_01_high_F";
            _class_price = "I_HMG_01_high_weapon_F";
        } else {
            _class_obj = "I_GMG_01_high_F";
            _class_price = "I_GMG_01_high_weapon_F";
        };
        
        private _doit = true;
        
        if !(_done) then {
            _p = _pos findEmptyPosition [20,120,_class_obj];
            if (count _p == 0) exitWith {_doit = false;_charge = false;diag_log format ["Overthrow: Unable to find a position for %1 near %2",_create,_pos];format ["Unable to find a position for %1",_create] call OT_fnc_notifyMinor};
                _dir = random 360;
                //put sandbags
                private _sp = _p getPos [1.5,_dir];
                _veh =  OT_NATO_Sandbag_Curved createVehicle _sp;
                _veh setpos _sp;
                _veh setDir (_dir-180);
                _sp = _p getPos [-1.5,_dir];
                _veh =  OT_NATO_Sandbag_Curved createVehicle _sp;
                _veh setpos _sp;
                _veh setDir (_dir);
            };

        private _cost = [OT_nation,_class_price,0] call OT_fnc_getPrice;
        _cost = _cost + ([OT_nation,"CIV",0] call OT_fnc_getPrice);
        _cost = _cost + 300;

        if(_charge) then {
            private _money = player getVariable ["money",0];
            if(_money < _cost) exitWith {_doit = false;format ["You need $%1",_cost] call OT_fnc_notifyMinor};
            [-_cost] call OT_fnc_money;
            _garrison = server getVariable [format["resgarrison%1",_code],[]];
            _garrison pushback [_create,[]];
            server setVariable [format["resgarrison%1",_code],_garrison,true];
        };

        if(_doit) then {
            private _gun = _class_obj createVehicle _p;
            _gun setVariable ["OT_garrison",true,true];
            [_gun,getplayeruid player] call OT_fnc_setOwner;
            _gun setDir _dir;
            _gun setPosATL _p;

            [_code, _gun] remoteExec ["OT_fnc_createGarrisonGun", 2];
        };
    };
};
