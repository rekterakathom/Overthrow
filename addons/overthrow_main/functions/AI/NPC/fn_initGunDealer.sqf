private ["_unit","_group"];

_unit = _this select 0;

(group _unit) setVariable ["VCM_Disable",true];
(group _unit) setVariable ["lambs_danger_disableGroupAI", true];

private _identity = call OT_fnc_randomLocalIdentity;
_identity set [1, selectRandom OT_clothes_guerilla];
_identity set [3, selectRandom OT_allGlasses];
[_unit, _identity] call OT_fnc_applyIdentity;

removeAllWeapons _unit;
removeAllAssignedItems _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeVest _unit;

_unit setVariable ["NOAI",true,false];

_group = group _unit;

_group setBehaviour "CARELESS";
[_unit,"self"] call OT_fnc_setOwner;
(group _unit) allowFleeing 0;
