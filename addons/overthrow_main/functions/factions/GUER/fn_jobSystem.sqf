
OT_allJobs = [];
{
    private _code = getText (_x >> "condition");
    private _target = getText (_x >> "target");
    private _script = getText (_x >> "script");
    private _repeat = getNumber (_x >> "repeatable");
    private _chance = getNumber (_x >> "chance");
    private _expires = getNumber (_x >> "expires");
    private _requestable = (getNumber (_x >> "requestable")) isEqualTo 1;

    OT_allJobs pushBack [configName _x, _target, compileFinal _code, compileScript [_script, true], _repeat, _chance, _expires, _requestable];
}forEach("true" configClasses ( configFile >> "CfgOverthrowMissions" ));
if(isServer) then {
	job_system_counter = 12;
	["job_system","_counter%10 isEqualTo 0","call OT_fnc_jobLoop"] call OT_fnc_addActionLoop;
};
