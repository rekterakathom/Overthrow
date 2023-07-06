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

// Group must be deleted on the machine where it is local. The locality of a group can be found out
// only on server. Therefore we need to call the server to find out the machine where the group is
// local, and the server needs to call that machine to delete the group.
[
    _group,
    {
        private _groupOwner = groupOwner _this;
        _this remoteExecCall ["deleteGroup", _groupOwner, false];
    }
] remoteExecCall ["call", 2, false];