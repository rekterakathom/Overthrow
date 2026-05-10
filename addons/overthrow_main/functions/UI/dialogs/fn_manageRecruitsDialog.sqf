closeDialog 0;
createDialog "OT_dialog_recruits";
openMap false;

ctrlEnable [1600, false];

refreshRecruits = {
    lbClear 1500;
    private _t = 1;
    {
        private _recruit = _x;
        if !(isPlayer _x) then {
            private _idx = lbAdd [1500, format ["%1. %2 (%3) [%4/%5]", _t, name _x, rank _x, _recruit getVariable ["OT_xp", 0], OT_rankXP select (rankId _recruit)]];
            lbSetValue [1500, _idx, _t];
        };
        _t = _t + 1;
    } forEach (units (group player));
};

recruitSelected = {
    ctrlEnable [1600, true];
    private _recruit = (units group player) select (lbValue [1500, lbCurSel 1500] - 1);
    disableSerialization;
    private _ctrl = (findDisplay 8004) displayCtrl 1100;
    _ctrl ctrlSetStructuredText parseText format [
        localize "STR_DISPLAY_DISPLAY_MANAGE_RECRUIT_DIAG_01",
        name _recruit,
        _recruit call BIS_fnc_locationDescription,
        rank _recruit,
        _recruit getVariable ["OT_xp", 0],
        OT_rankXP select (rankId _recruit)
    ];
};

dismissRecruit = {
    private _recruit = (units group player) select (lbValue [1500, lbCurSel 1500] - 1);
    [_recruit] call OT_fnc_cleanupUnit;
    ctrlEnable [1600, false];
    [] call refreshRecruits;
    disableSerialization;
    private _ctrl = (findDisplay 8004) displayCtrl 1100;
    _ctrl ctrlSetStructuredText parseText "";
};

[] call refreshRecruits;
