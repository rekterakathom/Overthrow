disableSerialization;

private _town = player call OT_fnc_nearestTown;
if !(_town in (server getVariable ["NATOabandoned", []])) exitWith { localize "STR_DISPLAY_DISPLAY_POLICE_DIAG_01" call OT_fnc_notifyMinor };

private _garrison = server getVariable [format ['police%1', _town], 0];
createDialog "OT_dialog_police";

private _soldier = "Police" call OT_fnc_getSoldier;
private _price = _soldier param [0, 500];

private _effect = floor (_garrison / 2);
if (_effect isEqualTo 0) then { _effect = localize "STR_DISPLAY_DISPLAY_POLICE_DIAG_02" } else { _effect = format [localize "STR_DISPLAY_DISPLAY_POLICE_DIAG_03", _effect] };

if !(call OT_fnc_playerIsGeneral) then {
    ctrlEnable [1608, false];
};

((findDisplay 9000) displayCtrl 1100) ctrlSetStructuredText parseText format [localize "STR_DISPLAY_DISPLAY_POLICE_DIAG_04", _town];
((findDisplay 9000) displayCtrl 1103) ctrlSetStructuredText parseText format [localize "STR_DISPLAY_DISPLAY_POLICE_DIAG_05", _price];
((findDisplay 9000) displayCtrl 1101) ctrlSetStructuredText parseText format [localize "STR_DISPLAY_DISPLAY_POLICE_DIAG_06", _garrison];
((findDisplay 9000) displayCtrl 1104) ctrlSetStructuredText parseText format [localize "STR_DISPLAY_DISPLAY_POLICE_DIAG_07", _effect];
