class CfgFunctions
{
	class OT
	{
		class Base
		{
			file = "\overthrow_main\functions";
			class initVar {};
			class initOverthrow {};
			class initBaseVar {};
		};

        class Cleanup
		{
			file = "\overthrow_main\functions\cleanup";
			class cleanup {};
			class cleanupEmptyGroup {};
			class cleanupUnit {};
			class cleanupVehicle {};
			class cleanDead {};
		};

		class Factions
		{
			file = "\overthrow_main\functions\factions";
			class factionNATO {};
			class factionGUER {};
			class factionCIV {};
			class factionCRIM {};
			class unitSeen {};
			class unitSeenNATO {};
			class unitSeenCRIM {};
			class unitSeenCIV {};
			class unitSeenPlayer {};
			class unitSeenAny {};
			class revealToNATO {};
			class revealToCRIM {};
			class revealToResistance {};
		};

		/* Persistent Save */
		class Save
		{
			file = "\overthrow_main\functions\save";
			class saveGame {};
			class loadGame {};
			class setOfflinePlayerAttribute {};
			class getOfflinePlayerAttribute {};
			class loadPlayerData {};
			class savePlayerData {};
			class autoSaveToggle {};
			class autoloadToggle {};
		};

		class sleep
		{
			file = "\overthrow_main\functions\sleep";
			class startSleeping {};
		};

		class admin
		{
			file = "\overthrow_main\functions\admin";
			class toggleZeus {};
		};

		class Loop
		{
			file = "\overthrow_main\functions\loop";
			class initActionLoop {};
			class addActionLoop {};
			class removeActionLoop {};
		};

		class Player
		{
			file = "\overthrow_main\functions\player";
			class initPlayerLocal {};
			class mapSystem {};
			class mapHandler {};
			class notificationLoop {};
			class townCheckLoop {};
			class perkSystem {};
			class setupPlayer {};
			class statsSystem {};
			class statsSystemLoop {};
			class wantedSystem {};
			class wantedLoop {};
			class unconsciousNoHelpPossible {};
			class playerIsOwner {};
			class playerIsGeneral {};
			class playerIsAtWarehouse {};
			class playerIsAtHardwareStore {};
			class playerIsAtStore {};
			class tutorial {};
			class influence {};
			class influenceSilent {};
			class rewardMoney {};
			class money {};
			class getPlayerHome {};
			class generalIsOnline {};
			class doConversation {};
			class givePlayerWaypoint {};
			class clearPlayerWaypoint {};
			class hasWeaponEquipped {};
			class carriesStaticWeapon {};
			class illegalInCar {};
			class detectedByReputation {};
			class detectedByReputationNATO {};
			class gangRep {};
		};

		class Interaction
		{
			file = "\overthrow_main\functions\interaction";
			class mountAttached {};
			class initAttached {};
			class updateAttached {};
			class initObjectLocal {};
			class initStaticMGLocal {};
		};

		class Events
		{
			file = "\overthrow_main\functions\events";
			class deathHandler {};
			class buildingDamagedHandler {};
			class cargoLoadedHandler {};
			class explosivesPlacedHandler {};
			class playerConnectHandler {};
			class playerDisconnectHandler {};
			class refuelHandler {};
			class respawnHandler {};
			class keyHandler {};
			class taggedHandler {};
			class EnemyDamagedHandler {};
			class QRFStartHandler {};
			class QRFEndHandler {};
			class wheelStateHandler {};
			class healedHandler {};
		};

		class UI
		{
			file = "\overthrow_main\functions\UI";
			class notifyMinor {};
			class notifyBig {};
			class notifyGood {};
			class notifyBad {};
			class notifySilent {};
			class notifyVehicle {};
			class playerDecision {};
			class choiceMade {};
			class notifyStart {};
			class progressBar {};
			class getAssignedKey {};
			class formatTime {};
			class notifyAndLog {};
			class dynamicText {};
			class topMessage {};
			class dialogFadeIn {};
		};

		class Dialogs
		{
			file = "\overthrow_main\functions\UI\dialogs";

