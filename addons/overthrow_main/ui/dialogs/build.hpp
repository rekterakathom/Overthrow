class OT_dialog_buildbase {
    idd = -1;
    movingenable = 0;
    onMouseMoving = "_this call buildOnMouseMove";
    onMouseButtonDown = "_this call buildOnMouseDown";
    onMouseButtonUp = "_this call buildOnMouseUp";
    onMouseZChanged = "_this call buildOnMouseWheel";
    onKeyDown = "_this call buildOnKeyDown";
    onKeyUp = "_this call buildOnKeyUp";
    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Qytyja)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "closeDialog 0; [] call cancelBuild;";

            text = "$STR_STATISTICS_CLOSE"; //--- ToDo: Localize;
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.324 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            action = "'Walls' call build";

            text = "Walls"; //--- ToDo: Localize;
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.588 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Stop people (or tanks) from getting in"; //--- ToDo: Localize;
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            action = "'Observation Post' call build";

            text = "Observation Post"; //--- ToDo: Localize;
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Provides intel about the area"; //--- ToDo: Localize;
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            action = "'Bunkers' call build";

            text = "Bunkers"; //--- ToDo: Localize;
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Small defensive structures"; //--- ToDo: Localize;
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            action = "'Workshop' call build";

            text = "Workshop"; //--- ToDo: Localize;
            x = "0.891875 * safeZoneW + safeZoneX";
            y = "0.324 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Modify vehicles"; //--- ToDo: Localize;
        };
        class RscButton_1605: RscOverthrowButton {
            idc = 1605;
            action = "'Helipad' call build";

            text = "Helipad"; //--- ToDo: Localize;
            x = "0.891875 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Apparently helicopters need a place to land"; //--- ToDo: Localize;
        };
        class RscButton_1606: RscOverthrowButton {
            idc = 1606;
            action = "'Refugee Camp' call build";

            text = "Refugee Camp"; //--- ToDo: Localize;
            x = "0.891875 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Helps with recruiting local civilians to your cause."; //--- ToDo: Localize;
        };
        class RscButton_1607: RscOverthrowButton {
            idc = 1607;
            action = "'Training Camp' call build";

            text = "Training Camp"; //--- ToDo: Localize;
            x = "0.891875 * safeZoneW + safeZoneX";
            y = "0.588 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Recruit trained and pre-equipped soldiers"; //--- ToDo: Localize;
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_buildobjective {
    idd = -1;
    movingenable = 0;
    onMouseMoving = "_this call buildOnMouseMove";
    onMouseButtonDown = "_this call buildOnMouseDown";
    onMouseButtonUp = "_this call buildOnMouseUp";
    onMouseZChanged = "_this call buildOnMouseWheel";
    onKeyDown = "_this call buildOnKeyDown";
    onKeyUp = "_this call buildOnKeyUp";
    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Jatizu)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "closeDialog 0; [] call cancelBuild;";

            text = "$STR_STATISTICS_CLOSE";
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.324 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            action = "'Walls' call build";

            text = "$STR_UI_DIAG_BUILD_01";
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.588 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_UI_DIAG_BUILD_02";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            action = "'Observation Post' call build";

            text = "$STR_UI_DIAG_BUILD_03";
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_UI_DIAG_BUILD_04";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            action = "'Bunkers' call build";

            text = "$STR_UI_DIAG_BUILD_05";
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_UI_DIAG_BUILD_06";
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            action = "'Warehouse' call build";

            text = "$STR_UI_DIAG_BUILD_07";
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_UI_DIAG_BUILD_08";
        };
        class RscButton_1605: RscOverthrowButton {
            idc = 1605;
            action = "'Barracks' call build";

            text = "$STR_UI_DIAG_BUILD_09";
            x = "0.891875 * safeZoneW + safeZoneX";
            y = "0.324 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
        };
        class RscButton_1606: RscOverthrowButton {
            idc = 1606;
            action = "'Workshop' call build";

            text = "$STR_UI_DIAG_BUILD_10";
            x = "0.891875 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_UI_DIAG_BUILD_11";
        };
        class RscButton_1607: RscOverthrowButton {
            idc = 1607;
            action = "'Helipad' call build";

            text = "$STR_UI_DIAG_BUILD_12";
            x = "0.891875 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_UI_DIAG_BUILD_13";
        };
        class RscButton_1608: RscOverthrowButton {
            idc = 1608;
            action = "'Guard Tower' call build";

            text = "$STR_UI_DIAG_BUILD_14";
            x = "0.891875 * safeZoneW + safeZoneX";
            y = "0.588 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_UI_DIAG_BUILD_15";
        };
        class RscButton_1609: RscOverthrowButton {
            idc = 1609;
            action = "'Radar' call build";

            text = "$STR_UI_DIAG_BUILD_16";
            x = "0.891875 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_UI_DIAG_BUILD_17";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_buildtown {
    idd = -1;
    movingenable = 0;
    onMouseMoving = "_this call buildOnMouseMove";
    onMouseButtonDown = "_this call buildOnMouseDown";
    onMouseButtonUp = "_this call buildOnMouseUp";
    onMouseZChanged = "_this call buildOnMouseWheel";
    onKeyDown = "_this call buildOnKeyDown";
    onKeyUp = "_this call buildOnKeyUp";
    class controls {
        ////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Satudy)
////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "closeDialog 0; [] call cancelBuild;";

            text = "$STR_STATISTICS_CLOSE";
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.324 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            action = "'Workshop' call build";

            text = "$STR_UI_DIAG_BUILD_10";
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.588 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_UI_DIAG_BUILD_11";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            action = "'House' call build";

            text = "$STR_UI_DIAG_BUILD_18";
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_UI_DIAG_BUILD_19";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            action = "'Warehouse' call build";

            text = "$STR_UI_DIAG_BUILD_07";
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_UI_DIAG_BUILD_08";
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1601;
            action = "'Police Station' call build";

            text = "$STR_UI_DIAG_BUILD_20";
            x = "0.0204687 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.0876563 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "$STR_UI_DIAG_BUILD_21";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_police {
    idd = 9000;
    movingenable = 0;
    class controlsBackground {
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;

            text = "$STR_UI_DIAG_BUILD_22";
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
// GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Pikulu)
////////////////////////////////////////////////////////

        class RscStructuredText_1101: RscOverthrowStructuredText {
            idc = 1101;

            text = "$STR_UI_DIAG_BUILD_23";
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.28 * safeZoneH + safeZoneY";
            w = "0.4125 * safeZoneW";
            h = "0.033 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.1};
            colorActive[] = {0, 0, 0, 1};
        };
        /*
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;

            text = "Transfer 1"; //--- ToDo: Localize;
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.368 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.077 * safeZoneH";
        };
        class RscStructuredText_1102: RscOverthrowStructuredText {
            idc = 1102;

            text = "<t align='center'>Transfer to another station</t>"; //--- ToDo: Localize;
            x = "0.288594 * safeZoneW + safeZoneX";
            y = "0.335 * safeZoneH + safeZoneY";
            w = "0.422812 * safeZoneW";
            h = "0.022 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
            colorActive[] = {0, 0, 0, 0};
        };*/
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "$STR_UI_DIAG_BUILD_24";
            x = "0.288594 * safeZoneW + safeZoneX";
            y = "0.467 * safeZoneH + safeZoneY";
            w = "0.422812 * safeZoneW";
            h = "0.022 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
            colorActive[] = {0, 0, 0, 0};
        };
        class RscStructuredText_1104: RscOverthrowStructuredText {
            idc = 1104;

            text = "$STR_UI_DIAG_BUILD_25";
            x = "0.4175 * safeZoneW + safeZoneX";
            y = "0.632 * safeZoneH + safeZoneY";
            w = "0.170156 * safeZoneW";
            h = "0.088 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.1};
            colorActive[] = {0, 0, 0, 1};
        };
        class RscButton_1608: RscOverthrowButton {
            idc = 1608;

            text = "$STR_UI_DIAG_BUILD_26";
            x = "0.4175 * safeZoneW + safeZoneX";
            y = "0.73 * safeZoneH + safeZoneY";
            w = "0.170156 * safeZoneW";
            h = "0.033 * safeZoneH";
            action = "[] call OT_fnc_editPoliceLoadout";
        };
        /*
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;

            text = "Transfer 2"; //--- ToDo: Localize;
            x = "0.407187 * safeZoneW + safeZoneX";
            y = "0.368 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.077 * safeZoneH";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;

            text = "Transfer 4"; //--- ToDo: Localize;
            x = "0.520625 * safeZoneW + safeZoneX";
            y = "0.368 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.077 * safeZoneH";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;

            text = "Transfer All"; //--- ToDo: Localize;
            x = "0.634062 * safeZoneW + safeZoneX";
            y = "0.368 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.077 * safeZoneH";
        };
        */
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;

            text = "+1"; //--- ToDo: Localize;
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "1 call OT_fnc_addPolice;";
        };
        class RscButton_1605: RscOverthrowButton {
            idc = 1605;

            text = "+2"; //--- ToDo: Localize;
            x = "0.407187 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "2 call OT_fnc_addPolice;";
        };
        class RscButton_1606: RscOverthrowButton {
            idc = 1606;

            text = "+4"; //--- ToDo: Localize;
            x = "0.520625 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "4 call OT_fnc_addPolice;";
        };
        class RscButton_1607: RscOverthrowButton {
            idc = 1607;

            text = "+8"; //--- ToDo: Localize;
            x = "0.634062 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "8 call OT_fnc_addPolice;";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////



    };
};
