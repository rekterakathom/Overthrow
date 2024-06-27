private _range = 100;

private _selectedUnits = groupSelectedUnits player;
{
    player groupSelectUnit [_x, false];
} forEach (_selectedUnits);

// If at least one selected unit is a driver of a recovery truck, do truck recovery instead
private _unitInRecoveryTruck = _selectedUnits findIf {objectParent _x isKindOf "OT_I_Truck_recovery" && driver objectParent _x isEqualTo _x};
if (_unitInRecoveryTruck > -1) exitWith {
	[_selectedUnits # _unitInRecoveryTruck] spawn OT_fnc_recover;
};

private _sortedTargets = nearestObjects [_selectedUnits # 0, ["Car", "ReammoBox_F", "Air", "Ship"], 20];
if (count _sortedTargets isEqualTo 0) exitWith {
    "Cannot find any containers or vehicles within 20m of first selected unit" call OT_fnc_notifyMinor;
};
private _target = _sortedTargets # 0;

{
    [_x, _target] spawn {
		params ["_looter", "_target"];

        private _active = true;
        private _car = objectParent _looter;

        _looter setBehaviour "SAFE";
        [_looter, ""] remoteExec ["switchMove", 0, false];

        if (!isNull _car) then {
            doGetOut _looter;
        };

        _looter globalChat format["Looting bodies within %1m into the %2", _range, (typeOf _target) call OT_fnc_vehicleGetName];

        private _canOverload = (_target isKindOf "Truck_F") || (_target isKindOf "ReammoBox_F");

        _looter doMove ASLtoAGL (getPosASL _target);

        private _timeout = time + 30;
        waitUntil {sleep 1; (!alive _looter) || (isNull _target) || (_looter distance _target < 10) || (_timeout < time) || (unitReady _looter)};
        if (!alive _looter || (isNull _target) || (_timeout < time)) exitWith {};

        if !([_looter, _target] call OT_fnc_dumpStuff) then {
            _looter globalchat "This vehicle is full, cancelling loot order";
            _active = false;
        };

        if (_active) then {
            private _weapons = (_target nearObjects ["WeaponHolder", _range]) + (_target nearEntities ["WeaponHolderSimulated", _range]);
            _looter globalChat format["Looting %1 weapons", count _weapons];
            {
                _weapon = _x;
                _s = (weaponsItems _weapon) select 0;
                if (!isNil {_s}) then {
                    _cls = (_s select 0);
                    _i = _s select 1;
                    if (_i != "") then {_target addItemCargoGlobal [_i, 1]};
                    _i = _s select 2;
                    if (_i != "") then {_target addItemCargoGlobal [_i, 1]};
                    _i = _s select 3;
                    if (_i != "") then {_target addItemCargoGlobal [_i, 1]};

                    if (!(_target canAdd (_cls call BIS_fnc_baseWeapon)) && !_canOverload) exitWith {
                        _looter globalChat "This vehicle is full, cancelling loot order";
                        _active = false;
                    };
                    _target addWeaponCargoGlobal [_cls call BIS_fnc_baseWeapon, 1];
                    deleteVehicle _weapon;
                };
            } forEach (_weapons);
        };

        while {_active} do {
            private _deadguys = [];
            {
                // Some bodies are inside vehicles, so we search through the crew of every vehicle we find.
                // Luckily every man is crew of itself so the same code also works for bodies on the ground.
                private _vehicleOrMan = _x;
                {
                    private _body = _x;
                    if (!alive _body) then {
                        _deadguys pushBack _x;
                    };
                } forEach crew _vehicleOrMan;
            } forEach (nearestObjects [_target, ["AllVehicles"], _range]);

            if (count _deadguys isEqualTo 0) exitWith {_looter globalChat "All done!"};
            _looter globalChat format["%1 bodies to loot", count _deadguys];

            _timeout = time + 30;
            private _deadguy = _deadguys # 0;
            _deadguy setVariable ["OT_looted", true, true];
            _deadguy setvariable ["OT_lootedAt", time, true];

            _looter doMove ASLtoAGL (getPosASL _deadguy);
            [_looter, 1] call OT_fnc_experience;

            waitUntil {sleep 1; (!alive _looter) || (isNull _target) || (_looter distance2D _deadguy < 12) || (_timeout < time)};
            if ((!alive _looter) || (_timeout < time)) exitWith {_looter globalChat "Cant get to a body, cancelling loot order"};

            [_deadguy, _looter] call OT_fnc_takeStuff;
            sleep 2;
            [_deadguy] call OT_fnc_cleanupUnit;
            _timeout = time + 30;
            _looter doMove ASLtoAGL (getPosASL _target);
            waitUntil {sleep 1; (!alive _looter) || (isNull _target) || (_looter distance _target < 12) || (_timeout < time)};
            if ((!alive _looter) || (_timeout < time)) exitWith {};

            if !([_looter, _target] call OT_fnc_dumpStuff) exitWith {
                _looter globalChat "This vehicle is full, cancelling loot order";
                _active = false;
            };

            sleep 1;
        };

        if (!isNull _car) then {
            _looter assignAsCargo _car;
            [_looter] orderGetIn true;
        };
    };
} forEach (_selectedUnits);
