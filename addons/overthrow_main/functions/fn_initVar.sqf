private _cfgVehicles = configFile >> "CfgVehicles";
private _cfgWeapons = configFile >> "CfgWeapons";
private _cfgMagazines = configFile >> "CfgMagazines";

OT_ACEremoveAction = [
	"OT_Remove",
	"Remove",
	"",
	{},
	{params ["_target"]; (call OT_fnc_playerIsGeneral) || (_target call OT_fnc_playerIsOwner)},
	{},
	[],
	[0,0,0],
	10
] call ace_interact_menu_fnc_createAction;
OT_ACEremoveActionConfirm = [
	"OT_Remove_Confirm",
	"Confirm",
	"",
	{params ["_target"]; deleteVehicle _target;},
	{true},
	{},
	[],
	[0,0,0],
	10
] call ace_interact_menu_fnc_createAction;

//Find markers
OT_ferryDestinations = [];
OT_NATO_control = [];
OT_regions = [];
{
	if((_x select [0,12]) isEqualTo "destination_") then {OT_ferryDestinations pushBack _x; continue};
	if((_x select [0,8]) isEqualTo "control_") then {OT_NATO_control pushBack _x; continue};
	if((_x select [0,7]) isEqualTo "island_") then {OT_regions pushBack _x; continue};
	if((_x select [0,7]) isEqualTo "region_") then {OT_regions pushBack _x};
}forEach(allMapMarkers);

OT_missions = [];
OT_localMissions = [];
{
	_name = configName _x;
	_script = getText (_x >> "script");
	_code = compileScript [_script, true];
	OT_missions pushBack _code;
}forEach("true" configClasses ( configFile >> "CfgOverthrowMissions" ));

OT_tutorialMissions = [];
OT_tutorialMissions pushBack (compileScript ["\overthrow_main\missions\tutorial\tut_NATO.sqf", true]); // index 0
//OT_tutorialMissions pushback (compileFinal preprocessFileLineNumbers "\overthrow_main\missions\tutorial\tut_CRIM.sqf");
OT_tutorialMissions pushBack (compileScript ["\overthrow_main\missions\tutorial\tut_Drugs.sqf", true]); // index 1
OT_tutorialMissions pushBack (compileScript ["\overthrow_main\missions\tutorial\tut_Economy.sqf", true]); // index 2

OT_NATO_HQ_garrisonPos = [];
OT_NATO_HQ_garrisonDir = 0;

OT_QRFstart = nil;

// Load mission data
call compileScript ["data\names.sqf", false];
call compileScript ["data\towns.sqf", false];
call compileScript ["data\airports.sqf", false];
call compileScript ["data\objectives.sqf", false];
call compileScript ["data\economy.sqf", false];
call compileScript ["data\comms.sqf", false];

//Identity
OT_faces_local = [];
OT_faces_western = [];
OT_faces_eastern = [];
{
    private _types = getArray(_x >> "identityTypes");
	if(OT_identity_local in _types) then {OT_faces_local pushBack configName _x};
	if(OT_identity_western in _types) then {OT_faces_western pushBack configName _x};
	if(OT_identity_eastern in _types) then {OT_faces_eastern pushBack configName _x};
}forEach("getNumber(_x >> 'disabled') isEqualTo 0" configClasses (configFile >> "CfgFaces" >> "Man_A3"));

OT_voices_local = [];
OT_voices_western = [];
OT_voices_eastern = [];
{
    private _types = getArray(_x >> "identityTypes");
	if(OT_language_local in _types) then {OT_voices_local pushBack configName _x};
	if(OT_language_western in _types) then {OT_voices_western pushBack configName _x};
	if(OT_language_eastern in _types) then {OT_voices_eastern pushBack configName _x};
}forEach("getNumber(_x >> 'scope') isEqualTo 2" configClasses (configFile >> "CfgVoice"));

//Find houses
OT_hugePopHouses = ["Land_MultistoryBuilding_01_F","Land_MultistoryBuilding_03_F","Land_MultistoryBuilding_04_F","Land_House_2W04_F","Land_House_2W03_F"]; //buildings with potentially lots of people living in them
OT_mansions = ["Land_House_Big_02_F","Land_House_Big_03_F","Land_Hotel_01_F","Land_Hotel_02_F"]; //buildings that rich guys like to live in
OT_lowPopHouses = [];
OT_medPopHouses = [];
OT_highPopHouses = [];
{
    private _cost = getNumber(_x >> "cost");
    [_cost,configName _x] call {
		params ["_cost","_name"];
        if(_cost > 70000) exitWith {OT_hugePopHouses pushBack _name;};
        if(_cost > 55000) exitWith {OT_highPopHouses pushBack _name;};
        if(_cost > 25000) exitWith {OT_medPopHouses pushBack _name;};
        OT_lowPopHouses pushBack _name;
    };
}forEach("(getNumber (_x >> 'scope') isEqualTo 2) && {(configName _x isKindOf 'House') && {'_house' in (toLowerANSI (configName _x))}}" configClasses (_cfgVehicles));

OT_allBuyableBuildings = OT_lowPopHouses + OT_medPopHouses + OT_highPopHouses + OT_hugePopHouses + OT_mansions + [OT_item_Tent,OT_flag_IND];

OT_allHouses = OT_lowPopHouses + OT_medPopHouses + OT_highPopHouses + OT_hugePopHouses;
OT_allRealEstate = OT_lowPopHouses + OT_medPopHouses + OT_highPopHouses + OT_hugePopHouses + OT_mansions + [OT_warehouse,OT_policeStation,OT_barracks,OT_barracks,OT_workshopBuilding,OT_refugeeCamp,OT_trainingCamp];

OT_allTowns = [];
OT_allTownPositions = [];

{
	_x params ["_pos","_name"];
	OT_allTowns pushBack _name;
	OT_allTownPositions pushBack _pos;
	if(isServer) then {
		server setVariable [_name,_pos,true];
	};
}forEach(OT_townData);

OT_allAirports = OT_airportData apply { _x select 1 };

//Global overthrow variables related to any map

OT_currentMissionFaction = "";
OT_rankXP = [100,250,500,1000,4000,10000,100000];

OT_adminMode = false;
OT_deepDebug = false;
OT_allIntel = [];
OT_notifies = [];

OT_NATO_HQPos = [0,0,0];

OT_fastTime = true; //When true, 1 day will last 6 hrs real time
OT_spawnDistance = 1200;
if (isNil "OT_spawnCivPercentage") then {
	OT_spawnCivPercentage = 0.03;
};
OT_spawnVehiclePercentage = 0.04;
OT_standardMarkup = 0.2; //Markup in shops is calculated from this
OT_randomSpawnTown = false; //if true, every player will start in a different town, if false, all players start in the same town
OT_distroThreshold = 500; //Size a towns order must be before a truck is sent (in dollars)
OT_saving = false;
OT_activeShops = [];
OT_selling = false;
OT_taking = false;
OT_interactingWith = objNull;

OT_garrisonBuildings = ["Land_Cargo_Patrol_V1_F","Land_Cargo_Patrol_V2_F","Land_Cargo_Patrol_V3_F","Land_Cargo_Patrol_V4_F","Land_Cargo_HQ_V1_F","Land_Cargo_HQ_V2_F","Land_Cargo_HQ_V3_F","Land_Cargo_HQ_V4_F","Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V2_F","Land_Cargo_Tower_V3_F","Land_Cargo_Tower_V4_F","Land_Cargo_Tower_V1_No1_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No4_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No7_F","Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F"]; //Put HMGs in these buildings

