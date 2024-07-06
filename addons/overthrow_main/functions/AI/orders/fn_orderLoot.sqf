private _selectedUnits = groupSelectedUnits player;
{
    player groupSelectUnit [_x, false];
} forEach (_selectedUnits);

// If at least one selected unit is a driver of a recovery truck, do truck recovery instead
private _unitInRecoveryTruck = _selectedUnits findIf {objectParent _x isKindOf "OT_I_Truck_recovery" && driver objectParent _x isEqualTo _x};
if (_unitInRecoveryTruck > -1) exitWith {
	[_selectedUnits # _unitInRecoveryTruck] spawn OT_fnc_recover;
};

private _sortedTargets = nearestObjects [_selectedUnits # 0, ["Car", "ReammoBox_F", "Air", "Ship"], 20] select {alive _x};
if (count _sortedTargets isEqualTo 0) exitWith {
    "Cannot find any containers or vehicles within 20m of first selected unit" call OT_fnc_notifyMinor;
};
private _target = _sortedTargets # 0;

{
    [_x, _target] spawn {
        scopeName "looting script";
		params ["_looter", "_target"];

        _looter setBehaviour "SAFE";
        if (!isNull objectParent _looter) then {
            doGetOut _looter;
        };

        private _range = 100;

        _looter globalChat format["Looting bodies and item piles within %1m into the %2", _range, (typeOf _target) call OT_fnc_vehicleGetName];

        _looter doMove ASLtoAGL (getPosASL _target);

        // Wait until looter reaches the target container
        private _timeout = time + 30;
        waitUntil {sleep 1; (_looter distance _target < 12) || (!alive _looter) || (!alive _target) || (_timeout < time)};
        if ((!alive _looter) || (!alive _target) || (_timeout < time)) exitWith {
            if (alive _looter) then {_looter globalChat format ["Can't get to the %1, cancelling loot order", (typeOf _target) call OT_fnc_vehicleGetName]};
        };

        // Looter has reached the target container. Dump his loadout to it.
        if !([_looter, _target] call OT_fnc_canDumpUnitLoadout) exitWith {
            _looter globalChat "This vehicle is full, cancelling loot order";
        };

        private _looterOwnUniform = uniform _looter;

        [_looter, _target] call OT_fnc_dumpUnitLoadout;
        _looter setUnitLoadout [[], [], [], [_looterOwnUniform, []], [], [], "", "", [], ["", "", "", "", "", ""]];

        while {true} do {
            private _sortedBodies = [];
            {
                // Some bodies are inside vehicles, so we search through the crew of every vehicle
                // we find. Luckily every man is crew of itself so the same code also works for
                // bodies on the ground.
                private _vehicleOrMan = _x;
                {
                    private _body = _x;
                    if (!alive _body && !(_body getVariable ["OT_looterReserved", false])) then {
                        _sortedBodies pushBack _x;
                    };
                } forEach crew _vehicleOrMan;
            } forEach (nearestObjects [_target, ["AllVehicles"], _range]);

            if (_sortedBodies isNotEqualTo []) then {
                // There are bodies to be looted. Loot the nearest body.

                _looter globalChat format ["%1 bodies to loot", count _sortedBodies];
                private _body = _sortedBodies # 0;

                _body setVariable ["OT_looterReserved", true, false];
                _looter doMove ASLtoAGL (getPosASL _body);
                [_looter, 1] call OT_fnc_experience;

                // Wait until looter reaches the body
                _timeout = time + 30;
                waitUntil {sleep 1; (_looter distance2D _body < 12) || (isNull _body) || (!alive _looter) || (!alive _target) || (_timeout < time)};
                if ((!alive _looter) || (!alive _target) || (_timeout < time)) then {
                    if (alive _looter) then {_looter globalChat "Can't get to a body, cancelling loot order"};
                    _body setVariable ["OT_looterReserved", false, false];
                    breakOut "looting script";
                };
                if (isNull _body) then {
                    _looter globalChat "Body has vanished, skipping";
                    continue;
                };

                // Looter has reached the body. Transfer its loadout to the looter.
                private _lootedLoadout = getUnitLoadout _body;

                // If the looter has his own uniform, keep it.
                if (_looterOwnUniform isNotEqualTo "") then {
                    private _bodyUniformContent = _lootedLoadout # 3 param [1, []];
                    _lootedLoadout set [3, [_looterOwnUniform, _bodyUniformContent]];
                };

                // Also take the dropped weapons belonging to the body. The body may have dropped
                // its weapons outside of the search range and they would get deleted when the body
                // is deleted, so search for dropped weapons 10m further than bodies. It is still
                // possible that the weapon has flown more than 10m outside the range, in which case
                // it is lost. This code can be simplified in Arma 3 version 2.18 with the new
                // command getCorpseWeaponholders.
                // https://community.bistudio.com/wiki/getCorpseWeaponholders
                private _droppedWeaponHolders = (_target nearEntities ["WeaponHolderSimulated", (_range + 10)]);
                {
                    if (getCorpse _x isEqualTo _body) then {
                        private _weapon = weaponsItemsCargo _x # 0;
                        if (_weapon # 0 isKindOf ["Launcher", configFile >> "CfgWeapons"]) then {
                            _lootedLoadout set [1, _weapon];
                        } else {
                            _lootedLoadout set [0, _weapon];
                        };
                    };
                } forEach _droppedWeaponHolders;

                _looter setUnitLoadout _lootedLoadout;
                [_body] call OT_fnc_cleanupUnit;

                sleep 2;
                _looter doMove ASLtoAGL (getPosASL _target);

                // Wait until looter reaches the target container
                _timeout = time + 30;
                waitUntil {sleep 1; (_looter distance _target < 12) || (!alive _looter) || (!alive _target) || (_timeout < time)};
                if ((!alive _looter) || (!alive _target) || (_timeout < time)) then {
                    if (alive _looter) then {_looter globalChat format ["Can't get back to the %1, cancelling loot order", (typeOf _target) call OT_fnc_vehicleGetName]};
                    breakOut "looting script";
                };

                // Looter has reached the target container. Dump his loadout to it.
                if !([_looter, _target] call OT_fnc_canDumpUnitLoadout) then {
                    _looter globalChat "This vehicle is full, cancelling loot order";
                    breakOut "looting script";
                };

                [_looter, _target] call OT_fnc_dumpUnitLoadout;
                _looter setUnitLoadout [[], [], [], [_looterOwnUniform, []], [], [], "", "", [], ["", "", "", "", "", ""]];
            } else {
                // There are no longer any bodies to loot. Loot the nearest item pile.

                private _sortedWeaponHolders = nearestObjects [_target, ["WeaponHolder", "WeaponHolderSimulated"], _range] select {!(_x getVariable ["OT_looterReserved", false])};

                if (_sortedWeaponHolders isEqualTo []) then {
                    _looter globalChat "All done!";
                    breakOut "looting script";
                };

                _looter globalChat format ["%1 item piles to loot", count _sortedWeaponHolders];
                private _weaponHolder = _sortedWeaponHolders # 0;

                _weaponHolder setVariable ["OT_looterReserved", true, false];
                _looter doMove ASLtoAGL (getPosASL _weaponHolder);
                [_looter, 1] call OT_fnc_experience;

                // Wait until looter reaches the item pile
                _timeout = time + 30;
                waitUntil {sleep 1; (_looter distance2D _weaponHolder < 12) || (isNull _weaponHolder) || (!alive _looter) || (!alive _target) || (_timeout < time)};
                if ((!alive _looter) || (!alive _target) || (_timeout < time)) then {
                    if (alive _looter) then {_looter globalChat "Can't get to an item pile, cancelling loot order"};
                    _weaponHolder setVariable ["OT_looterReserved", false, false];
                    breakOut "looting script";
                };

                // Looter has reached the item pile. Its contents may not fit in the looter's
                // inventory, so fake the looting trip by running back empty handed and dumping the
                // contents directly to the target container once there.

                sleep 2;
                _looter doMove ASLtoAGL (getPosASL _target);

                // Wait until looter reaches the target container
                _timeout = time + 30;
                waitUntil {sleep 1; (_looter distance _target < 12) || (isNull _weaponHolder) || (!alive _looter) || (!alive _target) || (_timeout < time)};
                if ((!alive _looter) || (!alive _target) || (_timeout < time)) then {
                    if (alive _looter) then {_looter globalChat format ["Can't get back to the %1, cancelling loot order", (typeOf _target) call OT_fnc_vehicleGetName]};
                    _weaponHolder setVariable ["OT_looterReserved", false, false];
                    breakOut "looting script";
                };
                if (isNull _weaponHolder) then {
                    _looter globalChat "Item pile has vanished, skipping";
                    continue;
                };

                // Looter has reached the target container.
                if !([_weaponHolder, _target] call OT_fnc_canDumpContainer) then {
                    _looter globalChat "This vehicle is full, cancelling loot order";
                    _weaponHolder setVariable ["OT_looterReserved", false, false];
                    breakOut "looting script";
                };

                [_weaponHolder, _target] call OT_fnc_dumpContainer;
                deleteVehicle _weaponHolder;
            };

            sleep 1;
        };
    };
} forEach (_selectedUnits);
