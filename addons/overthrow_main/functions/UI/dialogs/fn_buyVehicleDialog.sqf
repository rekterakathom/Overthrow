private _town = player call OT_fnc_nearestTown;
private _standing = [_town] call OT_fnc_support;
private _items = OT_vehicles + [[OT_item_UAV]];

player setVariable ["OT_shopTarget","Self"];

private _ob = player call OT_fnc_nearestObjective;
_ob params ["_obpos","_obname"];
if((_obpos distance player) < 250) then {
	if(_obname in (server getVariable ["NATOabandoned",[]])) then {
		_town = OT_nation;
		_standing = 100;
		_items append OT_staticBackpacks;
		_items append [["Set_HMG"]];
		if(_obname in OT_allAirports) then {
			_items append OT_helis;
		}else{
			_items append OT_boats;
		};
		if(_obname == "Chemical Plant") then {
			_items append (OT_explosives + OT_detonators);
		};
	}
};

if(OT_adminMode) then {
	_items = OT_explosives + OT_detonators + OT_helis + OT_vehicles + OT_boats + OT_staticBackpacks + [["Set_HMG"], [OT_item_UAV]];
};

createDialog "OT_dialog_buy";

{
	_x params ["_cls"];
	if((_cls select [0,3]) != "IED") then {

		private _price = [_town,_cls,_standing] call OT_fnc_getPrice;
		if("fuel depot" in (server getVariable "NATOabandoned")) then {
			_price = round(_price * 0.5);
		};

		(_cls call OT_fnc_getClassDisplayInfo) params ["_pic", "_name"];

		// special cases
		if (_cls == "Set_HMG") then {
			private _p = (cost getVariable "I_HMG_01_high_weapon_F") select 0;
			_p = _p + ((cost getVariable "I_HMG_01_support_high_F") select 0);
			private _quad = ((cost getVariable "C_Quadbike_01_F") select 0) + 60;
			_p = _p + _quad;
			_p = _p + 150; //Convenience cost
			_price = _p;

			_pic = "C_Quadbike_01_F" call OT_fnc_vehicleGetPic;
			_name = "Quad Bike w/ HMG Backpacks";
		};
		if (_cls == OT_item_UAV) then {
			_name = "Quadcopter";
		};

		private _idx = lbAdd [1500,format["%1",_name]];
		lbSetPicture [1500,_idx,_pic];
		lbSetData [1500,_idx,_cls];
		lbSetValue [1500,_idx,_price];
	};
}forEach(_items);
