params ["_atpos","_attackdir"];
_attackdir = (_attackdir-45) + random 90; //randomize direction a little;

private _lowrange = 200;
private _rangeinterval = 300;
private _ao = _atpos getPos [(_lowrange + random _rangeinterval), _attackdir];

if(surfaceIsWater _ao) then {
	_attackdir = _attackdir + 90;
	if(_attackdir > 359) then {_attackdir = 360 - _attackdir};
	_ao = _atpos getPos [(_lowrange + random _rangeinterval), _attackdir];
	if(surfaceIsWater _ao) then {
		_attackdir = _attackdir + 180;
		if(_attackdir > 359) then {_attackdir = 360 - _attackdir};
		_ao = _atpos getPos [(_lowrange + random _rangeinterval), _attackdir];
		if(surfaceIsWater _ao) then {
			_attackdir = _attackdir - 90;
			if(_attackdir > 359) then {_attackdir = 360 - _attackdir};
			_ao = _atpos getPos [(_lowrange + random _rangeinterval), _attackdir];
		};
	};
};

_ao
