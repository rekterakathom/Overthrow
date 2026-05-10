class OT_dialog_start {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class Background: RscOverthrowStructuredText {
            idc = 1100;
            x = "0.381406 * safeZoneW + safeZoneX";
            y = "0.137 * safeZoneH + safeZoneY";
            w = "0.252656 * safeZoneW";
            h = "0.407 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "closeDialog 0; createDialog 'OT_dialog_load';";
            text = "$STR_STATISTICS_LOAD_PREVIOUS_GAME";
            x = "0.448438 * safeZoneW + safeZoneX";
            y = "0.313 * safeZoneH + safeZoneY";
            w = "0.118594 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_STATISTICS_CONTINUE_PREVIOUS_GAME";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            action = "closeDialog 0; createDialog 'OT_dialog_newgame'; call OT_fnc_newGameDialog;";

            text = "$STR_STATISTICS_NEW_GAME";
            x = "0.448438 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.118594 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_STATISTICS_NEW_GAME_TOOLTIP";
        };
        class background_picture: RscOverthrowPicture {
            idc = 1200;
            text = "\overthrow_main\ui\logo_overthrow.paa";
            x = "0.399969 * safeZoneW + safeZoneX";
            y = "0.038 * safeZoneH + safeZoneY";
            w = "0.216563 * safeZoneW";
            h = "0.363 * safeZoneH";
        };
    };
};

class OT_dialog_load {
    idd = 15150;
    movingenable = 0;

    class controlsBackground {
        class background1: RscOverthrowStructuredText {
            idc = -1;
            x = "0.381406 * safeZoneW + safeZoneX";
            y = "0.137 * safeZoneH + safeZoneY";
            w = "0.252656 * safeZoneW";
            h = "0.572 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        class EditBox: RscEditMulti {
            idc = 1400;
            text = "";
            x = "0.386562 * safeZoneW + safeZoneX";
            y = "0.291 * safeZoneH + safeZoneY";
            w = "0.242344 * safeZoneW";
            h = "0.231 * safeZoneH";
        };
        class LoadNormal: RscOverthrowButton {
            idc = -1;
            x = "0.448438 * safeZoneW + safeZoneX";
            y = "0.621 * safeZoneH + safeZoneY";
            w = "0.118594 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_STATISTICS_CONTINUE_PREVIOUS_GAME";
            action = "closeDialog 0; [] remoteExec ['OT_fnc_loadGame', 2, false];";
            text = "$STR_STATISTICS_LOAD_SAVE";
        };
        class LoadString: RscOverthrowButton {
            idc = -1;
            x = "0.448438 * safeZoneW + safeZoneX";
            y = "0.533 * safeZoneH + safeZoneY";
            w = "0.118594 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_STATISTICS_LOAD_STRING_SAVE";
            action = "closeDialog 0; private _data = parseSimpleArray ctrlText ((findDisplay 15150) displayCtrl 1400); [_data] remoteExec ['OT_fnc_loadGame', 2, false];";
            text = "$STR_STATISTICS_IMPORT_SAVE";
        };
        class Logo_Picture: RscOverthrowPicture {
            idc = -1;
            text = "\overthrow_main\ui\logo_overthrow.paa";
            x = "0.399969 * safeZoneW + safeZoneX";
            y = "0.038 * safeZoneH + safeZoneY";
            w = "0.216563 * safeZoneW";
            h = "0.363 * safeZoneH";
        };
    };
};

class OT_dialog_vehicle {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "closeDialog 0; [] spawn OT_fnc_fastTravel;";
            tooltip = "$STR_PARAMTERS_FAST_TRAVEL_TOOLTIP";

