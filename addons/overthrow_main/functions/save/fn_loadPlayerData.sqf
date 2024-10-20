private _player = _this;
private _data = players_NS getVariable (getPlayerUID _player);
private _newplayer = isNil "_data";
if !(_newplayer) then {
    {
        if (isNil "_x") then {continue};
        _x params ["_key","_val"];
        if !(isNil "_val") then {
            if((_key select [0,3] != "tf_") && {!((_key select [0,7]) in ["@attack","@counte","@assaul"])}) then {
                _player setVariable [_key,_val,true];
            };
        };
    }forEach(_data);

};
_player setVariable ["OT_newplayer",_newplayer,true];

private _loadout = players_NS getVariable format["loadout%1",getPlayerUID _player];
if !(isNil "_loadout") then {
    _player setUnitLoadout _loadout;
};
_player setVariable ["OT_loaded",true,true];
