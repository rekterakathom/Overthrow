private _town = _this;
private _townPos = server getVariable _town;

private _stability = server getVariable format["stability%1",_town];
private _region = server getVariable [format["region_%1",_town],"fake_region"];

private _police = [];
private _support = [];
private _groups = [];

private _close = nil;
private _dist = 8000;
private _closest = "";
private _abandoned = server getVariable["NATOabandoned",[]];
private _attacking = server getVariable["NATOattacking",""];
{
	_pos = _x select 0;
	_name = _x select 1;
	_garrison = server getVariable[format["garrison%1",_name],0];
	if(_name != _attacking) then {
		if(([_pos,_townPos] call OT_fnc_regionIsConnected) && !(_name in _abandoned)) then {
			_d = (_pos distance _townPos);
			if(_d < _dist) then {
				_dist = _d;
				_close = _pos;
				_closest = _name;
			};
		};
	};
}foreach(OT_NATOobjectives);

if(!isNil "_close") then {
	_current = server getVariable [format ["garrison%1",_town],0];
	server setVariable [format ["garrison%1",_town],_current+4,true];
	if !([_townPos] call OT_fnc_inSpawnDistance) exitWith {};

	// Group may not be moved into a vehicle, so it also needs space to spawn
	_start = [_close,50,200, 1, 0, 0, 0] call BIS_fnc_findSafePos;
	_group = creategroup blufor;
	_groups pushback _group;
	_usecar = false;
	_veh = objNull;

	if(((_close distance _townPos) > 2000) && (random 100) > 50) then {
		_spawnpos = _close findEmptyPosition [10,100,OT_NATO_Vehicle_Police];
		if (count _spawnpos == 0) then {_spawnpos = _close findEmptyPosition [0,100,OT_NATO_Vehicle_Police]};
		_veh =  OT_NATO_Vehicle_Police createVehicle _spawnpos;
		_veh setDir (random 360);
		_group addVehicle _veh;
		_usecar = true;
		_groups pushback _veh;
	};

	_civ = _group createUnit [OT_NATO_Unit_PoliceCommander_Heavy, _start, [],0, "NONE"];
	_police pushBack _civ;
	[_civ,_town] call OT_fnc_initGendarm;
	_civ setBehaviour "SAFE";
	sleep 0.01;

	_start = _start findEmptyPosition [1,100,OT_NATO_Unit_Police_Heavy];
	_civ = _group createUnit [OT_NATO_Unit_Police_Heavy, _start, [],0, "NONE"];

	_police pushBack _civ;
	[_civ,_town] call OT_fnc_initGendarm;
	_civ setBehaviour "SAFE";

	_start = _start findEmptyPosition [1,100,OT_NATO_Unit_Police_Heavy];
	_civ = _group createUnit [OT_NATO_Unit_Police_Heavy, _start, [],0, "NONE"];

	_police pushBack _civ;
	[_civ,_town] call OT_fnc_initGendarm;
	_civ setBehaviour "SAFE";

	_start = _start findEmptyPosition [1,100,OT_NATO_Unit_Police_Heavy];
	_civ = _group createUnit [OT_NATO_Unit_Police_Heavy, _start, [],0, "NONE"];

	_police pushBack _civ;
	[_civ,_town] call OT_fnc_initGendarm;
	_civ setBehaviour "SAFE";

	if(_usecar) then {
		{
			_x moveInAny _veh;
		}foreach(units _group);

		_drop = (([_townPos, 50, 350, 1, 0, 0, 0] call BIS_fnc_findSafePos) nearRoads 500) select 0;

		_move = _group addWaypoint [_drop,0];
		_move setWaypointType "MOVE";
		_move setWaypointBehaviour "CARELESS";

		_move = _group addWaypoint [_drop,0];
		_move setWaypointType "UNLOAD";
		_move setWaypointBehaviour "AWARE";
	};

	sleep 1;

	_group call OT_fnc_initGendarmPatrol;

};



_groups
