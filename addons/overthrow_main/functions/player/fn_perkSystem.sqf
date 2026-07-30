private _fitness = player getVariable ["OT_fitness", 1];

if (ace_advanced_fatigue_anreserve < 2300) then {
    ace_advanced_fatigue_anreserve = ace_advanced_fatigue_anreserve + (_fitness * 12);
    if (_fitness isEqualTo 5) then { ace_advanced_fatigue_anreserve = 2300 };
};

[OT_fnc_perkSystem, [], 2] call CBA_fnc_waitAndExecute;
