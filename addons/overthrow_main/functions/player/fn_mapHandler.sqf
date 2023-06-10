if !(visibleMap || visibleGPS) exitWith {};

disableSerialization;
params ["_mapCtrl"];

private _vehs = [];
private _cfgVeh = configFile >> "CfgVehicles";

//Draw markers for all players on foot, else save as vehicle to draw - Mission Parameter
if(OT_showPlayerMarkers) then {
	{
		private _veh = vehicle _x;
		if(_veh isEqualTo _x) then {
			_mapCtrl drawIcon [
				"iconMan",
				[[0,0.2,0,1], [0,0.5,0,1]] select captive _x,
				getPosASL _x,
				24,
				24,
				getdir _x,
				name _x
			];
		}else{
			_vehs pushBackUnique _veh;
		};
	}foreach(allPlayers - (entities "HeadlessClient_F"));
};

//Draw units under player command
private _grpUnits = groupSelectedUnits player;
{
	if (!(isPlayer _x) && {(_x getVariable ["polgarrison",""]) isEqualTo ""}) then {
		private _veh = vehicle _x;
		//If unit is on foot draw unit, else save as vehicle to draw
		if(_veh isEqualTo _x) then {
			private _color = [[0,0.2,0,1],[0,0.5,0,1]] select captive _x;
			private _visPos = getPosASL _x;
			private _txt = "";
			if(leader _x isEqualTo player) then {
				//Draw selected unit planned route
				expectedDestination _x params ["_destpos","_planning"];
				if (_planning == "LEADER PLANNED") then {
					_mapCtrl drawLine [
						_visPos,
						_destpos,
						_color
					];
					_mapCtrl drawIcon [
						"\A3\ui_f\data\map\groupicons\waypoint.paa",
						_color,
						_destpos,
						24,
						24,
						0
					];
				};
				//Draw circle on currently selected units
				if(_x in _grpUnits) then {
					_mapCtrl drawIcon [
						"\A3\ui_f\data\igui\cfg\islandmap\iconplayer_ca.paa",
						_color,
						_visPos,
						24,
						24,
						0
					];
				};
			};
			//Draw unit
			_mapCtrl drawIcon [
				"iconMan",
				_color,
				_visPos,
				24,
				24,
				getDir _x
			];
		}else{
			_vehs pushBackUnique _veh;
		};
	};
}foreach(units independent);

//Draw player vehicles on map only
if (visibleMap) then {
	{
		private _pos = getPosASL _x;
		if (_pos distance2D player < 1200) then {
			private _passengers = "";
			private _color = [0,0.5,0,1];
			{
				if(isPlayer _x && !(_x isEqualTo player)) then {
					_passengers = format["%1 %2",_passengers,name _x];
				};
				if !(captive _x) then {_color = [0,0.2,0,1];};
			}foreach(crew _x);

			_mapCtrl drawIcon [
				getText(_cfgVeh >> (typeof _x) >> "icon"),
				_color,
				_pos,
				24,
				24,
				getdir _x,
				_passengers
			];
		};
	}foreach(_vehs);
};

//Draw NATO Mortars
private _mortars = spawner getVariable ["NATOmortars",[]];
{
	_mapCtrl drawIcon [
		"\A3\ui_f\data\map\markers\nato\b_mortar.paa",
		[0,0.3,0.59,(2000 - (_x select 1)) / 2000],
		_x select 2,
		24,
		24,
		0,
		""
	];
}foreach(_mortars);

//Draw known Radar hits
{
	private _i = "\A3\ui_f\data\map\markers\nato\b_air.paa";
	if(_x isKindOf "Plane") then {_i = "\A3\ui_f\data\map\markers\nato\b_plane.paa"};
	if((_x isKindOf "UAV") || (typeof _x isEqualTo OT_NATO_Vehicles_ReconDrone)) then {_i = "\A3\ui_f\data\map\markers\nato\b_uav.paa"};
	_mapCtrl drawIcon [
		_i,
		[0,0.3,0.59,1],
		getPosASL _x,
		30,
		30,
		0
	];
}foreach(OT_mapcache_radar);

//Draw enemy groups on map - Mission Parameter
if(OT_showEnemyGroups) then {
	{
		private _u = leader _x;
		private _alive = alive _u;
		if(!_alive) then {
			{
				if(alive _x) exitWith {
					_u = _x;
					_alive=true;
				};
			}foreach(units _x);
		};
		if(_alive) then {
			private _ka = resistance knowsabout _u;
			if(_ka > 1.4) then {
				_mapCtrl drawIcon [
					"\A3\ui_f\data\map\markers\nato\b_inf.paa",
					[0,0.3,0.59,((_ka-1.4) / 1) min 1],
					getPosASL _u,
					30,
					30,
					0
				];
			};
		};
	}foreach(groups west);
	{
		private _u = leader _x;
		private _alive = alive _u;
		if(!_alive) then {
			{
				if(alive _x) exitWith {
					_u = _x;
					_alive=true;
				};
			}foreach(units _x);
		};
		if(_alive) then {
			private _ka = resistance knowsabout _u;
			if(_ka > 1.4) then {
				_mapCtrl drawIcon [
					"\A3\ui_f\data\map\markers\nato\b_inf.paa",
					[0.5,0,0,((_ka-1.4) / 1) min 1],
					getPosASL _u,
					30,
					30,
					0
				];
			};
		};
	}foreach(groups east);
};

