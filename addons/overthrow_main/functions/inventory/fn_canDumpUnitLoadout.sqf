/*
    Description:
    Checks if the loadout of the unit fits into the target container, excluding the unit's uniform.

    Parameters:
        _unit: OBJECT - Unit which has the loadout to add
        _target: OBJECT - Target container or vehicle where the content is to be added

    Usage:
    if !([_looter, _target] call OT_fnc_canDumpUnitLoadout) then {
        _looter globalChat "Target vehicle is full, cancelling loot order";
    };

    Returns: BOOL - True if the loadout fits into the target container
*/

params ["_unit", "_target"];

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

// Mass of the unit's loadout, excluding uniform which is not going to be dumped
private _unitDumpableLoad = loadAbs _unit - getNumber (configFile >> "CfgWeapons" >> (uniform _unit) >> "ItemInfo" >> "mass");

// Return if unit's loadout would fit in the target container
_targetLoad + _unitDumpableLoad <= maxLoad _target
