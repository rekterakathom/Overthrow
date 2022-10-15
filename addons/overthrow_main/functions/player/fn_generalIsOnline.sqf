private _online = false;
{
    if((getPlayerUID _x) in (server getvariable ["generals",[]])) exitWith {
            _online = true;
    };
}foreach(allPlayers - (entities "HeadlessClient_F"));
_online;
