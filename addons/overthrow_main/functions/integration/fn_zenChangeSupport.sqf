/*
    Description:
    Creates the dialog to change the support of the nearest town.
    Parameters:
        _position: ARRAY - The position the module was placed
        _logic: OBJECT - The module object
    Usage:
    [_hoveredEntity] call OT_zenChangeSupport;
    Returns: BOOL - Dialog created
*/

params ["_position", "_logic"];
deleteVehicle _logic;

private _nearestTown = _position call OT_fnc_nearestTown;
private _support = [_nearestTown] call OT_fnc_support;

[
    format ["Change Town Support: %1", _nearestTown],
    [[
        "EDIT",
        "Change this towns support by",
        "0"
    ]],
    {
        params ["_result", "_args"];
        _args params ["_town"];
        [_town, parseNumber (_result # 0)] call OT_fnc_support;
    },
    {},
    [_nearestTown, _support]
] call zen_dialog_fnc_create;
