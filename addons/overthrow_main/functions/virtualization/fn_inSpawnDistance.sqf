private _spawnDistance = OT_spawnDistance;
if(_this isEqualType grpNull) exitWith {false};
(
	(
		(
			alldeadmen + (allPlayers - (entities "HeadlessClient_F"))
		)
		+
		(spawner getVariable ["track",[]])
	) findIf {
		(alive _x || (_x getVariable ["player_uid",false]) isEqualType "")
		&&
		(_this distance _x) < _spawnDistance
	}
	isNotEqualTo -1
)