if !(params [
	["_target", [0,0,0], [[], objNull, locationNull]]
]) exitWith {diag_log "Overthrow: fn_inSpawnDistance wrong data type passed!"; false};

private _spawnDistance = OT_spawnDistance;
(
	(
		(allPlayers - (entities "HeadlessClient_F"))
		+
		(spawner getVariable ["track",[]])
	) findIf {
		(_target distance _x) < _spawnDistance
		&&
		{(alive _x || (_x getVariable ["player_uid",false]) isEqualType "")}
	}
	isNotEqualTo -1
)