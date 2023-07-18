waitUntil {sleep 1;missionNamespace getVariable ["OT_varInitDone",false]};
{_x setMarkerAlpha 0} foreach OT_regions;

//Find NATO HQ
{
    _x params ["_pos","_name"];
    if(_name isEqualTo OT_NATO_HQ) then {
        OT_NATO_HQPos = _pos;
    };
}foreach (OT_objectiveData + OT_airportData);

private _allActiveShops = [];
private _allActiveCarShops = [];
private _allActivePiers = [];

private _version = server getVariable ["EconomyVersion",0];

diag_log format["Overthrow: Economy version is %1",_version];

//Generate 10 possible gang camp positions for each town

{
    private _town = _x;
    private _posTown = server getVariable _x;
    private _allpos = [];

    _possible = selectBestPlaces [_posTown, 600,"(1 + forest + trees) * (1 - houses) * (1 - sea)",10,600];
    {
        _pos = _x select 0;
        _pos set [2,0];
        if !(_pos isFlatEmpty  [-1, -1, 0.5, 10] isEqualTo []) then {
            _ob = _pos call OT_fnc_nearestObjective;
            _obpos = _ob select 0;
    		_obdist = _obpos distance _pos;

            _towndist = (server getVariable _town) distance _pos;
            _control = _pos call OT_fnc_nearestCheckpoint;
            // If there are no checkpoints (Malden), use one million as distance.
    		_cdist = if (!isNil "_control") then {(getmarkerpos _control) distance _pos} else {1000000};

    		if(_obdist > 800 and _towndist > 200 and _cdist > 500) then {
                _allpos pushback _pos;
            };
        };
        if((count _allpos) > 10) exitWith{};
    }foreach(_possible);
    spawner setVariable [format["gangpositions%1",_town],_allpos,false];

    if((server getVariable "StartupType") == "NEW") then {
        //Form gangs on a new game start
        private _stability = server getVariable [format["stability%1",_town],50];
        if(_stability < 50 && (selectRandom [1,2,3,4]) isEqualTo 1) then { //Approx 1/4 of all towns < 50% will have a gang at start
            _gangid = [_town,false] call OT_fnc_formGang;
            if(_gangid > -1) then {
                [_gangid,1+floor(random 2),false] call OT_fnc_addToGang;
            };
        };
    };

    private _garrison = server getVariable [format['police%1',_town],0];
    _mrkid = format["%1-police",_town];
    _mrkid setMarkerText format["%1",_garrison];

}foreach(OT_allTowns);

if(_version < OT_economyVersion) then {
    diag_log "Overthrow: Economy version is old, regenerating towns";
    OT_allShops = [];

    {
        _x params ["_cls","_name","_side"];
        if(_side != 1) then {
            _reppos = server getVariable [format["factionrep%1",_cls],false];
            if !(_reppos isEqualType []) then {
                _town = selectRandom OT_allTowns;
                if(_cls isEqualTo OT_spawnFaction) then {_town = server getvariable "spawntown"};
                _posTown = server getVariable _town;
                _building = [_posTown,OT_allHouses] call OT_fnc_getRandomBuilding;
                _pos = _posTown;
                if !(_building isEqualType true) then {
            		_pos = selectRandom (_building call BIS_fnc_buildingPositions);
            		[_building,"system"] call OT_fnc_setOwner;
                    if(isNil "_pos") then {
                        _pos = [[[getpos _building,20]]] call BIS_fnc_randomPos;
                    };
            	}else{
            		_pos = [[[_posTown,200]]] call BIS_fnc_randomPos;
            	};
            	server setVariable [format["factionrep%1",_cls],_pos,true];
                server setVariable [format["factionname%1",_cls],_name,true];
            };
        };
    }foreach(OT_allFactions);
    diag_log "Overthrow: Economy Load Complete";
};

//Save upgrade for existing factions > 0.7.5.1
{
    _x params ["_cls","_name","_side"];
    _n = server getVariable [format["factionname%1",_cls],""];
    if(_n isEqualTo "") then {
        server setVariable [format["factionname%1",_cls],_name,true];
    };
}foreach(OT_allFactions);

//Stability markers
{
    _stability = server getVariable format["stability%1",_x];
    _posTown = server getVariable _x;
    _pos = _posTown getPos [40, -90];
    _mSize = 250;

    if(_x in OT_Capitals) then {
        _mSize = 400;
    };

    _mrk = createMarkerLocal [_x,_pos];
    _mrk setMarkerShapeLocal "ELLIPSE";
    _mrk setMarkerSizeLocal [_mSize,_mSize];

    _abandoned = server getVariable ["NATOabandoned",[]];
    if(_mrk in _abandoned) then {
        _mrk setMarkerColorLocal "ColorRed";
    }else{
        _mrk setMarkerColorLocal "ColorYellow";
    };

    if(_stability < 50) then {
        _mrk setMarkerAlpha 1.0 - (_stability / 50);
    }else{
        _mrk setMarkerAlpha 0;
    };
    _mrk = createMarkerLocal [format["%1-abandon",_x],_pos];
    _mrk setMarkerShapeLocal "ICON";
    _garrison = server getVariable [format['police%1',_x],0];
	if(_garrison > 0) then {
		_mrk setMarkerTypeLocal "OT_Police";
	}else{
		_mrk setMarkerTypeLocal "OT_Anarchy";
	};
    if(_stability < 50) then {
        _mrk setMarkerColorLocal "ColorOPFOR";
    }else{
        _mrk setMarkerColorLocal "ColorGUER";
    };
    if(_x in (server getVariable ["NATOabandoned",[]])) then {
        _mrk setMarkerAlpha 1;
    }else{
        _mrk setMarkerAlpha 0;
    };

    if((server getVariable ["EconomyVersion",0]) < OT_economyVersion) then {
        [_x] call OT_fnc_setupTownEconomy;
    };

	_shops = server getVariable [format["activeshopsin%1",_x],[]];
	_allActiveShops append _shops;

	_carshops = server getVariable [format["activecarshopsin%1",_x],[]];
	_allActiveCarShops append _carshops;

	_piers = server getVariable [format["activepiersin%1",_x],[]];
	_allActivePiers append _piers;
    sleep 0.3;
}foreach(OT_allTowns);

