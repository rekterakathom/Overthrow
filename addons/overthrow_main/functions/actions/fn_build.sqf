if !(isNil "modeTarget") exitWith { "You are already placing a previous object" call OT_fnc_notifyMinor };
if !(captive player) exitWith { "You cannot build while wanted" call OT_fnc_notifyMinor };
private _base = player call OT_fnc_nearestBase;
private _closest = "";
private _isBase = false;
private _isobj = false;
private _center = getPos player;
modeMax = 350;
private _buildlocation = "base";
if !(isNil "_base") then {
    if ((_base select 0) distance player < 120) then {
        _closest = _base select 1;
        _center = _base select 0;
        _isBase = true;
        modeMax = 100;
    };
};

if (!_isBase) then {
    private _obj = player call OT_fnc_nearestObjectiveNoComms;
    private _objpos = _obj select 0;

    private _town = player call OT_fnc_nearestTown;
    private _townpos = server getVariable _town;

    _closest = _town;
    _center = _townpos;
    if ((_objpos distance player) < 250) then {
        _closest = _obj select 1;
        _isobj = true;
        _center = _objpos;
        _buildlocation = "objective";
        modeMax = 250;
    } else {
        _buildlocation = "town";
        if (_town in OT_capitals) then {
            modeMax = 750;
        };
    };
};

if ((!_isBase) && !(_closest in (server getVariable ["NATOabandoned", []]))) exitWith {
    if (_isobj) then {
        format ["NATO does not allow construction this close to %1.", _closest] call OT_fnc_notifyMinor;
    } else {
        format ["NATO is currently not allowing any construction in %1", _closest] call OT_fnc_notifyMinor;
    };
};

if ((player distance _center) > modeMax) exitWith { format ["You need to be within %1m of the %2.", modeMax, _buildlocation] call OT_fnc_notifyMinor };

openMap false;
private _playerpos = (getPos player);

private _campos = [(_playerpos select 0) + 35, (_playerpos select 1) + 35, (_playerpos select 2) + 70];
private _start = [_playerpos select 0, _playerpos select 1, 2];
buildCam = "camera" camCreate _start;

buildFocus = createVehicle ["Sign_Sphere10cm_F", _start getPos [1000, getDir player], [], 0, "NONE"];
buildFocus setObjectTexture [0, "\overthrow_main\ui\clear.paa"];

buildCam camSetTarget buildFocus;
buildCam cameraEffect ["internal", "BACK"];
buildCam camCommit 0;

showCinemaBorder false;
waitUntil { camCommitted buildCam };

if (currentVisionMode player > 0) then {
    camUseNVG true;
};

buildFocus setPos _playerpos;
buildCam camSetTarget buildFocus;
buildCam camSetPos _campos;
buildCam camCommit 2;
waitUntil { camCommitted buildCam };

modeFinished = false;
modeCancelled = false;

cancelBuild = {
    modeCancelled = true;
};
modeValue = [0, 0, 0];

buildCamMoving = false;
buildCamRotating = false;
canBuildHere = false;

modeCenter = _center;

