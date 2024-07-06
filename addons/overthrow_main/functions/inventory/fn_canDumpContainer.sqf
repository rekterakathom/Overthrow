/*
    Description:
    Checks if the contents of the origin container fit into the target container.

    Parameters:
        _origin: OBJECT - Origin container or vehicle which has the content to add
        _target: OBJECT - Target container or vehicle where the content is to be added

    Usage:
    if !([_weaponHolder, _target] call OT_fnc_canDumpContainer) then {
        _looter globalChat "Target vehicle is full, cancelling loot order";
    };

    Returns: BOOL - True if the contents of the origin container fit into the target container
*/

params ["_origin", "_target"];

// If target is truck or ammobox, it can always be overloaded
if (_target isKindOf "Truck_F" || _target isKindOf "ReammoBox_F") exitWith {true};

// Load of the target container
private _targetLoad = loadAbs _target;
// Hack: Workaround for BIS bug where masses are double counted for items inside subcontainers.
// https://feedback.bistudio.com/T167469
// The workaround is to simply subtract the load of every subcontainer from main container load.
// Taken from ACE
// https://github.com/acemod/ACE3/blob/71afce53c1bde666369344652a30a71ec8ad751a/addons/dragging/functions/fnc_getWeight.sqf
{
    _targetLoad = _targetLoad - loadAbs (_x # 1);
} forEach (everyContainer _target);

// Load of the origin container
private _originLoad = loadAbs _origin;
// Same workaround here
{
    _originLoad = _originLoad - loadAbs (_x # 1);
} forEach (everyContainer _origin);

// Return if the content of the origin container would fit in the target container
_targetLoad + _originLoad <= maxLoad _target
