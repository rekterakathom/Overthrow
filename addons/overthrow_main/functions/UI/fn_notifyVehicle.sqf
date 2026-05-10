private _owner = players_NS getVariable ("name" + ((vehicle player) call OT_fnc_getOwner));
if (isNil "_owner") then { _owner = "Someone" };
if ((vehicle player) getVariable ["stolen", false]) then { _owner = format ["%1 (Stolen)", _owner] };
[
    format [
        localize "STR_FNC_NOTIFY_VEHICLE_01",
        (typeOf vehicle player) call OT_fnc_vehicleGetName,
        _owner
    ],
    -0.5,
    1,
    5,
    1,
    0,
    5
] call OT_fnc_dynamicText;
