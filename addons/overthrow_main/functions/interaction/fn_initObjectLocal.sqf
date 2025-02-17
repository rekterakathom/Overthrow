private _currentObject = typeOf _this;

// The player doesn't have the vars -> wait until they do
if (isNil "OT_localPlayerInitDone" || {!(isNil "OT_localPlayerInitDone") && {!(OT_localPlayerInitDone)}}) exitWith {
	[
		{!(isNil "OT_localPlayerInitDone") && {OT_localPlayerInitDone}},
		{_this call OT_initObjectLocal},
		_currentObject,
		60 // 60s timeout to avoid eternal loop
	] call CBA_fnc_waitUntilAndExecute;
};

if(_currentObject isEqualTo OT_item_Map) then {
	_this addAction ["Town Info", OT_fnc_mapInfoDialog,nil,0,false,true,"",""];
	_this addAction ["Reset UI", {
		closeDialog 0;
		[] spawn OT_fnc_setupPlayer;
	},nil,0,false,true,"",""];
	_this enableDynamicSimulation true;
};

if(_currentObject isEqualTo OT_item_Storage) then {
	_this addAction ["Open Arsenal (This Ammobox)", {[_this select 0,player] call OT_fnc_openArsenal},nil,0,false,true,"","!(call OT_fnc_playerIsAtWarehouse)"];
	_this addAction ["Open Arsenal (Warehouse)", {["WAREHOUSE",player,_this select 0] call OT_fnc_openArsenal},nil,0,false,true,"","call OT_fnc_playerIsAtWarehouse"];
	_this addAction ["Take From Warehouse", {
		private _iswarehouse = call OT_fnc_playerIsAtWarehouse;

		if !(_iswarehouse) exitWith {
			"No warehouse within range or needs repair" call OT_fnc_notifyMinor;
		};

		OT_warehouseTarget = _this select 0;
		closeDialog 0;
		createDialog "OT_dialog_warehouse";
		[] call OT_fnc_warehouseDialog;
	},nil,0,false,true,"","call OT_fnc_playerIsAtWarehouse"];
	_this addAction ["Store In Warehouse", {
		private _iswarehouse = call OT_fnc_playerIsAtWarehouse;
		if !(_iswarehouse) exitWith {
			"No warehouse within range or needs repair" call OT_fnc_notifyMinor;
		};
		OT_warehouseTarget = _this select 0;
		call OT_fnc_storeAll;
	},nil,0,false,true,"","call OT_fnc_playerIsAtWarehouse"];
	_this addAction ["Dump Everything", {[player,_this select 0] call OT_fnc_dumpStuff},nil,0,false,true,"",""];
	_this addAction ["Dump Everything into Warehouse", {[player] call OT_fnc_dumpIntoWarehouse},nil,0,false,true,"","call OT_fnc_playerIsAtWarehouse"];
	if(_this call OT_fnc_playerIsOwner) then {
		_this addAction ["Lock", {
			(_this select 0) setVariable ["OT_locked",true,true];
			"Ammobox locked" call OT_fnc_notifyMinor;
		},nil,0,false,true,"","!(_target getVariable ['OT_locked',false])"];
		_this addAction ["Unlock", {
			(_this select 0) setVariable ["OT_locked",false,true];
			"Ammobox unlocked" call OT_fnc_notifyMinor;
		},nil,0,false,true,"","(_target getVariable ['OT_locked',false])"];
		_this addAction ["Make global (10000$)", {
			[OT_fnc_makeWarehouseGlobal, _this] call CBA_fnc_directCall;
		},nil,0,false,true,"","(call OT_fnc_playerIsAtWarehouse && !((nearestObject [_target, OT_warehouse]) getVariable ['is_shared', false]))"];
	};
	_this enableDynamicSimulation true;
};

if(_currentObject isEqualTo OT_item_Safe) then {
	_this addAction ["Put Money", OT_fnc_safePutMoney,nil,0,false,true,"",""];
	_this addAction ["Take Money", OT_fnc_safeTakeMoney,nil,0,false,true,"",""];
	_this addAction ["Set Password", OT_fnc_safeSetPassword,nil,0,false,true,"","(_target getVariable ['owner','']) isEqualTo getplayeruid _this"];
	_this enableDynamicSimulation true;
};

if(_currentObject isEqualTo "Land_Cargo_House_V4_F") then {
	[_this] call ace_repair_fnc_moduleAssignRepairFacility;
	_this enableDynamicSimulation true;
};

if(_this isKindOf "CAManBase" || _this isKindOf "FlagCarrier") exitWith {};

[_this, 0, ["ACE_MainActions"], OT_ACEremoveAction] call ace_interact_menu_fnc_addActionToObject;
[_this, 0, ["ACE_MainActions","OT_Remove"], OT_ACEremoveActionConfirm] call ace_interact_menu_fnc_addActionToObject;

if(_this isKindOf "Building" || _this isKindOf "LandVehicle") exitWith{};

_dir = 0;
if(_currentObject isEqualTo "C_Rubberboat") then {
	_dir = 90;
};
[_this, true, [0, 2, 0.4],_dir] call ace_dragging_fnc_setCarryable;
