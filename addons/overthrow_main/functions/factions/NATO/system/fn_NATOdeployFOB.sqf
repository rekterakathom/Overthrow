/*
    Author: ThomasAngel, ARMAZac

    Description:
    Try to deploy a FOB

    Parameters:
        -

    Usage: [] call OT_fnc_NATOdeployFOB;

    Returns: Boolean - was a FOB established
*/

private _fobs = server getVariable ["NATOfobs", []];

private _fobEstablished = false;
private _lowest = "";
{
	private _stability = server getVariable [format["stability%1",_x],100];
	if ((_x in _abandoned) || _stability < 50) exitWith {
		_lowest = _x;
	};
} forEach (OT_townsSortedByPopulation call BIS_fnc_arrayShuffle);

if (_lowest isNotEqualTo "") then {
	private _townPos = (server getVariable _lowest);
	private _pp = _townPos getPos [2000, random 360];
	private _gotPos = [];
	{
		private _pos = _x select 0;
		_pos set [2,0];
		private _bb = _pos call OT_fnc_nearestObjective;
		private _bpos = _bb select 0;

		private _fobsNear = false;
		{
			_pb = _x select 0;
			if (_pb distance2D _pos < 500) then {
				_fobsNear = true;
			};
		} forEach (_fobs);

		if (!_fobsNear && {(_pos distance2D _bpos) > 400} && {(_pos distance2D _townPos) > 250}) exitWith {
			_gotPos = _pos;
		};
	} forEach (selectBestPlaces [_pp, 1000, "(1 - forest - trees) * (1 - houses) * (1 - sea)", 5, 4]);
	if (_gotPos isNotEqualTo []) then {
		_spend = _spend - 500;
		_resources = _resources - 500;
		spawner setVariable ["NATOdeploying",true,false];
		[_gotpos] spawn OT_fnc_NATOMissionDeployFOB;
		_fobEstablished = true;
	};
};

server setVariable ["NATOresources", _resources];

_fobEstablished
