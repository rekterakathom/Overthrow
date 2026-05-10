class OT_dialog_buy {
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
            onLBSelChanged = "_this call OT_fnc_displayShopPic";
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
            text = "$STR_STATISTICS_BUY";
            x = "0.752656 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.139219 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
            action = "[] call OT_fnc_buy;";
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

class OT_dialog_recruit {
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
            onLBSelChanged = "_this call OT_fnc_displayShopPic";
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
            action = "[] call OT_fnc_buy";

            text = "$STR_STATISTICS_RECRUIT";
            x = "0.840312 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0515625 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            action = "[] call OT_fnc_editLoadout";

            text = "$STR_STATISTICS_EDIT";
            x = "0.778437 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
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

class OT_dialog_sell {
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
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "[] call OT_fnc_sell;";

            text = "$STR_STATISTICS_SELL_1";
            x = "0.515469 * safeZoneW + safeZoneX";
            y = "0.786 * safeZoneH + safeZoneY";
            w = "0.0928125 * safeZoneW";
            h = "0.055 * safeZoneH";
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
        class RscButton_1602: RscOverthrowButton {
            idc = 1600;
            action = "[] call OT_fnc_sellAll;";

            text = "$STR_STATISTICS_SELL_ALL";
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

class OT_dialog_workshop {
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
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Jimepa)
        ////////////////////////////////////////////////////////

        class RscListbox_1500: RscOverthrowListBox {
            idc = 1500;
            onLBSelChanged = "_this call OT_fnc_displayShopPic";

            x = "0.247344 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.55 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.9};
        };
        class RscPicture_1200: RscOverthrowPicture {
            idc = 1200;

            text = "#(argb,8,8,3)color(1,1,1,1)";
            x = "0.654688 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.0979687 * safeZoneW";
            h = "0.165 * safeZoneH";
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "[] call OT_fnc_workshopAdd;";

            text = "$STR_STATISTICS_ADD";
            x = "0.752656 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.139219 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
        };
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;

            x = "0.654688 * safeZoneW + safeZoneX";
            y = "0.3999 * safeZoneH + safeZoneY";
            w = "0.237187 * safeZoneW";
            h = "0.265001 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.3};
        };
        class RscStructuredText_1101: RscOverthrowStructuredText {
            idc = 1101;
            text = "$STR_STATISTICS_WORKSHOP";
            x = "0.2525 * safeZoneW + safeZoneX";
            y = "0.159 * safeZoneH + safeZoneY";
            w = "0.391875 * safeZoneW";
            h = "0.055 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
            colorActive[] = {0, 0, 0, 0};
        };
        class RscPicture_1201: RscOverthrowPicture {
            idc = 1201;

            text = "#(argb,8,8,3)color(1,1,1,1)";
            x = "0.783594 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.108281 * safeZoneW";
            h = "0.165 * safeZoneH";
        };
        class RscStructuredText_1102: RscOverthrowStructuredText {
            idc = 1102;
            text = "<t size='2' align='center'>&gt;&gt;</t>"; //--- ToDo: Localize;
            x = "0.752656 * safeZoneW + safeZoneX";
            y = "0.28 * safeZoneH + safeZoneY";
            w = "0.0309375 * safeZoneW";
            h = "0.055 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
            colorActive[] = {0, 0, 0, 0};
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};
class OT_dialog_warehouse {
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
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Wivoti)
        ////////////////////////////////////////////////////////

        class RscListbox_1500: RscOverthrowListBox {
            idc = 1500;
            onLBSelChanged = "_this call OT_fnc_displayWarehousePic";

            x = "0.247344 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.55 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.9};
        };
        class RscPicture_1200: RscOverthrowPicture {
            idc = 1200;

            text = "#(argb,8,8,3)color(1,1,1,1)";
            x = "0.654688 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.237187 * safeZoneW";
            h = "0.165 * safeZoneH";
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "[-1] call OT_fnc_warehouseTake;";

            text = "$STR_STATISTICS_TAKE_ALL";
            x = "0.840312 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0515625 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
        };
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;

            x = "0.654688 * safeZoneW + safeZoneX";
            y = "0.3999 * safeZoneH + safeZoneY";
            w = "0.237187 * safeZoneW";
            h = "0.265001 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.3};
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1600;
            action = "[100] call OT_fnc_warehouseTake;";

            text = "$STR_STATISTICS_TAKE_100";
            x = "0.778437 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1600;
            action = "[10] call OT_fnc_warehouseTake;";

            text = "$STR_STATISTICS_TAKE_10";
            x = "0.716563 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1600;
            action = "[1] call OT_fnc_warehouseTake;";

            text = "$STR_STATISTICS_TAKE_1";
            x = "0.654688 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            text = "Search";
            x = "0.65 * safeZoneW + safeZoneX";
            y = "0.155 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.05 * safeZoneH";
        };
        class RscEdit_1700: RscEditOverthrow {
            idc = 1700;
            x = "0.247344 * safeZoneW + safeZoneX";
            y = "0.155 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.05 * safeZoneH";
        };
    };
};

class OT_dialog_import {
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
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Wivoti)
        ////////////////////////////////////////////////////////

        class RscListbox_1500: RscOverthrowListBox {
            idc = 1500;
            onLBSelChanged = "_this call OT_fnc_displayShopPic";

            x = "0.247344 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.55 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.9};
        };
        class RscPicture_1200: RscOverthrowPicture {
            idc = 1200;

            text = "#(argb,8,8,3)color(1,1,1,1)";
            x = "0.654688 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.237187 * safeZoneW";
            h = "0.165 * safeZoneH";
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "[1000] call OT_fnc_import;";

            text = "$STR_STATISTICS_IMPORT_1000";
            x = "0.840312 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0515625 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
        };
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;

            x = "0.654688 * safeZoneW + safeZoneX";
            y = "0.3999 * safeZoneH + safeZoneY";
            w = "0.237187 * safeZoneW";
            h = "0.265001 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.3};
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1600;
            action = "[100] call OT_fnc_import;";

            text = "$STR_STATISTICS_IMPORT_100";
            x = "0.778437 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1600;
            action = "[10] call OT_fnc_import;";

            text = "$STR_STATISTICS_IMPORT_10";
            x = "0.716563 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "Search";
            x = "0.65 * safeZoneW + safeZoneX";
            y = "0.155 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.05 * safeZoneH";
        };
        class RscEdit_1700: RscEditOverthrow {
            idc = 1700;
            x = "0.247344 * safeZoneW + safeZoneX";
            y = "0.155 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.05 * safeZoneH";
        };

    };
};

class OT_dialog_loadout {
    idd = 8000;
    movingenable = 0;

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Sozafo)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "[player, OT_context, lbData [1500, lbCurSel 1500]] call OT_fnc_restoreLoadout";

            text = "$STR_STATISTICS_RESTORE";
            x = "0.12875 * safeZoneW + safeZoneX";
            y = "0.511 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.088 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            action = "[lbData [1500, lbCurSel 1500]] call OT_fnc_removeLoadout";

            text = "$STR_STATISTICS_DELETE";
            x = "0.12875 * safeZoneW + safeZoneX";
            y = "0.61 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            colorBackground[] = {0.5, 0, 0, 0.8};
            colorActive[] = {0.5, 0, 0, 0.8};
        };
        class RscListbox_1500: RscOverthrowListBox {
            idc = 1500;
            x = "0.12875 * safeZoneW + safeZoneX";
            y = "0.236 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.264 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};
