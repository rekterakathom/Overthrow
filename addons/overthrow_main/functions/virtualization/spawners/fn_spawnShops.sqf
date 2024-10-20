private ["_id","_pos","_building","_tracked","_vehs","_group","_all","_shopkeeper","_groups"];

private _hour = date select 3;
params ["_town","_spawnid"];

private _activeshops = server getVariable [format["activeshopsin%1",_town],[]];

// All shopkeepers can be in the same group to save performance
private _groups = [];
private _group = createGroup civilian;
_group setBehaviour "CARELESS";
_group setGroupIdGlobal [format ["Shops %1", _town]];
_group setVariable ["VCM_Disable", true];
_group setVariable ["lambs_danger_disableGroupAI", true];
_groups pushBack _group;

if(count _activeshops > 0) exitWith {
	{
		//find building for active shop
		_x params ["_pos","_category"];
		private _pos = _x select 0;
		_building = nearestBuilding _pos;

		//set start location based on building config
		private _start = _building buildingPos getNumber(configFile >> "CfgVehicles" >> typeOf(_building) >> "ot_shopPos");
		if (isNil "_start" || {_start isEqualTo ""} || {_start isEqualTo "''"}) then { _start = _building buildingPos 0; };
		private _facing = 0;

		//spawn objects from building template
		private _tracked = _building call OT_fnc_spawnTemplate;		
		private _vehs = _tracked select 0;
		{
			//check for counter object and if found set start position relative.
			if (typeOf _x == "Land_CashDesk_F") then { 
				_start = _x getRelPos [0.8, 0]; 
				_facing = getDir _x - 180;
			};
			_groups pushBack _x;
		}forEach(_vehs);

		//create shopkeeper as member of group
		_shopkeeper = _group createUnit [OT_civType_shopkeeper, _start, [], 0, "CAN_COLLIDE"];

		_shopkeeper setDir _facing;
		doStop _shopkeeper;
		_shopkeeper allowDamage false;
		_shopkeeper setVariable ["NOAI",true,false];
		_shopkeeper setVariable ["shopcheck",true,true];
		_shopkeeper setVariable ["shop",format["%1",_pos],true];
		_shopkeeper setVariable ["OT_shopCategory",_category,true];
		_building setVariable ["OT_shopCategory",_category,true];
		[_shopkeeper] call OT_fnc_initShopkeeper;

		//Put a light on
		_light = "#lightpoint" createVehicle [_pos select 0,_pos select 1,(_pos select 2)+2.2];
		_light setLightBrightness 0.13;
		_light setLightAmbient[.9, .9, .6];
		_light setLightColor[.5, .5, .4];
		_groups pushBack _light;
		sleep 0.5;
	}forEach(_activeshops);

	// High command fix
	if (hcLeader _group isNotEqualTo objNull) then {
		(hcLeader _group) hcRemoveGroup _group;
	};

	spawner setVariable [_spawnid,(spawner getVariable [_spawnid,[]]) + _groups,false];
};
