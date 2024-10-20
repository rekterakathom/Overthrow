private ["_group","_population","_posTown","_vehs","_soldier","_vehtype","_pos","_wp","_numgroups","_attackpos","_count","_tgroup","_ao"];

_posTown = _this;

_vehs = [];
_soldiers = [];
_groups = [];

_count = 0;
_pos = OT_NATO_HQPos;

_dir = _pos getDir _posTown;

_attackpos = _posTown getPos [random 150, random 360];

//Determine direction to attack from (preferrably away from water)
_attackdir = random 360;
if(surfaceIsWater (_posTown getPos [150,_attackDir])) then {
	_attackdir = _attackdir + 180;
	if(_attackdir > 359) then {_attackdir = _attackdir - 359};
	if(surfaceIsWater (_posTown getPos [150,_attackDir])) then {
		_attackdir = _attackdir + 90;
		if(_attackdir > 359) then {_attackdir = _attackdir - 359};
		if(surfaceIsWater (_posTown getPos [150,_attackDir])) then {
			_attackdir = _attackdir + 180;
			if(_attackdir > 359) then {_attackdir = _attackdir - 359};
		};
	};
};
_attackdir = _attackdir - 45;


_ao = _posTown getPos [(350 + random 150), (_attackdir + random 90)];
_group = createGroup blufor;


{
	_type = _x;
	_civ = _group createUnit [_type, OT_NATO_HQPos, [],0, "NONE"];
	_civ setRank "CAPTAIN";
}forEach(OT_NATO_Units_CTRGSupport);

sleep 0.3;

//Transport
_tgroup = createGroup blufor;
private _emptypos = _pos findEmptyPosition [15,100,OT_NATO_Vehicle_CTRGTransport];
if (count _emptypos == 0) then {_emptypos = _pos findEmptyPosition [8,100,OT_NATO_Vehicle_CTRGTransport]};
sleep 0.3;
_veh = createVehicle [OT_NATO_Vehicle_CTRGTransport, _emptypos, [], 0,""];
_vehs pushBack _veh;


_veh setDir (_dir);
_tgroup addVehicle _veh;
createVehicleCrew _veh;
{
	[_x] joinSilent _tgroup;
	_x setVariable ["NOAI",1,false];
	_x setVariable ["garrison","HQ",false];
}forEach(crew _veh);

{
	_x moveInCargo _veh;
	_soldiers pushBack _x;
	_x setVariable ["garrison","HQ",false];
	_x setVariable ["VCOM_NOPATHING_Unit",1,false];
}forEach(units _group);

sleep 1;

_moveto = OT_NATO_HQPos getPos [500, _dir];
_wp = _tgroup addWaypoint [_moveto,0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "COMBAT";
_wp setWaypointSpeed "FULL";
_wp setWaypointCompletionRadius 150;
_wp setWaypointStatements ["true","(vehicle this) flyInHeight 100;"];

_wp = _tgroup addWaypoint [_ao,0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "COMBAT";
_wp setWaypointStatements ["true","(vehicle this) AnimateDoor ['Door_rear_source', 1, false];"];
_wp setWaypointCompletionRadius 50;
_wp setWaypointSpeed "FULL";

_wp = _tgroup addWaypoint [_ao,0];
_wp setWaypointType "SCRIPTED";
_wp setWaypointStatements ["true","[vehicle this,50] spawn OT_fnc_parachuteAll"];
_wp setWaypointTimeout [10,10,10];

_wp = _tgroup addWaypoint [_ao,0];
_wp setWaypointType "SCRIPTED";
_wp setWaypointStatements ["true","(vehicle this) AnimateDoor ['Door_rear_source', 0, false];"];
_wp setWaypointTimeout [15,15,15];

_moveto = OT_NATO_HQPos getPos [200, _dir];

_wp = _tgroup addWaypoint [_moveto,0];
_wp setWaypointType "LOITER";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "FULL";
_wp setWaypointCompletionRadius 100;

_wp = _tgroup addWaypoint [_moveto,0];
_wp setWaypointType "SCRIPTED";
_wp setWaypointStatements ["true","[vehicle this] call OT_fnc_cleanup"];

_wp = _group addWaypoint [_attackpos,20];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "COMBAT";

_wp = _group addWaypoint [_attackpos,0];
_wp setWaypointType "GUARD";
_wp setWaypointBehaviour "COMBAT";

_comp = OT_NATO_Vehicle_CTRGTransport call OT_fnc_vehicleGetName;
_an = "A";
if((_ao select [0,1]) in ["A","E","I","O","a","e","i","o"]) then {_an = "An"};

{
	_x addCuratorEditableObjects [_vehs+_soldiers,true];
} forEach allCurators;
