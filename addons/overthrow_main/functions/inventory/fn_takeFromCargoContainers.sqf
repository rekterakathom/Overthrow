params ["_input","_num","_pos"];
if(_num isEqualTo 0) exitWith {true};
if(_num < 1) then {_num = 1};
_gotit = false;
{
   _c = _x;
   {
       _x params ["_cls","_amt"];
       if(_cls == _input && _amt >= _num) exitWith {
           [_c, _cls, _num] call CBA_fnc_removeItemCargo;
           _gotit = true;
       };
   }forEach(_c call OT_fnc_unitStock);
}forEach(_pos nearObjects [OT_item_CargoContainer, 50]);
_gotit
