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
				getDir _x,
				name _x
			];
		}else{
			_vehs pushBackUnique _veh;
		};
	}forEach(allPlayers - (entities "HeadlessClient_F"));
};

//Draw indepenent units
private _grpUnits = groupSelectedUnits player;
{
	if (!(isPlayer _x) && {(_x getVariable ["polgarrison",""]) isEqualTo ""}) then {
		private _veh = vehicle _x;
		//If unit is on foot draw unit, else save as vehicle to draw
		if(_veh isEqualTo _x) then {
			private _visPos = getPosASL _x;
			if(leader _x isEqualTo player) then {
				//Draw selected unit planned route
				expectedDestination _x params ["_destpos","_planning"];
				if (_planning == "LEADER PLANNED") then {
					_mapCtrl drawLine [
						_visPos,
						_destpos,
						[0,0.5,0,1]
					];
					_mapCtrl drawIcon [
						"\A3\ui_f\data\map\groupicons\waypoint.paa",
						[0,0.5,0,1],
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
						[0,0.5,0,1],
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
				[0,0.5,0,1],
				_visPos,
				24,
				24,
				getDir _x
			];
		}else{
			_vehs pushBackUnique _veh;
		};
	};
}forEach(units independent);

//Draw captive units
{
	if (captive _x) then {
		_mapCtrl drawIcon [
			"iconMan",
			[0,0.2,0,1],
			getPosASL _x,
			24,
			24,
			getDir _x
		];
	};
}forEach(units civilian);

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
			}forEach(crew _x);

			_mapCtrl drawIcon [
				getText(_cfgVeh >> (typeOf _x) >> "icon"),
				_color,
				_pos,
				24,
				24,
				getDir _x,
				_passengers
			];
		};
	}forEach(_vehs);
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
}forEach(_mortars);

//Draw known Radar hits
{
	private _i = "\A3\ui_f\data\map\markers\nato\b_air.paa";
	if(_x isKindOf "Plane") then {_i = "\A3\ui_f\data\map\markers\nato\b_plane.paa"};
	if((_x isKindOf "UAV") || (typeOf _x isEqualTo OT_NATO_Vehicles_ReconDrone)) then {_i = "\A3\ui_f\data\map\markers\nato\b_uav.paa"};
	_mapCtrl drawIcon [
		_i,
		[0,0.3,0.59,1],
		getPosASL _x,
		30,
		30,
		0
	];
}forEach(OT_mapcache_radar);

//Draw enemy groups on map - Mission Parameter
if(OT_showEnemyGroups) then {
	{
		private _u = leader _x;
		private _alive = alive _u;
		if(!_alive || isNull _u) then {
			{
				if(alive _x && !isNull _x) exitWith {
					_u = _x;
					_alive=true;
				};
			}forEach(units _x);
		};
		if(_alive) then {
			private _ka = resistance knowsAbout _u;
			if(_ka > 2) then {
				private _approxPos = player getHideFrom _u;
				if (_approxPos isEqualTo [0,0,0]) then {
					continue;
				};

				_mapCtrl drawIcon [
					"\A3\ui_f\data\map\markers\nato\b_inf.paa",
					[0,0.3,0.6,((_ka-2) / 1) min 1],
					_approxPos,
					30,
					30,
					0
				];
			};
		};
	}forEach(groups west);
	{
		private _u = leader _x;
		private _alive = alive _u;
		if(!_alive || isNull _u) then {
			{
				if(alive _x && !isNull _x) exitWith {
					_u = _x;
					_alive=true;
				};
			}forEach(units _x);
		};
		if(_alive) then {
			private _ka = resistance knowsAbout _u;
			if(_ka > 2) then {
				private _approxPos = player getHideFrom _u;
				if (_approxPos isEqualTo [0,0,0]) then {
					continue;
				};

				_mapCtrl drawIcon [
					"\A3\ui_f\data\map\markers\nato\b_inf.paa",
					[0.5,0,0,((_ka-2) / 1) min 1],
					_approxPos,
					30,
					30,
					0
				];
			};
		};
	}forEach(groups east);
};

//If zoomed in draw shop, owned properties, faction rep, corpse cache and vehicle cache
private _scale = ctrlMapScale _mapCtrl;
if(_scale < 0.1) then {
	private _mousepos = [0,0,0];
	private _drawDist = 0;
	if !(visibleMap) then {
		_mousepos = getPos player;
		_drawDist = 1000;
	}else{
		_mousepos = _mapCtrl ctrlMapScreenToWorld getMousePosition;
		_drawDist = 3000;
	};

	//Make shop markers visible
	{
		_x setMarkerAlphaLocal 1;
		_x setMarkerSizeLocal [(0.1/_scale),(0.1/_scale)];
	} forEach (OT_allShopMarkers);

	//Draw owned properties
	{
		if(((_x select 2) distance2D _mousepos) < _drawDist) then {
			_mapCtrl drawIcon [
				_x select 0,
				_x select 1,
				_x select 2,
				(_x select 3) / _scale,
				(_x select 4) / _scale,
				_x select 5
			];
		};
	}forEach(OT_mapcache_properties);

	//Draw faction reps and Gun dealers
	{
		if(((_x select 2) distance2D _mousepos) < _drawDist) then {
			_mapCtrl drawIcon [
				_x select 0,
				_x select 1,
				_x select 2,
				(_x select 3) / _scale,
				(_x select 4) / _scale,
				_x select 5
			];
		};
	}forEach(OT_mapcache_factions);

	if(visibleMap) then {
		//Draw corpse markers
		{
			if(((_x select 2) distance2D _mousepos) < _drawDist) then {
				_mapCtrl drawIcon [
					_x select 0,
					_x select 1,
					_x select 2,
					(_x select 3) / _scale,
					(_x select 4) / _scale,
					_x select 5
				];
			};
		}forEach(OT_mapcache_bodies);

		//Draw owned vehicle map cache
		{
			if(((_x select 2) distance2D _mousepos) < _drawDist) then {
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
		}forEach(OT_mapcache_vehicles);
	};
} else {
	//hide shop markers
	{
		_x setMarkerAlphaLocal 0;
	} forEach (OT_allShopMarkers);
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
if(((getPos player) select 2) > 30) then {
	private _abandoned = server getVariable ["NATOabandoned",[]];
	{
		if !(_x in _abandoned) then {
			_mapCtrl drawEllipse [
				server getVariable _x,
				2000,
				2000,
				0,
				[1, 0, 0, 1],
				"\A3\ui_f\data\map\markerbrushes\bdiagonal_ca.paa"
			];
		};
	}forEach(OT_allAirports);
	private _attack = server getVariable ["NATOattacking",""];
	if(_attack != "") then {
		_mapCtrl drawEllipse [
			server getVariable [_attack, [0,0]],
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
	}forEach(spawner getVariable ["GUERradarPositions",[]]);
};
