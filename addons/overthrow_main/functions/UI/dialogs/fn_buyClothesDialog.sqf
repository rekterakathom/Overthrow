params ["_town","_standing"];

lbClear 1500;
{
	private _cls = _x;

	private _price = [_town,_cls,_standing] call OT_fnc_getPrice;

	(_cls call OT_fnc_getClassDisplayInfo) params ["_pic", "_name"];

	private _idx = lbAdd [1500,_name];
	lbSetPicture [1500,_idx,_pic];
	lbSetValue [1500,_idx,_price];
	lbSetData [1500,_idx,_cls];

}forEach(OT_allLegalClothing + ["V_RebreatherIA"] + OT_allGlasses + OT_allGoggles + OT_allFacewear);
