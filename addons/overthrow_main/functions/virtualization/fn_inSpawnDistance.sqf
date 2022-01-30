if(_this isEqualType grpNull) exitWith {false};
(
	{
		(alive _x || (_x getVariable ["player_uid",false]) isEqualType "")
		&&
		(_this distance _x) < OT_spawnDistance
	} count (
		(
			alldeadmen + (call CBA_fnc_players)
		)
		+
		(spawner getVariable ["track",[]])
	)
	> 0
)
