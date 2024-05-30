// This function should only be called on the server

params ["_businessName"];

private _group = spawner getVariable [format ["employees%1", _businessName], grpNull];
private _pos = server getVariable _businessName;
if (!assert !(isNil "_pos")) exitWith {diag_log "Overthrow: Nil position"};
if (isNull _group) then {
    // Either no player is in spawn distance or there are currently no employees on the business.
    // Create new group using the regular spawning mechanism
    _pos call OT_fnc_resetSpawn;
} else {
    // Add new member to existing group
    _pos = [[[_pos, 50]]] call BIS_fnc_randomPos;

    _civ = _group createUnit [OT_civType_worker, _pos, [], 0, "NONE"];

	_civ setBehaviour "SAFE";
    private _identity = call OT_fnc_randomLocalIdentity;
    _identity set [1, ""]; // Retain original worker clothes
    [_civ, _identity] call OT_fnc_applyIdentity;

    _civ setVariable ["employee", _businessName, true];
};
