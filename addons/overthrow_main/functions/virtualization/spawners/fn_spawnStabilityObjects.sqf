/*
Author: ThomasAngel
Description: Spawns objects like trash, graffiti, etc depending on a towns stability.
			 This creates immersion of an actual low-stability environment.
*/

params ["_town","_spawnid"];
private _stability = server getVariable [format["stability%1",_town],100];
private _objectCount = 10 - (_stability / 10);
private _garbageTypes = [
	"",
	"Land_roads_cracks_02_F",
	"MedicalGarbage_01_3x3_v2_F",
	"Land_RoadCrack_01_4x4_F",
	"MedicalGarbage_01_3x3_v1_F",
	"Land_Garbage_square3_F",
	"Land_Garbage_square5_F",
	"MedicalGarbage_01_5x5_v1_F",
	"Land_BrokenCarGlass_01_4x4_F",
	"BloodSplatter_01_Medium_New_F"
];

private _spawnedObjs = [];

for "_i" from 0 to _objectCount do {
	private _pos = _town call OT_fnc_getRandomRoadPosition;
	private _type = selectRandom _garbageTypes;
	if (_type isEqualTo "") then {continue};
	private _obj = createVehicle [_type, _pos, [], 3, "CAN_COLLIDE"];
	_obj enableSimulationGlobal false;
	_obj setDir (random 360);
	_spawnedObjs pushBack _obj;
};

spawner setvariable [_spawnid, (spawner getvariable [_spawnid,[]]) + _spawnedObjs, false];
