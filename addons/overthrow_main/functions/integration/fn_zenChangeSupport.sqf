/*
    Description:
    Creates the dialog to change the support of the nearest town.
    Parameters:
        _position: ARRAY - The position the module was placed
        _attached: OBJECT - The object the module was attached to
    Usage:
    [_position, _attached] call OT_fnc_zenChangeSupport;
    Returns: BOOL - Dialog created
*/

params ["_position"];

private _nearestTown = _position call OT_fnc_nearestTown;

[
    format ["Change Town Support: %1", _nearestTown],
    [
        [
            "EDIT",
            "Change this towns support by",
            ["0"]
        ]
    ],
    {
        params ["_result", "_args"];
        _args params ["_town"];
        [_town, parseNumber (_result # 0)] call OT_fnc_support;
    },
    {},
    [_nearestTown]
] call zen_dialog_fnc_create;
