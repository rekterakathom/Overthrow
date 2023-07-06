/*
    Author: ThomasAngel, ARMAZac

    Description:
    Loops through all town data and checks for stability changes and abandons towns

    Parameters:
        -

    Usage: [] call OT_fnc_NATOcheckTowns;

    Returns: Boolean - was an objective countered (QRF sent)
*/

if (isNil "OT_townsSortedByPopulation") then {
	OT_townsSortedByPopulation = [OT_allTowns, [], {server getvariable format["population%1",_x]}, "DESCEND"] call BIS_fnc_SortBy;
};

private _countered = false;
private _resources = server getVariable ["NATOresources", 2000];
private _abandoned = server getVariable ["NATOabandoned", []];
private _diff = server getVariable ["OT_difficulty", 1];
private _popControl = call OT_fnc_getControlledPopulation;

{
	private _town = _x;
	if (_town in _abandoned) then {continue};

	private _pos = server getVariable [_town, [0, 0, 0]];
	private _stability = server getVariable [format ["stability%1",_town], 0];
	private _population = server getVariable [format ["population%1",_town], 100];
	private _garrison = server getVariable [format ["garrison%1",_town], 10];
	// Limit towns checked to those within range of players
	if ([_pos] call OT_fnc_inSpawnDistance) then {
		// Send QRF to Town with > 100 population
		if (_population >= 100 && {_stability isEqualTo 0}) then {
			server setVariable [format ["garrison%1",_town], 0, true];
			diag_log format["Overthrow: NATO responding to %1", _town];
			private _multiplier = 3;
			if (_popControl > 1000) then {_multiplier = 4};
			if (_popControl > 2000) then {_multiplier = 5};

			_strength = _population * _multiplier;
			if (_strength > _resources) then {_strength = _resources};
			if (_town in OT_NATO_priority) then {_strength = _resources};
			[_town, _strength] spawn OT_fnc_NATOResponseTown;
			server setVariable ["NATOattacking", _town, true];
			server setVariable ["NATOattackstart", time, true];
			_countered = true;
			_resources = _resources - _strength;
		} else {
			// Send patrol to towns low in stability (new in v0.7.8.5)
			if (_resources > 250 && _stability < 30 && !(server getVariable [format["NATOpatrolsent%1",_town],false])) then {
				([_pos] call OT_fnc_NATOGetAttackVectors) params ["_ground", "_air"];
				if (count _ground > 0) then {
					server setVariable [format ["NATOpatrolsent%1", _town], true];
					(_ground select 0) params ["_obpos", "_obname"];
					private _dir = _pos getDir _obpos;
					private _ao = [_pos, _dir] call OT_fnc_getAO;
					_resources = _resources - 75;
					call {
						if (_population < 100) exitWith {
							// Just send the troops
						};
						if (_population < 500) exitWith {
							if ((random 100) < (_diff * 2)) then {
								// Small chance of a support vehicle
								_resources = _resources - 100;
								[_obpos, _pos, 100, 0] spawn OT_fnc_NATOGroundSupport;
								diag_log format ["Overthrow: NATO Sent ground support to %1 from %2", _town, _obname];
							};
						};
						//population > 500, definitely send support
						_resources = _resources - 100;
						[_obpos, _pos, 100, 0] spawn OT_fnc_NATOGroundSupport;
					};
					diag_log format["Overthrow: NATO Sent ground forces to %1 from %2",_town,_obname];
					[_obpos, _ao, _pos, false, 5] spawn OT_fnc_NATOGroundReinforcements;
				} else {
					if (count _air > 0 && _population > 500) then {
						server setVariable [format ["NATOpatrolsent%1", _town], true];
						(_air select 0) params ["_obpos", "_obname"];

						if ((random 100) < (_diff * 2)) then {
							//small chance of CAS
							_resources = _resources - 150;
							[_obpos, _pos, 0] spawn OT_fnc_NATOAirSupport;
							diag_log format ["Overthrow: NATO Sent CAS to %1 from %2", _town, _obname];
						};
						private _dir = _pos getDir _obpos;
						private _ao = [_pos, _dir] call OT_fnc_getAO;
						_resources = _resources - 100;

						[_obpos, _ao, _pos, true, 15] spawn OT_fnc_NATOGroundReinforcements;
						diag_log format ["Overthrow: NATO Sent ground forces by air to %1 from %2", _town, _obname];
					};
				};
			};
		};
	};

	// Abandon Town with <100 population if it has dropped to 0 stability
	if (_population < 100 && {(_stability isEqualTo 0)}) then {
		_abandoned pushBack _town;
		server setVariable [format ["garrison%1", _town], 0, true];
		format ["NATO has abandoned %1", _town] remoteExec ["OT_fnc_notifyGood", 0, false];
		_countered = true;
		diag_log format ["Overthrow: NATO has abandoned %1", _town];
	};
	if (_countered) exitWith {};
} forEach OT_townsSortedByPopulation;

server setVariable ["NATOabandoned", _abandoned, true];
server setVariable ["NATOresources", _resources];

_countered
