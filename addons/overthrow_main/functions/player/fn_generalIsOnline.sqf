private _online = false;
{
    if((getPlayerUID _x) in (server getVariable ["generals",[]])) exitWith {
            _online = true;
    };
}forEach(allPlayers - (entities "HeadlessClient_F"));
_online;
