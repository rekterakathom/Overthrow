// Parameters:
//     _class: string - an item class, such as "C_Offroad_01_F"
//     _largePic: bool (optional) - whether to show a large picture for vehicles or a small one
// Returns:
//     array - [
//         string - picture path,
//         string - name,
//         string - description
//     ]
params ["_class", ["_largePic", false]];

private _config = configFile >> "CfgWeapons" >> _class;
if (isClass _config) exitWith {
	private _pic = getText (_config >> "picture");
	private _name = getText (_config >> "displayName");
    private _desc = getText (_config >> "descriptionShort");
    [_pic, _name, _desc]
};

_config = configFile >> "CfgMagazines" >> _class;
if (isClass _config) exitWith {
    private _pic = getText (_config >> "picture");
	private _name = getText (_config >> "displayName");
    private _desc = getText (_config >> "descriptionShort");
    [_pic, _name, _desc]
};

_config = configFile >> "CfgVehicles" >> _class;
if (isClass _config) exitWith {
    if (getNumber (_config >> "isbackpack") isEqualTo 1) then {
        // backpacks
        private _pic = getText (_config >> "picture");
	    private _name = getText (_config >> "displayName");
        private _desc = "";
        [_pic, _name, _desc]
    } else {
        // non-backpack vehicles
        private _pic = getText (_config >> if (_largePic) then {"editorPreview"} else {"picture"});
	    private _name = getText (_config >> "displayName");
        private _desc = getText (_config >> "Library" >> "libTextDesc");
        [_pic, _name, _desc]
    };
};

_config = configFile >> "CfgGlasses" >> _class;
if (isClass _config) exitWith {
    private _pic = getText (_config >> "picture");
	private _name = getText (_config >> "displayName");
    private _desc = "";
    [_pic, _name, _desc]
};

["", "", ""]
