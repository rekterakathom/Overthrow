private _namesWithDuplicates = configProperties [(configFile >> "CfgWorlds" >> "GenericNames" >> "EnochMen" >> "FirstNames")] apply {getText _x};
OT_firstNames_local = _namesWithDuplicates arrayIntersect _namesWithDuplicates;

_namesWithDuplicates = configProperties [(configFile >> "CfgWorlds" >> "GenericNames" >> "EnochMen" >> "LastNames")] apply {getText _x};
OT_lastNames_local = _namesWithDuplicates arrayIntersect _namesWithDuplicates;