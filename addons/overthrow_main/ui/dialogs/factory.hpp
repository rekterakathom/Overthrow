class OT_dialog_factoryold {
    idd = 8000;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1199: RscOverthrowStructuredText {
            idc = 1199;
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.214 * safeZoneH + safeZoneY";
            w = "0.4125 * safeZoneW";
            h = "0.566 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Lolemu)
        ////////////////////////////////////////////////////////

        class RscListbox_1500: RscOverthrowListBox {
            idc = 1500;
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.577 * safeZoneH + safeZoneY";
            w = "0.293906 * safeZoneW";
            h = "0.132 * safeZoneH";
            onLBSelChanged = "_this call OT_fnc_showFactoryPic";
        };
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;
            text = "$STR_UI_DIAG_FACTORY_01";
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.4125 * safeZoneW";
            h = "0.066 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
            colorActive[] = {0, 0, 0, 0};
        };
        class RscPicture_1200: RscOverthrowPicture {
            idc = 1200;
            text = "#(argb,8,8,3)color(1,1,1,1)";
            x = "0.45875 * safeZoneW + safeZoneX";
            y = "0.302 * safeZoneH + safeZoneY";
            w = "0.0825 * safeZoneW";
            h = "0.121 * safeZoneH";
        };
        class RscStructuredText_1101: RscOverthrowStructuredText {
            idc = 1101;
            text = "$STR_UI_DIAG_FACTORY_02";
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.533 * safeZoneH + safeZoneY";
            w = "0.4125 * safeZoneW";
            h = "0.022 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
            colorActive[] = {0, 0, 0, 0};
        };
        class RscStructuredText_1102: RscOverthrowStructuredText {
            idc = 1102;
            text = "<t size='0.65' align='center'></t>"; //--- ToDo: Localize;
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.434 * safeZoneH + safeZoneY";
            w = "0.4125 * safeZoneW";
            h = "0.088 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
            colorActive[] = {0, 0, 0, 0};
        };
        class RscPicture_1201: RscOverthrowPicture {
            idc = 1201;
            text = "#(argb,8,8,3)color(1,1,1,1)";
            x = "0.597969 * safeZoneW + safeZoneX";
            y = "0.577 * safeZoneH + safeZoneY";
            w = "0.103125 * safeZoneW";
            h = "0.132 * safeZoneH";
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "$STR_UI_DIAG_FACTORY_03"; //--- this is a different "Clear" meaning
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.72 * safeZoneH + safeZoneY";
            w = "0.103125 * safeZoneW";
            h = "0.055 * safeZoneH";
            action = "[] call OT_fnc_factoryClear;";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_UI_DIAG_FACTORY_04";
            x = "0.597969 * safeZoneW + safeZoneX";
            y = "0.72 * safeZoneH + safeZoneY";
            w = "0.103125 * safeZoneW";
            h = "0.055 * safeZoneH";
            action = "[] call OT_fnc_factorySet;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "$STR_UI_DIAG_FACTORY_05";
            x = "0.448438 * safeZoneW + safeZoneX";
            y = "0.72 * safeZoneH + safeZoneY";
            w = "0.103125 * safeZoneW";
            h = "0.055 * safeZoneH";
            action = "closeDialog 0; [] call OT_fnc_reverseEngineerDialog;";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "X"; //--- ToDo: Localize;
            x = "0.675312 * safeZoneW + safeZoneX";
            y = "0.236 * safeZoneH + safeZoneY";
            w = "0.0257812 * safeZoneW";
            h = "0.044 * safeZoneH";
            action = "closeDialog 0";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////




    };
};