OT_ammo_50cal = "OT_ammo50cal";

OT_item_wrecks = ["Land_Wreck_HMMWV_F","Land_Wreck_Skodovka_F","Land_Wreck_Truck_F","Land_Wreck_Car2_F","Land_Wreck_Car_F","Land_Wreck_Hunter_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad2_F","Land_Wreck_UAZ_F","Land_Wreck_Truck_dropside_F"]; //rekt

OT_NATOwait = 500; //Half the Average time between NATO orders
OT_CRIMwait = 500; //Half the Average time between crim changes
OT_jobWait = 60;

OT_Resources = ["OT_Wood","OT_Steel","OT_Plastic","OT_Sugarcane","OT_Sugar","OT_Fertilizer","OT_Lumber","OT_Wine","OT_Grapes","OT_Olives"];

OT_item_CargoContainer = "B_Slingload_01_Cargo_F";

//Shop items
OT_item_ShopRegister = "Land_CashDesk_F";//Cash registers
OT_item_BasicGun = "hgun_P07_F";//Dealers always sell this cheap
OT_item_BasicAmmo = "16Rnd_9x21_Mag";

OT_allDrugs = ["OT_Ganja","OT_Blow"];
OT_illegalItems = OT_allDrugs;

OT_item_UAV = "I_UAV_01_F";
OT_item_UAVterminal = "I_UavTerminal";

OT_item_DefaultBlueprints = [];

OT_itemCategoryDefinitions = [
    ["General",["ACE_fieldDressing","Banana","ACE_Can_Franta","ACE_Can_RedGull","ACE_Can_Spirit","ACE_Canteen","ACE_WaterBottle","ACE_MRE_BeefStew","ACE_MRE_ChickenTikkaMasala","ACE_MRE_ChickenHerbDumplings","ACE_MRE_CreamChickenSoup","ACE_MRE_CreamTomatoSoup","ACE_MRE_LambCurry","ACE_MRE_MeatballsPasta","ACE_MRE_SteakVegetables","Map","ToolKit","Compass","ACE_EarPlugs","Watch","Radio","Compass","ACE_Spraypaint","Altimiter","MapTools","Binocular"]],
    ["Pharmacy",["Dressing","Bandage","morphine","adenosine","atropine","ACE_EarPlugs","epinephrine","bodyBag","quikclot","salineIV","bloodIV","plasmaIV","personalAidKit","surgicalKit","tourniquet","splint"]],
    ["Electronics",["Rangefinder","Cellphone","Radio","Watch","GPS","monitor","DAGR","_dagr","Battery","ATragMX","ACE_Flashlight","I_UavTerminal","ACE_Kestrel4500"]],
    ["Hardware",["Tool","CableTie","ACE_Spraypaint","wirecutter","ACE_rope3","ACE_rope6","ACE_rope12","ACE_rope15","ACE_rope18","ACE_rope27","ACE_rope36"]],
    ["Surplus",["Rangefinder","Binocular","Compass","RangeCard","RangeTable","DefusalKit","SpottingScope","ACE_Vector","ACE_Yardage","ACE_Kestrel4500","ACE_NVG_Gen4","ACE_NVG_Wide"]]
];

OT_items = [];
OT_allItems = [];
OT_craftableItems = [];

call OT_fnc_detectItems;

OT_notifyHistory = [];

OT_staticBackpacks = [
	["I_HMG_01_high_weapon_F",600,1,0,1],
	["I_GMG_01_high_weapon_F",2500,1,0,1],
	["I_HMG_01_support_high_F",50,1,0,0],
	["I_Mortar_01_weapon_F",5000,1,0,1],
	["I_Mortar_01_support_F",100,1,0,0],
	["I_AT_01_weapon_F",2500,1,0,1],
	["I_AA_01_weapon_F",2500,1,0,1],
	["I_HMG_01_support_F",50,1,0,0]
];

OT_backpacks = [
	["B_AssaultPack_cbr",20,0,0,1],
	["B_AssaultPack_blk",20,0,0,1],
	["B_AssaultPack_khk",20,0,0,1],
	["B_AssaultPack_sgg",20,0,0,1],
	["B_FieldPack_cbr",30,0,0,1],
	["B_FieldPack_blk",30,0,0,1],
	["B_FieldPack_khk",30,0,0,1],
	["B_FieldPack_oli",30,0,0,1],
	["B_Kitbag_cbr",45,0,0,1],
	["B_Kitbag_sgg",45,0,0,1],
	["B_Carryall_cbr",60,0,0,1],
	["B_Carryall_khk",60,0,0,1],
	["B_Carryall_oli",60,0,0,1],
	["B_Parachute",50,0,0,1]
];
if(OT_hasTFAR) then {
	OT_backpacks append [
		["tf_anprc155",100,0,0,0.1],
		["tf_anarc210",150,0,0,0.1],
		["tf_anarc164",20,0,0,0.5],
		["tf_anprc155_coyote",10,0,0,0.5]
	];
};

if (isServer) then {
	cost setVariable ["OT_Wood",[5,0,0,0],true];
	cost setVariable ["OT_Lumber",[8,0,0,0],true];
	cost setVariable ["OT_Steel",[25,0,0,0],true];
	cost setVariable ["OT_Plastic",[40,0,0,0],true];
	cost setVariable ["OT_Sugarcane",[5,0,0,0],true];
	cost setVariable ["OT_Grapes",[5,0,0,0],true];
	cost setVariable ["OT_Sugar",[15,0,0,0],true];
	cost setVariable ["OT_Wine",[25,0,0,0],true];
	cost setVariable ["OT_Olives",[7,0,0,0],true];
	cost setVariable ["OT_Fertilizer",[20,0,0,0],true];
};


//Detecting vehicles and weapons

OT_boats = [
	["C_Scooter_Transport_01_F",150,1,0,1],
	["C_Boat_Civil_01_rescue_F",300,1,1,1],
	["C_Boat_Transport_02_F",600,1,0,1]
];
OT_vehicles = [];
OT_helis = [];
OT_allVehicles = [];
OT_allBoats = ["B_Boat_Transport_01_F"];
OT_allWeapons = [];
OT_allOptics = [];
OT_allMagazines = [OT_ammo_50cal];
OT_allBackpacks = [];
OT_allStaticBackpacks = [];
OT_vehWeights_civ = [];
OT_mostExpensiveVehicle = "";
OT_allHeliThreats = [];
OT_allPlaneThreats = [];
OT_allVehicleThreats = [];

OT_spawnHouses = [];
{
	private _cls = configName _x;
	OT_spawnHouses pushBack _cls;
	OT_allBuyableBuildings pushBackUnique _cls;
	OT_allRealEstate pushBackUnique _cls;
}forEach( "getNumber ( _x >> ""ot_isPlayerHouse"" ) isEqualTo 1" configClasses ( _cfgVehicles ) );

//Mission house overrides
{
	_x params ["_cls","_template"];
	OT_spawnHouses pushBack _cls;
	OT_allBuyableBuildings pushBackUnique _cls;
	OT_allRealEstate pushBackUnique _cls;
	templates setVariable [_cls,_template,true];
}forEach(OT_spawnHouseBuildings);

