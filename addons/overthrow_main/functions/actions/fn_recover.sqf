params ["_user"];

private _range = 150;
private _time = 15;

private _veh = vehicle _user;
if (_veh == _user) exitWith {};
if ((driver _veh) != _user) exitWith {
    "Loot must be initiated by the driver of this vehicle" call OT_fnc_notifyMinor;
};
if ((typeOf _veh) != "OT_I_Truck_recovery") exitWith {
    "This command is only available when using a Recovery truck" call OT_fnc_notifyMinor;
};

if (isPlayer _user) then {
    _veh enableSimulation false;
    [_time, _veh] spawn {
        params ["_time", "_veh"];
        sleep (_time + 5);
        _veh enableSimulation true;
        //Fail safe for user input disabled.
    };
    format ["Looting all bodies within %1m",_range] call OT_fnc_notifyMinor;
    [_time, false] call OT_fnc_progressBar;
} else {
    _user globalchat format["Looting bodies within %1m using Recovery vehicle",_range];
};

sleep _time;

// Get loose weapons and items
private _countWeaponHolders = 0;
// WeaponHolderSimulated = dropped weapons from bodies. Bodies inside the range may drop their
// weapons outside of it and they would get deleted when the body is looted, so loot dropped weapons
// 10m further than bodies. It is still possible that the weapon has flown more than 10m outside the
// range, in which case it is lost.
private _weaponHolders = (_veh nearObjects ["WeaponHolder", _range]) + (_veh nearEntities ["WeaponHolderSimulated", (_range + 10)]);
{
    private _weaponHolder = _x;

    // Weapon holder may be any pile of stuff on the ground, not just weapons dropped from corpses,
    // so we have to treat it as a generic container that might contain any items.
    [_weaponHolder, _veh] call OT_fnc_dumpContainer;

    deleteVehicle _weaponHolder;
    _countWeaponHolders = _countWeaponHolders + 1;
} foreach _weaponHolders;

// Get the bodies
private _countBodies = 0;
{
    // Some bodies are inside vehicles, so we search through the crew of every vehicle we find.
    // Luckily every man is crew of itself so the same code also works for bodies on the ground.
    private _vehicleOrMan = _x;
    {
        private _body = _x;
        if (!alive _body) then {
            [_body, _veh] call OT_fnc_dumpUnitLoadout;

            [_body] call OT_fnc_cleanupUnit;
            _countBodies = _countBodies + 1;
        };
    } forEach crew _vehicleOrMan;
} forEach (_veh nearObjects ["AllVehicles", _range]);

if (isPlayer _user) then {
    _veh enableSimulation true;
    format["Looted %1 item piles and %2 bodies into this truck", _countWeaponHolders, _countBodies] call OT_fnc_notifyMinor;
} else {
    _user globalchat format["All done! Looted %1 item piles and %2 bodies", _countWeaponHolders, _countBodies];
};
