
/*
	Author: BIS, modified by Genesis

	Description:
		Check if string is vehicle class

	Parameter(s):
		0: STRING - String to check

	Returns:
		STRING
*/

params ["_name"];
private _return = "NotAClass";

if (_name isEqualType "") then
{
  _return = (configFile >> "cfgVehicles" >> _name);
};

_return 