			class mainMenu {};
			class buyDialog {};
			class sellDialog {};
			class buyDialogVehicle {};
			class sellDialogVehicle {};
			class workshopDialog {};
			class policeDialog {};
			class warehouseDialog {};
			class inputDialog {};
			class importDialog {};
			class recruitDialog {};
			class buyClothesDialog {};
			class buyVehicleDialog {};
			class gunDealerDialog {};
			class factoryDialog {};
			class garrisonDialog {};
			class newGameDialog {};
			class optionsDialog {};
			class resistanceDialog {};
			class reverseEngineerDialog {};
			class vehicleDialog {};
			class mapInfoDialog {};
			class characterSheetDialog {};
			class manageRecruitsDialog {};
			class loadoutDialog {};
			class buyHardwareDialog {};
			class sellHardwareDialog {};
			class jobsDialog {};
			class craftDialog {};
			class uploadData {};
			class logisticsDialog {};
		};

		class Display
		{
			file = "\overthrow_main\functions\UI\display";
			class displayShopPic {};
			class displayWarehousePic {};
			class showMemberInfo {};
			class showBusinessInfo {};
			class displayJobDetails {};
			class displayCraftItem {};
			class factoryRefresh {};
			class displayLogisticDetails {};
		};

		/*
		* User actions
		*/
		class Actions
		{
			file = "\overthrow_main\functions\actions";

			class newGame {};

			/* Main Menu */
			class salvageWreck {};
			class buyBuilding {};
			class buyBusiness {};
			class manageArea {};
			class fastTravel {};
			class talkToCiv {};
			class recruitCiv {};
			class recruitSpawnCiv {};
			class leaseBuilding {};
			class place {};
			class onNameDone {};
			class onNameKeyDown {};
			class setHome {};
			class build {};

			/* Options */
			class increaseTax {};
			class decreaseTax {};

			/* Vehicle */
			class transferTo {};
			class transferFrom {};
			class transferHelper {};
			class transferLegit {};
			class takeLegit {};
			class warehouseTake {};
			class recover {};
			class storeAll {};

			/* Port */
			class exportAll {};
			class import {};

			/* Workshop */
			class workshopAdd {};

			/* Shop */
			class buy {};
			class sell {};
			class sellAll {};

			/* Factory */
			class factoryQueueAdd {};
			class factoryQueueRemove {};
			class factoryQueueRemoveAll {};

			/* Resistance Screen */
			class makeGeneral {};
			class giveFunds {};
			class takeFunds {};
			class transferFunds {};
			class hireEmployee {};
			class fireEmployee {};
			class setVehicleWaypoint {};

			/* Jobs */
			class setJobWaypoint {};
			class requestJobResistance {};
			class requestJobGang {};
			class requestJobShop {};
			class requestJobFaction {};

			/* Safe */
			class safePutMoney {};
			class safeTakeMoney {};
			class safeSetPassword {};

			/* Ammobox */
			class removeLoadout {};
			class restoreLoadout {};
			class saveLoadout {};
			class dumpStuff {};
			class dumpIntoWarehouse {};
			class takeStuff {};
			class openArsenal {};

			/* Other */
			class craft {};
			class recruitSoldier {};
			class recruitSquad {};
			class editLoadout {};
			class editPoliceLoadout {};
			class addGarrison {};
			class addPolice {};
			class lockVehicle {};
			class reverseEngineer {};
			class playSound {};
            class canPlace {};
			class vehicleCanMove {};
			class unflipVehicle {};
			class triggerBattle {};
			class donateTransformer {};

		};

		class SelfActions
    	{
        	file = "\overthrow_main\functions\actions\self";
			/* Spliffs */
			class startSpliff {};
			class stopSpliff {};
			class smokeAnimation {};
			class smokePuffs {};
		};

		/*
		* Locations, positions etc.
		*/
		class Geography
		{
			file = "\overthrow_main\functions\geography";
			class getRandomBuilding {};
			class nearestBase {};
			class nearestCheckpoint {};
			class nearestComms {};
			class nearestLocation {};
			class nearestMobster {};
			class nearestObjective {};
			class nearestObjectiveNoComms {};
			class nearestPositionRegion {};
			class nearestTown {};
			class getRegion {};
			class townsInRegion {};
			class regionIsConnected {};
			class getAO {};
			class getBuildId {};
			class weatherSystem {};
			class getRandomRoadPosition {};
			class isRadarInRange {};
			class positionIsAtWarehouse {};
			class nearestWarehouse {};
		};

