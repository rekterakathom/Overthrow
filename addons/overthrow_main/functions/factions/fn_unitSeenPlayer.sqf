private _target = _this;

if (!isNull objectParent _target) then {_target = objectParent _target};

private _cache = _target getVariable "SeenCachePlayer";
if (isNil "_cache" || {time > (_cache select 1)}) then {
    _cache = [
        (
            ((allPlayers - (entities "HeadlessClient_F")) findIf {
                _x = driver _x;
                (_x distance _target) < 7
                ||
                { (time - ((_x targetKnowledge _target) select 2)) < 10 }
            }) isNotEqualTo -1
        ),
        time + 7
    ];
    _target setVariable ["SeenCachePlayer",_cache];
};
_cache select 0