            text = "$STR_PARAMTERS_FAST_TRAVEL";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.126 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        class RscButton_1614: RscOverthrowButton {
            idc = 1614;
            action = "closeDialog 0; [player] spawn OT_fnc_recover;";
            tooltip = "$STR_DIALOG_MAIN_LOOT_DESC";

            text = "$STR_STATISTICS_LOOT";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.214 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        class RscButton_1613: RscOverthrowButton {
            idc = 1613;
            text = "$STR_STATISTICS_JOBS";
            action = "call OT_fnc_jobsDialog";

            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.302 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";

        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_DIALOG_MAIN_TRANSFER_FROM";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.478 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_TRANSFER_FROM_DESC";
            action = "closeDialog 0; [] spawn OT_fnc_transferFrom;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "$STR_DIALOG_MAIN_TRANSFER_TO";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.390 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_TRANSFER_TO_DESC";
            action = "closeDialog 0; [] spawn OT_fnc_transferTo;";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "$STR_DIALOG_MAIN_TRANSFER_LEGIT";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.566 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_TRANSFER_LEGIT_DESC";
            action = "closeDialog 0; [] spawn OT_fnc_transferLegit;";
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            text = "$STR_DIALOG_MAIN_TAKE_LEGIT";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.654 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_TAKE_LEGIT_DESC";
            action = "closeDialog 0; [] spawn OT_fnc_takeLegit;";
        };
        class RscButton_1605: RscOverthrowButton {
            idc = 1605;
            text = "$STR_DIALOG_MAIN_LOCK_VEHICLE";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.742 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_LOCK_VEHICLE_DESC";
            action = "closeDialog 0; [] call OT_fnc_lockVehicle;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "$STR_DIALOG_MAIN_OPTIONS";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_vehiclewarehouse {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "$STR_PARAMTERS_FAST_TRAVEL";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.39 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_fastTravel;";
            tooltip = "$STR_PARAMTERS_FAST_TRAVEL_TOOLTIP";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_DIALOG_MAIN_TRANSFER_FROM";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.654 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_TRANSFER_FROM_DESC_WAREHOUSE";
            action = "closeDialog 0; createDialog 'OT_dialog_warehouse'; [] call OT_fnc_warehouseDialog;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "$STR_DIALOG_MAIN_STORE_ALL";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.478 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_STORE_ALL_DESC";
            action = "closeDialog 0; [] spawn OT_fnc_storeAll;";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "$STR_DIALOG_MAIN_TRANSFER_LEGIT";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.566 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_TRANSFER_LEGIT_DESC_WAREHOUSE";
            action = "closeDialog 0; [] spawn OT_fnc_transferLegit;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "$STR_DIALOG_MAIN_OPTIONS";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_vehicleport {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "$STR_PARAMTERS_FAST_TRAVEL";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.39 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_fastTravel;";
            tooltip = "$STR_PARAMTERS_FAST_TRAVEL_TOOLTIP";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_STATISTICS_IMPORT";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.654 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_IMPORT_DESC";
            action = "closeDialog 0; createDialog 'OT_dialog_import'; [] call OT_fnc_importDialog;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "$STR_STATISTICS_EXPORT_ALL";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.566 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_STATISTICS_EXPORT_ALL_DESC";
            action = "closeDialog 0; [] spawn OT_fnc_exportAll;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "$STR_DIALOG_MAIN_OPTIONS";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_vehiclehardware {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "$STR_PARAMTERS_FAST_TRAVEL";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.39 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_fastTravel;";
            tooltip = "$STR_PARAMTERS_FAST_TRAVEL_TOOLTIP";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_STATISTICS_BUY";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.654 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_BUY_HARDWARE_STORE";
            action = "closeDialog 0; [] call OT_fnc_buyHardwareDialog;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "$STR_STATISTICS_SELL";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.566 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_SELL_HARDWARE_STORE";
            action = "closeDialog 0; [] call OT_fnc_sellHardwareDialog;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "$STR_DIALOG_MAIN_OPTIONS";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_vehiclestore {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "$STR_PARAMTERS_FAST_TRAVEL";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.39 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_fastTravel;";
            tooltip = "$STR_PARAMTERS_FAST_TRAVEL_TOOLTIP";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_STATISTICS_BUY";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.654 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_BUY_DESC";
            action = "closeDialog 0; [] call OT_fnc_buyDialogVehicle;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "$STR_STATISTICS_SELL";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.566 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_SELL";
            action = "closeDialog 0; [] call OT_fnc_sellDialogVehicle;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "$STR_DIALOG_MAIN_OPTIONS";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_command {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            text = "$STR_DIALOG_MAIN_OPEN_ARSENAL";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.236 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_OPEN_ARSENAL_AI_DESC";
            action = "closeDialog 0; [] call OT_fnc_orderOpenArsenal;";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_STATISTICS_LOOT";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_LOOT_AI_DESC";
            action = "closeDialog 0; [] spawn OT_fnc_orderLoot;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "$STR_DIALOG_MAIN_OPEN_INVENTORY";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.324 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_OPEN_INVENTORY_AI_DESC";
            action = "closeDialog 0; [] spawn OT_fnc_orderOpenInventory;";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "$STR_DIALOG_MAIN_CREATE_SQUAD";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_CREATE_SQUAD_AI_DESC";
            action = "closeDialog 0; [] spawn OT_fnc_createSquad;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "$STR_DIALOG_MAIN_OPTIONS";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_squad {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////

        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_DIALOG_MAIN_ASSIGN_VEHICLE";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.324 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_ASSIGN_VEHICLE_AI_DESC";
            action = "closeDialog 0; [] call OT_fnc_squadAssignVehicle;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "$STR_DIALOG_MAIN_GET_IN";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_GET_IN_AI_DESC";
            action = "closeDialog 0; [] call OT_fnc_squadGetIn;";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "$STR_DIALOG_MAIN_GET_OUT";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_GET_OUT_AI_DESC";
            action = "closeDialog 0; [] call OT_fnc_squadGetOut;";
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            text = "$STR_DIALOG_MAIN_GET_IN_MY_VEHICLE";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.588 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_DIALOG_MAIN_GET_IN_MY_VEHICLE_AI_DESC";
            action = "closeDialog 0; [] call OT_fnc_squadGetInMyVehicle;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "$STR_DIALOG_MAIN_OPTIONS";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_options {
    idd = -1;
    movingenable = 0;

    class controls {
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "closeDialog 0; [player] remoteExec ['OT_fnc_saveGame', 2, false];";

            text = "$STR_PARAMTERS_PERSISTENT_SAVE";
            x = "0.386563 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.2475 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_PARAMTERS_PERSISTENT_SAVE_DESC";
        };
        class RscButton_1607: RscOverthrowButton {
            idc = 1607;
            action = "[] remoteExec ['OT_fnc_autoSaveToggle', 2];";
            text = "$STR_PARAMTERS_PERSISTENT_AUTO_SAVE";
            x = "0.386562 * safeZoneW + safeZoneX";
            y = "0.313 * safeZoneH + safeZoneY";
            w = "0.118594 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_PARAMTERS_PERSISTENT_AUTO_SAVE_DESC";
        };
        class RscButton_1608: RscOverthrowButton {
            idc = 1608;
            action = "[] remoteExec ['OT_fnc_autoloadToggle', 2]";
            text = "$STR_PARAMTERS_AUTO_LOAD_TOGGLE";
            x = "0.515469 * safeZoneW + safeZoneX";
            y = "0.313 * safeZoneH + safeZoneY";
            w = "0.118594 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_PARAMTERS_AUTO_LOAD_TOGGLE_DESC";
        };

        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            action = "OT_spawnCivPercentage = OT_spawnCivPercentage - 0.01; if (OT_spawnCivPercentage < 0) then { OT_spawnCivPercentage = 0 }; publicVariable 'OT_spawnCivPercentage'; hint format ['Civilian spawn now at %1%2', OT_spawnCivPercentage * 100, '%'];";

            text = "$STR_PARAMTERS_CIV_DECREASE";
            x = "0.386562 * safeZoneW + safeZoneX";
            y = "0.511 * safeZoneH + safeZoneY";
            w = "0.118594 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_PARAMTERS_CIV_DECREASE_DESC";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            action = "OT_spawnCivPercentage = OT_spawnCivPercentage + 0.01; if (OT_spawnCivPercentage < 0) then { OT_spawnCivPercentage = 0 }; publicVariable 'OT_spawnCivPercentage'; hint format ['Civilian spawn now at %1%2', OT_spawnCivPercentage * 100, '%'];";

            text = "$STR_PARAMTERS_CIV_INCREASE";
            x = "0.515469 * safeZoneW + safeZoneX";
            y = "0.511 * safeZoneH + safeZoneY";
            w = "0.118594 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_PARAMTERS_CIV_INCREASE_DESC";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            action = "call OT_fnc_decreaseTax";

            text = "$STR_PARAMTERS_TAX_DECREASE";
            x = "0.386562 * safeZoneW + safeZoneX";
            y = "0.61 * safeZoneH + safeZoneY";
            w = "0.118594 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_PARAMTERS_TAX_DECREASE_DESC";
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            action = "call OT_fnc_increaseTax";

            text = "$STR_PARAMTERS_TAX_INCREASE";
            x = "0.515469 * safeZoneW + safeZoneX";
            y = "0.61 * safeZoneH + safeZoneY";
            w = "0.118594 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_PARAMTERS_TAX_INCREASE_DESC";
        };
        class RscButton_1605: RscOverthrowButton {
            idc = 1605;
            action = "call OT_fnc_cleanDead;";
            text = "$STR_PARAMTERS_CLEAR_DEAD";
            x = "0.386562 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.118594 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_PARAMTERS_CLEAR_DEAD_DESC";
        };
        class RscButton_1606: RscOverthrowButton {
            idc = 1606;
            action = "[0, 0] remoteExecCall ['setFog', 0, false]";

            text = "$STR_PARAMTERS_CLEAR_FOG";
            x = "0.515469 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.118594 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_PARAMTERS_CLEAR_FOG_DESC";
        };
        class RscText_1009: RscOverthrowButton {
            idc = 1609;
            action = "call OT_fnc_toggleZeus;";
            text = "$STR_PARAMTERS_ZEUS_TOGGLE";
            x = "0.386562 * safeZoneW + safeZoneX";
            y = "0.709 * safeZoneH + safeZoneY";
            w = "0.2475 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "$STR_PARAMTERS_ZEUS_TOGGLE_DESC";
        };
    };
};

