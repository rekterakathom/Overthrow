private _found = false;
{
    if((_x distance _this) <= 2500) exitWith {_found = true};
}forEach(spawner getVariable ["GUERradarPositions",[]]);

_found