//If zoomed in draw shop, business, faction rep, corpse cache and vehicle cache
private _scale = ctrlMapScale _mapCtrl;
if(_scale < 0.1) then {
	private _mousepos = [0,0,0];
	private _towns = OT_townData;
	if !(visibleMap) then {
		_mousepos = getpos player;
	}else{
		_mousepos = _mapCtrl ctrlMapScreenToWorld getMousePosition;
	};

	//Draw owned properties
	private _leased = player getvariable ["leased",[]];
	{
		private _buildingPos = buildingpositions getVariable _x;
		if!(isNil "_buildingPos") then {
			if((_buildingPos distance2D _mousepos) < 3000) then {
				_mapCtrl drawIcon [
					"\A3\ui_f\data\map\mapcontrol\Tourism_CA.paa",
					[1,1,1,[1,0.3] select (_x in _leased)],
					_buildingPos,
					0.3/_scale,
					0.3/_scale,
					0
				];
			};
		};
	}foreach(player getvariable ["owned",[]]);

	//Draw faction reps
	{
		_x params ["_cls","_name","_side","_flag"];
		if!(_side isEqualTo 1) then {
			private _factionPos = server getVariable format["factionrep%1",_cls];
			if!(isNil "_factionPos") then {
				if((_factionPos distance2D _mousepos) < 3000) then {
					_mapCtrl drawIcon [
						_flag,
						[1,1,1,1],
						_factionPos,
						0.6/_scale,
						0.5/_scale,
						0
					];
				};
			};
		};
	}foreach(OT_allFactions);

	//Draw shop icons
	{
		_x params ["_tpos","_tname"];
		if((_tpos distance2D _mousepos) < 2500) then {
			private _townPos = server getVariable format["gundealer%1",_tname];
			if!(isNil "_townPos") then {
				_mapCtrl drawIcon [
					OT_flagImage,
					[1,1,1,1],
					_townPos,
					0.3/_scale,
					0.3/_scale,
					0
				];
			};
			{
				_mapCtrl drawIcon [
					format["\overthrow_main\ui\markers\shop-%1.paa",_x select 1],
					[1,1,1,1],
					_x select 0,
					0.2/_scale,
					0.2/_scale,
					0
				];
			}foreach(server getVariable [format["activeshopsin%1",_tname],[]]);
			{
				_mapCtrl drawIcon [
					"\overthrow_main\ui\markers\shop-Hardware.paa",
					[1,1,1,1],
					_x select 0,
					0.3/_scale,
					0.3/_scale,
					0
				];
			}foreach(server getVariable [format["activehardwarein%1",_tname],[]]);
		};
	}foreach(_towns);

	if(visibleMap) then {
		//Draw corpse markers
		{
			if(((_x select 2) distance2D _mousepos) < 3000) then {
				_mapCtrl drawIcon [
					_x select 0,
					_x select 1,
					_x select 2,
					(_x select 3) / _scale,
					(_x select 4) / _scale,
					_x select 5
				];
			};
		}foreach(OT_mapcache_bodies);

		//Draw owned vehicle map cache
		{
			if(((_x select 2) distance2D _mousepos) < 3000) then {
				if((_x select 3) < 1) then {
					_mapCtrl drawIcon [
						_x select 0,
						_x select 1,
						_x select 2,
						(_x select 3) / _scale,
						(_x select 4) / _scale,
						_x select 5
					];
				} else {
					_mapCtrl drawIcon _x;
				};
			};
		}foreach(OT_mapcache_vehicles);
	};
};

//Draw QRF regions
private _qrf = server getVariable "QRFpos";
if(!isNil "_qrf") then {
	private _progress = server getVariable ["QRFprogress",0];
	if(_progress != 0) then {
		_mapCtrl drawEllipse [
			_qrf,
			100,
			100,
			0,
			[
				parseNumber(_progress > 0),
				parseNumber(_progress < 0),
				1,
				abs _progress
			],
			"\A3\ui_f\data\map\markerbrushes\fdiagonal_ca.paa"
		];
		_mapCtrl drawEllipse [
			_qrf,
			200,
			200,
			0,
			[
				0,
				parseNumber(_progress < 0),
				parseNumber(_progress > 0),
				abs _progress
			],
			"\A3\ui_f\data\map\markerbrushes\bdiagonal_ca.paa"
		];
	};
};

//Draw no-fly zones if player is in the air
if(((getpos player) select 2) > 30) then {
	private _abandoned = server getVariable ["NATOabandoned",[]];
	{
		if !(_x in _abandoned) then {
			_mapCtrl drawEllipse [
				server getvariable _x,
				2000,
				2000,
				0,
				[1, 0, 0, 1],
				"\A3\ui_f\data\map\markerbrushes\bdiagonal_ca.paa"
			];
		};
	}foreach(OT_allAirports);
	private _attack = server getVariable ["NATOattacking",""];
	if(_attack != "") then {
		_mapCtrl drawEllipse [
			server getvariable [_attack, [0,0]],
			2000,
			2000,
			0,
			[1, 0, 0, 1],
			"\A3\ui_f\data\map\markerbrushes\bdiagonal_ca.paa"
		];
	};
};

//Draw resistance radar coverage
if(_scale > 0.16) then {
	{
		_mapCtrl drawEllipse [
			_x,
			2500,
			2500,
			0,
			[0,0.7,0,0.4],
			"\A3\ui_f\data\map\markerbrushes\fdiagonal_ca.paa"
		];
	}foreach(spawner getVariable ["GUERradarPositions",[]]);
};