		/*
		* The spawner
		*/
		class Virtualization
		{
			file = "\overthrow_main\functions\virtualization";
			class initVirtualization {};
			class runVirtualization {};
			class spawn {};
			class despawn {};
			class inSpawnDistance {};
			class registerSpawner {};
			class deregisterSpawner {};
			class updateSpawnerPosition {};
			class resetSpawn {};
		};

		class Spawners
		{
			file = "\overthrow_main\functions\virtualization\spawners";

			class spawnAmbientVehicles {};
			class spawnBoatDealers {};
			class spawnBusinessEmployees {};
			class spawnCarDealers {};
			class spawnCivilians {};
			class spawnFactionRep {};
			class spawnGendarmerie {};
			class spawnGunDealer {};
			class spawnNATOCheckpoint {};
			class spawnNATOObjective {};
			class spawnPolice {};
			class spawnShops {};
			class spawnStabilityObjects {};
		};

		/*
		* The economy, trade and real estate
		*/
		class Economy
		{
			file = "\overthrow_main\functions\economy";
			class initEconomy {};
			class initEconomyLoad {};
			class setupTownEconomy {};
			class support {};
			class getPrice {};
			class getSellPrice {};
			class getDrugPrice {};
			class nearestRealEstate {};
			class getRealEstateData {};
			class getBusinessData {};
			class getBusinessPrice {};
			class getTaxIncome {};
			class resistanceFunds {};
			class incomeSystem {};
			class propagandaSystem {};
			class stability {};
			class getControlledPopulation {};
		};

		/*
		* Inventory transfer and manegement
		*/
		class Inventory
		{
			file = "\overthrow_main\functions\inventory";
			class takeFromCargoContainers {};
			class hasFromCargoContainers {};
			class getClassDisplayName {};
			class getClassDisplayInfo {};
			class weaponGetName {};
			class vehicleGetName {};
			class vehicleGetPic {};
			class getSearchStock {};
		};

		/*
		* The warehouse
		*/
		class Warehouse
		{
			file = "\overthrow_main\functions\warehouse";
			class addToWarehouse {};
			class removeFromWarehouse {};
			class findHelmetInWarehouse {};
			class findScopeInWarehouse {};
			class findWeaponInWarehouse {};
			class findVestInWarehouse {};
			class verifyFromWarehouse {};
			class verifyLoadoutFromWarehouse {};
			class applyLoadoutFromWarehouse {};
			class qtyInWarehouse {};
			class isInWarehouse {};
			class makeWarehouseGlobal {};
		};

		/*
		* AI and recruits
		*/
		class AI
		{
			file = "\overthrow_main\functions\AI";
			class createEmployee {};
			class deleteEmployee {};
			class createGarrisonUnit {};
			class createGarrisonGun {};
			class createPoliceGroup {};
			class createSoldier {};
			class getSoldier {};
			class getSquad {};
			class parachuteAll {};
			class NATOsearch {};
			class createSquad {};
			class experience {};
			class dangerCaused {};
			class randomizeLoadout {};
			class getRandomLoadout {};
		};

		/*
		* AI orders
		*/
		class Orders
		{
			file = "\overthrow_main\functions\AI\orders";
			class orderLoot {};
			class orderOpenInventory {};
			class orderOpenArsenal {};
			class orderRevivePlayer {};
			class squadAssignVehicle {};
			class squadGetIn {};
			class squadGetOut {};
			class squadGetInMyVehicle {};
			class orderStopAndFace {};
			class landAndCleanupHelicopter {};
		};

