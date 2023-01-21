params ["_mortar","_mortargroup"];

while {sleep 5+(random 5); ("8Rnd_82mm_Mo_shells" in getArtilleryAmmo[_mortar]) && (alive _mortar) && ((units _mortargroup) findIf {alive _x} != -1)} do {
    private _attacking = server getVariable ["NATOattacking",""];
    private _mortarpos = position _mortar;

    if(_attacking != "" && !(_attacking in OT_allTowns)) then {
        _pos = server getvariable _attacking;
        _distance = (_pos distance _mortar);

        _timesince = time - (server getVariable ["NATOattackstart",time]);
        if(_timesince < 300) then {
            if (_distance < 4000 && _distance > 500) then {
                _mortargroup setCombatMode "RED";
                _p = [_pos,150,random 360] call SHK_pos_fnc_pos;
                _mortar commandArtilleryFire [_p, "8Rnd_82mm_Mo_shells", 1];
                sleep 3+(random 3);
                _mortar commandArtilleryFire [_p, "8Rnd_82mm_Mo_shells", 1];
                sleep 3;
                _mortargroup setCombatMode "BLUE";
                //Did anyone hear that?
                if((_mortarpos nearEntities ["CAManBase",3000]) findIf {side _x isEqualTo resistance || captive _x} != -1) then {
                    private _icons = spawner getVariable ["NATOmortars",[]];
                    _found = false;
                    {
                        if((_x select 0) isEqualTo _mortarpos) exitWith {
                            _range = (_x select 1) - round((_x select 1) * 0.25);
                            _x set [1,_range];
                            _x set [2,[_mortarpos,_range,random 360] call SHK_pos_fnc_pos];
                        };
                    }foreach(_icons);
                    if !(_found) then {
                        _icons pushback [_mortarpos,1500,[_mortarpos,1500,random 360] call SHK_pos_fnc_pos];
                    };
                    spawner setVariable ["NATOmortars",_icons,true];
                };
            };
        };
    }else{
        private _targets = [spawner getVariable ["NATOknownTargets",[]],[],{_x select 2},"DESCEND"] call BIS_fnc_SortBy;
        {
            _x params ["_ty","_pos","_pri","_obj","_done"];
            _distance = (_pos distance _mortar);
            _town = _pos call OT_fnc_nearestTown;
            _towndist = _pos distance (server getvariable [_town,_pos]); //make sure we dont shell towns
            if (!(_ty == "H" || _ty == "P" || _ty == "V") && _pri > 80 && _towndist > 600 && _distance < 4000 && _distance > 250 && !_done) exitWith {
                _x set [4,true];
                _mortargroup setCombatMode "RED";

                _mortar commandArtilleryFire [_pos, "8Rnd_82mm_Mo_shells", 1];
                sleep 3+(random 3);
                _mortar commandArtilleryFire [_pos, "8Rnd_82mm_Mo_shells", 1];
                sleep 3+(random 3);
                _mortar commandArtilleryFire [_pos, "8Rnd_82mm_Mo_shells", 1];
                sleep 3;
                _mortargroup setCombatMode "BLUE";
                //Did anyone hear that?
                if((_mortarpos nearEntities ["CAManBase",3000]) findIf {side _x isEqualTo resistance || captive _x} != -1) then {
                    private _icons = spawner getVariable ["NATOmortars",[]];
                    _found = false;
                    {
                        if((_x select 0) isEqualTo _mortarpos) exitWith {
                            _range = (_x select 1) - round((_x select 1) * 0.25);
                            _x set [1,_range];
                            _x set [2,[_mortarpos,_range,random 360] call SHK_pos_fnc_pos];
                        };
                    }foreach(_icons);
                    if !(_found) then {
                        _icons pushback [_mortarpos,1500,[_mortarpos,1500,random 360] call SHK_pos_fnc_pos];
                    };
                    spawner setVariable ["NATOmortars",_icons,true];
                };
            };
        }foreach(_targets);
        spawner setVariable ["NATOknowntargets",_targets,true];
    };
};
