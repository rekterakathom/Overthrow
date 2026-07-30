private _unit = _this select 2;

private _seenByNATO = _unit call OT_fnc_unitSeenNATO;
private _seenByCRIM = _unit call OT_fnc_unitSeenCRIM;
if (_seenByNATO || _seenByCRIM) then {
    _unit setCaptive false;
    if (_seenByNATO) then {
        [_unit] call OT_fnc_revealToNATO;
    } else {
        [_unit] call OT_fnc_revealToCRIM;
    };
    "You have been seen placing an explosive" remoteExec ["OT_fnc_notifyMinor", _unit, false];
    // if((random 100) > 70 && ((typeof _exp) select [0,3] == "IED")) then {
    //     [[_exp], -3] call ace_explosives_fnc_scriptedExplosive;
    // };
};
