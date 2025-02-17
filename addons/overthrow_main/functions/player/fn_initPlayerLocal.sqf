if (!hasInterface) exitWith {};

if !(isClass (configFile >> "CfgPatches" >> "OT_Overthrow_Main")) exitWith {
	[
        format ["<t size='0.5' color='#000000'>Overthrow addon not detected, you must add @Overthrow to your -mod commandline</t>"],
        0,
        0.2,
        30,
        0,
        0,
        2
    ] spawn BIS_fnc_dynamicText;
};

OT_localPlayerInitDone = false;

waitUntil {!isNull player && player isEqualTo player && !isNil "server" && {!isNull server}};

ace_interaction_EnableTeamManagement = false; //Disable group switching
ace_interaction_disableNegativeRating = true; //Disable ACE negative ratings

enableSaving [false,false];
enableEnvironment [false,true,0.5]; // Wind volume to 50%

if(isServer) then {
	missionNamespace setVariable ["OT_HOST", player, true];
};

if(isNil {server getVariable "generals"}) then {
	server setVariable ["generals",[getPlayerUID player]]
};

OT_centerPos = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");

if(!isServer) then {
	// this is all done on server too, no need to execute them again
	call OT_fnc_initBaseVar;
	call compileScript ["initVar.sqf", false];
	call OT_fnc_initVar;
	[] spawn OT_fnc_jobSystem;
	addMissionEventHandler ["EntityKilled",OT_fnc_deathHandler];
	//ACE3 events
	["ace_cargoLoaded",OT_fnc_cargoLoadedHandler] call CBA_fnc_addEventHandler;
	["ace_common_setFuel",OT_fnc_refuelHandler] call CBA_fnc_addEventHandler;
	["ace_explosives_place",OT_fnc_explosivesPlacedHandler] call CBA_fnc_addEventHandler;
	["ace_repair_setWheelHitPointDamage",OT_fnc_wheelStateHandler] call CBA_fnc_addEventHandler;
	["ace_treatmentSucceded", OT_fnc_healedHandler] call CBA_fnc_addEventHandler;
	//Overthrow events
	["OT_QRFstart", OT_fnc_QRFStartHandler] call CBA_fnc_addEventHandler;
	["OT_QRFend", OT_fnc_QRFEndHandler] call CBA_fnc_addEventHandler;
	OT_QRFstart = spawner getVariable ["QRFstart",nil];//If theres already a QRF going
}else{
	OT_varInitDone = true;
};

private _highCommandModule = (createGroup sideLogic) createUnit ["HighCommand",[0,0,0],[],0,"NONE"];
_highCommandModule synchronizeObjectsAdd [player];
missionNamespace setVariable [format["%1_hc_module",getPlayerUID player],_highCommandModule,true];

private _start = OT_startCameraPos;
private _introcam = "camera" camCreate _start;
_introcam camSetTarget OT_startCameraTarget;
_introcam cameraEffect ["internal", "BACK"];
_introcam camSetFocus [15, 1];
_introcam camSetFov 1.1;
_introcam camCommit 0;
waitUntil {camCommitted _introcam};
showCinemaBorder false;

if((isServer || count ([] call CBA_fnc_players) == 1) && (server getVariable ["StartupType",""] isEqualTo "")) then {
    waitUntil {!(isNull (findDisplay 46)) && OT_varInitDone};

	if (isServer || count ([] call CBA_fnc_players) == 1) then {
		sleep 1;
		if ((["ot_start_autoload", 0] call BIS_fnc_getParamValue) == 1) then {
			server setVariable ["OT_difficulty",["ot_start_difficulty", 1] call BIS_fnc_getParamValue,true];
			server setVariable ["OT_fastTravelType",["ot_start_fasttravel", 1] call BIS_fnc_getParamValue,true];
			server setVariable ["OT_fastTravelRules",["ot_start_fasttravelrules", 1] call BIS_fnc_getParamValue,true];
			[] remoteExec ['OT_fnc_loadGame',2,false];
		} else {
			createDialog "OT_dialog_start";
		};
	};
}else{
	"Loading" call OT_fnc_notifyStart;
};
OT_showPlayerMarkers = (["ot_showplayermarkers", 1] call BIS_fnc_getParamValue) isEqualTo 1;
OT_showTownChange = (["ot_showtownchange", 1] call BIS_fnc_getParamValue) isEqualTo 1;
OT_showEnemyGroups = (["ot_showenemygroups", 1] call BIS_fnc_getParamValue) isEqualTo 1;
OT_randomizeLoadouts = (["ot_randomizeloadouts", 0] call BIS_fnc_getParamValue) isEqualTo 1;
OT_factoryProductionMulti = (["ot_factoryproductionmulti", 0] call BIS_fnc_getParamValue) * 0.01;
OT_gangMemberCap = ["ot_gangmembercap", 0] call BIS_fnc_getParamValue;
OT_gangResourceCap = ["ot_gangresourcecap", 0] call BIS_fnc_getParamValue;

