class OT_dialog_resistance {
    idd = 8000;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;
            x = "0.237031 * safeZoneW + safeZoneX";
            y = "0.17 * safeZoneH + safeZoneY";
            w = "0.525937 * safeZoneW";
            h = "0.7 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Defoki)
        ////////////////////////////////////////////////////////

        class RscStructuredText_1101: RscOverthrowStructuredText {
            idc = 1101;
            text = "$STR_UI_DIAG_RESISTANCE_01";
            x = "0.242187 * safeZoneW + safeZoneX";
            y = "0.181 * safeZoneH + safeZoneY";
            w = "0.515625 * safeZoneW";
            h = "0.044 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
            colorActive[] = {0, 0, 0, 0};
        };
        class RscListbox_1500: RscOverthrowListBox {
            idc = 1500;
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.236 * safeZoneH + safeZoneY";
            w = "0.242344 * safeZoneW";
            h = "0.165 * safeZoneH";
            onLBSelChanged = "_this call OT_fnc_showMemberInfo";
        };
        class RscStructuredText_1102: RscOverthrowStructuredText {
            idc = 1102;
            x = "0.546406 * safeZoneW + safeZoneX";
            y = "0.236 * safeZoneH + safeZoneY";
            w = "0.154687 * safeZoneW";
            h = "0.11 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.2};
            colorActive[] = {0, 0, 0, 0};
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "$STR_UI_DIAG_RESISTANCE_02";
            x = "0.628906 * safeZoneW + safeZoneX";
            y = "0.357 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.044 * safeZoneH";
            action = "[] call OT_fnc_makeGeneral;";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_UI_DIAG_RESISTANCE_03";
            x = "0.546406 * safeZoneW + safeZoneX";
            y = "0.357 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.044 * safeZoneH";
            action = "[] call OT_fnc_transferFunds;";
        };
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;
            text = "$STR_UI_DIAG_RESISTANCE_04";
            x = "0.242187 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.515625 * safeZoneW";
            h = "0.033 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
            colorActive[] = {0, 0, 0, 0};
        };
        class RscListbox_1501: RscOverthrowListBox {
            idc = 1501;
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.445 * safeZoneH + safeZoneY";
            w = "0.242344 * safeZoneW";
            h = "0.165 * safeZoneH";
            onLBSelChanged = "_this call OT_fnc_showBusinessInfo";
        };
        class RscStructuredText_1104: RscOverthrowStructuredText {
            idc = 1104;
            x = "0.546406 * safeZoneW + safeZoneX";
            y = "0.445 * safeZoneH + safeZoneY";
            w = "0.154687 * safeZoneW";
            h = "0.11 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.2};
            colorActive[] = {0, 0, 0, 0};
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "$STR_UI_DIAG_RESISTANCE_05";
            x = "0.546406 * safeZoneW + safeZoneX";
            y = "0.566 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.044 * safeZoneH";
            action = "[] call OT_fnc_fireEmployee;";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "$STR_UI_DIAG_RESISTANCE_06";
            x = "0.628906 * safeZoneW + safeZoneX";
            y = "0.566 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.044 * safeZoneH";
            action = "[] call OT_fnc_hireEmployee;";
        };
        class RscStructuredText_1106: RscOverthrowStructuredText {
            idc = 1106;

            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.698 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.151 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.2};
            colorActive[] = {0, 0, 0, 0};
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            text = "$STR_UI_DIAG_RESISTANCE_07";
            x = "0.402031 * safeZoneW + safeZoneX";
            y = "0.643 * safeZoneH + safeZoneY";
            w = "0.0979687 * safeZoneW";
            h = "0.044 * safeZoneH";
            action = "[] call OT_fnc_giveFunds;";
        };
        class RscButton_1605: RscOverthrowButton {
            idc = 1605;
            text = "$STR_UI_DIAG_RESISTANCE_08";
            x = "0.510313 * safeZoneW + safeZoneX";
            y = "0.643 * safeZoneH + safeZoneY";
            w = "0.0979687 * safeZoneW";
            h = "0.044 * safeZoneH";
            action = "[] call OT_fnc_takeFunds;";
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


class OT_dialog_garrison {
    idd = 9000;
    movingenable = 0;
    class controlsBackground {
        class RscStructuredText_1199: RscOverthrowStructuredText {
            idc = 1199;

            text = ""; //--- ToDo: Localize;
            x = "0.288594 * safeZoneW + safeZoneX";
            y = "0.214 * safeZoneH + safeZoneY";
            w = "0.422812 * safeZoneW";
            h = "0.572 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };
    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Niwire)
        ////////////////////////////////////////////////////////

        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;
            text = "$STR_UI_DIAG_RESISTANCE_09";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.236 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.033 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "$STR_UI_DIAG_RESISTANCE_10";
            x = "0.37625 * safeZoneW + safeZoneX";
            y = "0.291 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "[getPos player, 0] spawn OT_fnc_addGarrison";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_UI_DIAG_RESISTANCE_11";
            x = "0.438125 * safeZoneW + safeZoneX";
            y = "0.291 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "[getPos player, 1] spawn OT_fnc_addGarrison";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "$STR_UI_DIAG_RESISTANCE_12";
            x = "0.5 * safeZoneW + safeZoneX";
            y = "0.291 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "[getPos player, 12] spawn OT_fnc_addGarrison";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "$STR_UI_DIAG_RESISTANCE_13";
            x = "0.561875 * safeZoneW + safeZoneX";
            y = "0.291 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "[getPos player, 7] spawn OT_fnc_addGarrison";
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            text = "$STR_UI_DIAG_RESISTANCE_14";
            x = "0.37625 * safeZoneW + safeZoneX";
            y = "0.379 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "[getPos player, 8] spawn OT_fnc_addGarrison";
        };
        class RscButton_1605: RscOverthrowButton {
            idc = 1605;
            text = "$STR_UI_DIAG_RESISTANCE_15";
            x = "0.438125 * safeZoneW + safeZoneX";
            y = "0.379 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "[getPos player, 9] spawn OT_fnc_addGarrison";
        };
        class RscButton_1606: RscOverthrowButton {
            idc = 1606;
            text = "$STR_UI_DIAG_RESISTANCE_16";
            x = "0.5 * safeZoneW + safeZoneX";
            y = "0.379 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "[getPos player, 'HMG'] spawn OT_fnc_addGarrison";
        };
        class RscButton_1607: RscOverthrowButton {
            idc = 1607;
            text = "$STR_UI_DIAG_RESISTANCE_17";
            x = "0.561875 * safeZoneW + safeZoneX";
            y = "0.379 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "[getPos player, 'GMG'] spawn OT_fnc_addGarrison";
        };
        class RscStructuredText_1101: RscOverthrowStructuredText {
            idc = 1101;
            x = "0.314375 * safeZoneW + safeZoneX";
            y = "0.489 * safeZoneH + safeZoneY";
            w = "0.37125 * safeZoneW";
            h = "0.264 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.3};
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};

class OT_dialog_jobs {
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
            onLBSelChanged = "_this call OT_fnc_displayJobDetails";
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
            text = "$STR_UI_DIAG_RESISTANCE_18";
            x = "0.840312 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0515625 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
            action = "[] call OT_fnc_setJobWaypoint;";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_UI_DIAG_RESISTANCE_19";
            x = "0.778437 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
            action = "[] call OT_fnc_clearPlayerWaypoint;";
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

class OT_dialog_logistics {
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
            onLBSelChanged = "_this call OT_fnc_displayLogisticDetails";
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
            text = "$STR_UI_DIAG_RESISTANCE_18";
            x = "0.840312 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0515625 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
            action = "[] call OT_fnc_setVehicleWaypoint;";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_UI_DIAG_RESISTANCE_19";
            x = "0.778437 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0567187 * safeZoneW";
            h = "0.099 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.8};
            action = "[] call OT_fnc_clearPlayerWaypoint;";
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

class OT_dialog_joboffer {
    idd = 8000;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1199: RscOverthrowStructuredText {
            idc = 1199;
            x = "0.329844 * safeZoneW + safeZoneX";
            y = "0.28 * safeZoneH + safeZoneY";
            w = "0.345469 * safeZoneW";
            h = "0.319 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Jeduvu)
        ////////////////////////////////////////////////////////
        class RscButton_1600: RscOverthrowGreenButton {
            idc = 1600;
            text = "$STR_STATISTICS_ACCEPT";
            x = "0.592812 * safeZoneW + safeZoneX";
            y = "0.522 * safeZoneH + safeZoneY";
            w = "0.0773437 * safeZoneW";
            h = "0.066 * safeZoneH";
            action = "[] call OT_fnc_acceptJob;";
            tooltip = "Accept this job (will appear in Jobs screen for all players)";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "$STR_STATISTICS_DENY";
            x = "0.510312 * safeZoneW + safeZoneX";
            y = "0.522 * safeZoneH + safeZoneY";
            w = "0.0773437 * safeZoneW";
            h = "0.066 * safeZoneH";
            action = "[] call OT_fnc_denyJob;";
            tooltip = "Deny this job (will be offered another job if available)";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "$STR_STATISTICS_CANCEL";
            x = "0.335 * safeZoneW + safeZoneX";
            y = "0.522 * safeZoneH + safeZoneY";
            w = "0.0773437 * safeZoneW";
            h = "0.066 * safeZoneH";
            action = "closeDialog 0";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };

};
