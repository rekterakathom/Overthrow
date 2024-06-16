#include "script_component.hpp"
#include "headers\config_macros.hpp"

class CfgPatches
{
	class OT_Overthrow_Main
	{
		author=QUOTE(MOD_AUTHOR);
		name=QUOTE(MOD_NAME - VERSION);
		url="https://steamcommunity.com/sharedfiles/filedetails/?id=774201744";
		requiredAddons[]=
		{
			"cba_ui",
            "cba_xeh",
            "cba_jr",
			"ace_main",
			"ace_medical",
			"a3_ui_f",
			"a3_characters_f",
			"A3_Ui_F_Orange",
			"A3_Ui_F_Tacops",
			"A3_Ui_F_Tank",
			"A3_Ui_F_Enoch",
			"A3_Ui_F_Oldman",
			"A3_Ui_F_AoW",
			"A3_Map_Tanoabuka",
			"A3_Map_Tanoa_Scenes_F"
		};
		requiredVersion=REQUIRED_VERSION;
        VERSION_CONFIG;
		units[] = {
			"OT_GanjaItem",
			"OT_BlowItem",
			"OT_I_Truck_recovery",
			"B_Gen_Soldier_Heavy_F",
			"B_Gen_Commander_Heavy_F",
			"B_Gen_Medic_Heavy_F",
			"B_W_Recon_Exp_F",
			"B_W_Recon_JTAC_F",
			"B_W_Recon_M_F",
			"B_W_Recon_Medic_F",
			"B_W_Recon_LAT_F",
			"B_W_Recon_TL_F",
			"OT_Flag_Malden_F"
		};
		weapons[] = {
			"OT_Ganja",
			"OT_Blow",
			"OT_Wood",
			"OT_Lumber",
			"OT_Steel",
			"OT_Plastic",
			"OT_Sugarcane",
			"OT_Sugar",
			"OT_Grapes",
			"OT_Wine",
			"OT_Olives",
			"OT_Fertilizer",
			"OT_ammo50cal"
		};
	};
};

class CfgMainMenuSpotlight
{
	class Overthrow
	{
		text = "Overthrow"; // Text displayed on the square button, converted to upper-case
		textIsQuote = 1; // 1 to add quotation marks around the text
		picture = "\overthrow_main\campaign\overthrow_spotlight.jpg"; // Square picture, ideally 512x512
		video = "\a3\Ui_f\Video\spotlight_1_Apex.ogv"; // Video played on mouse hover
		// First activate "multiplayer" control in main display, then activate "host server" control in "multiplayer" display
		action = "ctrlactivate ((ctrlparent (_this select 0)) displayctrl 105); ctrlactivate (findDisplay 8 displayctrl 167);";
		actionText = "$STR_A3_RscDisplayMain_Spotlight_Play"; // Text displayed in top left corner of on-hover white frame
		condition = "true"; // Condition for showing the spotlight
	};
	class AoW_Showcase_Future
	{
		condition = "false";
	};
	class AoW_Showcase_AoW: AoW_Showcase_Future
	{
		condition = "false";
	};
	class ApexProtocol
	{
		condition = "false";
	};
	class Bootcamp
	{
		condition = "false";
	};
	class Orange_Campaign
	{
		condition = "false";
	};
	class Orange_CampaignGerman: Orange_Campaign
	{
		condition = "false";
	};
	class Orange_Showcase_IDAP
	{
		condition = "false";
	};
	class Orange_Showcase_LoW
	{
		condition = "false";
	};
	class Showcase_TankDestroyers
	{
		condition = "false";
	};
	class Tacops_Campaign_01
	{
		condition = "false";
	};
	class Tacops_Campaign_02: Tacops_Campaign_01
	{
		condition = "false";
	};
	class Tacops_Campaign_03: Tacops_Campaign_01
	{
		condition = "false";
	};
	class Tanks_Campaign_01
	{
		condition = "false";
	};
	class OldMan 
	{
		condition = "false";
	};
	class SP_FD14 
	{
		condition = "false";
	};
	class Contact_Campaign
	{
		condition = "false";
	};
};

class CfgMissions
{
	class MPMissions
	{
		class OverthrowMpTanoa
		{
			directory="overthrow_main\campaign\missions\OverthrowMpTanoa.Tanoa";
		};
		class OverthrowMpAltis
		{
			directory="overthrow_main\campaign\missions\OverthrowMpAltis.Altis";
		};
		class OverthrowMpMalden
		{
			directory="overthrow_main\campaign\missions\OverthrowMpMalden.Malden";
		};
		class OverthrowMpLivonia
		{
			directory="overthrow_main\campaign\missions\OverthrowMpLivonia.Enoch";
		};
	};
	class Cutscenes
	{
		class OT_Tanoa_intro1
		{
			directory="overthrow_main\campaign\missions\Overthrow_background.Tanoa";
		};
	};
};