class OT_dialog_upload {
    idd = 49558;
    movingenable = 0;
    onLoad = "params ['_display']; _display displayAddEventHandler ['KeyDown', { if ((_this select 1) == 1) then { true } }];";

    class controlsBackground {
        class background1: RscOverthrowText {
            idc = -1;
            text = "$STR_PARAMTERS_MISSION_EXPORT";
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.4125 * safeZoneW";
            h = "0.022 * safeZoneH";
            colorBackground[] = {
                "(profileNamespace getVariable ['GUI_BCG_RGB_R', 0.77])",
                "(profileNamespace getVariable ['GUI_BCG_RGB_G', 0.51])",
                "(profileNamespace getVariable ['GUI_BCG_RGB_B', 0.08])",
                1
            };
        };
        class background2: RscOverthrowText {
            idc = -1;
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.247 * safeZoneH + safeZoneY";
            w = "0.4125 * safeZoneW";
            h = "0.528 * safeZoneH";
            colorBackground[] = {-1, -1, -1, 0.7};
        };
        class background3: RscOverthrowText {
            idc = -1;
            x = "0.298905 * safeZoneW + safeZoneX";
            y = "0.577 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.143 * safeZoneH";
            colorBackground[] = {-1, -1, -1, 0.5};
        };
    };
    class controls {
        class EditBox: RscEdit {
            idc = 1;
            style = 16;
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.258 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.308 * safeZoneH";
            canModify = 0;
            font = "EtelkaMonospacePro";
            colorBackground[] = {-1, -1, -1, 0.75};
        };
        class LegalControlGroup: RscControlsGroup {
            idc = -1;
            x = "0.298905 * safeZoneW + safeZoneX";
            y = "0.577 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.143 * safeZoneH";
            class Controls {
                class LegalText: RscOverthrowStructuredText {
                    idc = 5;
                    x = "0 * safeZoneW";
                    y = "0 * safeZoneH";
                    w = "0.397031 * safeZoneW";
                    h = "0.143 * safeZoneH";
                    text = "";
                    colorBackground[] = {-1, -1, -1, 0};
                };
            };
        };
        class CancelButton: RscOverthrowStructuredText {
            idc = -1;
            text = "$STR_MAIN_CLOSE_MENU";
            onMouseButtonClick = "playSound 'click'; closeDialog 0;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.731 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.033 * safeZoneH";
            onMouseEnter = "(_this select 0) ctrlSetStructuredText parseText ""<t align='center' font='PuristaBold' color='#00FF00'>CLOSE MENU</t>""; (_this select 0) ctrlCommit 0.5; ";
            onMouseExit = "(_this select 0) ctrlSetStructuredText parseText ""<t align='center' font='PuristaBold' color='#FFFFFF'>CLOSE MENU</t>""; (_this select 0) ctrlCommit 0.5; ";
            colorBackground[] = {-1, -1, -1, 0.7};
        };
    };
};

