if (dialog) then {
    closeDialog 0;
};

createDialog "OT_dialog_upload";

params [
    ["_data", "ERROR"],
    ["_editBox", ((findDisplay 49558) displayCtrl 1)],
    ["_legalText", ((findDisplay 49558) displayCtrl 5)]
];

if (_data isEqualTo "ERROR") exitWith {
    closeDialog 0;
    diag_log "UPLOAD DIALOG encountered an error with data transmited";
};

private _editData = str _data;
_editData = [_editData, "<NULL-object>", "objNull"] call OT_fnc_findReplace;
_editData = [_editData, ",any]", ",nil]"] call OT_fnc_findReplace;

_editBox ctrlSetText _editData;
_editBox ctrlSetTooltip localize "STR_DISPLAY_DISPLAY_UPLOAD_DIAG_01";

_legalText ctrlSetStructuredText parseText format [localize "STR_DISPLAY_DISPLAY_UPLOAD_DIAG_02"];
[_legalText] call BIS_fnc_ctrlFitToTextHeight;
