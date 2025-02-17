private ["_found","_range","_houses","_house"];

assert (params [
	["_search", [0,0,0]],
	["_types", []]
]);

private _found = false;
private _range = 400;
private _house = false;
while {!_found && _range < 1200} do {
	_houses = nearestObjects [_search, ["house"], _range,false];
	_possible = [];
	if(count _houses > 0) then {
		{
			if (!(_x call OT_fnc_hasOwner) && (typeOf _x) in _types) then {
				_possible pushBack _x
			};
		}forEach(_houses);

		if(count _possible > 0) then {
			_house = selectRandom _possible;
			_found = true;
		}
	};
	_range = _range + 100;
};

_house
