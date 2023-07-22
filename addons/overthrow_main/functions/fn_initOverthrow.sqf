if(!isServer) exitWith {};

if !(isClass (configFile >> "CfgPatches" >> "OT_Overthrow_Main")) exitWith {
	diag_log "Overthrow addon not detected, you must add @Overthrow to your -mod commandline";
	"Overthrow addon not detected, you must add @Overthrow to your -mod commandline" call OT_fnc_notifyStart;
};

if (isDedicated) then {
	server_dedi = true;
}else{
	server_dedi = false;
};
publicVariable "server_dedi";

missionNamespace setVariable ["OT_varInitDone", false, true];

server = true call CBA_fnc_createNamespace;
publicVariable "server";
players_NS = true call CBA_fnc_createNamespace;
publicVariable "players_NS";
cost = true call CBA_fnc_createNamespace;
publicVariable "cost";

// This namespace contains a list of warehouses -
// instead of warehouse contents like in OT+
warehouse = true call CBA_fnc_createNamespace;
publicVariable "warehouse";

warehouse_shared = true call CBA_fnc_createNamespace;
publicVariable "warehouse_shared";

spawner = true call CBA_fnc_createNamespace;
publicVariable "spawner";
templates = true call CBA_fnc_createNamespace;
publicVariable "templates";
owners = true call CBA_fnc_createNamespace;
publicVariable "owners";
buildingpositions = true call CBA_fnc_createNamespace;
publicVariable "buildingpositions";
OT_civilians = true call CBA_fnc_createNamespace;
publicVariable "OT_civilians";

OT_centerPos = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");

// Init basic variables
call OT_fnc_initBaseVar;
call compileScript ["initVar.sqf", false];

// Get faction before final variable init & detection takes place
private _faction = ["ot_enemy_faction", 0] call BIS_fnc_getParamValue;
switch (_faction) do {
	case 0: {_faction = OT_faction_NATO};
	case 1: {_faction = "BLU_F"};
	case 2: {_faction = "BLU_T_F"};
	case 3: {_faction = "BLU_W_F"};
	case 4: {_faction = "rhs_faction_usarmy_wd"};
	case 5: {_faction = "rhs_faction_usarmy_d"};
	case 6: {_faction = "rhs_faction_usmc_wd"};
	case 7: {_faction = "rhs_faction_usmc_d"};
	case 8: {_faction = "rhsgref_faction_hidf"};
	case 9: {_faction = "UK3CB_AAF_B"};
	case 10: {_faction = "UK3CB_LDF_B"};
	case 11: {_faction = "UK3CB_LSM_B"};
	case 12: {_faction = "UK3CB_MDF_B"};
	case 13: {_faction = "UK3CB_MEI_B"};
	default {_faction = OT_faction_NATO};
};

OT_faction_NATO = _faction;
publicVariable "OT_faction_NATO";

// Dedicated servers need a separate definition for mission params
if (isDedicated) then {
	OT_randomizeLoadouts = (["ot_randomizeloadouts", 0] call BIS_fnc_getParamValue) isEqualTo 1;
	OT_factoryProductionMulti = (["ot_factoryproductionmulti", 0] call BIS_fnc_getParamValue) * 0.01;
	OT_gangMemberCap = ["ot_gangmembercap", 0] call BIS_fnc_getParamValue;
	OT_gangResourceCap = ["ot_gangresourcecap", 0] call BIS_fnc_getParamValue;
};

// Call final variable init
call OT_fnc_initVar;

diag_log "Overthrow: Server Pre-Init";
server setVariable ["StartupType","",true];
call OT_fnc_initVirtualization;


OT_tpl_checkpoint = [] call compileScript ["data\templates\NATOcheckpoint.sqf", true];

//Advanced towing script, credits to Duda http://www.armaholic.com/page.php?id=30575
// Disabled due to ACE towing
//[] spawn OT_fnc_advancedTowingInit;

