if (!isServer) exitwith {};
OT_NATO_Group_Recon = ["", 0]; // 2nd param used to keep track of group size, see below
OT_NATO_Group_Engineers = "";
OT_NATO_GroundForces = [];

// Basic infantry troops
{
	private _config = _x;
	{
		private _name = toLower (configName _x);
		private _numtroops = count ("true" configClasses _x);

		// Recon troops are checked here as well, in case specops config doesn't exist
		// no uav or ugv groups
		// also try to get the largest possible recon group
		if ("recon" in _name && {!("uav" in _name) && !("ugv" in _name) && _numTroops > (OT_NATO_Group_Recon # 1)}) then {
			OT_NATO_Group_Recon = [_x, _numtroops];
			continue; // We don't want recon guys ending up as regular infantry
		};
		if (_numtroops > 5) then {
			OT_NATO_GroundForces pushBack _x;
		};
	} forEach ("true" configClasses _config);
} forEach ("'infantry' in toLower (configName _x)" configClasses (configFile >> "CfgGroups" >> "West" >> OT_faction_NATO));

// Reset the recon troop size because a smaller group from 'specops' is worth more
OT_NATO_Group_Recon set [1, 0];

// Recon troops / special forces
{
	private _config = _x;
	{
		private _name = toLower (configName _x);
		private _numTroops = count ("true" configClasses _x);
		// Try to get the largest possible recon group
		if ("recon" in _name && {!("uav" in _name) && !("ugv" in _name) && _numTroops > (OT_NATO_Group_Recon # 1)}) then {
			OT_NATO_Group_Recon = [_x, _numTroops];
		};
	} forEach ("true" configClasses _config);
} forEach ("'specops' in toLower (configName _x)" configClasses (configFile >> "CfgGroups" >> "West" >> OT_faction_NATO));

// Remove the specops counter, it's no longer needed
OT_NATO_Group_Recon = (OT_NATO_Group_Recon # 0);

// Engineering troops
{
	private _config = _x;
	{
		private _name = toLower (configName _x);
		if ("eng" in _name) then {
			OT_NATO_Group_Engineers = _name;
		};
	} forEach ("true" configClasses _config);
} forEach ("'support' in toLower (configName _x)" configClasses (configFile >> "CfgGroups" >> "West" >> OT_faction_NATO));

OT_NATO_Units_LevelOne = [];
OT_NATO_Units_LevelTwo = [];
OT_NATO_Units_CTRGSupport = [];

{
	private _name = configName _x;
	private _unitCfg = _x;
	if(!(_name isEqualTo OT_NATO_Unit_Police) && !(_name isEqualTo OT_NATO_Unit_PoliceCommander)) then {
		[_name] call {
			params ["_name"];
			_name = toLower _name;
			if(
				"recon" in _name
				|| "story" in _name
				|| "lite" in _name
				|| "heavygunner" in _name
				|| "officer" in _name
				|| "crew" in _name
				|| "diver" in _name
				|| "pilot" in _name
				|| "pettka" in _name
				|| "captain_jay" in _name
			) exitWith {};
			if("_ctrg_" in _name) exitWith {
				OT_NATO_Units_CTRGSupport pushback _name
			};

			private _leader = getText (_x >> "icon") == "iconManLeader";
			if (_leader) then {
				OT_NATO_Unit_TeamLeader = _name;
				OT_NATO_Unit_SquadLeader = _name;
			};

			private _role = toLower (getText (_x >> "role"));
			if(_role in ["machinegunner","rifleman","combatlifesaver"]) then {OT_NATO_Units_LevelOne pushBack _name};
			if(_role in ["grenadier","missilespecialist","marksman"]) then {OT_NATO_Units_LevelTwo pushBack _name};

			//Generate and cache alternative loadouts for this unit
			private _loadout = getUnitLoadout _unitCfg;
			private _loadouts = [];
			for "_i" from 1 to 5 do {
				_loadouts pushback ([_loadout] call OT_fnc_randomizeLoadout);
			};
			spawner setVariable [format["loadouts_%1",_name],_loadouts,false];
		};
	};
} forEach (format["(getNumber(_x >> 'scope') == 2) && (getText(_x >> 'faction') == '%1') && (configName _x) isKindOf 'SoldierWB'",OT_faction_NATO] configClasses (configFile >> "CfgVehicles"));

//Generate and cache gendarm loadouts
private _loadout = getUnitLoadout OT_NATO_Unit_Police;
private _loadouts = [];
for "_i" from 1 to 5 do {
	_loadouts pushback ([_loadout,OT_allBLUSMG] call OT_fnc_randomizeLoadout);
};
spawner setVariable [format["loadouts_%1",OT_NATO_Unit_Police],_loadouts,false];

private _loadout = getUnitLoadout OT_NATO_Unit_PoliceCommander;
private _loadouts = [];
for "_i" from 1 to 5 do {
	_loadouts pushback ([_loadout,OT_allBLUSMG] call OT_fnc_randomizeLoadout);
};
spawner setVariable [format["loadouts_%1",OT_NATO_Unit_PoliceCommander],_loadouts,false];


OT_NATO_Units_LevelTwo = OT_NATO_Units_LevelOne + OT_NATO_Units_LevelTwo;

OT_NATOobjectives = [];
OT_NATOcomms = [];

OT_NATOobjectives = server getVariable ["NATOobjectives", []];
OT_NATOcomms = server getVariable ["NATOcomms", []];
OT_NATOhvts = server getVariable ["NATOhvts", []];
OT_allObjectives = [];
OT_allComms = [];
OT_NATOHelipads = [];

private _diff = server getVariable ["OT_difficulty", 1];

if((server getVariable "StartupType") == "NEW" || (server getVariable ["NATOversion",0]) < OT_NATOversion) then {
	diag_log "Overthrow: Generating NATO";
	server setVariable ["NATOversion",OT_NATOversion,false];
	private _abandoned = server getVariable ["NATOabandoned",[]];

	{
		private _stability = server getVariable format ["stability%1",_x];
		if(_stability < 11 && !(_x in _abandoned)) then {
			_abandoned pushback _x;
		};
	}foreach (OT_allTowns);
	server setVariable ["NATOabandoned",_abandoned,true];
	private _startingResources = 500;
	if(_diff isEqualTo 1) then {_startingResources = 1500};
	if(_diff isEqualTo 2) then {_startingResources = 2500};
    server setVariable ["NATOresources",_startingResources,true];
	server setVariable ["garrisonHQ",1000,false];
	OT_NATOobjectives = [];
	OT_NATOcomms = [];
	OT_NATOhvts = [];
	server setVariable ["NATOobjectives",OT_NATOobjectives,false];
	server setVariable ["NATOcomms",OT_NATOcomms,false];
	server setVariable ["NATOhvts",OT_NATOhvts,false];

	private _numHVTs = 6;
	if(_diff == 0) then {_numHVTs = 4};
	if(_diff == 2) then {_numHVTs = 8};

	//Find military objectives
	private _groundvehs = OT_allBLUOffensiveVehicles select {getText (configFile >> "CfgVehicles" >> _x >> "faction") == OT_faction_NATO && {!((_x isKindOf "Air") || (_x isKindOf "Tank") || (_x isKindOf "Ship"))}};
	if (count _groundvehs == 0) then {
		_groundvehs = OT_allBLUOffensiveVehicles select {getText (configFile >> "CfgVehicles" >> _x >> "faction") == OT_fallback_faction_NATO && {!((_x isKindOf "Air") || (_x isKindOf "Tank") || (_x isKindOf "Ship"))}};
	};
	{
		_x params ["_pos","_name","_worth"];
		if !(_name in _abandoned) then {
			diag_log format["Overthrow: Initializing %1",_name];
			OT_NATOobjectives pushBack _x;
			server setVariable [format ["vehgarrison%1",_name],[],true];

            private _base = 8;
            private _statics = OT_NATO_StaticGarrison_LevelOne;
            if(_worth > 500) then {
                _base = 16;
                _statics = OT_NATO_StaticGarrison_LevelTwo;
            };
            if(_worth > 1000) then {
                _base = 24;
                _statics = OT_NATO_StaticGarrison_LevelThree;
            };
			if((random 150) < ((count _groundvehs)+_base)) then {
				_veh = (selectRandom _groundvehs);
				diag_log format["Adding %1 to %2",_veh call OT_fnc_vehicleGetName,_name];
				_statics pushbackUnique _veh;
			};
			private _garrison = floor(_base + random(8));

			if(_name isEqualTo OT_NATO_HQ) then {
				_garrison = 48;
				server setVariable [format ["vehgarrison%1",_name],["B_T_APC_Tracked_01_AA_F","B_T_APC_Tracked_01_AA_F","B_GMG_01_high_F","B_GMG_01_high_F","B_GMG_01_high_F","B_HMG_01_high_F","B_HMG_01_high_F","B_HMG_01_high_F"],true];
				_garr = [];
				{
					_x params ["_class","_num"];
					_count = 0;
					while {_count < _num} do {
						_count = _count + 1;
						_garr pushback _class;
					};
				}foreach(OT_NATO_Vehicles_JetGarrison);
				server setVariable [format ["airgarrison%1",_name],_garr,true];
				OT_NATO_HQPos = _pos;
				if((count OT_NATO_HQ_garrisonPos) isEqualTo 0) then {
					OT_NATO_HQ_garrisonPos = _pos;
				};
			}else{
				server setVariable [format ["airgarrison%1",_name],[],true];
				server setVariable [format ["vehgarrison%1",_name],_statics,true];
			};
			server setVariable [format ["garrison%1",_name],_garrison,true];

		}else{
			OT_NATOobjectives pushBack _x;
		};
		//Check for helipads
		if !(_name in OT_allAirports) then {
			private _helipads = (_pos nearObjects ["Land_HelipadCircle_F", 400]) + (_pos nearObjects ["Land_HelipadSquare_F", 400]);
			if((count _helipads) > 0) then {
				OT_NATOHelipads pushbackUnique _x;
			};
		};
	}foreach (OT_objectiveData + OT_airportData);

	private _count = 0;
	private _done = [];
	while {_count < _numHVTs} do {
		private _ob = selectRandom (OT_NATOobjectives - ([[OT_NATO_HQ,OT_NATO_HQPos]] + _done));
		private _name = _ob select 1;
		_done pushback _ob;
		private _id = format["%1%2",_name,round(random 99999)];
		OT_NATOhvts pushback [_id,_name,""];
		_count = _count + 1;
	};

	//Add comms towers
	{
		_x params ["_pos","_name"];
		OT_NATOcomms pushBack [_pos,_name];
		private _garrison = floor(4 + random(4));
		server setVariable [format ["garrison%1",_name],_garrison,true];
	}foreach (OT_commsData);

	server setVariable ["NATOobjectives",OT_NATOobjectives,true];
	server setVariable ["NATOcomms",OT_NATOcomms,true];
	server setVariable ["NATOhvts",OT_NATOhvts,true];
	diag_log "Overthrow: Distributing NATO vehicles";

    //Weighted airport list to distribute air vehicles
    private _prilist = [];
    {
        _x params ["_pos","_name","_worth"];
		if(_name != OT_NATO_HQ) then {
	        _prilist pushback _name;
			if(_worth > 900) then {
	            _prilist pushback _name;
	        };
	        if(_worth > 1200) then {
	            _prilist pushback _name;
	        };
	        if(_worth > 2500) then {
	            _prilist pushback _name;
	        };
		};
    }foreach(OT_airportData);

	if((count _prilist) > 0) then {
		{
			_x params ["_type","_num"];
			private _count = 0;
			while {_count < _num} do {
				private _name = selectRandom _prilist;
				private _garrison = server getVariable [format["airgarrison%1",_name],[]];
				_garrison pushback _type;
				_count = _count + 1;
				server setVariable [format ["airgarrison%1",_name],_garrison,true];
			};
		}foreach(OT_NATO_Vehicles_AirGarrison);

		//Distribute some random Air vehicles
		private _airvehs = OT_allBLUOffensiveVehicles select {getText (configFile >> "CfgVehicles" >> _x >> "faction") == OT_faction_NATO && {_x isKindOf "Air"}};
		if (count _airvehs == 0) then {
			_airvehs = OT_allBLUOffensiveVehicles select {getText (configFile >> "CfgVehicles" >> _x >> "faction") == OT_fallback_faction_NATO && {_x isKindOf "Air"}};
		};
		{
			_name = _x;
			if((random 200) < (count _airvehs)) then {
				_type = selectRandom _airvehs;
				private _garrison = server getVariable [format["airgarrison%1",_name],[]];
				_garrison pushback _type;
				server setVariable [format ["airgarrison%1",_name],_garrison,true];
			};
		}foreach(_prilist);
	};

	//Distribute static AA to airfields
	{
		_x params ["","_name"];
		_vehs = server getVariable [format ["vehgarrison%1",_name],[]];
		_vehs = _vehs + OT_NATO_Vehicles_StaticAAGarrison;
		server setVariable [format ["vehgarrison%1",_name],_vehs,true];
	}foreach(OT_airportData);

	diag_log "Overthrow: Setting up NATO checkpoints";
	{
		if((server getVariable [format ["garrison%1",_x],-1]) isEqualTo -1) then {
			private _garrison = floor(8 + random(6));
			if(_x in OT_NATO_priority) then {
				_garrison = floor(12 + random(6));
			};

			//_x setMarkerText format ["%1",_garrison];
			_x setMarkerAlpha 0;
			server setVariable [format ["garrison%1",_x],_garrison,true];
		};
	}foreach (OT_NATO_control);

	diag_log "Overthrow: Garrisoning towns";
	{
		private _town = _x;
		private _garrison = 0;
		private _stability = server getVariable format ["stability%1",_town];
		private _population = server getVariable format ["population%1",_town];
		if(_stability > 10) then {
			private _max = round(_population / 30);
			_max = _max max 4;
			_garrison = 2+round((1-(_stability / 100)) * _max);
			if(_town in OT_NATO_priority) then {
				_garrison = round(_garrison * 2);
			};
		};
		server setVariable [format ["garrison%1",_x],_garrison,true];
	}foreach (OT_allTowns);
};
diag_log "Overthrow: NATO Init Done";

{
	_x params ["_pos","_name","_pri"];

	// Precalculate empty positions for objectives
	_pos findEmptyPositionReady [0, 100];

	private _mrk = createMarkerLocal [_name,_pos];
	_mrk setMarkerShape "ICON";
	if(_name in (server getVariable "NATOabandoned")) then {
		_mrk setMarkerType OT_flagMarker;
	}else{
		if(_name isEqualTo OT_NATO_HQ) then {
			_mrk setMarkerType "ot_HQ";
		}else{
			_mrk setMarkerType "flag_NATO";
		};
	};

	_mrk = createMarkerLocal [_name+"_restrict",_pos];
	_mrk setMarkerShapeLocal "ELLIPSE";
	_mrk setMarkerBrushLocal "BDIAGONAL";
	private _dist = 200;
	if(_name in OT_NATO_priority) then {_dist = 500};
	_mrk setMarkerSizeLocal [_dist, _dist];
	_mrk setMarkerColor "ColorRed";
	if(_name in (server getVariable "NATOabandoned")) then {
		_mrk setMarkerAlpha 0;
	}else{
		_mrk setMarkerAlpha 0.4;
	};

	server setVariable [_name,_pos,true];

	OT_allObjectives pushback _name;

	//Check for helipads
	if !((server getVariable "StartupType") == "NEW" || (server getVariable ["NATOversion",0]) < OT_NATOversion) then {
		if !(_name in OT_allAirports) then {
			private _helipads = (_pos nearObjects ["Land_HelipadCircle_F", 400]) + (_pos nearObjects ["Land_HelipadSquare_F", 400]);
			if((count _helipads) > 0) then {
				OT_NATOHelipads pushbackUnique _x;
			};
		};
	};

	//Set supply cache locations for this session
	//first try to find a warehouse to put it at
	private _warehouses = (_pos nearObjects [OT_warehouse, 400]);
	private _supplypos = _pos;
	if((count _warehouses) isEqualTo 0) then {
		//just pick a random position
		_supplypos = _pos findEmptyPosition [4,100,OT_item_Storage];
	}else{
		//put it at the warehouse
		_supplypos = (getPosATL (_warehouses select 0)) findEmptyPosition [4,100,OT_item_Storage];
	};
	spawner setVariable [format["NATOsupply%1",_name],_supplypos,false];

	//Now generate whats in it
	private _items = [];
	private _wpns = [];
	private _mags = [];

	private _done = 0;
	private _supplyamount = (_pri - 100) + (random 200);
	while {_done < _supplyamount} do {
		private _rnd = random 100;
		_rnd call {
			if(_this > 90) exitWith {
				//Add some radios (10% chance)
				_done = _done + 25;
				_items pushback ["ItemRadio",(2-_diff)+(round(random (5-_diff)))];
			};
			if(_this > 89) exitWith {
				//Add a random launcher (1% chance)
				_done = _done + 100;
				_wpn = selectRandom OT_allBLULaunchers;
				_wpns pushback [_wpn,1+(round(random (2-_diff)))];
				_mags pushback [(getArray (configFile >> "CfgWeapons" >> _wpn >> "magazines")) select 0,5];
			};
			if(_this > 85) exitWith {
				//Add a random rifle (4% chance)
				_done = _done + 50;
				_wpn = selectRandom OT_allBLURifles;
				_wpns pushback [_wpn,1+(round(random (2-_diff)))];
				_mags pushback [(getArray (configFile >> "CfgWeapons" >> _wpn >> "magazines")) select 0,5];
			};
			if(_this > 75) exitWith {
				//Add a random pistol (10% chance)
				_done = _done + 25;
				_wpn = selectRandom OT_allBLUPistols;
				_wpns pushback [_wpn,1+(round(random (3-_diff)))];
				_mags pushback [(getArray (configFile >> "CfgWeapons" >> _wpn >> "magazines")) select 0,5];
			};
			if(_this > 50) exitWith {
				//Add random ammunition (25% chance)
				_done = _done + 20;
				_mags pushback [selectRandom OT_allBLURifleMagazines,3+(round(random (4-_diff)) * 2)];
			};
			//Add some meds (50% chance)
			_done = _done + 40;
			_items pushback [selectRandom ["ACE_fieldDressing","ACE_fieldDressing","ACE_morphine"],(2-_diff)+(round(random (5-_diff)))];
		};
	};
	spawner setVariable [format["NATOsupplyitems%1",_name],[_items,_wpns,_mags],false];
} forEach (OT_NATOobjectives);

publicVariable "OT_allObjectives";

{
	_x params ["_pos","_name"];

	// Precalculate empty positions
	_pos findEmptyPositionReady [0, 100];

	private _mrk = createMarkerLocal [_name,_pos];
	_mrk setMarkerShapeLocal "ICON";
	_mrk setMarkerTypeLocal "loc_Transmitter";
	if(_name in (server getVariable "NATOabandoned")) then {
		_mrk setMarkerColor "ColorGUER";
	}else{
		_mrk setMarkerColor "ColorBLUFOR";
	};
	server setVariable [_name,_pos,true];
	OT_allComms pushback _name;
	OT_allObjectives pushback _name;

	_mrk = createMarkerLocal [_name+"_restrict",_pos];
	_mrk setMarkerShapeLocal "ELLIPSE";
	_mrk setMarkerBrushLocal "BDIAGONAL";
	private _dist = 40;
	if(_name in OT_NATO_priority) then {_dist = 500};
	_mrk setMarkerSizeLocal [_dist, _dist];
	_mrk setMarkerColorLocal "ColorRed";
	if(_name in (server getVariable "NATOabandoned")) then {
		_mrk setMarkerAlpha 0;
	}else{
		_mrk setMarkerAlpha 0.4;
	};
} forEach (OT_NATOcomms);

private _revealed = server getVariable ["revealedFOBs",[]];
{
	_x params ["_pos","_garrison","_upgrades"];
	OT_flag_NATO createVehicle _pos;

	private _count = 0;
	private _group = creategroup blufor;
	while {_count < _garrison} do {
		private _start = [[[_pos,50]]] call BIS_fnc_randomPos;

		private _civ = _group createUnit [selectRandom OT_NATO_Units_LevelOne, _start, [],0, "NONE"];
		_civ setVariable ["garrison","HQ",false];
		_civ setRank "LIEUTENANT";
		_civ setVariable ["VCOM_NOPATHING_Unit",true,false];
		_civ setBehaviour "SAFE";

		_count = _count + 1;
	};
	_group call OT_fnc_initMilitaryPatrol;

	[_pos,_upgrades] call OT_fnc_NATOupgradeFOB;

	private _id = str _pos;
	if(_id in _revealed) then {
		//create marker
		_mrkid = createMarkerLocal [format["natofob%1",_id],_pos];
		_mrkid setMarkerShapeLocal "ICON";
		_mrkid setMarkerTypeLocal "mil_Flag";
		_mrkid setMarkerColorLocal "ColorBLUFOR";
		_mrkid setMarkerAlpha 1;
	};
} forEach (server getVariable ["NATOfobs",[]]);

publicVariable "OT_allObjectives";
publicVariable "OT_allComms";
OT_NATOInitDone = true;
publicVariable "OT_NATOInitDone";
