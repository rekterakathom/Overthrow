/*
    Description:
    Creates the dialog to change the stability of the nearest town.
    Parameters:
        _position: ARRAY - The position the module was placed
        _attached: OBJECT - The object the module was attached to
    Usage:
    [_position, _attached] call OT_fnc_zenSetStability;
    Returns: BOOL - Dialog created
*/

params ["_position"];

private _nearestTown = _position call OT_fnc_nearestTown;
private _stability = server getVariable [format ["stability%1", _nearestTown], 100];

[
    format ["Set Town Stability: %1", _nearestTown],
    [
        [
            "SLIDER:PERCENT",
            "Set this towns stability to:",
            [0, 1, (_stability / 100)]
        ]
    ],
    {
        params ["_result", "_args"];
        _args params ["_town"];
        server setVariable [format ["stability%1", _town], round ((_result # 0) * 100), true];
    },
    {},
    [_nearestTown]
] call zen_dialog_fnc_create;
