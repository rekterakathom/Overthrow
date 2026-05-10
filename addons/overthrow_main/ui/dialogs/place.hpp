class OT_dialog_name {
    idd = -1;
    movingenable = 0;
    onKeyDown = "_this call OT_fnc_onNameKeyDown;";

    class controlsBackground {
        class RscStructuredText_1199: RscOverthrowStructuredText {
            idc = 1199;
            x = "0.371094 * safeZoneW + safeZoneX";
            y = "0.368 * safeZoneH + safeZoneY";
            w = "0.252656 * safeZoneW";
            h = "0.176 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Votehi)
        ////////////////////////////////////////////////////////

        class RscEdit_1400: RscOverthrowEdit {
            idc = 1400;
            x = "0.37625 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.242344 * safeZoneW";
            h = "0.055 * safeZoneH";
            text = "Base";
        };
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;
            text = "$STR_UI_DIAG_PLACE_01";
            x = "0.37625 * safeZoneW + safeZoneX";
            y = "0.379 * safeZoneH + safeZoneY";
            w = "0.195937 * safeZoneW";
            h = "0.022 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "$STR_UI_DIAG_PLACE_02";
            x = "0.577344 * safeZoneW + safeZoneX";
            y = "0.478 * safeZoneH + safeZoneY";
            w = "0.04125 * safeZoneW";
            h = "0.055 * safeZoneH";
            action = "_this call OT_fnc_onNameDone";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};

class OT_dialog_input {
    idd = 8001;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1199: RscOverthrowStructuredText {
            idc = 1199;
            x = "0.371094 * safeZoneW + safeZoneX";
            y = "0.368 * safeZoneH + safeZoneY";
            w = "0.252656 * safeZoneW";
            h = "0.176 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Fuxuza)
        ////////////////////////////////////////////////////////

        class RscEdit_1400: RscOverthrowEdit {
            idc = 1400;

            onKeyDown = "private _key = _this select 1; private _name = ctrlText 1400; if (_key == 28 && _name != '') then { [] call OT_inputHandler; closeDialog 0; };";
            text = ""; //--- ToDo: Localize;
            x = "0.37625 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.242344 * safeZoneW";
            h = "0.055 * safeZoneH";
        };
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;

            text = ""; //--- ToDo: Localize;
            x = "0.37625 * safeZoneW + safeZoneX";
            y = "0.379 * safeZoneH + safeZoneY";
            w = "0.195937 * safeZoneW";
            h = "0.022 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            onButtonClick = "_this call OT_inputHandler; closeDialog 0;";
            text = "$STR_UI_DIAG_PLACE_03";
            x = "0.577344 * safeZoneW + safeZoneX";
            y = "0.478 * safeZoneH + safeZoneY";
            w = "0.04125 * safeZoneW";
            h = "0.055 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};

class OT_dialog_place {
    idd = 8002;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1199: RscOverthrowStructuredText {
            idc = 1199;
            x = "-0.000156274 * safeZoneW + safeZoneX";
            y = "0.786 * safeZoneH + safeZoneY";
            w = "1.00031 * safeZoneW";
            h = "0.11 * safeZoneH";
            colorBackground[] = {0.1, 0.1, 0.1, 1};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Jevede)
////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "closeDialog 0; 'Sandbags' spawn OT_fnc_place";

            text = "$STR_UI_DIAG_PLACE_04";
            x = "0.551562 * safeZoneW + safeZoneX";
            y = "0.797 * safeZoneH + safeZoneY";
            w = "0.0928125 * safeZoneW";
            h = "0.088 * safeZoneH";
            tooltip = "$STR_UI_DIAG_PLACE_05";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            action = "closeDialog 0; 'Camo Nets' spawn OT_fnc_place";

            text = "$STR_UI_DIAG_PLACE_06";
            x = "0.7475 * safeZoneW + safeZoneX";
            y = "0.797 * safeZoneH + safeZoneY";
            w = "0.0928125 * safeZoneW";
            h = "0.088 * safeZoneH";
            tooltip = "$STR_UI_DIAG_PLACE_07";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            action = "closeDialog 0; 'Barriers' spawn OT_fnc_place";

            text = "$STR_UI_DIAG_PLACE_08";
            x = "0.649531 * safeZoneW + safeZoneX";
            y = "0.797 * safeZoneH + safeZoneY";
            w = "0.0928125 * safeZoneW";
            h = "0.088 * safeZoneH";
            tooltip = "$STR_UI_DIAG_PLACE_09";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            action = "closeDialog 0; 'Camp' spawn OT_fnc_place";

            text = "$STR_UI_DIAG_PLACE_10";
            x = "0.0617187 * safeZoneW + safeZoneX";
            y = "0.797 * safeZoneH + safeZoneY";
            w = "0.0928125 * safeZoneW";
            h = "0.088 * safeZoneH";
            tooltip = "$STR_UI_DIAG_PLACE_11";
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            action = "closeDialog 0; 'Ammobox' spawn OT_fnc_place";

            text = "$STR_UI_DIAG_PLACE_12";
            x = "0.355625 * safeZoneW + safeZoneX";
            y = "0.797 * safeZoneH + safeZoneY";
            w = "0.0928125 * safeZoneW";
            h = "0.088 * safeZoneH";
            tooltip = "$STR_UI_DIAG_PLACE_13";
        };
        class RscButton_1605: RscOverthrowButton {
            idc = 1605;
            action = "closeDialog 0; 'Misc' spawn OT_fnc_place";

            text = "$STR_UI_DIAG_PLACE_14";
            x = "0.845469 * safeZoneW + safeZoneX";
            y = "0.797 * safeZoneH + safeZoneY";
            w = "0.0928125 * safeZoneW";
            h = "0.088 * safeZoneH";
            tooltip = "$STR_UI_DIAG_PLACE_15";
        };
        class RscButton_1606: RscOverthrowButton {
            idc = 1606;
            action = "closeDialog 0; 'Base' spawn OT_fnc_place";

            text = "$STR_UI_DIAG_PLACE_16";
            x = "0.159687 * safeZoneW + safeZoneX";
            y = "0.797 * safeZoneH + safeZoneY";
            w = "0.0928125 * safeZoneW";
            h = "0.088 * safeZoneH";
            tooltip = "$STR_UI_DIAG_PLACE_17";
        };
        class RscButton_1607: RscOverthrowButton {
            idc = 1607;
            action = "closeDialog 0; 'Map' spawn OT_fnc_place";

            text = "$STR_UI_DIAG_PLACE_18";
            x = "0.257656 * safeZoneW + safeZoneX";
            y = "0.797 * safeZoneH + safeZoneY";
            w = "0.0928125 * safeZoneW";
            h = "0.088 * safeZoneH";
            tooltip = "$STR_UI_DIAG_PLACE_19";
        };
        class RscButton_1608: RscOverthrowButton {
            idc = 1608;
            action = "closeDialog 0; 'Safe' spawn OT_fnc_place";

            text = "$STR_UI_DIAG_PLACE_20";
            x = "0.453594 * safeZoneW + safeZoneX";
            y = "0.797 * safeZoneH + safeZoneY";
            w = "0.0928125 * safeZoneW";
            h = "0.088 * safeZoneH";
            tooltip = "$STR_UI_DIAG_PLACE_21";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};
