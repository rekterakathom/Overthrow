/*
    Description:
    Creates the dialog to change money, and sets the money.
    Parameters:
        _unit: OBJECT - Unit to change the money of
    Usage:
    [_hoveredEntity] call OT_fnc_zenSetMoney;
    Returns: BOOL - Dialog created
*/

params ["_unit"];

if !(isPlayer _unit) exitWith { false };
private _money = _unit getVariable ["money", 0];

[
    "Set Unit Money",
    [
        [
            "EDIT",
            "Set this units money to",
            [str _money]
        ]
    ],
    {
        params ["_result", "_unit"];
        _unit setVariable ["money", parseNumber (_result # 0), true];
    },
    {},
    _unit
] call zen_dialog_fnc_create;
