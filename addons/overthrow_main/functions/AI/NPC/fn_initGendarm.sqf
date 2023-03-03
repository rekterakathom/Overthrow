params ["_unit","_town"];

private _identity = call OT_fnc_randomLocalIdentity;
_identity set [1, ""]; // Retain original gendarme clothes
_identity set [3, ""]; // No glasses for gendarme
_identity pushBack (selectRandom OT_voices_local);
[_unit,_identity] call OT_fnc_applyIdentity;

_unit setVariable ["garrison",_town,false];

private _stability = server getVariable format["stability%1",_town];

_unit addEventHandler ["HandleDamage", {
	_me = _this select 0;
	_src = _this select 3;
	if(captive _src) then {
		if(!isNull objectParent _src || (_src call OT_fnc_unitSeenNATO)) then {
			_src setCaptive false;
		};
	};
}];

if((random 100) < 75 && OT_randomizeLoadouts) then {
	_unit setUnitLoadout [_unit call OT_fnc_getRandomLoadout, true];
};

_unit addEventHandler ["Dammaged", OT_fnc_EnemyDamagedHandler];