		/*
		* NPCs
		*/
		class NPC
		{
			file = "\overthrow_main\functions\AI\NPC";
			class randomLocalIdentity {};
			class applyIdentity {};
			class initMayor {};
			class initCarDealer {};
			class initCivilian {};
			class initCivilianGroup {};
			class initCriminal {};
			class initCriminalGroup {};
			class initCrimLeader {};
			class initGendarm {};
			class initGendarmPatrol {};
			class initGunDealer {};
			class initHarbor {};
			class initMilitary {};
			class initMilitaryPatrol {};
			class initMobBoss {};
			class initMobster {};
			class initNATOCheckpoint {};
			class initPolice {};
			class initPolicePatrol {};
			class initPriest {};
			class initShopkeeper {};
			class initSniper {};
			class initRecruit {};
		};

		/*
		* Math.. how does it work?
		*/
		class Math
		{
			file = "\overthrow_main\functions\math";
			class rotationMatrix {};
			class matrixMultiply {};
			class matrixRotate {};
		};

		/*
		* NATO
		*/
		class NATO
		{
			file = "\overthrow_main\functions\factions\NATO";
			class initNATO {};

			class NATOQRF {};
			class NATOGroundForces {};
			class NATOGroundReinforcements {};
			class CTRGSupport {};
			class NATOAirSupport {};
			class NATOGroundSupport {};
			class NATOTankSupport {};
			class NATOSeaSupport {};
			class NATOScrambleJet {};
			class NATOAPCInsertion {};
			class NATOScrambleHelicopter {};
			class NATOGroundPatrol {};
			class NATOAirPatrol {};

			class NATOResponseObjective {};
			class NATOResponseTown {};
			class NATOCounterTown {};
			class NATOCounterObjective {};

			class NATOSupportSniper {};
			class NATOSupportRecon {};
			class NATOConvoy {};
			class NATOGroupDeployFOB {};
			class NATOMissionDeployFOB {};
			class NATOMissionReconInsert {};
			class NATOSetExplosives {};
			class NATOupgradeFOB {};
			class NATOsendGendarmerie {};
			class NATOreportThreat {};
			class NATOGetAttackVectors {};
			class NATOsiegeFOB {};
		};

		class NATOAI
		{
			file = "\overthrow_main\functions\factions\NATO\AI";
			class NATODrone {};
			class NATOMortar {};
		};

		class NATOSYSTEM
		{
			file = "\overthrow_main\functions\factions\NATO\system";
			class NATOabandonTowers {};
			class NATOcheckFOBs {};
			class NATOcheckObjectives {};
			class NATOcheckTowns {};
			class NATOcounterObjectives {};
			class NATOcounterTowns {};
			class NATOdeployFOB {};
			class NATOreinforceGendarmerie {};
			class NATOscheduleConvoy {};
			class NATOsendAirPatrol {};
			class NATOsendGroundPatrol {};
			class NATOupgradeFOBs {};
			class NATOupgradeGarrisons {};
			class NATOscrambleAircraft {};
			class NATOsendRaid {};
		};

		class CRIM
		{
			file = "\overthrow_main\functions\factions\CRIM";
			class CRIMLoop {};
			class formOrJoinGang {};
			class formGang {};
			class addToGang {};
			class gangJoinResistance {};
		};

		class GUER
		{
			file = "\overthrow_main\functions\factions\GUER";
			class jobSystem {};
			class assignJob {};
			class acceptJob {};
			class denyJob {};
			class startJob {};
			class jobLoop {};
			class GUERLoop {};
		};

		class Buildings
		{
			file = "\overthrow_main\functions\buildings";
			class initBuilding {};
			class initObservationPost {};
			class initPoliceStation {};
			class initWorkshop {};
			class initTrainingCamp {};
			class initWarehouse {};
			class initRadar {};
		};

        class Util
		{
			file = "\overthrow_main\functions\util";
			class getOwner {};
			class getOwnerUnit {};
      		class hasOwner {};
			class setOwner {};
			class unitStock {};
      		class spawnTemplate {};
			class sortBy {};
			class sortByInplace {};
			class findReplace {};
			class exportPrices {};
			class datestamp {};
			class logVerbose {};
			class consolidateArray {};
		};

		/*
		* Mod integration
		*/
		class Integration
		{
			file = "\overthrow_main\functions\integration";
			//class advancedTowingInit {};
			class detectItems {};
		};
	};
};
