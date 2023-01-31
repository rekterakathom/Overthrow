private ["_unit"];

_unit = _this select 0;
_unit setskill ["courage",1];

private _identity = call OT_fnc_randomLocalIdentity;
_identity set [1, selectRandom OT_clothes_priest];
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
	if !(_u getVariable ["fleeing",false]) then {
		_u setVariable ["fleeing",true,false];
		_u setBehaviour "COMBAT";
		_by = _this select 1;
		_u allowFleeing 1;
		_u setskill ["courage",0];
	};
}];
