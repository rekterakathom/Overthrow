

closedialog 0;
createDialog "OT_dialog_main";

openMap false;

private _ft = server getVariable ["OT_fastTravelType",1];
if(!OT_adminMode && _ft > 1) then {
	ctrlEnable [1600,false];
};

disableSerialization;
private _buildingtextctrl = (findDisplay 8001) displayCtrl 1102;

private _town = player call OT_fnc_nearestTown;

private _weather = "Clear";
if(overcast > 0.4) then {
	_weather = "Cloudy";
};
if(rain > 0.1) then {
	_weather = "Rain";
};
if(rain > 0.9) then {
	_weather = "Storm";
};

private _ctrl = (findDisplay 8001) displayCtrl 1100;
private _standing = [_town] call OT_fnc_support;

private _rep = server getVariable ["rep",0];
private _extra = "";

if((getplayeruid player) in (server getVariable ["generals",[]])) then {
	_extra = format[
		"<t align='left' size='0.65'>Resistance Funds: $%1 (Tax Rate %2%3)</t>",
		[server getVariable ["money",0], 1, 0, true] call CBA_fnc_formatNumber,
		server getVariable ["taxrate",0],
		"%"
	];
};

_ctrl ctrlSetStructuredText parseText format[
	"
		<t align='left' size='0.65'>Resistance Support: %1 (%2%3) %4 (%5%6)</t><br/>
		<t align='left' size='0.65'>Influence: %7</t><br/>
		<t align='left' size='0.65'>Weather: %8 (Forecast: %9)</t><br/>
		<t align='left' size='0.65'>Fuel Price: $%10/L</t><br/>
		%11
	",
	_town, ["","+"] select (_standing > -1), _standing, OT_nation, ["","+"] select (_rep > -1), _rep,
	player getVariable ["influence",0],
	_weather, server getVariable "forecast",
	[OT_nation,"FUEL",100] call OT_fnc_getPrice,
	_extra
];

_ctrl = (findDisplay 8001) displayCtrl 1106;
_ctrl ctrlSetStructuredText parseText format[
	"<t align='right' size='0.9'>$%1</t>",
	[player getVariable ["money",0], 1, 0, true] call CBA_fnc_formatNumber
];

//Nearest building info
_b = player call OT_fnc_nearestRealEstate;
_buildingTxt = "";