[] spawn {
	if (false/*isDedicated && profileNamespace getVariable ["OT_autoload",false]*/) then {
		diag_log "== OVERTHROW == Mission autoloaded as per settings. Toggle in the options menu in-game to disable.";
		diag_log "== OVERTHROW == Waiting for a player to connect!";
		waitUntil{sleep 1; count ([] call CBA_fnc_players) > 0};
		[] spawn OT_fnc_loadGame;
	};

	waitUntil {sleep 1; server getVariable ["StartupType",""] != ""};

	if(OT_fastTime) then {
	    setTimeMultiplier 4;
	};

	//Init factions
	[] spawn OT_fnc_initNATO;
	waitUntil {!isNil "OT_NATOInitDone"};
	[] spawn OT_fnc_factionNATO;
	[] spawn OT_fnc_factionGUER;
	[] spawn OT_fnc_factionCRIM;

	[] spawn OT_fnc_initEconomyLoad;

	//Game systems
	[] spawn OT_fnc_propagandaSystem;
	[] spawn OT_fnc_weatherSystem;
	[] spawn OT_fnc_incomeSystem;
	[] spawn OT_fnc_jobSystem;

	//Init virtualization
	waitUntil {!isNil "OT_economyLoadDone"};
	[] spawn OT_fnc_runVirtualization;

	//ACE3 Arsenal default loadouts
	{
		_x params ["_cls","_loadout"];
		[_cls call OT_fnc_vehicleGetName, _loadout] call ace_arsenal_fnc_addDefaultLoadout;
	}foreach(OT_Recruitables);
	["Police", OT_Loadout_Police] call ace_arsenal_fnc_addDefaultLoadout;

	//Subscribe to events
	addMissionEventHandler ["PlayerConnected",OT_fnc_playerConnectHandler];
	addMissionEventHandler ["HandleDisconnect",OT_fnc_playerDisconnectHandler];
	["Building", "Dammaged", OT_fnc_buildingDamagedHandler] call CBA_fnc_addClassEventHandler;

	//ACE3 events
	["ace_cargoLoaded",OT_fnc_cargoLoadedHandler] call CBA_fnc_addEventHandler;
	["ace_common_setFuel",OT_fnc_refuelHandler] call CBA_fnc_addEventHandler;
	["ace_explosives_place",OT_fnc_explosivesPlacedHandler] call CBA_fnc_addEventHandler;
	["ace_tagCreated", OT_fnc_taggedHandler] call CBA_fnc_addEventHandler;
	["ace_repair_setWheelHitPointDamage",OT_fnc_wheelStateHandler] call CBA_fnc_addEventHandler;
	["ace_treatmentSucceded", OT_fnc_healedHandler] call CBA_fnc_addEventHandler;

	//Overthrow events
	["OT_QRFstart", OT_fnc_QRFStartHandler] call CBA_fnc_addEventHandler;
	["OT_QRFend", OT_fnc_QRFEndHandler] call CBA_fnc_addEventHandler;

	addMissionEventHandler ["EntityKilled", OT_fnc_deathHandler];

	["OT_autosave_loop"] call OT_fnc_addActionLoop;
	["OT_civilian_cleanup_crew", "time > OT_cleanup_civilian_loop","
		OT_cleanup_civilian_loop = time + (5*60);
		private _totalcivs = {!captive _x} count (units civilian);
		{
			if(_x getVariable ['OT_Looted',false]) then {
				private _stock = _x call OT_fnc_unitStock;
				if((count _stock) isEqualTo 0) then {
					[_x] call OT_fnc_cleanupUnit;
				};
			};
		}forEach(alldeadmen);
		if(_totalcivs < 50) exitWith {};
		{
			if (!(isPlayer _x) && !(_x getVariable ['shopcheck',false]) && { ({side _x isEqualTo civilian} count (_x nearEntities ['CAManBase',150])) > round(150*OT_spawnCivPercentage) } ) then {
				private _unit = _x;
				[_unit] call OT_fnc_cleanupUnit;
			};
		}forEach (units civilian);
	"] call OT_fnc_addActionLoop;

	OT_serverInitDone = true;
	publicVariable "OT_serverInitDone";
	diag_log "Overthrow: Server Pre-Init Done";
};
