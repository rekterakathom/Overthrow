params [
	["_vehicle", objNull, [objNull]],
	["_hitpoint", "", [""]],
	["_value", 0, [0]]
];

if (_value != 1) exitWith {};
private _nearPlayers = (_vehicle nearEntities ["CAManBase", 10]) select {isPlayer _x && {side _x isNotEqualTo side _vehicle && {!(_vehicle call OT_fnc_hasOwner) && {_x call OT_fnc_unitSeen}}}};

// All players around who are tampering with the vehicle will be revealed
{
	switch (side _vehicle) do {
		case east: {_x setCaptive false; [_x] call OT_fnc_revealToCRIM};
		case west: {_x setCaptive false; [_x] call OT_fnc_revealToNATO};
		//case resistance: {_x setCaptive false; [_x] call OT_fnc_revealToResistance};
		default {diag_log format ["Overthrow: Couldn't find a side for %1", _vehicle]};
	};
	"You have been seen tampering with a vehicle" remoteExec ["OT_fnc_notifyMinor", _x, false];
} forEach _nearPlayers;