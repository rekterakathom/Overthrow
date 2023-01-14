private _class = _this;

//@todo: support literally anything, ie a player, civ, location
private _config = configFile >> "CfgWeapons" >> _class;
if (isClass _config) exitWith {
	getText (_config >> "displayName")
};
_config = configFile >> "CfgMagazines" >> _class;
if (isClass _config) exitWith {
    getText (_config >> "displayName")
};
_config = configFile >> "CfgVehicles" >> _class;
if (isClass _config) exitWith {
    getText (_config >> "displayName")
};
_config = configFile >> "CfgGlasses" >> _class;
if (isClass _config) exitWith {
	getText (_config >> "displayName")
};
""