buildOnMouseMove = {
    params ["", "_mouseX", "_mouseY"];
    modeValue = screenToWorld getMousePosition;
    modeValue = [modeValue select 0, modeValue select 1, 0];
    if (!isNull modeTarget) then {
        modeTarget setPos modeValue;
        modeVisual setPos modeValue;
        modeVisual setVectorDirAndUp [[0, 0, -1], [0, 1, 0]];
        modeTarget setVectorDirAndUp [[0, 1, 0], [0, 1, 0]];
        modeTarget setDir buildRotation;

        if (modeMode == 0) then {
            if (surfaceIsWater modeValue || (modeTarget distance modeCenter > modeMax) || ((nearestObjects [modeTarget, [], 10]) findIf { !(_x isKindOf "CAManBase") && (typeOf _x != OT_flag_IND) && (_x isNotEqualTo modeTarget) && (_x isNotEqualTo modeVisual) } != -1)) then {
                if (canBuildHere) then {
                    canBuildHere = false;
                    modeVisual setObjectTexture [0, '#(argb,8,8,3)color(1,0,0,0.5)'];
                };
            } else {
                if !(canBuildHere) then {
                    canBuildHere = true;
                    modeVisual setObjectTexture [0, '#(argb,8,8,3)color(0,1,0,0.5)'];
                };
            };
        } else {
            if (surfaceIsWater modeValue || (modeTarget distance modeCenter > modeMax)) then {
                if (canBuildHere) then {
                    canBuildHere = false;
                    modeVisual setObjectTexture [0, '#(argb,8,8,3)color(1,0,0,0.5)'];
                };
            } else {
                if !(canBuildHere) then {
                    canBuildHere = true;
                    modeVisual setObjectTexture [0, '#(argb,8,8,3)color(0,1,0,0.5)'];
                };
            };
        };
    };
    if (buildCamRotating && buildCamMoving) exitWith {
        private _mouseVec = [-_mouseX, _mouseY, 0];
        private _dist = (vectorMagnitude _mouseVec) * (buildCam distance buildFocus) / 200;
        private _dir = [0, 0, 0] getDir _mouseVec;
        _dir = _dir + getDir buildCam;
        ([sin _dir, cos _dir, 0] vectorMultiply _dist) params ["_relX", "_relY"];

        private _camATL = getPosATL buildCam;
        private _camWaterDepth = (getTerrainHeightASL _camATL) min 0;
        buildCam camSetPos (_camATL vectorAdd [_relX, _relY, _camWaterDepth]);
        buildCam camSetTarget buildFocus;
        buildCam camCommit 0;
    };
    if (buildCamMoving) exitWith {
        private _mouseVec = [-_mouseX, _mouseY, 0];
        private _dist = (vectorMagnitude _mouseVec) * (buildCam distance buildFocus) / 200;
        private _dir = [0, 0, 0] getDir _mouseVec;
        _dir = _dir + getDir buildCam;
        ([sin _dir, cos _dir, 0] vectorMultiply _dist) params ["_relX", "_relY"];

        private _camATL = getPosATL buildCam;
        private _camWaterDepth = (getTerrainHeightASL _camATL) min 0;
        buildFocus setPosATL ((getPosATL buildFocus) vectorAdd [_relX, _relY, 0]);
        buildCam camSetPos (_camATL vectorAdd [_relX, _relY, _camWaterDepth]);
        buildCam camSetTarget buildFocus;
        buildCam camCommit 0;
    };
};
buildMoveCam = {
    params ["_dir", "_dist"];

    _dir = _dir + getDir buildCam;
    ([sin _dir, cos _dir, 0] vectorMultiply _dist) params ["_relX", "_relY"];

    buildFocus setPosATL ((getPosATL buildFocus) vectorAdd [_relX, _relY, 0]);
    buildCam camSetPos ((getPosATL buildCam) vectorAdd [_relX, _relY, 0]);
    buildCam camSetTarget buildFocus;
    buildCam camCommit 0;
};

buildOnKeyUp = {
    params ["", "_key"];
    if (_key isEqualTo 42 || _key isEqualTo 54) then {
        //Shift
        OT_shiftHeld = false;
    };
    if (_this select 2) then {
        buildCamRotating = false;
    };
};

OT_shiftHeld = false;

buildRotation = 0;