waitUntil {sleep 1;!isNil "OT_NATOInitDone"};

private _aplayers = players_NS getVariable ["OT_allplayers",[]];
if (!(getPlayerUID player in _aplayers)) then {
	_aplayers pushBack (getPlayerUID player);
	players_NS setVariable ["OT_allplayers",_aplayers,true];
};
players_NS setVariable [format["name%1",getPlayerUID player],name player,true];
players_NS setVariable [format["uid%1",name player],getPlayerUID player,true];
spawner setVariable [format["%1",getPlayerUID player],player,true];

player forceAddUniform (selectRandom OT_clothes_locals);
// clear player
removeAllWeapons player;
removeAllAssignedItems player;
removeGoggles player;
removeBackpack player;
removeHeadgear player;
removeVest player;
player linkItem "ItemMap";

private _newplayer = true;
private _furniture = [];
private _town = "";
private _pos = [];
private _housepos = [];

player remoteExec ["OT_fnc_loadPlayerData",2,false];
waitUntil{sleep 0.5;player getVariable ["OT_loaded",false]};

if (player getVariable["home",false] isEqualType []) then {
	_newplayer = false;
}else{
	_newplayer = true;
};


//ensure player is in own group, not one someone else left
private  _group = createGroup resistance;
[player] joinSilent _group;

if(!_newplayer) then {
	_housepos = player getVariable "home";
	if(isNil "_housepos" || (count _housepos) isEqualTo 0) exitWith {_newplayer = true};
	_town = _housepos call OT_fnc_nearestTown;
	_pos = server getVariable _town;
	{
		if(_x call OT_fnc_hasOwner) then {
			if ((_x call OT_fnc_playerIsOwner) && !(_x isKindOf "LandVehicle") && !(_x isKindOf "Building")) then {
				_furniture pushBack _x
			};
		};
	}forEach(_housepos nearObjects 50);
};

(group player) setVariable ["VCM_Disable",true];

_recruits = server getVariable ["recruits",[]];
_newrecruits = [];
{
	if !(_x params [
		["_owner", ""],
		["_name", ""],
		["_civ", []],
		["_rank", "PRIVATE"],
		["_loadout", []],
		["_type", ""],
		["_xp", 0]
	]) then {
		diag_log format ["Overthrow: Failed to load recruit data: %1 %2 %3 %4 %5 %6 %7", _owner, _name, _civ, _rank, _loadout, _type, _xp];
		continue;
	};
	
	if(_owner isEqualTo (getPlayerUID player)) then {
		if(_civ isEqualType []) then {
			_pos = _civ findEmptyPosition [1,20,_type];
			_civ =  group player createUnit [_type,_pos,[],0,"NONE"];
			[_civ,getPlayerUID player] call OT_fnc_setOwner;
			_civ setVariable ["OT_xp",_xp,true];
			_civ setVariable ["NOAI",true,true];
			_civ setRank _rank;
			if(_rank isEqualTo "PRIVATE") then {_civ setSkill 0.2 + (random 0.3)};
			if(_rank isEqualTo "CORPORAL") then {_civ setSkill 0.3 + (random 0.3)};
			if(_rank isEqualTo "SERGEANT") then {_civ setSkill 0.4 + (random 0.3)};
			if(_rank isEqualTo "LIEUTENANT") then {_civ setSkill 0.6 + (random 0.3)};
			if(_rank isEqualTo "CAPTAIN") then {_civ setSkill 0.7 + (random 0.3)};
			if(_rank isEqualTo "MAJOR") then {_civ setSkill 0.8 + (random 0.2)};
			[_civ, (selectRandom OT_faces_local)] remoteExecCall ["setFace", 0, _civ];
			[_civ, (selectRandom OT_voices_local)] remoteExecCall ["setSpeaker", 0, _civ];
			_civ setUnitLoadout _loadout;
			_civ spawn OT_fnc_wantedSystem;
			_civ setName _name;
			_civ setVariable ["OT_spawntrack",true,true];

			[_civ] joinSilent nil;
			[_civ] joinSilent (group player);

			commandStop _civ;
		}else{
			if(_civ call OT_fnc_playerIsOwner) then {
				[_civ] joinSilent (group player);
			};
		};
	};
	_newrecruits pushBack [_owner,_name,_civ,_rank,_loadout,_type];
}forEach (_recruits);
server setVariable ["recruits",_newrecruits,true];

