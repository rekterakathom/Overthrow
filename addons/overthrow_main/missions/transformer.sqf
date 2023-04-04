params ["_jobid","_jobparams"];
_jobparams params ["_destinationName"];

private _destination = server getVariable [_destinationName,[]];

// Shut down all the lights in the town
private _lamps = nearestObjects [_destination, ["Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F"], 500];
{_x switchLight "OFF"} forEach _lamps;

private _params = [_destination,_destinationName];
private _markerPos = _destination;

private _effect = "Stability in the town will decrease and the local community will support the resistance more (+25 support).";
if(_destinationName in (server getVariable ["NATOabandoned",[]])) then {
    _effect = "Stability in the town will increase and the local community will support the resistance more (+25 support).";
};

//Build a mission description and title
private _description = format["A transformer in %1 has broken down and they are without electricity. Donate 4000$ to the mayor so they can get a new one. <br/><br/>%2", _destinationName, _effect];
private _title = format["%1 needs electricity", _destinationName];

// Set variables
private _paidVariable = _destinationName + "transformerpaid";
server setVariable [_paidVariable, false];

//The data below is what is returned to the gun dealer/faction rep, _markerPos is where to put the mission marker, the code in {} brackets is the actual mission code, only run if the player accepts
[
    [_title,_description],
    _markerPos,
    {
        //No setup required for this mission
        true
    },
    {
        //Fail check...
        false
    },
    {
        //Success Check
        params ["_destination","_destinationName"];
        private _paidVariable = _destinationName + "transformerpaid";
        server getVariable [_paidVariable, false]
    },
    {
        params ["_destination","_destinationName","_wassuccess"];

        //If mission was a success
        // Restore power
        private _lamps = nearestObjects [_destination, ["Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F"], 500];
        {_x switchLight "AUTO"} forEach _lamps;

        if(_wassuccess) then {
            //apply stability and support
            [
                _destinationName,
                25,
                format["Donated 4000$ to %1", _destinationName]
            ] call OT_fnc_support;

            if(_destinationName in (server getVariable ["NATOabandoned",[]])) then {
                [_destinationName,10] call OT_fnc_stability;
            }else{
                [_destinationName,-10] call OT_fnc_stability;
            };
        };
    },
    _params
];
