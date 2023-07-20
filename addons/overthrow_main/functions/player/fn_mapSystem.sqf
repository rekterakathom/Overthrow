addMissionEventHandler ["Draw3D", {
	if !(OT_showPlayerMarkers) exitWith {};
	{
		if (_x isNotEqualTo player) then {
			private _dis = round(_x distance player);
			if(_dis < 250) then {
				private _t = "m";
				//if(_dis > 999) then {
				//	_dis = round(_dis / 1000);
				//	_t = "km";
				//};
				private _pos = _x modelToWorldVisual [0,0,0];
				if ((worldToScreen _pos) isEqualTo []) exitWith {};
				drawIcon3D ["a3\ui_f\data\map\groupicons\selector_selectable_ca.paa", [1,1,1,0.3], _pos, 1, 1, 0, format["%1 (%2%3)",name _x,_dis,_t], 0, 0.02, "TahomaB", "center", true];
			};
		};
	}foreach(allPlayers - (entities "HeadlessClient_F"));
}];

addMissionEventHandler ["Draw3D", {
	if(!isNil "OT_missionMarker") then {
		private _dis = round(OT_missionMarker distance player);
		private _t = "m";
		if(_dis > 999) then {
			_dis = round(_dis / 1000);
			_t = "km";
		};
		drawIcon3D ["a3\ui_f\data\map\markers\military\dot_ca.paa", [1,1,1,1], OT_missionMarker, 1, 1, 0, format["%1 (%2%3)",OT_missionMarkerText,_dis,_t], 0, 0.02, "TahomaB", "center", true];
	};
}];