_squads = server getVariable ["squads",[]];
_newsquads = [];
_cc = 1;
// Remove all the HC groups
hcRemoveAllGroups player;
{
	_x params ["_owner","_cls","_group","_units"];
	if(_owner isEqualTo (getPlayerUID player)) then {
		if !(_group isEqualType grpNull) then {
			_name = _cls;
			if(count _x > 4) then {
				_name = _x select 4;
			}else{
				{
					if((_x select 0) isEqualTo _cls) then {
						_name = _x select 2;
					};
				}forEach(OT_Squadables);
			};
			_group = createGroup resistance;
			_group setGroupIdGlobal [_name];
			{
				_x params ["_type","_pos","_loadout"];
				_civ = _group createUnit [_type,_pos,[],0,"NONE"];
				_civ setSkill 0.5 + (random 0.4);
				_civ setUnitLoadout _loadout;
				[_civ, (selectRandom OT_faces_local)] remoteExecCall ["setFace", 0, _civ];
				[_civ, (selectRandom OT_voices_local)] remoteExecCall ["setSpeaker", 0, _civ];
				_civ setVariable ["OT_spawntrack",true,true];
			}forEach(_units);
		};
		player hcSetGroup [_group,groupId _group,"teamgreen"];
		_cc = _cc + 1;
	};
	_newsquads pushBack [_owner,_cls,_group,[]];
}forEach (_squads);
player setVariable ["OT_squadcount",_cc,true];
server setVariable ["squads",_newsquads,true];

if (_newplayer) then {
    _clothes = (selectRandom OT_clothes_guerilla);
	player forceAddUniform _clothes;
    player setVariable ["uniform",_clothes,true];
	private _money = 100;
	private _diff = server getVariable ["OT_difficulty",1];
	if(_diff isEqualTo 0) then {
		_money = 1000;
	};
	if(_diff isEqualTo 2) then {
		_money = 0;
	};
    player setVariable ["money",_money,true];
    [player,getPlayerUID player] call OT_fnc_setOwner;

    _town = server getVariable "spawntown";
    if(OT_randomSpawnTown) then {
        _town = selectRandom OT_spawnTowns;
    };
	_house = _town call OT_fnc_getPlayerHome;
    _housepos = getPos _house;

    //Put a light on at home
    _light = "#lightpoint" createVehicle [_housepos select 0,_housepos select 1,(_housepos select 2)+2.2];
    _light setLightBrightness 0.11;
    _light setLightAmbient[.9, .9, .6];
    _light setLightColor[.5, .5, .4];

	//Free quad
	_pos = _housepos findEmptyPosition [5,100,"C_Quadbike_01_F"];
	if (count _pos == 0) then {_pos = _housepos findEmptyPosition [0,100,"C_Quadbike_01_F"]};

	if (count _pos > 0) then {
		_veh = "C_Quadbike_01_F" createVehicle _pos;
		[_veh,getPlayerUID player] call OT_fnc_setOwner;
		clearWeaponCargoGlobal _veh;
		clearMagazineCargoGlobal _veh;
		clearBackpackCargoGlobal _veh;
		clearItemCargoGlobal _veh;
		player reveal _veh;
	};

    [_house,getPlayerUID player] call OT_fnc_setOwner;
    player setVariable ["home",_housepos,true];

    _furniture = (_house call OT_fnc_spawnTemplate) select 0;

    {
		if(typeOf _x isEqualTo OT_item_Storage) then {
            _x addItemCargoGlobal ["ToolKit", 1];
			_x addBackpackCargoGlobal ["B_AssaultPack_khk", 1];
			_x addItemCargoGlobal ["NVGoggles_INDEP", 1];
			_x addItemCargoGlobal ["ACRE_PRC343", 1];
        };
        [_x,getPlayerUID player] call OT_fnc_setOwner;
    }forEach(_furniture);
    player setVariable ["owned",[[_house] call OT_fnc_getBuildID],true];

};
_count = 0;
{
	if !(_x isKindOf "Vehicle") then {
		if(_x call OT_fnc_hasOwner) then {
			_x call OT_fnc_initObjectLocal;
		};
	};
	if(_count > 5000) then {
		_count = 0;
		titleText ["Loading... please wait", "BLACK FADED", 0];
	};
	_count = _count + 1;
}forEach((allMissionObjects "Building") + vehicles);

