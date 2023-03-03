private ["_unit"];

_unit = _this select 0;

(group _unit) setVariable ["VCM_Disable",true];
(group _unit) setVariable ["lambs_danger_disableGroupAI", true];

private _identity = call OT_fnc_randomLocalIdentity;
_identity set [1, selectRandom OT_clothes_carDealers];
[_unit, _identity] call OT_fnc_applyIdentity;

removeAllWeapons _unit;
removeAllAssignedItems _unit;
removeGoggles _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeVest _unit;

[_unit,"self"] call OT_fnc_setOwner;

_unit addEventHandler ["FiredNear", {
	_u = _this select 0;
	_u setUnitPos "DOWN";
}];