class OT_dialog_main {
    idd = 8001;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };
        class RscStructuredText_1104: RscOverthrowStructuredText {
            idc = 1104;

            text = "";
            x = "0.876406 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.123759 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Mucomo)
        ////////////////////////////////////////////////////////
        class RscButton_1699: RscOverthrowButton {
            idc = 1699;
            action = "closeDialog 0; [] spawn OT_fnc_mapInfoDialog";

            text = "$STR_PARAMTERS_MAP_INFO";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.247 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "$STR_PARAMTERS_MAP_INFO_DESC";
        };
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;

            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.302 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.1 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.4};
        };
        class RscStructuredText_1150: RscOverthrowStructuredText {
            idc = 1150;

            x = "0.16 * safeZoneW + safeZoneX";
            y = "0.302 * safeZoneH + safeZoneY";
            w = "0.3 * safeZoneW";
            h = "0.3 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "closeDialog 0; [] spawn OT_fnc_fastTravel";

            text = "$STR_PARAMTERS_FAST_TRAVEL";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.423 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "$STR_PARAMTERS_FAST_TRAVEL_TOOLTIP_INSTA";
        };
        class RscButton_1613: RscOverthrowButton {
            idc = 1613;
            action = "closeDialog 0; [] spawn OT_fnc_resistanceDialog";

            text = "$STR_PARAMTERS_RESISTENCE";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.478 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "$STR_PARAMTERS_RESISTENCE_DESC";
        };
        class RscButton_1614: RscOverthrowButton {
            idc = 1614;
            action = "closeDialog 0; [] spawn OT_fnc_jobsDialog";

            text = "$STR_STATISTICS_JOBS";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.533 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "$STR_STATISTICS_JOBS_DESC";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            action = "closeDialog 0; createDialog 'OT_dialog_place'";

            text = "$STR_STATISTICS_PLACE";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.588 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "$STR_STATISTICS_PLACE_DESC";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            action = "closeDialog 0; [] spawn OT_fnc_build";

            text = "$STR_STATISTICS_BUILD";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.643 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "$STR_STATISTICS_BUILD_DESC";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            action = "[] spawn OT_fnc_manageRecruitsDialog;";

            text = "$STR_PARAMTERS_MANAGE_RECRUITS";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.698 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "$STR_PARAMTERS_MANAGE_RECRUITS_DESC";
        };
        class RscButton_1611: RscOverthrowButton {
            idc = 1611;
            action = "[] spawn OT_fnc_characterSheetDialog;";

            text = "$STR_PARAMTERS_CHAR_SHEET";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.753 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "$STR_PARAMTERS_CHAR_SHEET_DESC";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "$STR_DIALOG_MAIN_OPTIONS";
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.808 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "$STR_PARAMTERS_PERSISTENT_SAVE_DESC1";
        };

        class RscButton_1620: RscOverthrowButton {
            idc = 1620;
            action = "closeDialog 0; [] spawn OT_fnc_manageArea";

            text = "$STR_PARAMTERS_PROCUREMENT";
            x = "0.881562 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.0515625 * safeZoneW";
            h = "0.044 * safeZoneH";
        };
        class RscButton_1621: RscOverthrowButton {
            idc = 1621;
            action = "closeDialog 0; [] call OT_fnc_garrisonDialog";

            text = "$STR_PARAMTERS_GARRISON";
            x = "0.943438 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.0515625 * safeZoneW";
            h = "0.044 * safeZoneH";
        };

        class RscPicture_1201: RscOverthrowPicture {
            idc = 1201;

            text = "#(argb,8,8,3)color(0,0,0,0)";
            x = "0.881562 * safeZoneW + safeZoneX";
            y = "0.479 * safeZoneH + safeZoneY";
            w = "0.113437 * safeZoneW";
            h = "0.1 * safeZoneH";
        };
        class RscButton_1608: RscOverthrowButton {
            idc = 1608;
            action = "closeDialog 0; [] call OT_fnc_buyBuilding";

            text = "$STR_STATISTICS_BUY";
            x = "0.881562 * safeZoneW + safeZoneX";
            y = "0.698 * safeZoneH + safeZoneY";
            w = "0.113437 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "Purchase this building";
        };
        class RscButton_1630: RscOverthrowButton {
            idc = 1630;
            action = "closeDialog 0; [] call OT_fnc_logisticsDialog";

            text = "$STR_PARAMTERS_VEHICLE";
            x = "0.881562 * safeZoneW + safeZoneX";
            y = "0.247 * safeZoneH + safeZoneY";
            w = "0.113437 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "$STR_PARAMTERS_VEHICLE_DESC";
        };
        class RscButton_1609: RscOverthrowButton {
            idc = 1609;
            action = "closeDialog 0; [] call OT_fnc_leaseBuilding";

            text = "$STR_PARAMTERS_LEASE";
            x = "0.881562 * safeZoneW + safeZoneX";
            y = "0.753 * safeZoneH + safeZoneY";
            w = "0.0515625 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "$STR_PARAMTERS_LEASE_DESC";
        };
        class RscButton_1610: RscOverthrowButton {
            idc = 1610;
            action = "closeDialog 0; [] call OT_fnc_setHome";

            text = "$STR_PARAMTERS_SET_HOME";
            x = "0.943438 * safeZoneW + safeZoneX";
            y = "0.753 * safeZoneH + safeZoneY";
            w = "0.0515625 * safeZoneW";
            h = "0.044 * safeZoneH";
            tooltip = "$STR_PARAMTERS_SET_HOME_DESC";
        };
        class RscStructuredText_1101: RscOverthrowStructuredText {
            idc = 1101;

            x = "0.881562 * safeZoneW + safeZoneX";
            y = "0.302 * safeZoneH + safeZoneY";
            w = "0.113437 * safeZoneW";
            h = "0.1 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.4};
        };
        class RscStructuredText_1102: RscOverthrowStructuredText {
            idc = 1102;

            x = "0.881562 * safeZoneW + safeZoneX";
            y = "0.588 * safeZoneH + safeZoneY";
            w = "0.113437 * safeZoneW";
            h = "0.1 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.4};
        };
        class RscPicture_1200: RscOverthrowPicture {
            idc = 1200;
            text = "\overthrow_main\ui\logo_overthrow.paa";
            x = "0.00499997 * safeZoneW + safeZoneX";
            y = "0.103 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.144 * safeZoneW";
        };
        class RscStructuredText_1106: RscOverthrowStructuredText {
            idc = 1106;

            x = "safeZoneX + (0.8 * safeZoneW)";
            y = "safeZoneY + (0.15 * safeZoneH)";
            w = "0.19 * safeZoneW";
            h = "0.1 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
            colorActive[] = {0, 0, 0, 0};
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};