if(!isNil "OT_OnDraw") then {
	((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw",OT_OnDraw];
};

// Set-up shop markers
[] spawn {
	waitUntil {!(isNil "OT_townData")};
	OT_allShopMarkers = [];
	{
		_x params ["_tpos","_tname"];
		
		// We need to wait for the server...
		waitUntil {
			!(isNil {server getVariable format["activeshopsin%1",_tname]})
			&& {!(isNil {server getVariable format["activehardwarein%1",_tname]})
			&& !(isNil {server getVariable format["activecarshopsin%1",_tname]})
			&& !(isNil {server getVariable format["activepiersin%1",_tname]})}
		};
		//Shop Markers
		{
			_x params ["_pos","_name"];
			private _mrkName = format["%1 %2", _pos select 0, _pos select 1];
			_mrk = createMarkerLocal [_mrkName,_pos];
			_mrk setMarkerShapeLocal "ICON";
			_mrk setMarkerTypeLocal format["ot_Shop%1",_name];
			_mrk setMarkerAlphaLocal 1;
			OT_allShopMarkers pushback _mrkName;
		}foreach(server getVariable [format["activeshopsin%1",_tname],[]]);
		//Hardware Store Markers
		{
			_x params ["_pos","_name"];
			private _mrkName = format["%1 %2", _pos select 0, _pos select 1];
			_mrk = createMarkerLocal [_mrkName,_pos];
			_mrk setMarkerShapeLocal "ICON";
			_mrk setMarkerTypeLocal "ot_ShopHardware";
			_mrk setMarkerAlphaLocal 1;
			OT_allShopMarkers pushback _mrkName;
		}foreach(server getVariable [format["activehardwarein%1",_tname],[]]);
		//Vehicle Store Markers
		{
			private _mrkName = format["%1 %2", _x select 0, _x select 1];
			_mrk = createMarkerLocal [_mrkName,_x];
			_mrk setMarkerShapeLocal "ICON";
			_mrk setMarkerTypeLocal "ot_ShopVehicle";
			_mrk setMarkerAlphaLocal 1;
			OT_allShopMarkers pushback _mrkName;
		}foreach(server getVariable [format["activecarshopsin%1",_tname],[]]);
		//Pier Store Markers
		{
			private _mrkName = format["%1 %2", _x select 0, _x select 1];
			_mrk = createMarkerLocal [_mrkName,_x];
			_mrk setMarkerShapeLocal "ICON";
			_mrk setMarkerTypeLocal "ot_ShopPier";
			_mrk setMarkerAlphaLocal 1;
			OT_allShopMarkers pushback _mrkName;
		}foreach(server getVariable [format["activepiersin%1",_tname],[]]);
	} foreach (OT_townData);
};

OT_OnDraw = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", OT_fnc_mapHandler];

//Map caching
OT_mapcache_properties = [];
OT_mapcache_vehicles = [];
OT_mapcache_radar = [];
OT_mapcache_bodies = [];
//3 second Cache
[{
	if (!visibleMap) exitWith {};
	private _properties = [];
	private _vehs = [];
	private _radar = [];
	private _bodies = [];
	//Properties cache
	private _leased = player getvariable ["leased",[]];
	{
		private _buildingPos = buildingpositions getVariable _x;
		if!(isNil "_buildingPos") then {
			_properties pushback [
				"\A3\ui_f\data\map\mapcontrol\Tourism_CA.paa",
				[1,1,1,[1,0.3] select (_x in _leased)],
				_buildingPos,
				0.3,
				0.3,
				0
			];
		};
	}foreach(player getvariable ["owned",[]]);

	//Vehicle cache
	private _cfgVeh = configFile >> "CfgVehicles";
	{
		//Owned vehicles
		if(((typeof _x == OT_item_CargoContainer) || (_x isKindOf "Ship") || (_x isKindOf "Air") || (_x isKindOf "Car")) && {(count crew _x == 0)} && {(_x call OT_fnc_hasOwner)}) then {
			_vehs pushback [
				getText(_cfgVeh >> (typeof _x) >> "icon"),
				[1,1,1,1],
				getPosASL _x,
				0.4,
				0.4,
				getdir _x
			];
		};
		//All resistance static weapons
		if((_x isKindOf "StaticWeapon") && {(isNull attachedTo _x)} && {(alive _x)}) then {
			if(side _x isEqualTo civilian || side _x isEqualTo resistance || captive _x) then {
				_col = [0.5,0.5,0.5,1];
				if(!(isNull gunner _x) && {(alive gunner _x)}) then {_col = [0,0.5,0,1]};
				_i = "\A3\ui_f\data\map\markers\nato\o_art.paa";
				if(_x isKindOf "StaticMortar") then {_i = "\A3\ui_f\data\map\markers\nato\o_mortar.paa"};
				if !(someAmmo _x) then {_col set [3,0.4]};
				_vehs pushback [
					_i,
					_col,
					getPosASL _x,
					30,
					30,
					0
				];
			};
		};
		//Radar hits
		if((_x isKindOf "Air") && {(alive _x)} && ((side _x) isEqualTo west) && (_x call OT_fnc_isRadarInRange) && {(count crew _x > 0)}) then {
			_radar pushback _x;
		};
	} forEach entities [["Car", "Air", "Ship", "StaticWeapon", OT_item_CargoContainer], ["Parachute"], false, false];
	//Corpse cache
	{
		if (typeof _x != "B_UAV_AI") then {
			_p = getPosASL _x;
			_bodies pushback [
				"\overthrow_main\ui\markers\death.paa",
				[1,1,1,0.5],
				_p,
				0.2,
				0.2,
				0
			];
		};
	}foreach(alldeadmen);
	OT_mapcache_properties = _properties;
	OT_mapcache_vehicles = _vehs;
	OT_mapcache_radar = _radar;
	OT_mapcache_bodies = _bodies;
}, 3, []] call CBA_fnc_addPerFrameHandler;

//Map Icon Cache
[] spawn {
	OT_mapcache_factions = [];
	{
		_x params ["_cls","_name","_side","_flag"];
		// Ensure that the server is done with this faction
		waitUntil {!(isNil {server getVariable format["factionname%1",_cls]})};
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
	// server is probably done with them by now...?
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
};

[{
	disableSerialization;
	private _gps = controlNull;
	{
		if !(isNil {_x displayCtrl 101}) exitWith {
			_gps = _x displayCtrl 101;
		};
	} foreach(uiNamespace getVariable "IGUI_Displays");
	if (!isNull _gps) exitWith {
		if(!isNil "OT_GPSOnDraw") then {
			_gps ctrlRemoveEventHandler ['Draw',OT_GPSOnDraw];
		};
		OT_GPSOnDraw = _gps ctrlAddEventHandler ['Draw',OT_fnc_mapHandler];
	};
}, 0.5, []] call CBA_fnc_addPerFrameHandler;
