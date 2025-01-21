private _target = _this;

if (!isNull objectParent _target) then {_target = objectParent _target};

private _targetPosition = getPosATL _target;
private _cache = _target getVariable "SeenCacheCRIM";
if (isNil "_cache" || {time > (_cache select 1)}) then {
    _cache = [
        (
            ([_targetPosition, 1200, 1200, 0, false] nearEntities [["CAManBase"], false, true, true] findIf {
                side _x isEqualTo east
                && {
                    (_x distance _target < 7) ||
                    { (time - ((_x targetKnowledge _target) select 2)) < 10 }
                }
            }) isNotEqualTo -1
        ),
        time + 7
    ];
    _target setVariable ["SeenCacheCRIM",_cache];
};
_cache select 0
