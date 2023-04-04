if !(params [
	// _target, default, data types, array lengths
	["_target", [0,0,0], [[], objNull, locationNull], [2, 3]]
]) exitWith {diag_log "Overthrow: fn_inSpawnDistance wrong data passed!"; false};

if (time > (OT_trackedUnitCache # 1)) then {
	OT_trackedUnitCache = [
		(allPlayers - (entities "HeadlessClient_F")) + (spawner getVariable ["track",[]]),
		time + 10
	];
};

OT_trackedUnitCache # 0 findIf {
	(_target distance _x) < OT_spawnDistance
	&&
	{alive _x || (_x getVariable ["player_uid",false]) isEqualType ""}
} isNotEqualTo -1
