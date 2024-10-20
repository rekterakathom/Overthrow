private _uid = _this call OT_fnc_getOwner;
private _player = objNull;
{
    if(getPlayerUID _x isEqualTo _uid) exitWith {_player = _x};
}forEach(allPlayers);

_player
