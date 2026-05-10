class RscTitles {

    class Default {
        idd = -1;
        fadein = 0;
        fadeout = 0;
        duration = 0;
    };
    class OT_stashHUD {
        idd = 746;
        movingEnable = 0;
        enableSimulation = 1;
        enableDisplay = 1;
        duration = 10e10;
        fadein = 0;
        fadeout = 0;
        name = "OT_stashHUD";
        onLoad = "with uiNamespace do { OT_stashHUD = _this select 0 }";

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
            ////////////////////////////////////////////////////////
            // GUI EDITOR OUTPUT END
            ////////////////////////////////////////////////////////



        };
    };
    class OT_statsHUD {
        idd = 745;
        movingEnable = 0;
        enableSimulation = 1;
        enableDisplay = 1;
        duration = 10e10;
        fadein = 0;
        fadeout = 0;
        name = "OT_statsHUD";
        onLoad = "with uiNamespace do { OT_statsHUD = _this select 0 }";
        class controls {
            class RscStructuredText_1106: RscOverthrowStructuredText {
                idc = 1001;
                x = "safeZoneX + (0.8 * safeZoneW)";
                y = "safeZoneY + (0.15 * safeZoneH)";
                w = "0.19 * safeZoneW";
                h = "0.4 * safeZoneH";
                colorBackground[] = {0, 0, 0, 0.2};
                colorText[] = {0.34, 0.33, 0.33, 0}; //{1, 1, 1, 1}
                text = "";
                shadow = 1;
            };
        };
    };
};
