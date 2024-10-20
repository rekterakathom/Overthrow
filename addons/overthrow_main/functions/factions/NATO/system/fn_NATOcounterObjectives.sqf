/*
    Author: ThomasAngel, ARMAZac

    Description:
    NATO checks if it can try to capture an objective for itself

    Parameters:
        -

    Usage: [] call OT_fnc_NATOcounterObjectives;

    Returns: Boolean - was an objective counter-attacked
*/

if (isNil "OT_townsSortedByPopulation") then {
	OT_townsSortedByPopulation = [OT_allTowns, [], {server getVariable format["population%1",_x]}, "DESCEND"] call BIS_fnc_SortBy;
};

private _countered = false;
private _popControl = call OT_fnc_getControlledPopulation;
private _lastAttack = time - (server getVariable ["NATOlastattack", 0]);
private _abandoned = server getVariable ["NATOabandoned", []];
private _resources = server getVariable ["NATOresources", 2000];
private _lastCounter = server getVariable ["NATOlastcounter", ""];

{
	_x params [
		"_pos",
		"_name",
		["_pri", 1000, [0]] // Priority isn't defined for comms
	];

	private _chance = 99;
	if (_pri > 800) then {_chance = _chance - 1};
	if (_popControl > 1000) then {_chance = _chance - 1};
	if (_popControl > 2000) then {_chance = _chance - 1};
	if ((time - _lastAttack) > 1200 && {(_name != _lastcounter)} && {(_name in _abandoned)} && {(_resources > _pri)} && {(random 100) > _chance}) exitWith {
		//Counter an objective
		private _multiplier = _diff + 1;
		if (_popControl > 1000) then {_multiplier = 2};
		if (_popControl > 2000) then {_multiplier = 4};
		if (_pri > 800) then {_multiplier = _multiplier + 2};
		if (_pri > _resources) then {_pri = _resources};
		_resources = _resources - _pri;
		[_name, _pri * _multiplier] spawn OT_fnc_NATOCounterObjective;
		diag_log format ["Overthrow: Counter-attacking %1", _name];
		server setVariable ["NATOlastcounter", _name, true];
		server setVariable ["NATOattacking", _name, true];
		server setVariable ["NATOattackstart", time, true];
		server setVariable ["NATOlastattack", time, true];
		_countered = true;
	};

	if !(_name in _abandoned) then {
		private _drone = spawner getVariable [format ["drone%1", _name], objNull];
		if (!(isNull _drone) && !(alive _drone)) then {
			[_drone] call OT_fnc_cleanupVehicle;
		};
		if ((isNull _drone || !alive _drone) && {_resources > 10}) then {
			_targets = [];
			{
				private _town = _x;
				private _townPos = server getVariable _town;
				if ((_townPos distance _pos) < 3000 && {[_townPos] call OT_fnc_inSpawnDistance}) then {
					private _stability = server getVariable format["stability%1", _town];
					if ((_town in _abandoned) || (_stability < 50)) then {
						_targets pushBack _townPos;
					};
				};
			} forEach OT_townsSortedByPopulation;

			{
				_x params ["_p","_name"];
				if((_p distance _pos) < 3000) then {
					if (_name in _abandoned && {[_p] call OT_fnc_inSpawnDistance}) then {
						_targets pushBack _p;
					};
				};
			} forEach (OT_objectiveData + OT_NATOComms);

			{
				_x params ["_ty","_p"];
				if (((toUpperANSI _ty) isEqualTo "FOB") && {(_p distance _pos) < 3000} && {[_p] call OT_fnc_inSpawnDistance}) then {
					_targets pushBack _p;
				};
			} forEach (_knownTargets);

			if (count _targets > 0) then {
				_targets = _targets call BIS_fnc_arrayShuffle;
				private _group = createGroup blufor;
				_group deleteGroupWhenEmpty true;
				_group setVariable ["lambs_danger_disableGroupAI", true];
				private _p = _pos findEmptyPosition [5, 100, OT_NATO_Vehicles_ReconDrone];
				if (count _p == 0) then {_p = _pos findEmptyPosition [2, 100, OT_NATO_Vehicles_ReconDrone]};
				_drone = createVehicle [OT_NATO_Vehicles_ReconDrone, _p, [], 0, ""];
				_drone enableDynamicSimulation false;

				createVehicleCrew _drone;
				{
					[_x] joinSilent _group;
					_x setVariable ["lambs_danger_disableAI", true];
				} forEach (crew _drone);

				spawner setVariable [format["drone%1",_name], _drone, false];
				_resources = _resources - 10;

				{
					private _wp = _group addWaypoint [_x,100];
					_wp setWaypointType "MOVE";
					_wp setWaypointBehaviour "COMBAT";
					_wp setWaypointSpeed "FULL";
					_wp setWaypointTimeout [5,20,60];
					_wp setWaypointStatements ["true",format["(vehicle this) flyInHeight %1;",25+random 50]];
				} forEach (_targets);

				_wp = _group addWaypoint [_pos,300];
				_wp setWaypointType "MOVE";
				_wp setWaypointBehaviour "COMBAT";
				_wp setWaypointSpeed "FULL";
				_wp setWaypointTimeout [5,20,60];
				_wp setWaypointStatements ["true",format["(vehicle this) flyInHeight %1;",25+random 50]];

				_wp = _group addWaypoint [_pos,0];
				_wp setWaypointType "CYCLE";

				{
					_x addCuratorEditableObjects [[_drone]];
				} forEach (allCurators);

				[_drone, _name] spawn OT_fnc_NATODrone;
			};
		};
	};
	if (_resources <= 0) exitWith {_resources = 0};
} forEach (OT_objectiveData + OT_NATOComms);

server setVariable ["NATOresources", _resources];

_countered
