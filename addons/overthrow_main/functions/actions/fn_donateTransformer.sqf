/*
Donate money for the transformer mission
*/

private _money = player getVariable ["money",0];
private _town = player call OT_fnc_nearestTown;

if (_money < 4000) exitWith {hint "You don't have enough money"};

player setVariable ["money", _money - 4000, true];
server setVariable [(_town + "transformerpaid"), true];
