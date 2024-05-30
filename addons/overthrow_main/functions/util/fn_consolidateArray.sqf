/*
Author(s):
    ThomasAngel

Description:
    A replacement for BIS_fnc_consolidateArray because it is very slow.

Parameters:
    _this - ARRAY

Return:
    Ok: HASHMAP with unique elements as keys and their occurrence as values
    Err: Empty HASHMAP

Examples:
    _fruitMap = ["apple","apple","pear","pear","apple"] call OT_fnc_consolidateArray
    _fruitMap -> [["apple",3],["pear",2]]
    
    _fruitMap get "apple" -> 3
*/

if !(assert (_this isEqualType [])) exitWith {createHashMap};

private _resultMap = createHashMap;

{
	_resultMap set [
		_x, 
		(_resultMap getOrDefault [_x, 0]) + 1
	];
} forEach _this;

_resultMap
