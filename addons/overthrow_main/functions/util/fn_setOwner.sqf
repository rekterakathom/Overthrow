params ["_obj",["_owner",objNull]];
if(_obj isEqualType 1) exitWith {
    owners setVariable [str _obj,_owner,true];
};
if(_obj isEqualType "") exitWith {
    owners setVariable [_obj,_owner,true];
};
if !(_obj isEqualType objNull) exitWith {};
_obj setVariable ["owner",_owner,true];
if((getObjectType _obj) != 8 && (_obj isKindOf "Building")) exitWith {
    _id = [_obj] call OT_fnc_getBuildID;
    owners setVariable [_id,_owner,true];
};
