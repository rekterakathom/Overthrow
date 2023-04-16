private _call = {
  if (zeusToggle) then {
    [player,zeusCurator] remoteExec ["assignCurator", 2];
    zeusToggle = false;
    "Zeus Enabled" call OT_fnc_notifyMinor;
  } else {
    [zeusCurator] remoteExec ["unassignCurator", 2];
    zeusToggle = true;
    "Zeus Disabled" call OT_fnc_notifyMinor;
  };
};


if (!isDedicated) then {
  call _call;
} else {
  if (call BIS_fnc_admin isEqualTo 2) then {
    call _call;
  }else{
    "You need to be logged in admin to access Zeus!" call OT_fnc_notifyBig;
  };
};