class OT_dialog_factory {
    idd = 8000;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1199: RscOverthrowStructuredText {
            idc = 1199;
            x = "0.21125 * safeZoneW + safeZoneX";
            y = "0.093 * safeZoneH + safeZoneY";
            w = "0.562031 * safeZoneW";
            h = "0.803 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Fotyke)
        ////////////////////////////////////////////////////////

        class RscStructuredText_1104: RscOverthrowStructuredText {
            idc = 1104;
            text = "$STR_UI_DIAG_FACTORY_06";
            x = "0.381406 * safeZoneW + safeZoneX";
            y = "0.104 * safeZoneH + safeZoneY";
            w = "0.232031 * safeZoneW";
            h = "0.044 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
        class RscButton_1608: RscOverthrowButton {
            idc = 1608;
            text = "$STR_UI_DIAG_FACTORY_05";
            x = "0.432969 * safeZoneW + safeZoneX";
            y = "0.797 * safeZoneH + safeZoneY";
            w = "0.128906 * safeZoneW";
            h = "0.066 * safeZoneH";
            action = "closeDialog 0; [] call OT_fnc_reverseEngineerDialog;";
        };
        class RscListbox_1500: RscOverthrowListBox {
            idc = 1500;
            x = "0.216406 * safeZoneW + safeZoneX";
            y = "0.181 * safeZoneH + safeZoneY";
            w = "0.144375 * safeZoneW";
            h = "0.616 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.9};
            onLBSelChanged = "call OT_fnc_factoryRefresh";
        };
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;
            x = "0.438125 * safeZoneW + safeZoneX";
            y = "0.181 * safeZoneH + safeZoneY";
            w = "0.33 * safeZoneW";
            h = "0.11 * safeZoneH";
        };
        class RscListbox_1501: RscOverthrowListBox {
            idc = 1501;
            x = "0.438125 * safeZoneW + safeZoneX";
            y = "0.324 * safeZoneH + safeZoneY";
            w = "0.257813 * safeZoneW";
            h = "0.187 * safeZoneH";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "+1"; //--- ToDo: Localize;
            x = "0.365937 * safeZoneW + safeZoneX";
            y = "0.324 * safeZoneH + safeZoneY";
            w = "0.0670312 * safeZoneW";
            h = "0.055 * safeZoneH";
            action = "[1] call OT_fnc_factoryQueueAdd";
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            text = "+10"; //--- ToDo: Localize;
            x = "0.365937 * safeZoneW + safeZoneX";
            y = "0.39 * safeZoneH + safeZoneY";
            w = "0.0670312 * safeZoneW";
            h = "0.055 * safeZoneH";
            action = "[10] call OT_fnc_factoryQueueAdd";
        };
        class RscButton_1605: RscOverthrowButton {
            idc = 1605;
            text = "+100"; //--- ToDo: Localize;
            x = "0.365937 * safeZoneW + safeZoneX";
            y = "0.456 * safeZoneH + safeZoneY";
            w = "0.0670312 * safeZoneW";
            h = "0.055 * safeZoneH";
            action = "[100] call OT_fnc_factoryQueueAdd";
        };
        class RscStructuredText_1101: RscOverthrowStructuredText {
            idc = 1101;
            text = "$STR_UI_DIAG_FACTORY_07";
            x = "0.438125 * safeZoneW + safeZoneX";
            y = "0.291 * safeZoneH + safeZoneY";
            w = "0.113437 * safeZoneW";
            h = "0.033 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
        class RscStructuredText_1102: RscOverthrowStructuredText {
            idc = 1102;
            text = "$STR_UI_DIAG_FACTORY_08";
            x = "0.216406 * safeZoneW + safeZoneX";
            y = "0.148 * safeZoneH + safeZoneY";
            w = "0.113437 * safeZoneW";
            h = "0.033 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
        class RscButton_1606: RscOverthrowButton {
            idc = 1606;
            text = "$STR_UI_DIAG_FACTORY_09";
            x = "0.701094 * safeZoneW + safeZoneX";
            y = "0.324 * safeZoneH + safeZoneY";
            w = "0.0670312 * safeZoneW";
            h = "0.055 * safeZoneH";
            action = "call OT_fnc_factoryQueueRemove";
        };
        class RscButton_1607: RscOverthrowButton {
            idc = 1607;
            text = "$STR_UI_DIAG_FACTORY_10";
            x = "0.701094 * safeZoneW + safeZoneX";
            y = "0.39 * safeZoneH + safeZoneY";
            w = "0.0670312 * safeZoneW";
            h = "0.055 * safeZoneH";
            action = "call OT_fnc_factoryQueueRemoveAll";
        };
        class RscPicture_1200: RscOverthrowPicture {
            idc = 1200;
            text = "";
            x = "0.365937 * safeZoneW + safeZoneX";
            y = "0.181 * safeZoneH + safeZoneY";
            w = "0.0670312 * safeZoneW";
            h = "0.11 * safeZoneH";
        };
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;
            x = "0.365937 * safeZoneW + safeZoneX";
            y = "0.522 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.275 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};


class OT_dialog_reverse {
    idd = -1;
    movingenable = 0;

    class controls {
        ////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Fylaby)
////////////////////////////////////////////////////////

        class RscListbox_1500: RscOverthrowListBox {
            idc = 1500;

            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.4125 * safeZoneW";
            h = "0.55 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.9};
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            action = "closeDialog 0;";

            text = "$STR_STATISTICS_CLOSE";
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.786 * safeZoneH + safeZoneY";
            w = "0.0928125 * safeZoneW";
            h = "0.055 * safeZoneH";
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "[] call OT_fnc_reverseEngineer;";

            text = "$STR_UI_DIAG_FACTORY_05";
            x = "0.613437 * safeZoneW + safeZoneX";
            y = "0.786 * safeZoneH + safeZoneY";
            w = "0.0928125 * safeZoneW";
            h = "0.055 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};

class OT_dialog_craft {
    idd = 8000;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1199: RscOverthrowStructuredText {
            idc = 1199;
            x = "0.242187 * safeZoneW + safeZoneX";
            y = "0.214 * safeZoneH + safeZoneY";
            w = "0.654844 * safeZoneW";
            h = "0.572 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Jeduvu)
        ////////////////////////////////////////////////////////

        class RscListbox_1500: RscOverthrowListBox {
            idc = 1500;
            x = "0.247344 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.55 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.9};
            onLBSelChanged = "_this call OT_fnc_displayCraftItem";
        };
        class RscPicture_1200: RscOverthrowPicture {
            idc = 1200;
            text = "";
            x = "0.654688 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.237187 * safeZoneW";
            h = "0.165 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "$STR_UI_DIAG_FACTORY_11";
            x = "0.752656 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.139219 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
            action = "[] call OT_fnc_craft;";
        };
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;
            x = "0.654688 * safeZoneW + safeZoneX";
            y = "0.4 * safeZoneH + safeZoneY";
            w = "0.237187 * safeZoneW";
            h = "0.265 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.3};
        };
        class RscButton_1699: RscOverthrowButton {
            idc = 1699;
            text = "X"; //--- ToDo: Localize;
            action = "closeDialog 0";
            x = "0.732031 * safeZoneW + safeZoneX";
            y = "0.181 * safeZoneH + safeZoneY";
            w = "0.0257812 * safeZoneW";
            h = "0.044 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////



    };
};
