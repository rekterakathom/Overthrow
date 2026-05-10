class OT_sleep_dialog {
    idd = 152001;
    name = "sleep";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = " [152001] spawn OT_fnc_dialogFadeIn; ";

    class controlsBackground {
        class Background1: RscText {
            idc = -1;
            fade = 1;
            text = "";
            x = "0.37625 * safeZoneW + safeZoneX";
            y = "0.423 * safeZoneH + safeZoneY";
            w = "0.257813 * safeZoneW";
            h = "0.022 * safeZoneH";
            colorBackground[] = {
                "(profileNamespace getVariable ['GUI_BCG_RGB_R', 0.3843])",
                "(profileNamespace getVariable ['GUI_BCG_RGB_G', 0.7019])",
                "(profileNamespace getVariable ['GUI_BCG_RGB_B', 0.8862])",
                1
            };
        };
        class Background2: RscText {
            idc = -1;
            fade = 1;
            text = "";
            x = "0.37625 * safeZoneW + safeZoneX";
            y = "0.445 * safeZoneH + safeZoneY";
            w = "0.257813 * safeZoneW";
            h = "0.132 * safeZoneH";
            colorBackground[] = {-1, -1, -1, 0.7};
        };
    };

    class controls {
        class Question: RscText {
            idc = -1;
            fade = 1;
            style = 0x02;
            font = "PuristaBold";
            sizeEx = "(((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 0.8)";
            text = "$STR_STATISTICS_SLEEP_ASK";
            x = "0.386562 * safeZoneW + safeZoneX";
            y = "0.456 * safeZoneH + safeZoneY";
            w = "0.237187 * safeZoneW";
            h = "0.033 * safeZoneH";
        };
        class SleepSlider: RscSlider {
            idc = 1;
            fade = 1;
            x = "0.386562 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.237187 * safeZoneW";
            h = "0.022 * safeZoneH";
            onLoad = "(_this # 0) sliderSetRange [1, 48]; OT_sleepTime = 1;";
            onSliderPosChanged = "((findDisplay 152001) displayCtrl 10) ctrlSetText format ['%1 Hour(s)', round (_this # 1)]; OT_sleepTime = (round (_this # 1));";
        };
        class SleepButton: RscButton {
            idc = -1;
            fade = 1;
            text = "$STR_STATISTICS_SLEEP";
            x = "0.494844 * safeZoneW + safeZoneX";
            y = "0.533 * safeZoneH + safeZoneY";
            w = "0.134062 * safeZoneW";
            h = "0.033 * safeZoneH";
            onButtonClick = "[] remoteExec ['OT_fnc_startSleeping', [0, -2] select isDedicated, false]; [] spawn { uiSleep 8; OT_sleepTime remoteExec ['skipTime', 2]; };";
            colorBackground[] = {
                "(profileNamespace getVariable ['GUI_BCG_RGB_R', 0.3843])",
                "(profileNamespace getVariable ['GUI_BCG_RGB_G', 0.7019])",
                "(profileNamespace getVariable ['GUI_BCG_RGB_B', 0.8862])",
                1
            };
        };
        class SelectedTime: RscText {
            idc = 10;
            fade = 1;
            style = 0x02;
            text = "$STR_STATISTICS_SLEEP_HOURS";
            x = "0.386563 * safeZoneW + safeZoneX";
            y = "0.533 * safeZoneH + safeZoneY";
            w = "0.0928125 * safeZoneW";
            h = "0.033 * safeZoneH";
            font = "PuristaMedium";
            onLoad = "(_this # 0) ctrlSetText '1 Hour(s)'";
        };
    };
};
