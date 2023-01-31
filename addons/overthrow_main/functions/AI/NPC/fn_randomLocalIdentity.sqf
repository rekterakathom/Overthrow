//Generates a civilian identity [face, clothes, name]
private _glasses = "";
if((random 100) < 35) then {_glasses = selectRandom OT_allGlasses};
[
	selectRandom OT_faces_local,
	selectRandom OT_clothes_locals,
	[floor random count OT_firstNames_local, floor random count OT_lastNames_local],
	_glasses
]