buildOnKeyDown = {
    params ["", "_key"];
    private _handled = false;
    if (_this select 2) then {
        buildCamRotating = true;
    };
    [_key] call {
        params ["_key"];
        if (_key isEqualTo 42 || _key isEqualTo 54) exitWith {
            //Shift
            OT_shiftHeld = true;
        };
        if (_key isEqualTo 17) exitWith {
            //W
            _handled = true;
            [0, 2] call buildMoveCam;
        };
        if (_key isEqualTo 31) exitWith {
            //S
            _handled = true;
            [180, 2] call buildMoveCam;
        };
        if (_key isEqualTo 30) exitWith {
            //A
            _handled = true;
            [270, 2] call buildMoveCam;
        };
        if (_key isEqualTo 32) exitWith {
            //D
            _handled = true;
            [90, 2] call buildMoveCam;
        };

        if (isNull modeTarget) exitWith {};
        private _dir = buildRotation;

        if (_key isEqualTo 57 && modeMode isEqualTo 1) exitWith {
            //Space
            _handled = true;
            deleteVehicle modeTarget;
            modeIndex = modeIndex + 1;
            if (modeIndex > ((count modeValues) - 1)) then { modeIndex = 0 };

            private _cls = modeValues select modeIndex;

            modeTarget = createVehicle [_cls, modeValue, [], 0, "CAN_COLLIDE"];
            modeTarget enableDynamicSimulation true;
            modeTarget setDir _dir;
        };
        private _amt = 5;
        if (_key isEqualTo 16) exitWith {
            //Q
            _handled = true;
            private _newDir = _dir - _amt;
            if (_newDir < 0) then { _newDir = 359 };
            modeTarget setDir (_newDir);
            buildRotation = _newDir;
        };
        if (_key isEqualTo 18) exitWith {
            //E
            _handled = true;
            private _newDir = _dir + _amt;
            if (_newDir > 359) then { _newDir = 0 };
            modeTarget setDir (_newDir);
            buildRotation = _newDir;
        };
    };
    _handled;
};

buildOnMouseDown = {
    params ["", "_btn"];
    if (_btn isEqualTo 1) then {
        buildCamMoving = true;
    };
};

buildOnMouseUp = {
    params ["", "_btn", "_sx"];
    if (_btn isEqualTo 1) then {
        buildCamMoving = false;
    };
    if (_btn isEqualTo 2) then {
        buildCamRotating = false;
    };
    if (_btn isEqualTo 0 && _sx > (safeZoneX + (0.1 * safeZoneW)) && _sx < (safeZoneX + (0.9 * safeZoneW))) then {
        //Click LMB
        if (!isNull modeTarget && canBuildHere) then {
            private _money = player getVariable "money";
            if (_money < modePrice) then {
                "You cannot afford that" call OT_fnc_notifyMinor;
            } else {

                private _created = objNull;
                playSound "3DEN_notificationDefault";
                player setVariable ["money", _money - modePrice, true];
                if (modeMode isEqualTo 0) then {
                    private _objects = [modeValue, getDir modeTarget, modeValues] call BIS_fnc_objectsMapper;
                    {
                        clearWeaponCargoGlobal _x;
                        clearMagazineCargoGlobal _x;
                        clearBackpackCargoGlobal _x;
                        clearItemCargoGlobal _x;
                        [_x, getPlayerUID player] call OT_fnc_setOwner;
                        _x call OT_fnc_initObjectLocal;
                    } forEach (_objects);
                    _created = _objects select 0;
                    deleteVehicle modeTarget;
                } else {
                    _created = modeTarget;
                    [modeTarget, getPlayerUID player] call OT_fnc_setOwner;
                    modeTarget = objNull;
                };

                // If the object is a house, mark it as being player-built (will be used to save the leasing status)
                private _buildableHouses = (OT_Buildables param [9, []]) param [2, []];
                if ((typeOf _created) in _buildableHouses) then {
                    _created setVariable ["OT_house_isPlayerBuilt", true, true];
                };

                if (typeOf _created == OT_warehouse) then {
                    private _ownedWarehouses = warehouse getVariable ["owned", []];
                    _ownedWarehouses pushBack _created;
                    warehouse setVariable ["owned", _ownedWarehouses, true];
                };

                if (modeCode != "") then {
                    _created setVariable ["OT_init", modeCode, true];
                    [_created, modeValue, modeCode] remoteExec ["OT_fnc_initBuilding", 2];
                };
                private _clu = createVehicle ["Land_ClutterCutter_large_F", (getPos modeTarget), [], 0, "CAN_COLLIDE"];
                _clu enableDynamicSimulation true;
            };
            deleteVehicle modeVisual;
            if (OT_shiftHeld) then {
                modeSelected call build;
            };
        };
        if (!canBuildHere) then {
            "You cannot build that there" call OT_fnc_notifyMinor;
        };
    };
};

