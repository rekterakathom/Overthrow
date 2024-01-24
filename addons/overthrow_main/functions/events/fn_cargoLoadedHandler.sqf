_item = _this select 0;
_veh = _this select 1;
_pos = getPosATL _veh;

if(_item in OT_illegalItems) then {
	{
		if(isPlayer _x && {_x call OT_fnc_unitSeenNATO}) then {
			_x setCaptive false;
			[_x] call OT_fnc_revealToNATO;
		};
	}foreach(_pos nearentities ["CAManBase", 30]);
};