OT_gunDealerHouses = OT_spawnHouses;

private _allShops = "getNumber ( _x >> ""ot_isShop"" ) isEqualTo 1" configClasses ( _cfgVehicles );
OT_shops = _allShops apply {configName _x};

//Mission shop overrides
{
	_x params ["_cls","_template"];
	OT_shops pushBack _cls;
	templates setVariable [_cls,_template,true];
}forEach(OT_shopBuildings);

private _allCarShops = "getNumber ( _x >> ""ot_isCarDealer"" ) isEqualTo 1" configClasses ( _cfgVehicles );
OT_carShops = _allCarShops apply {configName _x};

//Mission car shop overrides
{
	_x params ["_cls","_template"];
	OT_carShops pushBack _cls;
	templates setVariable [_cls,_template,true];
}forEach(OT_carShopBuildings);

//Calculate prices
//First, load the hardcoded prices from data/prices.sqf
if(isServer) then {
	OT_loadedPrices = [];
	call compileScript ["\overthrow_main\data\prices.sqf", false];
	{
		OT_loadedPrices pushBack (_x select 0);
		cost setVariable[_x select 0,_x select 1, true];
	}forEach(OT_priceData);
	OT_priceData = nil; //free memory

	call compileScript ["\overthrow_main\data\gangnames.sqf", false];
};

