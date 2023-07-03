if (!isServer) exitwith {};

private _abandoned = [];
private _resources = 0;

private _nextturn = 30; //wait 30 seconds from game start until spending resources

server setVariable ["NATOattacking","",true];
server setVariable ["NATOattackstart",0,true];
server setVariable ["NATOlastattack",0,true];
server setVariable ["QRFpos",nil,true];
server setVariable ["QRFprogress",nil,true];
server setVariable ["QRFstart",nil,true];

OT_nextNATOTurn = time+_nextturn;
publicVariable "OT_nextNATOTurn";

[{
	[] spawn { // Run in scheduled to debug errors

	private _numplayers = count(allPlayers - (entities "HeadlessClient_F"));
	if(_numplayers > 0) then {
		private _countered = (server getVariable ["NATOattacking",""]) != "";
		_knownTargets = spawner getVariable ["NATOknownTargets",[]];
		_schedule = server getVariable ["NATOschedule",[]];
		private _popControl = call OT_fnc_getControlledPopulation;
		private _diff = server getVariable ["OT_difficulty",1];

		//scheduler
		if (count _schedule > 0) then {
			private _item = [];
			private _idx = -1;
			private _remove = [];
			{
				_x params ["_id","_ty","_p1","_p2","_hour"];
				if(!isNil "_hour" && _hour < 23 && _hour == (date select 3)) exitWith {_remove pushback _forEachIndex;_idx = _forEachIndex; _item = _x};
				if(!isNil "_hour" && _hour > 23) then {_remove pushback _forEachIndex}; //remove old bugged schedules from v0.7.7.3
			}forEach(_schedule);
			if(_idx > -1) then {
				_item params ["_id","_mission","_p1","_p2"];
				if(_mission isEqualTo "CONVOY") then {
					_vehtypes = [];
					_numveh = round(random 2) + 2;
					_count = 0;
					while {_count < _numveh} do {
						_count = _count + 1;
						_vehtypes pushback (selectRandom OT_NATO_Vehicles_Convoy);
					};
					[_vehtypes,[],_p1 select 1,_p2 select 1,_id] spawn OT_fnc_NATOConvoy;
				};
			};
			{
				_schedule deleteAt _x;
			}foreach(_remove);
			server setVariable ["NATOschedule",_schedule];
		};


		// Objective QRF, drone intel reports
		// Todo: Resource hits
		if !(_countered) then {
			_countered = [] call OT_fnc_NATOcheckObjectives;
		};

		// Respond to town stability changes (QRF, patrol)
		// Todo: Resource hits
		if !(_countered) then {
			_countered = [] call OT_fnc_NATOcheckTowns;
		};

		// Abandon towers
		// NATO loses 100 resources if it has to abandon a tower
		[] call OT_fnc_NATOabandonTowers;

		// Check on FOBs
		// No effect on resources
		[] call OT_fnc_NATOcheckFOBs;

		// Expire targets
		spawner setVariable ["NATOknownTargets", _knownTargets select {(time - (_x # 5)) < 800}];

		// Scramble jets and helos
		// Price of jet scramble: 500
		// Price of heli scramble: 350
		[] call OT_fnc_NATOscrambleAircraft;

		//NATO gets to play if it hasn't reacted to anything
		if(time >= OT_nextNATOTurn && {!_countered}) then {
			OT_lastNATOTurn = time;
			publicVariable "OT_lastNATOTurn";
			_lastAttack = time - (server getVariable ["NATOlastattack", 0]);
			_resourceGain = server getVariable ["NATOresourceGain", 0];
			//NATO turn
			_nextturn = OT_NATOwait + random OT_NATOwait;
			OT_nextNATOTurn = time + _nextTurn;
			publicVariable "OT_nextNATOTurn";

			_count = 0;
			_chance = 98;
			_gain = 75;
			_mul = 50;
			if(_diff > 1) then {_gain = 150;_mul = 100;_chance = 97};
			if(_diff < 1) then {_gain = 0;_mul = 15;_chance = 99};
			if(_popControl > 1000) then {_chance = _chance - 1};
			if(_popControl > 2000) then {_chance = _chance - 1};
			_gain = _gain + (5 * count ([] call CBA_fnc_players)); // 5 extra resources per player in-game

			// Recover resources
			_resources = server getVariable ["NATOresources", 2000];
			_resources = _resources + _gain + _resourceGain + ((round (_popControl * 0.01)) * _mul);
			server setVariable ["NATOresources", _resources];

			server setVariable ["NATOlastgain", _gain + _resourceGain + ((round (_popControl * 0.01)) * _mul), true];

			// Counter Towns
			[_chance] call OT_fnc_NATOcounterTowns;

			// Spawn missing drones & counter objectives
			[] call OT_fnc_NATOcounterObjectives;

			//Decide on spend
			_resources = server getVariable ["NATOresources", 2000];
			_spend = 0;
			if (_resources > 500) then {
				_spend = 500;
			};
			if (_resources > 1000) then {
				_spend = 800;
				_chance = 95;
			};
			if (_resources > 1500) then {
				_spend = 1200;
				_chance = 90;
			};
			if (_resources > 2500) then {
				_spend = 1500;
				_chance = 80;
			};
			if (_popControl > 1000) then {
				_chance = _chance - 10;
			};
			if (_popControl > 2000) then {
				_chance = _chance - 10;
			};
			if (_diff > 1) then {
				_chance = _chance - 5;
			};

			if (!(spawner getVariable ["NATOdeploying",false]) && {(_spend > 500)} && {(count (server getVariable ["NATOfobs",[]])) < 3} && {(random 100) > _chance}) then {
				[] call OT_fnc_NATOdeployFOB;
			};

			//Reinforce gendarm
			if (_spend >= 20) then {
				_spend = [_spend] call OT_fnc_NATOreinforceGendarmerie;
			};

			// v2.3.0 - react to known targets
			private _last = spawner getVariable ["NATOlastRaid", 0];
			if ((time - _last) > 1200 && _spend > 250) then {
				_spend = [_spend, _chance] call OT_fnc_NATOsendRaid;
			};

			//Send a ground patrol
			private _last = spawner getVariable ["NATOlastpatrol",0];
			if ((time - _last) > 1200 && _spend > 150) then {
				private _spend = [_spend, _chance] call OT_fnc_NATOsendGroundPatrol;
			};

			//Schedule a convoy
			private _lastConvoy = spawner getVariable ["NATOlastconvoy",0];
			if(_spend > 500) then {
				if((time - _lastConvoy) > 3600 && {(random 100) > _chance}) then {
					_spend = [_spend] call OT_fnc_NATOscheduleConvoy;
				};
			};

			//Send an air patrol
			_last = spawner getVariable ["NATOlastairpatrol",0];
			if((time - _last) > 3600 && _spend > 250 && _popControl > 750) then {
				_spend = [_spend] call OT_fnc_NATOsendAirPatrol;
			};

			//Upgrade garrisons
			_spend = [_spend, _chance] call OT_fnc_NATOupgradeGarrisons;

			//Upgrade FOBs
			_spend = [_spend, _chance] call OT_fnc_NATOupgradeFOBs;
		};
		//Finish
		_resources = server getVariable ["NATOresources", 2000];
		_limit = 3000;
		if (_diff > 0 && _popControl > 1000) then {_limit = _limit + 500};
		if (_diff > 1 && _popControl > 1000) then {_limit = _limit + 500};
		if (_popControl > 2000) then {_limit = _limit + 500};
		if (_diff > 1 && _popControl > 2000) then {_limit = _limit + 500};
		if (_resources > _limit) then {_resources = _limit};
		
		server setVariable ["NATOresources",_resources,true];

		private _abandoned = server getVariable ["NATOabandoned", []];
		server setVariable ["NATOabandoned",_abandoned,true];

		private _knownTargets = spawner getVariable ["NATOknownTargets", []];
		spawner setVariable ["NATOknownTargets", _knownTargets, true];

		server setVariable ["NATOschedule",_schedule,true];

		private _fobs = server getVariable ["NATOfobs", []];
		server setVariable ["NATOfobs",_fobs,true];
	};
	};
}, 10, []] call CBA_fnc_addPerFrameHandler;
