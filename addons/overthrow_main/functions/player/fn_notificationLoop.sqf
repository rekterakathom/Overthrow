if (OT_notifies isNotEqualTo []) then {
    [OT_notifies joinString "<br/>", -1, -0.2, 10, 0.5, 0, 9876] call OT_fnc_dynamicText;
    OT_notifies = [];
    [OT_fnc_notificationLoop, [], 11.5] call CBA_fnc_waitAndExecute;
} else {
    [OT_fnc_notificationLoop, [], 1] call CBA_fnc_waitAndExecute;
};
