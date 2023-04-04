private ["_unit"];

_unit = _this select 0;
_unit setskill ["courage",1];

_unit setVariable ["mayor",true,true];

private _identity = call OT_fnc_randomLocalIdentity;
_identity set [1, ""]; // We don't want random clothes
[_unit, _identity] call OT_fnc_applyIdentity;

removeAllWeapons _unit;
removeAllAssignedItems _unit;
removeGoggles _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeVest _unit;

[_unit,"self"] call OT_fnc_setOwner;
_unit addEventHandler ["Dammaged", OT_fnc_EnemyDamagedHandler];
