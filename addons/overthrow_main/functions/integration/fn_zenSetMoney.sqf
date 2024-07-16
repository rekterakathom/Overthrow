/*
    Description:
    Creates the dialog to change money, and sets the money.
    Parameters:
        _unit: OBJECT - Unit to change the money of
    Usage:
    [_hoveredEntity] call OT_zenSetMoney;
    Returns: BOOL - Dialog created
*/

params ["_unit"];

if !(isPlayer _unit) exitWith {false};

[
    "Set Unit Money",
    [[
        "EDIT",
        "Set this units money to",
        "0"
    ]],
    {params ["_result", "_unit"]; _unit setVariable ["money", parseNumber (_result # 0), true]},
    {},
    _unit
] call zen_dialog_fnc_create;
