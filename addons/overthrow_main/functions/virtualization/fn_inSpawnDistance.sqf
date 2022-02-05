if(_this isEqualType grpNull) exitWith {false};
(
	(
		(
			alldeadmen + (call CBA_fnc_players)
		)
		+
		(spawner getVariable ["track",[]])
	) findIf {
		(alive _x || (_x getVariable ["player_uid",false]) isEqualType "")
		&&
		(_this distance _x) < OT_spawnDistance
	}
	!= -1
)