waitUntil {!isNil "OT_SystemInitDone"};
titleText ["Loading Session", "BLACK FADED", 0];
player setCaptive true;
player setPos (_housepos findEmptyPosition [1,20,typeOf player]);
if !("ItemMap" in (assignedItems player)) then {
	player linkItem "ItemMap";
};
[_housepos,_newplayer] spawn {
	params ["_housepos","_newplayer"];
	waitUntil{ preloadCamera _housepos};
	titleText ["", "BLACK IN", 5];
	sleep 1;
	if(_newplayer) then {
		if!(player getVariable ["OT_tute",false]) then {
			createDialog "OT_dialog_tute";
			player setVariable ["OT_tute",true,true];
			player setVariable ["OT_tute_trigger",false,true];
		} else {
			player setVariable ["OT_tute_trigger",false,true];
		};
	} else {
		player setVariable ["OT_tute_trigger",false,true];
	};
	[[[format["%1, %2",(getPos player) call OT_fnc_nearestTown,OT_nation],"align = 'center' size = '0.7' font='PuristaBold'"],["","<br/>"],[format["%1/%2/%3",date#2,date#1,date#0]],["","<br/>"],[format["%1",[dayTime,"HH:MM"] call BIS_fnc_timeToString],"align = 'center' size = '0.7'"],["s","<br/>"]]] spawn BIS_fnc_typeText2;
};

[] spawn {
	waitUntil{!(isNull (findDisplay 46))};
	(findDisplay 46) displayAddEventHandler ["KeyDown", "if ((_this#1) isEqualTo 1) then { [player] call OT_fnc_savePlayerData;	};"];
};

player addEventHandler ["WeaponAssembled",{
	params ["_me","_wpn"];
	private _pos = getPosATL _wpn;
	if(typeOf _wpn in OT_staticWeapons) then {
		if(_me call OT_fnc_unitSeen) then {
			_me setCaptive false;
		};
	};
	if(isPlayer _me) then {
		[_wpn,getPlayerUID player] call OT_fnc_setOwner;
	};
}];

player addEventHandler ["InventoryOpened", {
	params ["","_veh"];
	private _locked = false;
	if !(_veh call OT_fnc_playerIsOwner) then {
		private _isgen = call OT_fnc_playerIsGeneral;
		if(!_isgen && (_veh getVariable ["OT_locked",false])) exitWith {
			hint format["This inventory has been locked by %1",server getVariable "name"+(_veh call OT_fnc_getOwner)];
			_locked = true;
		};
	};
	_locked
}];

player addEventHandler ["GetInMan",{
	params ["_unit","_position","_veh"];

	call OT_fnc_notifyVehicle;

	if !(_veh call OT_fnc_hasOwner) then {
		[_veh,getPlayerUID player] call OT_fnc_setOwner;
		_veh setVariable ["stolen",true,true];
		if((_veh getVariable ["ambient",false]) && (random 100) > 30) then {
			["play", _veh] call BIS_fnc_carAlarm;
			[(getPos player) call OT_fnc_nearestTown,-5,"Stolen vehicle",player] call OT_fnc_support;
			//does anyone hear the alarm?
			if((_veh nearEntities ["CAManBase",200]) findIf {side _x isEqualTo west} != -1) then {
				player setCaptive false;
				[player] call OT_fnc_revealToNATO;
			};
		};
	};

	if(_position == "driver") then {
			if !(_veh call OT_fnc_playerIsOwner) then {
				private _isgen = call OT_fnc_playerIsGeneral;
				if(!_isgen && (_veh getVariable ["OT_locked",false])) then {
					moveOut player;
					hint format["This vehicle has been locked by %1",server getVariable "name"+(_veh call OT_fnc_getOwner)];
				};
			};
	}else{
		if (isNull (driver _veh)) then {
			if !(_veh call OT_fnc_playerIsOwner) then {
				private _isgen = call OT_fnc_playerIsGeneral;
				if(!_isgen && (_veh getVariable ["OT_locked",false])) then {
					moveOut player;
					hint format["This vehicle has been locked by %1",server getVariable "name"+(_veh call OT_fnc_getOwner)];
				};
			};
		};
	};
	_g = _veh getVariable ["vehgarrison",false];
	if(_g isEqualType "") then {
		_vg = server getVariable format["vehgarrison%1",_g];
		_vg deleteAt (_vg find (typeOf _veh));
		server setVariable [format["vehgarrison%1",_g],_vg,false];
		_veh setVariable ["vehgarrison",nil,true];
		{
			_x setCaptive false;
		}forEach(crew _veh);
		[_veh] call OT_fnc_revealToNATO;
	};
	_g = _veh getVariable ["airgarrison",false];
	if(_g isEqualType "") then {
		_vg = server getVariable format["airgarrison%1",_g];
		_vg deleteAt (_vg find (typeOf _veh));
		server setVariable [format["airgarrison%1",_g],_vg,false];
		_veh setVariable ["airgarrison",nil,true];
		{
			_x setCaptive false;
		}forEach(crew _veh);
		[_veh] call OT_fnc_revealToNATO;
	};
}];

{
	_pos = buildingpositions getVariable [_x,[]];
	if(count _pos isEqualTo 0) then {
		_bdg = OT_centerPos nearestObject parseNumber _x;
		_pos = position _bdg;
		buildingpositions setVariable [_x,_pos,true];
	};
}forEach(player getVariable ["owned",[]]);

player addEventHandler ["Respawn",OT_fnc_respawnHandler];

OT_keyHandlerID = [21, [false, false, false], OT_fnc_keyHandler] call CBA_fnc_addKeyHandler;

player call OT_fnc_mapSystem;
//Scroll actions
{
    _x params ["_pos"];
    private _base = _pos nearObjects [OT_flag_IND,5];
    if((count _base) > 0) then {
        _base = _base#0;
        _base addAction ["Set As Home", {player setVariable ["home",getPos (_this select 0),true];"This FOB is now your home" call OT_fnc_notifyMinor},nil,0,false,true];
    };
}forEach(server getVariable ["bases",[]]);

// ZEN integration
if (isClass (configFile >> "CfgPatches" >> "zen_common")) then {
	systemChat "Zeus Enhanced has been detected, Overthrow specific functionality has been added to Zeus";
	["Overthrow", "Change Town Stability", {_this call OT_fnc_zenSetStability}] call zen_custom_modules_fnc_register;
	["Overthrow", "Change Town Support", {_this call OT_fnc_zenChangeSupport}] call zen_custom_modules_fnc_register;
} else {
	systemChat "Zeus Enhanced not detected, consider adding it to your modlist for Overthrow specific functionality";
};

[] call OT_fnc_setupPlayer;
_introcam cameraEffect ["Terminate", "BACK" ];
camDestroy _introcam;

OT_localPlayerInitDone = true;