private _allVehs = "
	( getNumber ( _x >> 'scope' ) isEqualTo 2
	&&
	{ (getArray ( _x >> 'threat' ) # 0) < 0.5 }
	&&
	{ toLowerANSI getText ( _x >> 'vehicleClass' ) in ['car', 'support'] }
	&&
	{ toLowerANSI getText ( _x >> 'faction' ) in ['civ_f', 'ind_f'] })
" configClasses ( _cfgVehicles );

private _mostExpensive = 0;
{
	private _cls = configName _x;
	private _clsConfig = _x;
	private _cost = round(getNumber (_clsConfig >> "armor") + (getNumber (_clsConfig >> "enginePower") * 2));
	_cost = _cost + round(getNumber (_clsConfig >> "maximumLoad") * 0.1);

	if(_cls isKindOf "Truck_F") then {_cost = _cost * 2};
	if(getText (_clsConfig >> "faction") != "CIV_F") then {_cost = _cost * 1.5};


	OT_vehicles pushBack [_cls,_cost,0,getNumber (_clsConfig >> "armor"),2];
	OT_allVehicles pushBack _cls;
	if(getText (_clsConfig >> "faction") == "CIV_F") then {
		if(getText(_clsConfig >> "textSingular") != "truck" && getText(_clsConfig >> "driverAction") != "Kart_driver") then {
			OT_vehTypes_civ pushBack _cls;

			if(_cost > _mostExpensive)then {
				_mostExpensive = _cost;
				OT_mostExpensiveVehicle = _cls;
			};
		};
	};
}forEach(_allVehs);

//Determine vehicle threats
_allVehs = "
	( getNumber ( _x >> 'scope' ) isEqualTo 2
	&&
	{ (getArray ( _x >> 'threat' ) # 0) > 0}
	&&
	{ toLowerANSI getText ( _x >> 'vehicleClass' ) in ['car', 'armored']})

" configClasses ( _cfgVehicles );

{
	OT_allVehicleThreats pushBack (configName _x);
}forEach(_allVehs);

private _allHelis = "
    ( getNumber ( _x >> 'scope' ) isEqualTo 2
    &&
	{ (getArray ( _x >> 'threat' ) select 0) < 0.5}
	&&
    { toLowerANSI getText ( _x >> 'vehicleClass' ) isEqualTo 'air'}
	&&
    { toLowerANSI getText ( _x >> 'faction' ) in ['civ_f', 'ind_f'] })
" configClasses ( _cfgVehicles );

{
	private _cls = configName _x;
	private _clsConfig = _x;
	private _multiply = 3;
	if(_cls isKindOf "Plane") then {_multiply = 6};
	private _cost = (getNumber (_clsConfig >> "armor") + getNumber (_clsConfig >> "enginePower")) * _multiply;
	_cost = _cost + round(getNumber (_clsConfig >> "maximumLoad") * _multiply);
	private _steel = round(getNumber (_clsConfig >> "armor"));
	private _numturrets = count("true" configClasses(_clsConfig >> "Turrets"));
	private _plastic = 2;
	if(_numturrets > 0) then {
		_cost = _cost + (_numturrets * _cost * _multiply);
		_steel = _steel * 3;
		_plastic = 6;
	};

	if(isServer && isNil {cost getVariable _cls}) then {
		cost setVariable [_cls,[_cost,0,_steel,_plastic],true];
	};

	OT_helis pushBack [_cls,[_cost,0,_steel,_plastic],true];
	OT_allVehicles pushBack _cls;
}forEach(_allHelis);

//Determine aircraft threats
_allHelis = "
    ( getNumber ( _x >> 'scope' ) isEqualTo 2
    &&
	{ (getArray ( _x >> 'threat' ) select 0) >= 0.5}
	&&
    { toLowerANSI getText ( _x >> 'vehicleClass' ) isEqualTo 'air'})
" configClasses ( _cfgVehicles );

{
	private _cls = configName _x;
	// private _clsConfig = _x;
	// private _numturrets = count("true" configClasses(_clsConfig >> "Turrets"));

	if(_cls isKindOf "Plane") then {
		OT_allPlaneThreats pushBack _cls;
	}else{
		OT_allHeliThreats pushBack _cls;
	};
}forEach(_allHelis);

//Chinook (unarmed) special case for production logistics
OT_helis pushBack ["B_Heli_Transport_03_unarmed_F",[150000,0,110,5],true];
OT_allVehicles pushBackUnique "B_Heli_Transport_03_unarmed_F";
if(isServer) then {
	cost setVariable ["B_Heli_Transport_03_unarmed_F",[150000,0,110,5],true];
};

{
	private _cls = _x select 0;
	if(isServer && isNil {cost getVariable _cls}) then {
		cost setVariable [_cls,[_x select 1,_x select 2,_x select 3,_x select 4],true];
	};
	if(_cls in OT_vehTypes_civ) then {
		OT_vehWeights_civ pushBack (_mostExpensive - (_x select 1)) + 1; //This will make whatever is the most expensive car very rare
	};
	OT_allVehicles pushBack _cls;
}forEach(OT_vehicles);

// Filter the scope only once
private _filteredWeaponConfigs = "
	(getNumber (_x >> 'scope') == 2)
" configClasses (_cfgWeapons);

private _allWeapons = [];
private _allVests = [];
private _allDetonators = [];
private _allOptics = [];
private _allAttachments = [];
private _allUniforms = [];
private _allHelmets = [];

{
	if (getNumber (_x >> "type") in [1,2,4]) then { _allWeapons pushBack _x; continue};
	if (getNumber (_x >> "ItemInfo">> "type") == 701) then { _allVests pushBack _x; continue};
	if (getNumber (_x >> "ItemInfo" >> "type") == 201) then { _allOptics pushBack _x; continue };
	if (getNumber (_x >> "ItemInfo" >> "type") in [101,301,302]) then { _allAttachments pushBack _x; continue };
	if (getNumber (_x >> "ItemInfo" >> "type") == 605) then { _allHelmets pushBack _x; continue };
	if (getNumber (_x >> "ItemInfo" >> "type") == 801) then { _allUniforms pushBack _x; continue };
	if (getNumber ( _x >> "ace_explosives_Detonator" ) == 1) then { _allDetonators pushBack _x};
} forEach _filteredWeaponConfigs;

// Delete this massive variable after it's no longer used
_filteredWeaponConfigs = nil;

private _allAmmo = "
    ( getNumber ( _x >> 'scope' ) isEqualTo 2 )
" configClasses ( configFile >> "cfgMagazines" );

private _allVehicles = "
    ( getNumber ( _x >> 'scope' ) > 0 )
" configClasses ( _cfgVehicles );

private _allFactions = "
    ( getNumber ( _x >> 'side' ) < 3 )
" configClasses ( configFile >> "cfgFactionClasses" );

private _allGlasses = "
    ( getNumber ( _x >> 'scope' ) isEqualTo 2 )
" configClasses ( configFile >> "CfgGlasses" );

OT_allFactions = [];
OT_allSubMachineGuns = [];
OT_allAssaultRifles = [];
OT_allMachineGuns = [];
OT_allSniperRifles = [];
OT_allHandGuns = [];
OT_allMissileLaunchers = [];
OT_allRocketLaunchers = [];
OT_allExpensiveRifles = [];
OT_allCheapRifles = [];
OT_allVests = [];
OT_allProtectiveVests = [];
OT_allExpensiveVests = [];
OT_allCheapVests = [];
OT_allClothing = [];
OT_allOptics = [];
OT_allHelmets = [];
OT_allHats = [];
OT_allAttachments = [];
OT_allExplosives = [];
OT_explosives = [];
OT_detonators = [];
OT_allDetonators = [];
OT_allGlasses = [];
OT_allFacewear = [];
OT_allGoggles = [];
OT_allBLURifles = [];
OT_allBLUSMG = [];
OT_allBLUMachineGuns = [];
OT_allBLUSniperRifles = [];
OT_allBLUGLRifles = [];
OT_allBLULaunchers = [];
OT_allBLUPistols = [];
OT_allBLUVehicles = [];
OT_allBLUOffensiveVehicles = [];
OT_allBLURifleMagazines = [];

{
	private _name = configName _x;
	private _title = getText (_x >> "displayname");
	private _m = getNumber(_x >> "mass");
	private _ignore = getNumber(_x >> "ot_shopignore");
	if(_ignore != 1) then {
		if("Balaclava_TI_" in _name) then {
			_m = _m * 2;
		};

		private _protection = getNumber(_x >> "ACE_Protection");
		if(_protection > 0) then {
			_m = round(_m * 1.5);
		};

		[_name,_title] call {
			params ["_name","_title"];
			_name = toLowerANSI _name;
			if(_name == "none") exitWith {};
			if(_name == "g_goggles_vr") exitWith {};

			if (
				"respirator" in _name
				|| "blindfold" in _name
				|| "regulator" in _name
			) exitWith {};

			if("Tactical" in _title || "Diving" in _title || "Goggles" in _title) exitWith {
				OT_allGoggles pushBack _name;
			};
			if("Balaclava" in _title || "Bandana" in _title) exitWith {
				OT_allFacewear pushBack _name;
			};
			OT_allGlasses pushBack _name;
		};
		if(isServer && _name != "None" && isNil {cost getVariable _name}) then {
			cost setVariable [_name,[_m*3,0,0,ceil(_m*0.5)],true];
		};
	};
}forEach(_allGlasses);

{
	private _name = configName _x;
	private _title = getText (_x >> "displayName");
	private _side = getNumber (_x >> "side");
	private _flag = getText (_x >> "flag");
	private _numblueprints = 0;

	//736

	//Get vehicles and weapons
	private _vehicles = [];
	private _weapons = [];
	
	// These weapons and magazines will NEVER be given to units.
	private _blacklist = ["Throw","Put","NLAW_F","rhs_weap_m79","rhs_mag_30Rnd_556x45_M200_Stanag"];

	private _all = format["(getNumber( _x >> ""scope"" ) isEqualTo 2 ) && {(getText( _x >> ""faction"" ) isEqualTo '%1')}",_name] configClasses ( _cfgVehicles );
	{
		private _cls = configName _x;
		if(_cls isKindOf "CAManBase") then {
			//Get weapons;
			{
				private _base = [_x] call BIS_fnc_baseWeapon;
				if !(_base in _blacklist) then {
					private _muzzleEffect = getText (_cfgWeapons >> _base >> "muzzleEffect");
					if (!(_x in _weapons) && (getNumber (_cfgWeapons >> _base >> "scope") isEqualTo 2)) then {_weapons pushBack _base};
					if(_side isEqualTo 1 && !(_muzzleEffect isEqualTo "BIS_fnc_effectFiredFlares")) then {
						if(_base isKindOf ["Rifle", _cfgWeapons]) then {
							private _mass = getNumber (_cfgWeapons >> _base >> "WeaponSlotsInfo" >> "mass");
							_base call {
								_itemType = ([_cls] call BIS_fnc_itemType) select 1;
								if(_itemType isEqualTo "MachineGun") exitWith {OT_allBLUMachineGuns pushBackUnique _base};
								if((_this select [0,7]) == "srifle_" || (_this isKindOf ["Rifle_Long_Base_F", _cfgWeapons])) exitWith {OT_allBLUSniperRifles pushBackUnique _base};
								if("_GL_" in _this) exitWith {OT_allBLUGLRifles pushBackUnique _base};
								private _events = "" configClasses (_cfgWeapons >> _base >> "Eventhandlers");
								_add = true;
								{
									private _n = configName _x;
									if(_n isEqualTo "RHS_BoltAction") exitWith {_add = false}; //ignore RHS bolt-action rifles
								}forEach(_events);
								if(_add && _mass < 61) exitWith {OT_allBLUSMG pushBackUnique _base};
								if(_add) then {
									OT_allBLURifles pushBackUnique _base;
									OT_allBLURifleMagazines = OT_allBLURifleMagazines + getArray(_cfgWeapons >> _base >> "WeaponSlotsInfo" >> "magazines");
								};
							};
						};
						if(_base isKindOf ["Launcher", _cfgWeapons]) then {OT_allBLULaunchers pushBackUnique _base};
						if(_base isKindOf ["Pistol", _cfgWeapons]) then {OT_allBLUPistols pushBackUnique _base};
					};
					//Get ammo
					{
						if ((getNumber (configFile >> "CfgMagazines" >> _x >> "scope") isEqualTo 2) && {!(_x in _blacklist) || _x in OT_allExplosives}) then {
							_weapons pushBackUnique _x
						};
					}forEach(getArray(_cfgWeapons >> _base >> "magazines"));
				};
			}forEach(getArray(_cfgVehicles >> _cls >> "weapons"));
		}else{
			//It's a vehicle
			if !(_cls isKindOf "Bag_Base" || _cls isKindOf "StaticWeapon") then {
				if(_cls isKindOf "LandVehicle" || _cls isKindOf "Air" || _cls isKindOf "Ship") then {
					_vehicles pushBack _cls;
					_numblueprints = _numblueprints + 1;
					if(_side isEqualTo 1) then {
						private _threat = getArray (_x >> "threat");
						if(_threat # 0 > 0.5) then {
							OT_allBLUOffensiveVehicles pushBackUnique _cls;
						}else{
							OT_allBLUVehicles pushBackUnique _cls;
						};
					};
				};
			};
		};
	}forEach(_all);
	_weapons = (_weapons arrayIntersect _weapons); //remove duplicates

	if(isServer) then {
		spawner setVariable [format["facweapons%1",_name],_weapons,true];
		spawner setVariable [format["facvehicles%1",_name],_vehicles,true];
	};
	if(_side > -1 && _numblueprints > 0) then {
		OT_allFactions pushBack [_name,_title,_side,_flag];
	};
}forEach(_allFactions);

private _caliberRegex = "(\d*\.\d+)\s*x\s*(\d+)|(\d+)\.(\d+)|\.(\d+)|(\d+)x(\d+)|(\d+)\s*GA/i";
{
	private _name = [configName _x] call BIS_fnc_baseWeapon;

	private _short = getText (_cfgWeapons >> _name >> "descriptionShort");

	private _caliber = (_short regexFind [_caliberRegex]);
	private _haslauncher = false;
	if (_caliber isNotEqualTo []) then {
		_caliber = _caliber # 0 # 0 # 0;
	} else {
		// We didn't find a caliber. Start looping through mags until we find a caliber.
		private _magazines = getArray (_cfgWeapons >> _name >> "magazines");
		{
			private _magName = getText (_cfgMagazines >> _x >> "displayName");
			private _magCaliber =  _magName regexFind [_caliberRegex];
			if (_magCaliber isNotEqualTo []) exitWith {_caliber = _magCaliber # 0 # 0 # 0};
			private _magDescription = getText (_cfgMagazines >> _x >> "descriptionShort");
			private _magCaliber =  _magDescription regexFind [_caliberRegex];
			if (_magCaliber isNotEqualTo []) exitWith {_caliber = _magCaliber # 0 # 0 # 0};
		} forEach _magazines; 
	};

	// A caliber wasn't found. Default to empty string
	if (_caliber isEqualType []) then {
		_caliber = "";
		diag_log format ["Overthrow: Couldn't find a caliber for %1", _name];
	};

	private _weapon = [_name] call BIS_fnc_itemType;
	private _weaponType = _weapon select 1;

	private _muzzles = getArray (_cfgWeapons >> _name >> "muzzles");
	{
		if("EGLM" in _x) then {
			_haslauncher = true;
		};
	}forEach(_muzzles);

	([_weaponType,_name,_caliber,_haslauncher,_short] call {
		params ["_weaponType","_name","_caliber","_haslauncher","_short"];

		if (_weaponType == "SubmachineGun") exitWith {
			OT_allSubMachineGuns pushBack _name;
			[350, 1];
		};
		if (_weaponType == "AssaultRifle") exitWith {
			private _cost = [_caliber] call {
				params ["_caliber"];
				_caliber = toLower _caliber;
				if("5.56" in _caliber || "5.45" in _caliber || "5.8" in _caliber) exitWith {500};
				if("12 ga" in _caliber) exitWith {1200};
				if(".408" in _caliber) exitWith {4000};
				if(".338" in _caliber || ".303" in _caliber) exitWith {700};
				if("9.3" in _caliber) exitWith {1700};
				if("6.5" in _caliber) exitWith {1000};
				if("7.62" in _caliber) exitWith {1500};
				if("12.7" in _caliber) exitWith {3000};
				if("9" in _caliber) exitWith {400}; //9x21mm
				//I dunno what caliber this is
				1500;
			};
			if(_haslauncher) then {_cost = round(_cost * 1.2)};
			OT_allAssaultRifles pushBack _name;
			if(_cost > 1400) then {
				OT_allExpensiveRifles pushBack _name;
			} else {
				OT_allCheapRifles pushBack _name;
			};
			[_cost, 2]
		};
		if (_weaponType == "Shotgun") exitWith {
			OT_allAssaultRifles pushBack _name;
			[250, 0.5];
		};
		if (_weaponType ==  "MachineGun") exitWith {
			OT_allMachineGuns pushBack _name;
			[1500, 2];
		};
		if (_weaponType ==  "SniperRifle") exitWith {
			OT_allSniperRifles pushBack _name;
			[4000, 2];
		};
		if (_weaponType ==  "Handgun") exitWith {
			private _cost = _caliber call {
				if(".408" in _this) exitWith {2000};
				if(".338" in _this || ".303" in _this) exitWith {700};
				100
			};
			if(_short != "Metal Detector") then {
				OT_allHandGuns pushBack _name
			};
			[_cost, 1]
		};
		if (_weaponType ==  "MissileLauncher") exitWith {
			OT_allMissileLaunchers pushBack _name;
			[15000, 2];
		};
		if (_weaponType ==  "RocketLauncher") exitWith {
			OT_allRocketLaunchers pushBack _name;
			private _cost = 1500;
			if(_name == "launch_NLAW_F") then {
				_cost=1000
			};
			[_cost, 2]
		};
		// There are many other items in _allWeapons, set their prices elsewhere.
		[]
	}) params ["_cost", "_steel"];
	if(isServer && {isNil {cost getVariable _name}} && {! isNil {_cost}}) then {
		cost setVariable [_name,[_cost,0,_steel,0],true];
	};
} forEach (_allWeapons);

{
	private _cost = 0;
	private _steel = 0;
	private _name = configName _x;
	if !(_name in ["V_RebreatherB","V_RebreatherIA","V_RebreatherIR","V_Rangemaster_belt"]) then {
		_cost = 40 + (getNumber(_cfgWeapons >> _name >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Chest" >> "armor") * 20);
		if !(_name in ["V_Press_F","V_TacVest_blk_POLICE"]) then {
			OT_allVests pushBack _name;
			if(_cost > 40) then {
				OT_allProtectiveVests pushBack _name;
			};
			if(_cost > 300) then {
				OT_allExpensiveVests pushBack _name;
			};
			if(_cost < 300 && _cost > 40) then {
				OT_allCheapVests pushBack _name;
			};
		};
		_steel = 2;
		cost setVariable [_name,[_cost,0,_steel,0],true];
	};
} forEach _allVests;

OT_allLegalClothing = [];
{
	private _name = configName _x;
	private _short = getText (_cfgWeapons >> _name >> "descriptionShort");
	private _supply = getText(_cfgWeapons >> _name >> "ItemInfo" >> "containerClass");
	private _mass = getNumber(_cfgWeapons >> _name >> "ItemInfo" >> "mass");
	private _carry = getNumber(_cfgVehicles >> _supply >> "maximumLoad");
	private _cost = round(_mass * 4);

	private _c = _name splitString "_";
	if(_c select (count _c - 1) != "VR") then {
		OT_allClothing pushBack _name;

		private _side = _c select 1;
		if((_name == "V_RebreatherIA" || (!isNil "_side" && {_side == "C" || _side == "I"})) && (_c select (count _c - 1) != "VR")) then {
			OT_allLegalClothing pushBack _name;
		};
		if (isServer && isNil {cost getVariable _name}) then {
			cost setVariable [_name,[_cost,0,0,1],true];
		};
	};
} forEach (_allUniforms);

{
	private _name = configName _x;
	private _cost = 20 + (getNumber(_cfgWeapons >> _name >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Head" >> "armor") * 30);
	if(_cost > 20) then {
		OT_allHelmets pushBack _name;
	}else{
		OT_allHats pushBack _name;
	};
	if(isServer && isNil {cost getVariable _name}) then {
		cost setVariable [_name,[_cost,0,1,0],true];
	};
} forEach (_allHelmets);

{
	private _name = configName _x;
	private _m = getNumber(_x >> "mass");
	if(_name isKindOf ["Default",configFile >> "CfgMagazines"] && (_name != "NLAW_F") && !(_name isKindOf ["VehicleMagazine",configFile >> "CfgMagazines"])) then {
		private _cost = round(_m * 4);
		private _desc = getText(_x >> "descriptionShort");
		if(".408" in _desc) then {
			_cost = _cost * 4;
		};
		private _exp = false;
		private _steel = 0.1;
		private _plastic = 0;
		if(getNumber(_x >> "ace_explosives_Placeable") == 1) then {
			_exp = true;
		};
		if("Smoke" in _desc) then {
			_cost = round(_m * 0.5);
		}else{
			if("Grenade" in _desc) then {
				_cost = round(_m * 2);
				_exp = true;
			};
		};
		if("Flare" in _desc || "flare" in _desc) then {
			_cost = round(_m * 0.6);
			_exp = false;
		};

		if(_name isEqualTo OT_ammo_50cal) then {_cost = 50};

		if(_exp) then {
			_steel = 0;
			_plastic = round(_m * 0.5);
			OT_allExplosives pushBack _name;
			OT_explosives pushBack [_name,_cost,0,_steel,_plastic];
		}else{
			OT_allMagazines pushBack _name;
		};
		if(isServer && isNil {cost getVariable _name}) then {
			cost setVariable [_name,[_cost,0,_steel,_plastic],true];
		};
	};
} forEach (_allAmmo);

{
	private _name = configName _x;
	private _m = getNumber(_x >> "ItemInfo" >> "mass");
	if(getNumber(_x >> "ace_explosives_Range") > 1000) then {
		_m = _m * 10;
	};
	OT_allDetonators pushBack _name;
	OT_detonators pushBack [_name,_m,0,0.1,0];
	if(isServer && isNil {cost getVariable _name}) then {
		cost setVariable [_name,[_m,0,0.1,0],true];
	};
} forEach (_allDetonators);

if(isServer) then {
	//Remaining vehicle costs
	private _cfgVeh = _cfgVehicles;
	{
		private _name = configName _x;
		if((_name isKindOf "AllVehicles") && !(_name in OT_allVehicles)) then {
			private _multiply = 80;
			if(_name isKindOf "Air") then {_multiply = 700}; //Planes/Helis have less armor

			private _clsCfg = _cfgVeh >> _name;
			private _cost = getNumber (_clsCfg >> "armor") * _multiply;
			private _steel = round(getNumber (_clsCfg >> "armor") * 0.5);
			private _numturrets = count("!((configName _x) select [0,5] == ""Cargo"") && !((count getArray (_x >> ""magazines"")) isEqualTo 0)" configClasses(_clsCfg >> "Turrets"));
			private _plastic = 2;
			if(_numturrets > 0) then {
				_cost = _cost + (_numturrets * _cost * 10);
				_steel = _steel + 50;
				_plastic = 5 * _numturrets;

				if(_name isKindOf "Air") then {_cost = _cost * 2};
			};
			if(isNil {cost getVariable _name}) then {
				cost setVariable [_name,[_cost,0,_steel,_plastic],true];
			};
		};
	} forEach (_allVehicles);
};

OT_attachments = [];
{
	private _name = configName _x;
	private _cost = 75;
	private _t = getNumber(_cfgWeapons >> _name >> "ItemInfo" >> "type");
	if(_t isEqualTo 302) then {
		//Bipods
		_cost = 150;
	};
	if(_t isEqualTo 101) then {
		//Suppressors
		_cost = 350;
	};
	if(isServer && isNil {cost getVariable _name}) then {
		cost setVariable [_name,[_cost,0,0,0.25],true];
	};
	OT_allAttachments pushBack _name;
	OT_attachments pushBack [_name,[_cost,0,0,0.25]];
} forEach (_allAttachments);

{
	private _name = configName _x;
	private _allModes = "true" configClasses ( _cfgWeapons >> _name >> "ItemInfo" >> "OpticsModes" );
	private _cost = 50;
	{
		private _mode = configName _x;
		private _max = getNumber (_cfgWeapons >> _name >> "ItemInfo" >> "OpticsModes" >> _mode >> "distanceZoomMax");
		private _mul = 0.1;
		if(_mode == "NVS") then {_mul = 0.2};
		if(_mode == "TWS") then {_mul = 0.5};
		_cost = _cost + floor(_max * _mul);
	}forEach(_allModes);

	OT_allOptics pushBack _name;
	if(isServer && isNil {cost getVariable _name}) then {
		cost setVariable [_name,[_cost,0,0,0.5],true];
	};
} forEach (_allOptics);

OT_allWeapons = OT_allSubMachineGuns + OT_allAssaultRifles + OT_allMachineGuns + OT_allSniperRifles + OT_allHandGuns + OT_allMissileLaunchers + OT_allRocketLaunchers;

if(isServer) then {
	cost setVariable ["CIV",[80,0,0,0],true];
	cost setVariable ["WAGE",[5,0,0,0],true];
	cost setVariable [OT_item_UAV,[200,0,0,1],true];
	cost setVariable ["FUEL",[5,0,0,0],true];
};
//populate the cost gamelogic with the above data so it can be accessed quickly
{
	if(isServer && isNil {cost getVariable (_x select 0)}) then {
		cost setVariable [_x select 0,_x select [1,4],true];
	};
	OT_allBackpacks pushBack (_x select 0);
}forEach(OT_backpacks);
{
	if(isServer && isNil {cost getVariable (_x select 0)}) then {
		cost setVariable [_x select 0,_x select [1,4],true];
	};
	OT_allStaticBackpacks pushBack (_x select 0);
}forEach(OT_staticBackpacks);

{
	if(isServer && isNil {cost getVariable (_x select 0)}) then {
		cost setVariable [_x select 0,_x select [1,4],true];
	};
	OT_allBoats pushBack (_x select 0);
}forEach(OT_boats);

OT_staticMachineGuns = ["I_HMG_01_F","I_HMG_01_high_F","I_HMG_01_A_F","O_HMG_01_F","O_HMG_01_high_F","O_HMG_01_A_F","B_HMG_01_F","B_HMG_01_high_F","B_HMG_01_A_F"];
OT_staticWeapons = ["I_Mortar_01_F","I_static_AA_F","I_static_AT_F","I_GMG_01_F","I_GMG_01_high_F","I_GMG_01_A_F","I_HMG_01_F","I_HMG_01_high_F","I_HMG_01_A_F","O_static_AA_F","O_static_AT_F","O_Mortar_01_F","O_GMG_01_F","O_GMG_01_high_F","O_GMG_01_A_F","O_HMG_01_F","O_HMG_01_high_F","O_HMG_01_A_F","B_static_AA_F","B_static_AT_F","B_Mortar_01_F","B_GMG_01_F","B_GMG_01_high_F","B_GMG_01_A_F","B_HMG_01_F","B_HMG_01_high_F","B_HMG_01_A_F"];

OT_miscables = ["ACE_Wheel","ACE_Track",OT_item_Workbench,"Land_PortableLight_double_F","Land_PortableLight_single_F","Land_Camping_Light_F","Land_PortableHelipadLight_01_F","PortableHelipadLight_01_blue_F",
"PortableHelipadLight_01_green_F","PortableHelipadLight_01_red_F","PortableHelipadLight_01_white_F","PortableHelipadLight_01_yellow_F","Land_Campfire_F","ArrowDesk_L_F",
"ArrowDesk_R_F","ArrowMarker_L_F","ArrowMarker_R_F","Pole_F","Land_RedWhitePole_F","RoadBarrier_F","RoadBarrier_small_F","RoadCone_F","RoadCone_L_F","Land_VergePost_01_F",
"TapeSign_F","Land_LampDecor_F","Land_WheelChock_01_F","Land_Sleeping_bag_F","Land_Sleeping_bag_blue_F","Land_WoodenLog_F","FlagChecked_F","FlagSmall_F","Land_LandMark_F","Land_Bollard_01_F"];

//Stuff you can build: [name,price,array of possible classnames,init function,??,description]
OT_Buildables = [
	["Training Camp",1500,[
		["Land_IRMaskingCover_02_F",[-0.039865,0.14918,0],0,1,0,[],"","",true,false],
		["Box_NATO_Grenades_F",[1.23933,-1.05774,0],93.4866,1,0,[],"","",true,false],
		["Land_CampingTable_F",[-0.0490456,-1.74478,0],0,1,0,[],"","",true,false],
		["Land_CampingChair_V2_F",[-1.44146,-1.7173,0],223.485,1,0,[],"","",true,false],
		["Land_ClutterCutter_large_F",[0,0,0],0,1,0,[],"","",true,false]
	],"OT_fnc_initTrainingCamp",true,"Allows training of recruits and hiring of mercenaries"],
	["Bunkers",500,["Land_Hangar_F","Land_BagBunker_Tower_F","Land_BagBunker_Small_F","Land_HBarrierTower_F","Land_Bunker_01_blocks_3_F","Land_Bunker_01_blocks_1_f","Land_Bunker_01_big_F","Land_Bunker_01_small_F","Land_Bunker_01_tall_F","Land_Bunker_01_HQ_F","Land_BagBunker_01_small_green_F","Land_HBarrier_01_big_tower_green_F","Land_HBarrier_01_tower_green_F"],"",false,"Small Defensive Structures. CONTAINS TEST OBJECTS. Press space to change type."],
	["Walls",200,["Land_ConcreteWall_01_l_8m_F","Land_ConcreteWall_01_l_gate_F","Land_HBarrier_01_wall_6_green_F","Land_HBarrier_01_wall_4_green_F","Land_HBarrier_01_wall_corner_green_F"],"",false,"Stop people (or tanks) from getting in. Press space to change type."],
	["Helipad",50,["Land_HelipadCircle_F","Land_HelipadCivil_F","Land_HelipadRescue_F","Land_HelipadSquare_F"],"",false,"Informs helicopter pilots of where might be a nice place to land"],
	["Observation Post",800,["Land_Cargo_Patrol_V4_F","Land_Cargo_Patrol_V3_F","Land_Cargo_Patrol_V2_F","Land_Cargo_Patrol_V1_F"],"",false,"A small tower, can garrison a static HMG/GMG in it"],
	["Barracks",10000,[OT_barracks],"",false,"Allows recruiting of squads"],
	["Guard Tower",5000,["Land_Cargo_Tower_V4_F","Land_Cargo_Tower_V3_F","Land_Cargo_Tower_V2_F","Land_Cargo_Tower_V1_F"],"",false,"It's a huge tower, what else do you need?."],
	["Hangar",1200,["Land_Airport_01_hangar_F"],"",false,"A big empty building, could probably fit a plane inside it."],
	["Workshop",1000,[
		["Land_Cargo_House_V4_F",[0,0,0],0,1,0,[],"","",true,false],
		["Land_ClutterCutter_large_F",[0,0,0],0,1,0,[],"","",true,false],
		["Box_NATO_AmmoVeh_F",[-2.91,-3.2,0],90,1,0,[],"","",true,false],
		["Land_WeldingTrolley_01_F",[-3.53163,1.73366,0],87.0816,1,0,[],"","",true,false],
		["Land_ToolTrolley_02_F",[-3.47775,3.5155,0],331.186,1,0,[],"","",true,false]
	],"OT_fnc_initWorkshop",true,"Attach weapons to vehicles"],
	["House",2000,["Land_House_Small_06_F","Land_House_Small_02_F","Land_House_Small_03_F","Land_GarageShelter_01_F","Land_Slum_04_F"],"",false,"4 walls, a roof, and if you're lucky a door that opens."],
	["Police Station",2500,[OT_policeStation],"OT_fnc_initPoliceStation",false,"Allows hiring of policeman to raise stability in a town and keep the peace. Comes with 2 units."],
	["Warehouse",4000,[OT_warehouse],"OT_fnc_initWarehouse",false,"A house that you put wares in."],
	["Refugee Camp",600,[OT_refugeeCamp],"",false,"Can recruit civilians here without needing to chase them down"],
	["Radar",25000,[OT_radarBuilding],"OT_fnc_initRadar",false,"Reveals enemy drones, helicopters and planes within 2.5km"]
];

{
	private _istpl = _x select 4;
	if(_istpl) then {
		private _tpl = _x select 2;
		OT_allBuyableBuildings pushBack ((_tpl select 0) select 0);
	}else{
		OT_allBuyableBuildings append (_x select 2);
	}
}forEach(OT_Buildables);

//Items you can place
OT_Placeables = [
	["Sandbags",20,["Land_BagFence_Short_F","Land_BagFence_Round_F","Land_BagFence_Long_F","Land_BagFence_End_F","Land_BagFence_Corner_F","Land_BagFence_01_long_green_F","Land_BagFence_01_short_green_F","Land_BagFence_01_round_green_F","Land_BagFence_01_corner_green_F","Land_BagFence_01_end_green_F"],[0,3,0.8],"Bags filled with lots of sand. Apparently this can stop bullets or something?"],
	["Camo Nets",40,["Land_MedicalTent_01_white_generic_open_F","Land_MedicalTent_01_NATO_generic_open_F","Land_TentHangar_V1_F","CamoNet_INDP_open_F","CamoNet_INDP_F","CamoNet_ghex_F","CamoNet_ghex_open_F","CamoNet_ghex_big_F"],[0,7,2],"Large and terribly flimsy structures that may or may not obscure your forces from airborne units."],
	["Barriers",60,["Land_HBarrier_1_F","Land_HBarrier_3_F","Land_HBarrier_5_F","Land_HBarrier_Big_F","Land_HBarrierWall_corner_F","Land_HBarrier_01_line_5_green_F","Land_HBarrier_01_line_3_green_F","Land_HBarrier_01_line_1_green_F"],[0,4,1.2],"Really big sandbags, basically."],
	["Map",30,[OT_item_Map],[0,2,1.2],"Use these to save your game, change options or check town info."],
	["Safe",50,[OT_item_Safe],[0,2,0.5],"Store and retrieve money"],
	["Misc",30,OT_miscables,[0,3,1.2],"Various other items, including spare wheels and lights"]
];

OT_allSquads = OT_Squadables apply { _x params ["_name"]; _name };

OT_workshop = [
	["Static MG","C_Offroad_01_F",600,"I_HMG_01_high_weapon_F","I_HMG_01_high_F",[[0.25,-2,1]],0],
	["Static GL","C_Offroad_01_F",1100,"I_GMG_01_high_weapon_F","I_GMG_01_high_F",[[0.25,-2,1]],0],
	["Static AT","C_Offroad_01_F",2600,"I_AT_01_weapon_F","I_static_AT_F",[[0,-1.5,0.25],180]],
	["Static AA","C_Offroad_01_F",2600,"I_AA_01_weapon_F","I_static_AA_F",[[0,-1.5,0.25],180]]
];

OT_repairableRuins = [
	["Land_Cargo_Tower_V4_ruins_F","Land_Cargo_Tower_V4_F",2000],
	["Land_Cargo_Tower_V1_ruins_F","Land_Cargo_Tower_V1_F",2000],
	["Land_Cargo_Tower_V2_ruins_F","Land_Cargo_Tower_V2_F",2000],
	["Land_Cargo_Tower_V3_ruins_F","Land_Cargo_Tower_V3_F",2000],
	["Land_Cargo_Patrol_V1_ruins_F","Land_Cargo_Patrol_V1_F",500],
	["Land_Cargo_Patrol_V2_ruins_F","Land_Cargo_Patrol_V2_F",500],
	["Land_Cargo_Patrol_V3_ruins_F","Land_Cargo_Patrol_V3_F",500],
	["Land_Cargo_Patrol_V4_ruins_F","Land_Cargo_Patrol_V4_F",500],
	["Land_Cargo_HQ_V1_ruins_F","Land_Cargo_HQ_V1_F",2500],
	["Land_Cargo_HQ_V2_ruins_F","Land_Cargo_HQ_V2_F",2500],
	["Land_Cargo_HQ_V3_ruins_F","Land_Cargo_HQ_V3_F",2500],
	["Land_Cargo_HQ_V4_ruins_F","Land_Cargo_HQ_V4_F",2500]
];
OT_allRepairableRuins = [];
{
	_x params ["_ruin"];
	OT_allRepairableRuins pushBack _ruin;
}forEach(OT_repairableRuins);

OT_loadingMessages = ["Adding Hidden Agendas","Adjusting Bell Curves","Aesthesizing Industrial Areas","Aligning Covariance Matrices","Applying Feng Shui Shaders","Applying Theatre Soda Layer","Asserting Packed Exemplars","Attempting to Lock Back-Buffer","Binding Sapling Root System","Breeding Fauna","Building Data Trees","Bureacritizing Bureaucracies","Calculating Inverse Probability Matrices","Calculating Llama Expectoration Trajectory","Calibrating Blue Skies","Charging Ozone Layer","Coalescing Cloud Formations","Cohorting Exemplars","Collecting Meteor Particles","Compounding Inert Tessellations","Compressing Fish Files","Computing Optimal Bin Packing","Concatenating Sub-Contractors","Containing Existential Buffer","Debarking Ark Ramp","Debunching Unionized Commercial Services","Deciding What Message to Display Next","Decomposing Singular Values","Decrementing Tectonic Plates","Deleting Ferry Routes","Depixelating Inner Mountain Surface Back Faces","Depositing Slush Funds","Destabilizing Economic Indicators","Determining Width of Blast Fronts","Deunionizing Bulldozers","Dicing Models","Diluting Livestock Nutrition Variables","Downloading Satellite Terrain Data","Exposing Flash Variables to Streak System","Extracting Resources","Factoring Pay Scale","Fixing Election Outcome Matrix","Flood-Filling Ground Water","Flushing Pipe Network","Gathering Particle Sources","Generating Jobs","Gesticulating Mimes","Graphing Whale Migration","Hiding Willio Webnet Mask","Implementing Impeachment Routine","Increasing Accuracy of RCI Simulators","Increasing Magmafacation","Initializing Rhinoceros Breeding Timetable","Initializing Robotic Click-Path AI","Inserting Sublimated Messages","Integrating Curves","Integrating Illumination Form Factors","Integrating Population Graphs","Iterating Cellular Automata","Lecturing Errant Subsystems","Mixing Genetic Pool","Modeling Object Components","Mopping Occupant Leaks","Normalizing Power","Obfuscating Quigley Matrix","Overconstraining Dirty Industry Calculations","Partitioning City Grid Singularities","Perturbing Matrices","Pixellating Nude Patch","Polishing Water Highlights","Populating Lot Templates","Preparing Sprites for Random Walks","Prioritizing Landmarks","Projecting Law Enforcement Pastry Intake","Realigning Alternate Time Frames","Reconfiguring User Mental Processes","Relaxing Splines","Removing Road Network Speed Bumps","Removing Texture Gradients","Removing Vehicle Avoidance Behavior","Resolving GUID Conflict","Reticulating Splines","Retracting Phong Shader","Retrieving from Back Store","Reverse Engineering Image Consultant","Routing Neural Network Infanstructure","Scattering Rhino Food Sources","Scrubbing Terrain","Searching for Llamas","Seeding Architecture Simulation Parameters","Sequencing Particles","Setting Advisor ","Setting Inner Deity ","Setting Universal Physical Constants","Sonically Enhancing Occupant-Free Timber","Speculating Stock Market Indices","Splatting Transforms","Stratifying Ground Layers","Sub-Sampling Water Data","Synthesizing Gravity","Synthesizing Wavelets","Time-Compressing Simulator Clock","Unable to Reveal Current Activity","Weathering Buildings","Zeroing Crime Network"];

OT_cigsArray = ["EWK_Cigar1", "EWK_Cigar2", "EWK_Cig1", "EWK_Cig2", "EWK_Cig3", "EWK_Cig4", "EWK_Glasses_Cig1", "EWK_Glasses_Cig2", "EWK_Glasses_Cig3", "EWK_Glasses_Cig4", "EWK_Glasses_Shemag_GRE_Cig6", "EWK_Glasses_Shemag_NB_Cig6", "EWK_Glasses_Shemag_tan_Cig6", "EWK_Cig5", "EWK_Glasses_Cig5", "EWK_Cig6", "EWK_Glasses_Cig6", "EWK_Shemag_GRE_Cig6", "EWK_Shemag_NB_Cig6", "EWK_Shemag_tan_Cig6", "murshun_cigs_cig0", "murshun_cigs_cig1", "murshun_cigs_cig2", "murshun_cigs_cig3", "murshun_cigs_cig4"];

// Weapon mags to delete or not copy on transfers.
OT_noCopyMags = ["ACE_PreloadedMissileDummy"];

OT_autoSave_time = 0;
OT_autoSave_last_time = (10*60);
OT_cleanup_civilian_loop = (5*60);
OT_trackedUnitCache = [[], 0];
OT_warehouseLocationCache = createHashMap;
zeusToggle = true;

if(isServer) then {
	missionNamespace setVariable ["OT_varInitDone",true,true];
};