if(_b isEqualType []) then {
	_building = _b select 0;
	_price = _b select 1;
	_sell = _b select 2;
	_lease = _b select 3;
	_totaloccupants = _b select 4;

	_cls = typeOf _building;
	([_cls, true] call OT_fnc_getClassDisplayInfo) params ["_pic", "_name"];

	ctrlSetText [1201, _pic];

	if(_building call OT_fnc_hasOwner) then {
		_owner = _building call OT_fnc_getOwner;
		_ownername = players_NS getVariable format["name%1",_owner];
		if(isNil "_ownername") then {_ownername = "Someone"};

		if(_cls isEqualTo OT_warehouse) exitWith {
			ctrlEnable [1609,true];
			ctrlSetText [1609,"Procurement"];

			ctrlSetText [1608,"Sell"];
			ctrlEnable [1608,false];

			ctrlSetText [1610,"Repair"];
			if((damage _building) isEqualTo 1) then {
				ctrlEnable [1610,true];
			}else{
				ctrlEnable [1610,false];
			};

			_buildingTxt = format["
				<t align='left' size='0.8'>Warehouse</t><br/>
				<t align='left' size='0.65'>Owned by %1</t><br/>
				<t align='left' size='0.65'>Damage: %2%3</t>
			",_ownername,round((damage _building) * 100),"%"];
		};

		if(_owner isEqualTo getplayerUID player) then {
			_leased = player getVariable ["leased",[]];
			_id = [_building] call OT_fnc_getBuildID;
			if(_id in _leased) then {
				_ownername = format["%1 (Leased)",_ownername];
			};

			if(_cls isEqualTo OT_item_Tent) exitWith {
				ctrlSetText [1608,"Sell"];
				ctrlEnable [1608,false];
				ctrlEnable [1609,false];
				ctrlEnable [1610,false];

				_buildingTxt = format["
					<t align='left' size='0.8'>Camp</t><br/>
					<t align='left' size='0.65'>Owned by %1</t>
				",_ownername];
			};

			ctrlSetText [1608,format["Sell ($%1)",[_sell, 1, 0, true] call CBA_fnc_formatNumber]];

			if(_id in _leased) then {
				ctrlEnable [1609,false];
				ctrlEnable [1610,false];
			};
			if(damage _building isEqualTo 1) then {
				_lease = 0;
			};
			_buildingTxt = format["
				<t align='left' size='0.8'>%1</t><br/>
				<t align='left' size='0.65'>Owned by %2</t><br/>
				<t align='left' size='0.65'>Lease Value: $%3/6hrs</t><br/>
				<t align='left' size='0.65'>Damage: %4%5</t>
			",_name,_ownername,[_lease, 1, 0, true] call CBA_fnc_formatNumber,round((damage _building) * 100),"%"];

		}else{
			ctrlEnable [1608,false];
			ctrlEnable [1609,false];
			ctrlEnable [1610,false];
			if(_cls isEqualTo OT_item_Tent) then {
				_name = "Camp";
			};
			if(_cls isEqualTo OT_flag_IND) then {
				_name = _building getVariable "name";
			};
			_buildingTxt = format["
				<t align='left' size='0.8'>%1</t><br/>
				<t align='left' size='0.65'>Owned by %2</t><br/>
				<t align='left' size='0.65'>Damage: %3%4</t>
			",_name,_ownername,round((damage _building) * 100),"%"];
		};
		if(_cls isEqualTo OT_barracks) then {
			_owner = _building call OT_fnc_getOwner;
			_ownername = players_NS getVariable format["name%1",_owner];
			ctrlSetText [1608,"Sell"];
			ctrlEnable [1608,false];
			ctrlEnable [1609,true];
			ctrlSetText [1609,"Recruit"];
			//ctrlEnable [1609,false];
			//ctrlEnable [1610,false];

			_buildingTxt = format["
				<t align='left' size='0.8'>Barracks</t><br/>
				<t align='left' size='0.65'>Built by %1</t><br/>
				<t align='left' size='0.65'>Damage: %2%3</t>
			",_ownername,round((damage _building) * 100),"%"];
		};
		if(_cls isEqualTo OT_trainingCamp) then {
			_owner = _building call OT_fnc_getOwner;
			_ownername = players_NS getVariable format["name%1",_owner];
			ctrlSetText [1608,"Sell"];
			ctrlEnable [1608,false];
			ctrlEnable [1609,true];
			ctrlSetText [1609,"Recruit"];
			//ctrlEnable [1609,false];
			ctrlEnable [1610,false];

			_buildingTxt = format["
				<t align='left' size='0.8'>Training Camp</t><br/>
				<t align='left' size='0.65'>Built by %1</t><br/>
				<t align='left' size='0.65'>Damage: %2%3</t>
			",_ownername,round((damage _building) * 100),"%"];
		};

		if(_cls isEqualTo OT_refugeeCamp) then {
			_owner = _building call OT_fnc_getOwner;
			_ownername = players_NS getVariable format["name%1",_owner];
			ctrlSetText [1608,"Sell"];
			ctrlEnable [1608,false];
			ctrlEnable [1609,true];
			ctrlSetText [1609,"Recruit"];
			ctrlEnable [1610,false];

			_buildingTxt = format["
				<t align='left' size='0.8'>Refugee Camp</t><br/>
				<t align='left' size='0.65'>Built by %1</t><br/>
				<t align='left' size='0.65'>Damage: %2%3</t>
			",_ownername,round((damage _building) * 100),"%"];
		};

		if(_cls isEqualTo OT_flag_IND) then {
			_base = [];
			{
				if((_x select 0) distance _building < 5) exitWith {_base = _x};
			}foreach(server getvariable ["bases",[]]);

			_ownername = players_NS getVariable [format["name%1",_base select 2], ""];
			ctrlSetText [1608,"Sell"];
			ctrlEnable [1608,false];
			ctrlEnable [1621,true];
			ctrlEnable [1609,false];
			//ctrlEnable [1609,false];
			ctrlEnable [1610,true];

			_buildingTxt = format["
				<t align='left' size='0.8'>%1</t><br/>
				<t align='left' size='0.65'>Founded by %2</t>
			",_base select 1,_ownername];
		};

		if(damage _building isEqualTo 1) then {
			if((_owner isEqualTo getplayerUID player) || (call OT_fnc_playerIsGeneral)) then {
				ctrlEnable [1608,false]; //Not allowed to sell
				ctrlSetText [1609,"Repair"]; //Replace lease/manage with repair
				ctrlEnable [1609,true];
				ctrlEnable [1610,false];
			};
		};
	}else{
		if((_cls) in OT_allRepairableRuins) then {
			ctrlEnable [1608,false];
			ctrlEnable [1609,false];
			ctrlSetText [1610,"Repair"];
			ctrlEnable [1610,true];

			_buildingTxt = "<t align='left' size='0.8'>Ruins</t><br/>";
		}else{
			if(isNil "_price") then {
				ctrlEnable [1608,false];
				ctrlEnable [1609,false];
				ctrlEnable [1610,false];
			}else{
				ctrlSetText [1608,format["Buy ($%1)",[_price, 1, 0, true] call CBA_fnc_formatNumber]];
				ctrlEnable [1609,false];
				ctrlEnable [1610,false];

				_buildingTxt = format["
					<t align='left' size='0.8'>%1</t><br/>
					<t align='left' size='0.65'>Lease Value: $%2/6hrs</t>
				",_name,[_lease, 1, 0, true] call CBA_fnc_formatNumber];

				if(_cls isEqualTo OT_barracks) then {
					ctrlSetText [1608,"Sell"];
					ctrlEnable [1608,false];
					ctrlEnable [1609,false];
					ctrlEnable [1610,false];

					_buildingTxt = format["
						<t align='left' size='0.8'>Barracks</t><br/>
					"];
				};
			};
		};
	};

	if(_cls isEqualTo OT_policeStation) then {
		_owner = _building call OT_fnc_getOwner;
		if(!isNil "_owner") then {
			_ownername = players_NS getVariable format["name%1",_owner];
			ctrlSetText [1608,"Sell"];
			ctrlEnable [1608,false];
			ctrlSetText [1609,"Manage"];
			ctrlEnable [1609,true];
			//ctrlEnable [1610,false];

			_buildingTxt = format["
				<t align='left' size='0.8'>Police Station</t><br/>
				<t align='left' size='0.65'>Built by %1</t>
			",_ownername];
		};
	};

	if(_cls isEqualTo "Land_Cargo_House_V4_F") then {
		_owner = _building call OT_fnc_getOwner;
		if(!isNil "_owner") then {
			_ownername = players_NS getVariable format["name%1",_owner];
			ctrlSetText [1608,"Sell"];
			ctrlEnable [1608,false];
			ctrlEnable [1609,false];
			//ctrlEnable [1610,false];

			_buildingTxt = format["
				<t align='left' size='0.8'>Workshop</t><br/>
				<t align='left' size='0.65'>Built by %1</t>
			",_ownername];
		};
	};

	// Fetch the list of buildable houses
	private _buildableHouses = (OT_Buildables param [9, []]) param [2, []];
	if(!((_cls) in OT_allRealEstate + [OT_flag_IND]) and {!(_cls in _buildableHouses)}) then {
		ctrlEnable [1609,false];
		ctrlEnable [1610,false];
		ctrlEnable [1608,false];
		_lease = 0;
		ctrlSetText [1608,"Buy"];
		_buildingTxt = format["
			<t align='left' size='0.8'>%1</t>
		",_name];
	};
}else{
	ctrlEnable [1608,false];
	ctrlEnable [1609,false];
	ctrlEnable [1610,false];
};
private _areaText = "";
_areatxtctrl = (findDisplay 8001) displayCtrl 1101;
private _ob = player call OT_fnc_nearestObjective;
_ob params ["_obpos","_obname"];
if(_obpos distance player < 250) then {
	if(_obname in (server getVariable ["NATOabandoned",[]])) then {
		_areaText = format["
			<t align='left' size='0.8'>%1</t><br/>
			<t align='left' size='0.65'>Under resistance control</t>
		",_obname];
		ctrlEnable [1620,true];
		ctrlEnable [1621,true];
	}else{
		_areaText = format["
			<t align='left' size='0.8'>%1</t><br/>
			<t align='left' size='0.65'>Under NATO control</t>
		",_obname];
		ctrlEnable [1620,false];
		ctrlEnable [1621,false];
	};
}else{
	private _ob = player call OT_fnc_nearestLocation;
	if((_ob select 1) isEqualTo "Business") then {
		_obpos = (_ob select 2) select 0;
		_obname = (_ob select 0);

		if(_obpos distance player < 250) then {
			if(_obname in (server getVariable ["GEURowned",[]])) then {
				ctrlSetText [1201,"\A3\ui_f\data\map\markers\flags\Tanoa_ca.paa"];
				_areaText = format["
					<t align='left' size='0.8'>%1</t><br/>
					<t align='left' size='0.65'>Operational</t><br/>
					<t align='left' size='0.65'>(see resistance screen)</t><br/>
				",_obname];
				ctrlEnable [1620,false];
				ctrlEnable [1621,false];
			}else{
				_price = _obname call OT_fnc_getBusinessPrice;
				ctrlSetText [1201,"\overthrow_main\ui\closed.paa"];
				_areaText = format["
					<t align='left' size='0.8'>%1</t><br/>
					<t align='left' size='0.65'>Out Of Operation</t><br/>
					<t align='left' size='0.65'>$%2</t>
				",_obname,[_price, 1, 0, true] call CBA_fnc_formatNumber];
				ctrlSetText [1620,"Buy"];
				ctrlEnable [1621,false];
				if (call OT_fnc_playerIsGeneral) then {
					ctrlEnable [1620,true];
				}else{
					ctrlEnable [1620,false];
				};
			};
		};
	}else{
		if(player distance OT_factoryPos < 150) then {
			_obname = "Factory";
			if(_obname in (server getVariable ["GEURowned",[]])) then {
				_areaText = format["
					<t align='left' size='0.8'>%1</t><br/>
					<t align='left' size='0.65'>Operational</t>
				",_obname];
				ctrlEnable [1620,true];
				ctrlSetText [1620,"Manage"];
				ctrlEnable [1621,false];
			}else{
				_price = _obname call OT_fnc_getBusinessPrice;
				_areaText = format["
					<t align='left' size='0.8'>%1</t><br/>
					<t align='left' size='0.65'>Out Of Operation</t><br/>
					<t align='left' size='0.65'>$%2</t>
				",_obname,[_price, 1, 0, true] call CBA_fnc_formatNumber];
				ctrlSetText [1620,"Buy"];
				ctrlEnable [1621,false];
				if (call OT_fnc_playerIsGeneral) then {
					ctrlEnable [1620,true];
				}else{
					ctrlEnable [1620,false];
				};
			};
		}else{
			_base = player call OT_fnc_nearestBase;
			if !(isNil "_base" && {(_base select 0) distance player < 100}) then {
				ctrlEnable [1621,true];
			} else {
				ctrlEnable [1621,false];
			};
			ctrlEnable [1620,false];
		};
	};
};

_areatxtctrl ctrlSetStructuredText parseText _areaText;

OT_interactingWith = objNull;
_buildingtextctrl ctrlSetStructuredText parseText _buildingTxt;

_notifytxtctrl = (findDisplay 8001) displayCtrl 1150;

private _notifications = [];
private _opacityList = ["FF", "EF", "DF", "CF", "BF", "AF", "9F", "8F", "7F", "6F", "5F", "4F", "3F", "2F", "1F", "0F"];
for "_x" from 0 to (count OT_notifyHistory - 1) do {
	// Notifications are retreived back to front because the latest one is at the back
	_notifications pushBack (format ["<t size='0.7' align='left' color='#%1FFFFFF'>%2</t>", _opacityList select _x, OT_notifyHistory select ((count OT_notifyHistory) - _x - 1)]);
};

_txt = _notifications joinString "<br/>";
_notifytxtctrl ctrlSetStructuredText parseText _txt;