class OT_dialog_char {
    idd = 8003;
    movingenable = 0;

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Pejity)
        ////////////////////////////////////////////////////////

        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;
            text = ""; //--- ToDo: Localize;
            x = "0.273125 * safeZoneW + safeZoneX";
            y = "0.269 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.143 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.5};
            colorActive[] = {0, 0, 0, 0.5};
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "$STR_PARAMTERS_LEVEL_BUY";
            x = "0.273125 * safeZoneW + safeZoneX";
            y = "0.423 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            action = "['fitness'] call buyPerk;";
        };
        class RscStructuredText_1101: RscOverthrowStructuredText {
            idc = 1101;
            text = "$STR_PARAMTERS_LEVEL_BUY";
            x = "0.427812 * safeZoneW + safeZoneX";
            y = "0.269 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.143 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.3};
            colorActive[] = {0, 0, 0, 0.3};
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_PARAMTERS_LEVEL_BUY";
            x = "0.427812 * safeZoneW + safeZoneX";
            y = "0.423 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            action = "['trade'] call buyPerk;";
        };
        class RscStructuredText_1102: RscOverthrowStructuredText {
            idc = 1102;
            text = ""; //--- ToDo: Localize;
            x = "0.5825 * safeZoneW + safeZoneX";
            y = "0.269 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.143 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.3};
            colorActive[] = {0, 0, 0, 0.3};
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "$STR_PARAMTERS_LEVEL_BUY";
            x = "0.5825 * safeZoneW + safeZoneX";
            y = "0.423 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            action = "['stealth'] call buyPerk;";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};

class OT_dialog_tute {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1101: RscOverthrowStructuredText {
            idc = 1101;
            x = "0.324687 * safeZoneW + safeZoneX";
            y = "0.313 * safeZoneH + safeZoneY";
            w = "0.355781 * safeZoneW";
            h = "0.198 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Kizeru)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "closeDialog 0; [] spawn OT_fnc_tutorial;";

            text = "$STR_STATISTICS_YES";
            x = "0.340156 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.088 * safeZoneH";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            action = "closeDialog 0;";

            text = "$STR_STATISTICS_NO";
            x = "0.592812 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.088 * safeZoneH";
        };
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;

            text = "$STR_TUTORIAL_POP_UP";
            x = "0.340156 * safeZoneW + safeZoneX";
            y = "0.346 * safeZoneH + safeZoneY";
            w = "0.324844 * safeZoneW";
            h = "0.033 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};

class OT_dialog_choose {
    idd = 8002;
    movingenable = 0;

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Humesu)
        ////////////////////////////////////////////////////////

        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.269 * safeZoneH + safeZoneY";
            w = "0.4125 * safeZoneW";
            h = "0.184 * safeZoneH";
            colorBackground[] = {0.2, 0.2, 0.2, 1};
        };

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "Lorem Ipsum dolor sit amet blah blah blah"; //--- ToDo: Localize;
            action = "closeDialog 0; 0 call OT_fnc_choiceMade;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.478 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.055 * safeZoneH";
            sizeEx = "0.017 * safeZoneH";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "Lorem Ipsum dolor sit amet blah blah blah"; //--- ToDo: Localize;
            action = "closeDialog 0; 1 call OT_fnc_choiceMade;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.544 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.055 * safeZoneH";
            sizeEx = "0.017 * safeZoneH";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "Lorem Ipsum dolor sit amet blah blah blah"; //--- ToDo: Localize;
            action = "closeDialog 0; 2 call OT_fnc_choiceMade;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.61 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.055 * safeZoneH";
            sizeEx = "0.017 * safeZoneH";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "Lorem Ipsum dolor sit amet blah blah blah"; //--- ToDo: Localize;
            action = "closeDialog 0; 3 call OT_fnc_choiceMade;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.055 * safeZoneH";
            sizeEx = "0.017 * safeZoneH";
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            text = "Lorem Ipsum dolor sit amet blah blah blah"; //--- ToDo: Localize;
            action = "closeDialog 0; 4 call OT_fnc_choiceMade;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.742 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.055 * safeZoneH";
            sizeEx = "0.017 * safeZoneH";
        };
        class RscButton_1605: RscOverthrowButton {
            idc = 1605;
            text = "Lorem Ipsum dolor sit amet blah blah blah"; //--- ToDo: Localize;
            action = "closeDialog 0; 5 call OT_fnc_choiceMade;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.808 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.055 * safeZoneH";
            sizeEx = "0.017 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};

class OT_dialog_newgame {
    idd = 8099;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;
            x = "0.324687 * safeZoneW + safeZoneX";
            y = "0.269 * safeZoneH + safeZoneY";
            w = "0.345469 * safeZoneW";
            h = "0.495 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Zosiwi)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "$STR_STATISTICS_EASY";
            x = "0.329844 * safeZoneW + safeZoneX";
            y = "0.313 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "server setVariable ['OT_difficulty', 0, true]; call OT_fnc_newGameDialog;";
            tooltip = "$STR_TUTORIAL_TOOLTIP_01";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_STATISTICS_NORMAL";
            x = "0.453594 * safeZoneW + safeZoneX";
            y = "0.313 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "server setVariable ['OT_difficulty', 1, true]; call OT_fnc_newGameDialog;";
            color[] = {0, 0.8, 0, 1};
            tooltip = "$STR_TUTORIAL_TOOLTIP_02";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "$STR_STATISTICS_HARD";
            x = "0.577344 * safeZoneW + safeZoneX";
            y = "0.313 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "server setVariable ['OT_difficulty', 2, true]; call OT_fnc_newGameDialog;";
            tooltip = "$STR_TUTORIAL_TOOLTIP_03";
        };
        class RscStructuredText_1101: RscOverthrowStructuredText {
            idc = 1101;
            text = "$STR_PARAMTERS_DIFFICULTY";
            x = "0.329844 * safeZoneW + safeZoneX";
            y = "0.269 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "0.033 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
        class RscStructuredText_1102: RscOverthrowStructuredText {
            idc = 1102;
            text = "$STR_MAIN_FAST_TRAVEL";
            x = "0.329844 * safeZoneW + safeZoneX";
            y = "0.423 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "0.033 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "$STR_STATISTICS_FREE";
            x = "0.329844 * safeZoneW + safeZoneX";
            y = "0.467 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "server setVariable ['OT_fastTravelType', 0, true]; call OT_fnc_newGameDialog;";
            tooltip = "$STR_PARAMTERS_FAST_TRAVEL_TOOLTIP2";
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            text = "$STR_STATISTICS_COSTS";
            x = "0.453594 * safeZoneW + safeZoneX";
            y = "0.467 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            color[] = {0, 0.8, 0, 1};
            action = "server setVariable ['OT_fastTravelType', 1, true]; call OT_fnc_newGameDialog;";
            tooltip = "$STR_PARAMTERS_FAST_TRAVEL_TOOLTIP3";
        };
        class RscButton_1605: RscOverthrowButton {
            idc = 1605;
            text = "$STR_STATISTICS_DISABLED";
            x = "0.577344 * safeZoneW + safeZoneX";
            y = "0.467 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "server setVariable ['OT_fastTravelType', 2, true]; call OT_fnc_newGameDialog;";
            tooltip = "$STR_PARAMTERS_FAST_TRAVEL_TOOLTIP4";
        };
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;
            text = "$STR_MAIN_FAST_TRAVEL_RULES";
            x = "0.329844 * safeZoneW + safeZoneX";
            y = "0.577 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "0.033 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
        class RscButton_1607: RscOverthrowButton {
            idc = 1607;
            text = "$STR_STATISTICS_OPEN";
            x = "0.329844 * safeZoneW + safeZoneX";
            y = "0.621 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "server setVariable ['OT_fastTravelRules', 0, true]; call OT_fnc_newGameDialog;";
            tooltip = "$STR_PARAMTERS_FAST_TRAVEL_TOOLTIP5";
        };
        class RscButton_1608: RscOverthrowButton {
            idc = 1608;
            text = "$STR_STATISTICS_NO_WEAPONS";
            x = "0.453594 * safeZoneW + safeZoneX";
            y = "0.621 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            color[] = {0, 0.8, 0, 1};
            action = "server setVariable ['OT_fastTravelRules', 1, true]; call OT_fnc_newGameDialog;";
            tooltip = "$STR_PARAMTERS_FAST_TRAVEL_TOOLTIP6";
        };
        class RscButton_1609: RscOverthrowButton {
            idc = 1609;
            text = "$STR_STATISTICS_RESTRICTED";
            x = "0.577344 * safeZoneW + safeZoneX";
            y = "0.621 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "server setVariable ['OT_fastTravelRules', 2, true]; call OT_fnc_newGameDialog;";
            tooltip = "$STR_PARAMTERS_FAST_TRAVEL_TOOLTIP7";
        };
        class RscButton_1606: RscOverthrowButton {
            idc = 1606;
            text = "$STR_STATISTICS_START_GAME";
            x = "0.577344 * safeZoneW + safeZoneX";
            y = "0.708 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.045 * safeZoneH";
            action = "closeDialog 0; [] remoteExec ['OT_fnc_newGame', 2, false]";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};
