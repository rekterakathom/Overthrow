/*
    Description:
    Deletes an empty group, regardless of which machine is executing this script.

    Parameters:
        _this: GROUP - Group to be deleted

    Usage: _group call OT_fnc_cleanupEmptyGroup;

    Returns: Nothing
*/

params [
	["_group", grpNull, [grpNull]]
];

// Incorrect arguments or group got auto-deleted
if (isNull _group) exitWith {};

// Group must be deleted on the machine where it is local. The locality of a group can be found out
// only on server. Therefore we need to call the server to find out the machine where the group is
// local, and the server needs to call that machine to delete the group.
if !(isServer) exitWith {
    [_group] remoteExecCall ["OT_fnc_cleanupEmptyGroup", 2, false];
};

private _groupOwner = groupOwner _group;
_group remoteExec ["deleteGroup", _groupOwner, false];
