if (visibleMap) exitWith {};
if (!isNil "OT_MapSingleClickEHId" || !isNil "OT_MapEHId") exitWith {};

hint localize "STR_DISPLAY_DISPLAY_MAP_INFO_DIAG_01";

OT_MapSingleClickEHId = addMissionEventHandler [
    "MapSingleClick",
    {
        params ["", "_pos", "_alt", "_shift"];
        private _loc = _pos call OT_fnc_nearestLocation;
        private _txt = "";
        _loc call {
            params ["_name", "_type", "_data"];
            if (_type == "Town") exitWith {
                private _town = _name;
                private _pop = server getVariable format ["population%1", _town];
                private _stability = server getVariable format ["stability%1", _town];
                private _abandon = localize "STR_DISPLAY_DISPLAY_MAP_INFO_DIAG_02";
                if (_town in (server getVariable ["NATOabandoned", []])) then {
                    if (_stability < 50) then {
                        _abandon = localize "STR_DISPLAY_DISPLAY_MAP_INFO_DIAG_03";
                    } else {
                        _abandon = localize "STR_DISPLAY_DISPLAY_MAP_INFO_DIAG_04";
                    };
                };
                private _rep = [_town] call OT_fnc_support;
                private _plusmin = "";
                if (_rep > -1) then {
                    _plusmin = "+";
                };
                _txt = format [
                    localize "STR_DISPLAY_DISPLAY_MAP_INFO_DIAG_05",
                    _town,
                    [_pop, 1, 0, true] call CBA_fnc_formatNumber,
                    _stability,
                    "%",
                    _plusmin,
                    _rep,
                    _abandon
                ];
            };
            if (_type in ["Objective", "Radio Tower", "Airport"]) exitWith {
                private _abandon = localize "STR_DISPLAY_DISPLAY_MAP_INFO_DIAG_02";
                if (_name in (server getVariable ["NATOabandoned", []])) then {
                    _abandon = localize "STR_DISPLAY_DISPLAY_MAP_INFO_DIAG_04";
                };
                _txt = format [
                    localize "STR_DISPLAY_DISPLAY_MAP_INFO_DIAG_06",
                    _name,
                    _abandon
                ];
            };
            if (_type == "Business") exitWith {
                private _abandon = localize "STR_DISPLAY_DISPLAY_MAP_INFO_DIAG_08";
                if (_name in (server getVariable ["GEURowned", []])) then {
                    _abandon = localize "STR_DISPLAY_DISPLAY_MAP_INFO_DIAG_08";
                };
                _txt = format [
                    localize "STR_DISPLAY_DISPLAY_MAP_INFO_DIAG_06",
                    _name,
                    _abandon
                ];
            };
        };
        [_txt, [safeZoneX + (0.8 * safeZoneW), (0.2 * safeZoneW)], 0.5, 10, 0, 0, 2] call OT_fnc_dynamicText;
    }
];

OT_MapEHId = addMissionEventHandler [
    "Map",
    {
        params ["_mapIsOpened", "_mapIsForced"];
        if (!_mapIsOpened) then {
            diag_log "Removing OT_MapSingleClick";
            if (isNil "OT_MapSingleClickEHId" || isNil "OT_MapEHId") exitWith {};
            removeMissionEventHandler ["MapSingleClick", OT_MapSingleClickEHId];
            removeMissionEventHandler ["Map", OT_MapEHId];
            OT_MapSingleClickEHId = nil;
            OT_MapEHId = nil;
        };
    }
];

openMap true;
