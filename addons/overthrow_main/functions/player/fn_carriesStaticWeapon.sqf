{
	if(typeOf _x in OT_staticWeapons) exitWith {
		true
	};
	false
}forEach(attachedObjects _this)