class CfgWorlds
{
	class CAWorld;
	class Tanoa : CAWorld
	{
		cutscenes[] = { "OT_Tanoa_intro1" };
		class Names
		{
			class RailwayDepot01 {
				name = "factory";
			};
		};
	};
	initWorld = "Tanoa";
	demoWorld = "Tanoa";
};


class ACE_Tags {
	class OT_goHomeBlack {
		displayName = "NATO Go Home";
		requiredItem = "ACE_SpraypaintBlack";
		textures[] = {"\overthrow_main\ui\tags\gohome.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingBlack.paa";
	};
	class OT_goHomeRed {
		displayName = "NATO Go Home";
		requiredItem = "ACE_SpraypaintRed";
		textures[] = {"\overthrow_main\ui\tags\gohomered.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingRed.paa";
	};
	class OT_goHomeGreen {
		displayName = "NATO Go Home";
		requiredItem = "ACE_SpraypaintGreen";
		textures[] = {"\overthrow_main\ui\tags\gohomegreen.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingGreen.paa";
	};
	class OT_goHomeBlue {
		displayName = "NATO Go Home";
		requiredItem = "ACE_SpraypaintBlue";
		textures[] = {"\overthrow_main\ui\tags\gohomeblue.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingBlue.paa";
	};
	class OT_overthrowBlack {
		displayName = "Overthrow";
		requiredItem = "ACE_SpraypaintBlack";
		textures[] = {"\overthrow_main\ui\tags\overthrow.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingBlack.paa";
	};
	class OT_overthrowRed {
		displayName = "Overthrow";
		requiredItem = "ACE_SpraypaintRed";
		textures[] = {"\overthrow_main\ui\tags\overthrowred.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingRed.paa";
	};
	class OT_overthrowGreen {
		displayName = "Overthrow";
		requiredItem = "ACE_SpraypaintGreen";
		textures[] = {"\overthrow_main\ui\tags\overthrowgreen.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingGreen.paa";
	};
	class OT_overthrowBlue {
		displayName = "Overthrow";
		requiredItem = "ACE_SpraypaintBlue";
		textures[] = {"\overthrow_main\ui\tags\overthrowblue.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingBlue.paa";
	};
	class OT_fuckNATOBlack {
		displayName = "Fuck NATO";
		requiredItem = "ACE_SpraypaintBlack";
		textures[] = {"\overthrow_main\ui\tags\fucknato.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingBlack.paa";
	};
	class OT_fuckNATORed {
		displayName = "Fuck NATO";
		requiredItem = "ACE_SpraypaintRed";
		textures[] = {"\overthrow_main\ui\tags\fucknatored.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingRed.paa";
	};
	class OT_fuckNATOGreen {
		displayName = "Fuck NATO";
		requiredItem = "ACE_SpraypaintGreen";
		textures[] = {"\overthrow_main\ui\tags\fucknatogreen.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingGreen.paa";
	};
	class OT_fuckNATOBlue {
		displayName = "Fuck NATO";
		requiredItem = "ACE_SpraypaintBlue";
		textures[] = {"\overthrow_main\ui\tags\fucknatoblue.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingBlue.paa";
	};
	class OT_joinBlack {
		displayName = "Join";
		requiredItem = "ACE_SpraypaintBlack";
		textures[] = {"\overthrow_main\ui\tags\join.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingBlack.paa";
	};
	class OT_joinRed {
		displayName = "Join";
		requiredItem = "ACE_SpraypaintRed";
		textures[] = {"\overthrow_main\ui\tags\joinred.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingRed.paa";
	};
	class OT_joinGreen {
		displayName = "Join";
		requiredItem = "ACE_SpraypaintGreen";
		textures[] = {"\overthrow_main\ui\tags\joingreen.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingGreen.paa";
	};
	class OT_joinBlue {
		displayName = "Join";
		requiredItem = "ACE_SpraypaintBlue";
		textures[] = {"\overthrow_main\ui\tags\joinblue.paa"};
		icon = "\z\ace\addons\tagging\UI\icons\iconTaggingBlue.paa";
	};
};

#include "CfgMarkers.hpp"
#include "CfgGlasses.hpp"
#include "CfgSounds.hpp"
#include "CfgSettings.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
#include "CfgFunctions.hpp"
#include "CfgMagazines.hpp"
#include "CfgGroups.hpp"
#include "missions\CfgOverthrowMissions.hpp"

#include "ui\dialogs\defines.hpp"
#include "ui\dialogs\stats.hpp"
#include "ui\dialogs\shop.hpp"
#include "ui\dialogs\sleep.hpp"
#include "ui\dialogs\main.hpp"
#include "ui\dialogs\place.hpp"
#include "ui\dialogs\build.hpp"
#include "ui\dialogs\recruits.hpp"
#include "ui\dialogs\resistance.hpp"
#include "ui\dialogs\factory.hpp"
#include "ui\overrides.hpp"
