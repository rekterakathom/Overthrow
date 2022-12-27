private _cfg = configFile >> "CfgMagazines" >> _this;

if (isText(_cfg >> "descriptionShort")) then {
    getText(_cfg >> "descriptionShort")
}else{
    ""
}
