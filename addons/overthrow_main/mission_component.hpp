/* Included at top of mission's description.ext for default Overthrow settings
 * #include "\overthrow_main\mission_component.hpp"
 *
 * Override values after if required
 */
#include "\overthrow_main\script_component.hpp"

author = QUOTE(MOD_AUTHOR);
OnLoadMission = QUOTE(VERSION_STR - Read the wiki at overthrow.fandom.com for more information);

onLoadMissionTime = 1;
allowSubordinatesTakeWeapons = 1;

joinUnassigned = 1;
briefing = 0;

class Header {
    gameType = "Coop";
    minPlayers = 1;
    maxPlayers = 32;
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
        title = "$STR_PARAMTERS_ENEMY_FACTION_TITLE";
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
        title = "$STR_PARAMTERS_START_AUTOLOAD";
        values[] = {0, 1};
        texts[] = {"$STR_STATISTICS_NO", "$STR_STATISTICS_YES"};
        default = 0;
    };
    class ot_start_difficulty {
        title = "$STR_PARAMTERS_START_DIFFICULTY";
        values[] = {0, 1, 2};
        texts[] = {"$STR_STATISTICS_EASY", "$STR_STATISTICS_NORMAL", "$STR_STATISTICS_HARD"};
        default = 1;
    };
    class ot_start_fasttravel {
        title = "$STR_PARAMTERS_START_FAST_TRAVEL";
        values[] = {0, 1, 2};
        texts[] = {"$STR_STATISTICS_FREE", "$STR_STATISTICS_COSTS", "$STR_STATISTICS_DISABLED"};
        default = 1;
    };
    class ot_start_fasttravelrules {
        title = "$STR_PARAMTERS_START_FAST_TRAVEL_RULES";
        values[] = {0, 1, 2};
        texts[] = {"$STR_STATISTICS_OPEN", "$STR_STATISTICS_NO_WEAPONS", "$STR_STATISTICS_RESTRICTED"};
        default = 1;
    };
    class ot_showplayermarkers {
        title = "$STR_PARAMTERS_SHOW_PLAYERS_MARKERS";
        values[] = {1, 0};
        texts[] = {"$STR_STATISTICS_YES", "$STR_STATISTICS_NO"};
        default = 1;
    };
    class ot_showenemygroup {
        title = "$STR_PARAMTERS_SHOW_ENEMY_MARKERS";
        values[] = {1, 0};
        texts[] = {"$STR_STATISTICS_YES", "$STR_STATISTICS_NO"};
        default = 1;
    };
    class ot_randomizeloadouts {
        title = "$STR_PARAMTERS_RANDOM_NATO_GEAR";
        values[] = {1, 0};
        texts[] = {"$STR_STATISTICS_YES", "$STR_STATISTICS_NO"};
        default = 0;
    };
    class ot_gangmembercap {
        title = "$STR_PARAMTERS_GANG_MAX_SIZE";
        texts[] = {"10", "15", "20", "25", "30"};
        values[] = {10, 15, 20, 25, 30};
        default = 15;
    };
    class ot_gangresourcecap {
        title = "$STR_PARAMTERS_GANG_MAX_RESOURCE";
        texts[] = {"$STR_STATISTICS_LOW", "$STR_STATISTICS_MEDIUM", "$STR_STATISTICS_HIGH", "$STR_STATISTICS_VERY_HIGH"};
        values[] = {300, 600, 900, 1500};
        default = 600;
    };
    class ot_factoryproductionmulti {
        title = "$STR_PARAMTERS_FACTORY_MULTI";
        texts[] = {"$STR_STATISTICS_SPEED1", "$STR_STATISTICS_SPEED2", "$STR_STATISTICS_SPEED3", "$STR_STATISTICS_SPEED4", "$STR_STATISTICS_SPEED5", "$STR_STATISTICS_SPEED6", "$STR_STATISTICS_SPEED7", "$STR_STATISTICS_SPEED8", "$STR_STATISTICS_SPEED9", "$STR_STATISTICS_SPEED10"};
        values[] = {100, 150, 200, 250, 300, 350, 400, 450, 500, 1000};
        default = 100;
    };
    class ace_medical_level {
        title = "$STR_PARAMTERS_ACE_MEDICAL_LEVEL";
        ACE_setting = 1;
        values[] = {1, 2};
        texts[] = {"$STR_STATISTICS_BASIC", "$STR_STATISTICS_ADVANCED"};
        default = 1;
    };
    class ace_medical_blood_enabledFor {
        title = "$STR_PARAMTERS_ACE_BLOOD";
        ACE_setting = 1;
        values[] = {0, 1, 2};
        texts[] = {"$STR_STATISTICS_NONE", "$STR_STATISTICS_PLAYERS_ONLY", "$STR_STATISTICS_ALL"};
        default = 1;
    };
};

// ZEN integration
// This will do nothing if ZEN is loaded
class zen_context_menu_actions {
    class ot_setmoney {
        displayName = "$STR_STATISTICS_OVERTHROW_SET_MONEY";
        icon = "\overthrow_main\ui\markers\shop-General.paa";
        statement = "[_hoveredEntity] call OT_fnc_zenSetMoney";
        condition = "_hoveredEntity isKindOf 'CAManBase' && { isPlayer _hoveredEntity }";
        priority = 50;
    };
};
