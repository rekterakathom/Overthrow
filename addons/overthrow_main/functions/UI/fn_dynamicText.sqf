disableSerialization;

params ["_text",["_x",-1],["_y",-1],["_delay",4],["_fade",1],["_moveY",0],["_layer",[] call bis_fnc_rscLayer]];
_delay = 0 max _delay;
_fade = 0 max _fade;

//--- Width and Height
private _w = -1;
private _h = -1;
if (_x isEqualType []) then {
	_w = _x select 1;
	_x = _x select 0;
};
if (_y isEqualType []) then {
	_h = _y select 1;
	_y = _y select 0;
};

_layer cutRsc ["rscDynamicText","plain"];

private _display = uiNamespace getVariable "BIS_dynamicText";
private _control = _display displayCtrl 9999;
_control ctrlSetFade 1;
_control ctrlCommit 0;
private _pos = ctrlPosition _control;
if !(_x isEqualTo -1) then {_pos set [0,_x]};
if !(_y isEqualTo -1) then {_pos set [1,_y]};
if !(_w isEqualTo -1) then {_pos set [2,_w]};
if !(_h isEqualTo -1) then {_pos set [3,_h]};

if (isNil "OT_dynamicTextIdCounter") then {
	OT_dynamicTextIdCounter = 10000;
};

if (!isNull (_display displayCtrl OT_dynamicTextIdCounter)) then {
	ctrlDelete (_display displayCtrl OT_dynamicTextIdCounter);
};

OT_dynamicTextIdCounter = (OT_dynamicTextIdCounter + 1) % 11000;

_control = _display ctrlCreate [/*ctrlClassName _control*/ "OTRscDynamicText",OT_dynamicTextIdCounter];
_control ctrlSetPosition _pos;
if (_text isEqualType "") then {
	_control ctrlSetStructuredText parseText _text;
} else {
	_control ctrlSetStructuredText _text;
};
_control ctrlSetFade 1;
_control ctrlCommit 0;
_control ctrlSetFade 0;
_control ctrlCommit _fade;

[
	{
		disableSerialization;
		params ["_ctrl"];
		isNil "_ctrl" || {isNull _ctrl || ctrlCommitted _ctrl}
	},
	{
		disableSerialization;
		params ["_control","_delay","","_moveY"];

		if (isNil "_control" || {isNull _control}) exitWith {};

		private _pos = ctrlPosition _control;
		if !(_moveY isEqualTo 0) then {
			_pos set [1,(_pos select 1) + _moveY];
			_control ctrlSetPosition _pos;
			_control ctrlCommit _delay;
		} else {
			_this pushBack (time + _delay);
		};

		[
			{
				disableSerialization;
				params ["_control","","","","",["_delayDone", -1]];
				if (isNil "_control" || {isNull _control}) exitWith {true};
				if !(_delayDone isEqualTo -1) then {
					time >= _delayDone
				} else {
					ctrlCommitted _control
				};
			},
			{
				disableSerialization;
				params ["_control","","","","_layer"];
				if (isNil "_control" || {isNull _control}) exitWith {};

				_control ctrlSetFade 1;
				_control ctrlCommit 1;

				[
					{
						disableSerialization;
						params ["_control"];
						isNil "_control" || {isNull _control || ctrlCommitted _control}
					},
					{
						disableSerialization;
						params ["_control","","","","_layer"];
						if (isNil "_control" || {isNull _control}) exitWith {};
						_layer cutText ["","plain"];
					}
				] call CBA_fnc_waitUntilAndExecute;
			},
			_this
		] call CBA_fnc_waitUntilAndExecute;
	},
	[_control,_delay,_fade,_moveY,_layer]
] call CBA_fnc_waitUntilAndExecute;
