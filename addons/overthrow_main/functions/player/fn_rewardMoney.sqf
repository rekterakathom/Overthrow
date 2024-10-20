_who = _this select 0;
_amount = _this select 1;
if(isPlayer _who) then {
    [_amount] remoteExec ["OT_fnc_money",_who,false];
}else{
    if((side _who) isEqualTo resistance) then {
        //we spread it amongst everyone
        _perPlayer = round(_amount / count(allPlayers - (entities "HeadlessClient_F")));
        if(_perPlayer > 0) then {
            {
                [_perPlayer] remoteExec ["OT_fnc_money",_x,false];
            }forEach(allPlayers - (entities "HeadlessClient_F"));
        };
    };
};
