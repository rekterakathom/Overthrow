class CfgGroups {
    class West {
        class BLU_W_F {
            class Infantry {
				// Recon team for woodland NATO, based on existing recon team for Pacific NATO.
				// The recon units do not exist in vanilla game so they are defined in CfgVehicles.
                class B_W_ReconTeam {
                    name = "$STR_A3_CfgGroups_West_BLU_F_Infantry_BUS_ReconTeam0";
                    side = 1;
                    faction = "BLU_W_F";
                    icon = "\A3\ui_f\data\map\markers\nato\b_recon.paa";
                    class Unit0 {
                        side = 1;
                        vehicle = "B_W_recon_TL_F";
                        rank = "SERGEANT";
                        position[] = {0,0,0};
                    };
                    class Unit1 {
                        side = 1;
                        vehicle = "B_W_recon_M_F";
                        rank = "CORPORAL";
                        position[] = {5,-5,0};
                    };
                    class Unit2 {
                        side = 1;
                        vehicle = "B_W_recon_medic_F";
                        rank = "PRIVATE";
                        position[] = {-5,-5,0};
                    };
                    class Unit3 {
                        side = 1;
                        vehicle = "B_W_recon_LAT_F";
                        rank = "CORPORAL";
                        position[] = {10,-10,0};
                    };
                    class Unit4 {
                        side = 1;
                        vehicle = "B_W_recon_JTAC_F";
                        rank = "PRIVATE";
                        position[] = {-10,-10,0};
                    };
                    class Unit5 {
                        side = 1;
                        vehicle = "B_W_recon_exp_F";
                        rank = "PRIVATE";
                        position[] = {15,-15,0};
                    };
                };
            };
            class Support {
                name = "$STR_A3_CfgGroups_West_BLU_F_Support0";
				// Engineer team for woodland NATO, based on existing engineer team for Pacific NATO.
                class B_W_Support_ENG {
                    name = "$STR_A3_CfgGroups_West_BLU_F_Support_BUS_Support_ENG0";
                    side = 1;
                    faction = "BLU_W_F";
                    icon = "\A3\ui_f\data\map\markers\nato\b_inf.paa";
                    class Unit0 {
                        side = 1;
                        vehicle = "B_W_soldier_TL_F";
                        rank = "SERGEANT";
                        position[] = {0,0,0};
                    };
                    class Unit1 {
                        side = 1;
                        vehicle = "B_W_engineer_F";
                        rank = "CORPORAL";
                        position[] = {5,-5,0};
                    };
                    class Unit2 {
                        side = 1;
                        vehicle = "B_W_engineer_F";
                        rank = "PRIVATE";
                        position[] = {-5,-5,0};
                    };
                    class Unit3 {
                        side = 1;
                        vehicle = "B_W_soldier_repair_F";
                        rank = "PRIVATE";
                        position[] = {10,-5,0};
                    };
                };
            };
        };
    };
};
