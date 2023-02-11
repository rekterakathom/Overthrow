params ["_exp","_dir","_pitch","_unit"];

if (side _unit isNotEqualTo resistance || !(captive _unit)) exitWith {};
if(_unit call OT_fnc_unitSeen) then {
    _unit setCaptive false;
    "You have been seen placing an explosive" remoteExec ["OT_fnc_notifyMinor", _x, false];
    // if((random 100) > 70 && ((typeof _exp) select [0,3] == "IED")) then {
    //     [[_exp], -3] call ace_explosives_fnc_scriptedExplosive;
    // };
};
