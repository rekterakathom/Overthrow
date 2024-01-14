/* Included at top of mission's description.ext for default Overthrow settings
 * #include "\overthrow_main\mission_component.hpp"
 *
 * Override values after if required
 */
#include "\overthrow_main\script_component.hpp"

author=QUOTE(MOD_AUTHOR);
OnLoadMission=QUOTE(VERSION - Read the wiki at overthrow.fandom.com for more information);

onLoadMissionTime = 1;
allowSubordinatesTakeWeapons = 1;

joinUnassigned = 1;
briefing = 0;

class Header
{
	gameType = "Coop";
	minPlayers = 1;
	maxPlayers = 12;
};

allowFunctionsLog = 0;
enableDebugConsole = 1;

respawn = "BASE";
respawnDelay = 5;
respawnVehicleDelay = 120;
respawnDialog = 0;
aiKills = 0;
disabledAI = 1;
saving = 0;
showCompass = 1;
showRadio = 1;
showGPS = 1;
showMap = 1;
showBinocular = 1;
showNotepad = 1;
showWatch = 1;
debriefing = 0;
allowProfileGlasses = 0;

//Disable ACE blood (just too much of it in a heavy game)
class Params {
	class ot_enemy_faction {
		title = "Occupying faction";
		texts[] = {
			"0. Map default",
			"1. Vanilla NATO",
			"2. Vanilla NATO pacific",
			"3. Vanilla NATO woodland",
			"4. RHS US Army Woodland",
			"5. RHS US Army Desert",
			"6. RHS USMC Woodland",
			"7. RHS USMC Desert",
			"8. RHS Horizon Islands Defence Force",
			"9. 3CB AAF",
			"10. 3CB Livonian Defence Force",
			"11. 3CB Livonia Separatist Militia",
			"12. 3CB Malden Defence Force",
			"13. 3CB Middle East Insurgents"
		};
		values[] = {
			0, // Map default
			1, // Vanilla NATO
			2, // Vanilla NATO pacific
			3, // Vanilla NATO woodland
			4, // RHS US Army Woodland
			5, // RHS US Army Desert
			6, // RHS USMC Woodland
			7, // RHS USMC Desert
			8, // RHS Horizon Islands Defence Force
			9, // 3CB AAF
			10, // 3CB Livonian Defence Force
			11, // 3CB Livonia Separatist Militia
			12, // 3CB Malden Defence Force
			13 // 3CB Middle East Insurgents
		};
		default = 0;
	};
	class ot_start_autoload {
		title = "Autoload a save or start a new game";
		values[] = {0, 1};
		texts[] = {"No", "Yes"};
		default = 0;
	};
	class ot_start_difficulty {
		title = "Game difficulty (Only with autoload)";
		values[] = {0, 1, 2};
		texts[] = {"Easy", "Normal", "Hard"};
		default = 1;
	};
	class ot_start_fasttravel {
		title = "Fast Travel (Only with autoload)";
		values[] = {0, 1, 2};
		texts[] = {"Free", "Costs", "Disabled"};
		default = 1;
	};
	class ot_start_fasttravelrules {
		title = "Fast Travel Rules (Only with autoload)";
		values[] = {0, 1, 2};
		texts[] = {"Open", "No Weapons", "Restricted"};
		default = 1;
	};
	class ot_showplayermarkers {
		title = "Show Player Markers on HUD";
		values[] = {1,0};
		texts[] = {"Yes", "No"};
		default = 1;
	};
	class ot_showenemygroup {
		title = "Show known enemy groups on map";
		values[] = {1,0};
		texts[] = {"Yes", "No"};
		default = 1;
	};
	class ot_randomizeloadouts {
		title = "Randomize NATO loadouts";
		values[] = {1,0};
		texts[] = {"Yes", "No"};
		default = 0;
	};
	class ot_gangmembercap {
		title = "Gang Maximum Size";
		texts[] = {"10", "15", "20", "25", "30"};
		values[] = {10, 15, 20, 25, 30};
		default = 15;
	};
	class ot_gangresourcecap {
		title = "Gang Maximum Resources";
		texts[] = {"Low", "Medium", "High", "Very High"};
		values[] = {300, 600, 900, 1500};
		default = 600;
	};
	class ot_factoryproductionmulti {
		title = "Factory Production Multiplier";
		texts[] = {"100% Speed", "150% Speed", "200% Speed", "250% Speed", "300% Speed", "350% Speed", "400% Speed", "450% Speed", "500% Speed", "1000% Speed"};
		values[] = {100, 150, 200, 250, 300, 350, 400, 450, 500, 1000};
		default = 100;
	};
	class ace_medical_level {
        title = "ACE Medical Level";
        ACE_setting = 1;
        values[] = {1, 2};
        texts[] = {"Basic", "Advanced"};
        default = 1;
    };
    class ace_medical_blood_enabledFor {
        title = "ACE Blood";
        ACE_setting = 1;
        values[] = {0, 1, 2};
        texts[] = {"None", "Players Only", "All"};
        default = 1;
    };
};
