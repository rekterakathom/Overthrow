params ["_soldier","_pos","_group",["_takeFromWarehouse",true]];
_soldier params ["_cost","_cls","_loadout","_clothes","_allitems"];
if(_cls == "Police") then {_cls = OT_Unit_Police};
//Take from warehouse
if(_takeFromWarehouse) then {
	{
		_x params ["_cls","_num"];
		[_cls,_num] call OT_fnc_removeFromWarehouse;
	}foreach(_allitems call BIS_fnc_consolidateArray);
};

private _start = [[[_pos,30]]] call BIS_fnc_randomPos;
private _civ = _group createUnit [_cls, _start, [],0, "NONE"];

private _identity = call OT_fnc_randomLocalIdentity;
_identity pushBack (selectRandom OT_voices_local);
[_civ, _identity] call OT_fnc_applyIdentity;

_civ setRank "LIEUTENANT";
_civ setskill ["courage",1];

_civ setUnitLoadout [_loadout, false];

_civ
