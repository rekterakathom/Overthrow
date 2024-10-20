private _canMove = true;
private _veh = _this;
{
    private _hit = configName _x;
    if(("Wheel" in _hit) || ("Track" in _hit) || _hit isEqualTo "HitFuel" || _hit isEqualTo "HitEngine" || _hit isEqualTo "HitVRotor" || _hit isEqualTo "HitHRotor") then {
    	if (_veh getHitPointDamage _hit >= 1) exitWith {
    		_canMove = false;
    	};
    };
} forEach (configProperties [configFile >> "CfgVehicles" >> (typeOf _veh) >> "HitPoints"]);
if((fuel _veh) isEqualTo 0) then {_canMove = false};
_canMove