buildOnMouseWheel = {
    private _z = _this select 1;
    private _pos = getPos buildCam;
    private _distMul = 0.25 + (buildCam distance buildFocus) / 100;

    if (_z < 0) then {
        buildCam camSetPos [(_pos select 0), (_pos select 1), (_pos select 2) + 10 * _distMul];
    } else {
        buildCam camSetPos [(_pos select 0), (_pos select 1), (_pos select 2) - 10 * _distMul];
    };
    buildCam camSetTarget buildFocus;
    buildCam camCommit 0.1;
};

modeTarget = objNull;
modeValues = [];
modeMode = 0;
modePrice = 0;
modeSelected = "";
modeVisual = objNull;
modeIndex = 0;
modeCode = "";

build = {
    canBuildHere = false;
    modeSelected = _this;
    private _def = [];
    {
        if ((_x select 0) isEqualTo modeSelected) exitWith { _def = _x };
    } forEach (OT_Buildables);
    modeIndex = 0;
    private _name = _def select 0;
    private _description = _def select 5;
    modeCode = _def select 3;
    modeValues = _def select 2;
    modePrice = _def select 1;
    private _isTemplate = _def select 4;
    private _buildcls = "";
    if (_isTemplate) then {
        modeMode = 0;
        _buildcls = (modeValues select 0) select 0;
    } else {
        modeMode = 1;
        _buildcls = modeValues select modeIndex;
    };

    if (!isNull modeTarget) then {
        deleteVehicle modeTarget;
        deleteVehicle modeVisual;
    };
    modeTarget = createVehicle [_buildcls, modeValue, [], 0, "CAN_COLLIDE"];
    modeVisual = createVehicle ["Sign_Circle_F", modeValue, [], 0, "CAN_COLLIDE"];
    {
        modeTarget disableCollisionWith _x;
        modeVisual disableCollisionWith _x;
    } forEach (vehicles + allUnits);

    modeVisual setVectorDirAndUp [[0, 0, -1], [0, 1, 0]];
    modeVisual setObjectTexture [0, '#(argb,8,8,3)color(1,0,0,0.5)'];
    modeVisual allowDamage false;
    modeTarget setMass 0;
    modeVisual setMass 0;
    modeTarget setDir buildRotation;
    modeTarget allowDamage false;

    [
        format [
            "<t size='1.1' color='#eeeeee'>%1</t><br/><t size='0.8' color='#bbbbbb'>$%2</t><br/><t size='0.4' color='#bbbbbb'>%3</t><br/><br/><t size='0.5' color='#bbbbbb'>Q,E = Rotate (Shift for smaller)<br/>Space = Change Type<br/>Left Click = Build It<br/>Right Click = Move Camera<br/>Mouse Wheel = Zoom<br/>Shift = Build multiple</t>",
            _name,
            [modePrice, 1, 0, true] call CBA_fnc_formatNumber,
            _description
        ],
        [safeZoneX + (0.8 * safeZoneW), (0.2 * safeZoneW)],
        0.5,
        10,
        0,
        0,
        2
    ] call OT_fnc_dynamicText;
};

createDialog format ["OT_dialog_build%1", _buildlocation];

waitUntil {
    sleep 1;
    modeFinished || modeCancelled || !dialog;
};

if (!isNull modeTarget) then {
    deleteVehicle modeTarget;
    deleteVehicle modeVisual;
};

deleteVehicle buildFocus;

closeDialog 0;
buildCam cameraEffect ["Terminate", "BACK"];
buildCam = nil;

modeTarget = nil;
modeCancelled = nil;
modeFinished = nil;
modeValue = nil;
modeValues = nil;
modeSelected = nil;
modeMode = nil;
modeCode = nil;
