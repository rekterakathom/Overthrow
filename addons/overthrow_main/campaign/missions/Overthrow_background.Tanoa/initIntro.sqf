//mainCamera switchCamera "GUNNER";

setViewDistance 250;
disableRemoteSensors true;

[1, "BLACK", 5, 0, "", "", 1] spawn BIS_fnc_fadeEffect;

playMusic "OM_Music01";

police_01 disableAI "ALL";
police_01 enableAI "ANIM";


police_02 disableAI "RADIOPROTOCOL";
police_03 disableAI "RADIOPROTOCOL";
police_04 disableAI "RADIOPROTOCOL";

[] spawn {

	private _radioArray = [
		"a3\music_f_oldman\music\radio\news\news_rebels_attack_lugganville.ogg",
		"a3\music_f_oldman\music\radio\news\news_gendarme_raid_oumere.ogg",
		"a3\music_f_oldman\music\radio\news\news_checkpoints.ogg",
		"a3\music_f_oldman\music\radio\news\news_arrest.ogg",
		"a3\music_f_oldman\music\radio\news\news_house_destroyed.ogg",
		"a3\music_f_oldman\music\radio\news\news_execution.ogg",
		"a3\music_f_oldman\music\radio\news\news_weapons_prohibited.ogg"
	];

	sleep 5;

	while {true} do {
		if (isGameFocused) then {
			private _soundToPlay = selectRandom _radioArray;
			playSound3D [_soundToPlay, radioSpeaker, false, getPosASL radioSpeaker, 0.7, 1, 0, 0, true];
		};
		uiSleep 60;
	};
};