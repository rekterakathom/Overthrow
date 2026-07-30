params ["_town", "_cls"];

private _cost = cost getVariable _cls;
private _baseprice = _cost select 0;

private _stability = (server getVariable format ["stability%1", _town]) / 100;
private _population = server getVariable format ["population%1", _town];
if (_population > 1000) then { _population = 1000 };
_population = (_population / 1000);

private _price = _baseprice + _baseprice * (_stability * _population);

if !(_town in OT_allTowns) then { _price = round (_price * 0.63) };

round (_price);
