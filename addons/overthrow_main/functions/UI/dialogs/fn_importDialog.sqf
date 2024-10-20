buttonSetAction [1603, '[] spawn OT_fnc_importDialog'];
if(count (nearestObjects [player,OT_portBuilding,30]) isEqualTo 0) exitWith {};
private _town = player call OT_fnc_nearestTown;
_items = OT_Resources + OT_allItems + OT_allBackpacks + ["V_RebreatherIA"];
if(_town in (server getVariable ["NATOabandoned",[]]) || OT_adminMode) then {
	_items = OT_Resources + OT_allItems + OT_allBackpacks + ["V_RebreatherIA"] + OT_allWeapons + OT_allMagazines + OT_allAttachments + OT_allStaticBackpacks + OT_allOptics + OT_allVests + OT_allHelmets + OT_allClothing;
}else{
	hint format ["Only legal items may be imported while NATO controls %1",_town];
};
private _cursel = lbCurSel 1500;
lbClear 1500;
_done = [];
_SearchTerm = ctrlText 1700;
{
	_cls = _x;
	if(_SearchTerm in toLowerANSI _cls) then {

		if(isClass (configFile >> "CfgWeapons" >> _cls)) then {
			_cls = [_x] call BIS_fnc_baseWeapon;
		};
		if !((_cls in _done) || (_cls in OT_allExplosives)) then {
			_price = [OT_nation,_cls,100] call OT_fnc_getPrice;

			if(_price > 0) then {
				_done pushBack _cls;

				(_cls call OT_fnc_getClassDisplayInfo) params ["_pic", "_name"];

				_idx = lbAdd [1500,format["%1",_name]];
				lbSetPicture [1500,_idx,_pic];
				lbSetValue [1500,_idx,_price];
				lbSetData [1500,_idx,_cls];
			};
		};
	};
}forEach(_items);

if(_cursel >= count _done) then {_cursel = 0};
lbSetCurSel [1500, _cursel];