//Shop Markers
OT_allShopMarkers = [];
{
    _x params ["_tpos","_tname"];
    //Shop Markers
    {
	    _x params ["_pos","_name"];
        private _mrkName = format["%1 %2", _pos select 0, _pos select 1];
        _mrk = createMarkerLocal [_mrkName,_pos];
        _mrk setMarkerShapeLocal "ICON";
        _mrk setMarkerTypeLocal format["ot_Shop%1",_name];
        _mrk setMarkerAlpha 1;
        OT_allShopMarkers pushback _mrkName;
    }foreach(server getVariable [format["activeshopsin%1",_tname],[]]);
    //Hardware Store Markers
    {
	    _x params ["_pos","_name"];
        private _mrkName = format["%1 %2", _pos select 0, _pos select 1];
        _mrk = createMarkerLocal [_mrkName,_pos];
        _mrk setMarkerShapeLocal "ICON";
        _mrk setMarkerTypeLocal "ot_ShopHardware";
        _mrk setMarkerAlpha 1;
        OT_allShopMarkers pushback _mrkName;
    }foreach(server getVariable [format["activehardwarein%1",_tname],[]]);
    //Vehicle Store Markers
    {
        private _mrkName = format["%1 %2", _x select 0, _x select 1];
        _mrk = createMarkerLocal [_mrkName,_x];
        _mrk setMarkerShapeLocal "ICON";
        _mrk setMarkerTypeLocal "ot_ShopVehicle";
        _mrk setMarkerAlpha 1;
        OT_allShopMarkers pushback _mrkName;
    }foreach(server getVariable [format["activecarshopsin%1",_tname],[]]);
    //Pier Store Markers
    {
        private _mrkName = format["%1 %2", _x select 0, _x select 1];
        _mrk = createMarkerLocal [_mrkName,_x];
        _mrk setMarkerShapeLocal "ICON";
        _mrk setMarkerTypeLocal "ot_ShopPier";
        _mrk setMarkerAlpha 1;
        OT_allShopMarkers pushback _mrkName;
    }foreach(server getVariable [format["activepiersin%1",_tname],[]]);
} foreach (OT_townData);

//Business Markers
OT_allEconomic = [];
{
	_x params ["_pos","_name"];
	_mrk = createMarkerLocal [_name,_pos];
	_mrk setMarkerShapeLocal "ICON";
    _mrk setMarkerTypeLocal "ot_Business";
    _mrk setMarkerColorLocal "ColorWhite";
    if(_name in (server getVariable["GEURowned",[]])) then {_mrk setMarkerColorLocal "ColorGUER"};
    _mrk setMarkerAlpha 0.8;
	OT_allEconomic pushback _name;
    server setVariable [_name,_pos,true];
    cost setVariable [_name,_x,true];
}foreach(OT_economicData);
sleep 0.3;

//Factory Marker
_mrk = createMarkerLocal ["Factory",OT_factoryPos];
_mrk setMarkerShapeLocal "ICON";
_mrk setMarkerTypeLocal "ot_Factory";
_mrk setMarkerColorLocal "ColorWhite";
if("Factory" in (server getVariable["GEURowned",[]])) then {_mrk setMarkerColorLocal "ColorGUER"};
_mrk setMarkerAlpha 0.8;

//Map Icon Cache
OT_mapcache_factions = [];
{
    _x params ["_cls","_name","_side","_flag"];
    if!(_side isEqualTo 1) then {
        private _factionPos = server getVariable format["factionrep%1",_cls];
        if!(isNil "_factionPos") then {
            OT_mapcache_factions pushBack [
                _flag,
                [1,1,1,1],
                _factionPos,
                0.6,
                0.5,
                0
            ];
        };
    };
}foreach(OT_allFactions);

//Cache Gun Dealer map icons
{
    _x params ["_tpos","_tname"];
    private _townPos = server getVariable format["gundealer%1",_tname];
    if!(isNil "_townPos") then {
        OT_mapcache_factions pushback [
            OT_flagImage,
            [1,1,1,1],
            _townPos,
            0.3,
            0.3,
            0
        ];
    };
}foreach(OT_townData);

server setVariable ["EconomyVersion",OT_economyVersion,false];

OT_allActiveShops = _allActiveShops;
publicVariable "OT_allActiveShops";

OT_allActiveCarShops = _allActiveCarShops;
publicVariable "OT_allActiveCarShops";

OT_allActivePiers = _allActivePiers;
publicVariable "OT_allActivePiers";

OT_economyLoadDone = true;
publicVariable "OT_economyLoadDone";
