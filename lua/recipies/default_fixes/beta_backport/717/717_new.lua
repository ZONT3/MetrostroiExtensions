-- Copyright (c) Anatoly Raev, 2024. All right reserved
-- 
-- Unauthorized copying of any file in this repository, via any medium is strictly prohibited. 
-- All rights reserved by the Civil Code of the Russian Federation, Chapter 70.
-- Proprietary and confidential.
-- ------------
-- Авторские права принадлежат Раеву Анатолию Анатольевичу.
-- 
-- Копирование любого файла, через любой носитель абсолютно запрещено.
-- Все авторские права защищены на основании ГК РФ Глава 70.
-- Автор оставляет за собой право на защиту своих авторских прав согласно законам Российской Федерации.
MEL.DefineRecipe("717_new", "gmod_subway_81-717_mvm")
RECIPE.BackportPriority = 7
function RECIPE:Inject(ent)
    -- Setup door positions
    local function GetDoorPosition(i, k)
        return Vector(359.0 - 35 / 2 - 229.5 * i, -65 * (1 - 2 * k), 7.5)
    end

    ent.LeftDoorPositions = {}
    ent.RightDoorPositions = {}
    for i = 1, 4 do
        table.insert(ent.LeftDoorPositions, GetDoorPosition(i - 1, 1))
        table.insert(ent.RightDoorPositions, GetDoorPosition(i - 1, 0))
    end

    local ARSRelays = {"EK", "EK1", "KPK1", "KPK2", "FMM1", "FMM2", "PD1", "PD2", "ARS_VP", "ARS_RT", "NG", "NH", "BUM_RVD1", "BUM_RVD2", "BUM_RUVD", "BUM_RB", "BUM_TR", "BUM_PTR", "BUM_PTR1", "BUM_EK", "BUM_EK1", "BUM_RVZ1", "BUM_RET", "BUM_LTR1", "BUM_RVT1", "BUM_RVT2", "BUM_RVT4", "BUM_RVT5", "BUM_RIPP", "BUM_PEK", "BUM_KPP", "BSM_GE", "BSM_SIR1", "BSM_SIR2", "BSM_SIR3", "BSM_SIR4", "BSM_SIR5", "BSM_SR1", "BSM_SR2", "BSM_KSR1", "BSM_KSR2", "BSM_KRO", "BSM_KRH", "BSM_KRT", "BSM_BR1", "BSM_BR2", "BSM_PR1", "BSM_RNT", "BSM_RNT1", "BLPM_1R1", "BLPM_1R2", "BLPM_1R3", "BLPM_2R1", "BLPM_2R2", "BLPM_2R3", "BLPM_3R1", "BLPM_3R2", "BLPM_3R3", "BLPM_4R1", "BLPM_4R2", "BLPM_4R3", "BLPM_5R1", "BLPM_5R2", "BLPM_5R3", "BLPM_6R1", "BLPM_6R2", "BLPM_6R3", "BIS_R0", "BIS_R1", "BIS_R2", "BIS_R3", "BIS_R4", "BIS_R5", "BIS_R6", "BIS_R7", "BIS_R8", "BIS_R10",}
    function ent.InitializeSounds(wagon)
        wagon.BaseClass.InitializeSounds(wagon)
        wagon.SoundNames["rolling_5"] = {
            loop = true,
            "subway_trains/common/junk/junk_background3.wav"
        }

        wagon.SoundNames["rolling_10"] = {
            loop = true,
            "subway_trains/717/rolling/10_rolling.wav"
        }

        wagon.SoundNames["rolling_40"] = {
            loop = true,
            "subway_trains/717/rolling/40_rolling.wav"
        }

        wagon.SoundNames["rolling_70"] = {
            loop = true,
            "subway_trains/717/rolling/70_rolling.wav"
        }

        wagon.SoundNames["rolling_80"] = {
            loop = true,
            "subway_trains/717/rolling/80_rolling.wav"
        }

        wagon.SoundPositions["rolling_5"] = {480, 1e12, Vector(0, 0, 0), 0.05}
        wagon.SoundPositions["rolling_10"] = {480, 1e12, Vector(0, 0, 0), 0.1}
        wagon.SoundPositions["rolling_40"] = {480, 1e12, Vector(0, 0, 0), 0.55}
        wagon.SoundPositions["rolling_70"] = {480, 1e12, Vector(0, 0, 0), 0.60}
        wagon.SoundPositions["rolling_80"] = {480, 1e12, Vector(0, 0, 0), 0.75}
        wagon.SoundNames["rolling_32"] = {
            loop = true,
            "subway_trains/717/rolling/rolling_32.wav"
        }

        wagon.SoundNames["rolling_68"] = {
            loop = true,
            "subway_trains/717/rolling/rolling_68.wav"
        }

        wagon.SoundNames["rolling_75"] = {
            loop = true,
            "subway_trains/717/rolling/rolling_75.wav"
        }

        wagon.SoundPositions["rolling_32"] = {480, 1e12, Vector(0, 0, 0), 0.2}
        wagon.SoundPositions["rolling_68"] = {480, 1e12, Vector(0, 0, 0), 0.4}
        wagon.SoundPositions["rolling_75"] = {480, 1e12, Vector(0, 0, 0), 0.8}
        wagon.SoundNames["rolling_motors"] = {
            loop = true,
            "subway_trains/common/junk/wind_background1.wav"
        }

        wagon.SoundNames["rolling_motors2"] = {
            loop = true,
            "subway_trains/common/junk/wind_background1.wav"
        }

        wagon.SoundPositions["rolling_motors"] = {250, 1e12, Vector(200, 0, 0), 0.33}
        wagon.SoundPositions["rolling_motors2"] = {250, 1e12, Vector(-250, 0, 0), 0.33}
        wagon.SoundNames["rolling_low"] = {
            loop = true,
            "subway_trains/717/rolling/rolling_outside_low.wav"
        }

        wagon.SoundNames["rolling_medium1"] = {
            loop = true,
            "subway_trains/717/rolling/rolling_outside_medium1.wav"
        }

        wagon.SoundNames["rolling_medium2"] = {
            loop = true,
            "subway_trains/717/rolling/rolling_outside_medium2.wav"
        }

        wagon.SoundNames["rolling_high2"] = {
            loop = true,
            "subway_trains/717/rolling/rolling_outside_high2.wav"
        }

        wagon.SoundPositions["rolling_low"] = {480, 1e12, Vector(0, 0, 0), 0.6}
        wagon.SoundPositions["rolling_medium1"] = {480, 1e12, Vector(0, 0, 0), 0.90}
        wagon.SoundPositions["rolling_medium2"] = {480, 1e12, Vector(0, 0, 0), 0.90}
        wagon.SoundPositions["rolling_high2"] = {480, 1e12, Vector(0, 0, 0), 1.00}
        wagon.SoundNames["pneumo_disconnect2"] = "subway_trains/common/pneumatic/pneumo_close.mp3"
        wagon.SoundNames["pneumo_disconnect1"] = {"subway_trains/common/pneumatic/pneumo_open.mp3", "subway_trains/common/pneumatic/pneumo_open2.mp3",}
        wagon.SoundPositions["pneumo_disconnect2"] = {60, 1e9, Vector(431.8, -24.1 + 1.5, -33.7), 1}
        wagon.SoundPositions["pneumo_disconnect1"] = {60, 1e9, Vector(431.8, -24.1 + 1.5, -33.7), 1}
        wagon.SoundNames["epv_on"] = "subway_trains/common/pneumatic/epv_on.mp3"
        wagon.SoundNames["epv_off"] = "subway_trains/common/pneumatic/epv_off.mp3"
        wagon.SoundPositions["epv_on"] = {80, 1e9, Vector(437.2, -53.1, -32.0), 0.85}
        wagon.SoundPositions["epv_off"] = {80, 1e9, Vector(437.2, -53.1, -32.0), 0.85}
        wagon.SoundPositions["epv_off"] = {60, 1e9, Vector(437.2, -53.1, -32.0), 0.85}
        -- Релюшки
        --wagon.SoundNames["rpb_on"] = "subway_trains/717/relays/new/ro_off.mp3"
        --wagon.SoundNames["rpb_off"] = "subway_trains/717/relays/ro_on.mp3"
        wagon.SoundNames["rpb_on"] = "subway_trains/717/relays/rev813t_on1.mp3"
        wagon.SoundNames["rpb_off"] = "subway_trains/717/relays/rev813t_off1.mp3"
        wagon.SoundPositions["rpb_on"] = {80, 1e9, Vector(440, 16, 66), 1}
        wagon.SoundPositions["rpb_off"] = {80, 1e9, Vector(440, 16, 66), 0.7}
        --wagon.SoundNames["rvt_on"] = "subway_trains/717/relays/new/rvt_on1.mp3"
        --wagon.SoundNames["rvt_off"] = "subway_trains/717/relays/new/rvt_off.mp3"
        wagon.SoundNames["rvt_on"] = "subway_trains/717/relays/rev811t_on2.mp3"
        wagon.SoundNames["rvt_off"] = "subway_trains/717/relays/rev811t_off1.mp3"
        wagon.SoundPositions["rvt_on"] = {80, 1e9, Vector(440, 18, 66), 1}
        wagon.SoundPositions["rvt_off"] = {80, 1e9, Vector(440, 18, 66), 0.7}
        --wagon.SoundNames["k6_on"] = "subway_trains/717/relays/new/k6_on1.mp3"
        --wagon.SoundNames["k6_off"] = "subway_trains/717/relays/new/k6_off.mp3"
        wagon.SoundNames["k6_on"] = "subway_trains/717/relays/tkpm121_on1.mp3"
        wagon.SoundNames["k6_off"] = "subway_trains/717/relays/tkpm121_off1.mp3"
        wagon.SoundPositions["k6_on"] = {80, 1e9, Vector(440, 20, 66), 1}
        wagon.SoundPositions["k6_off"] = {80, 1e9, Vector(440, 20, 66), 1}
        --wagon.SoundNames["r1_5_on"] = "subway_trains/717/relays/new/r1_5_on.mp3"
        --wagon.SoundNames["r1_5_off"] = "subway_trains/717/relays/new/r1_5_off.mp3"
        wagon.SoundNames["r1_5_on"] = "subway_trains/717/relays/kpd110e_on1.mp3" --,"subway_trains/717/relays/kpd110e_on2.mp3"}
        wagon.SoundNames["r1_5_off"] = "subway_trains/717/relays/kpd110e_off1.mp3" --,"subway_trains/717/relays/kpd110e_off2.mp3"}
        wagon.SoundPositions["r1_5_on"] = {80, 1e9, Vector(440, 22, 66), 1}
        wagon.SoundPositions["r1_5_off"] = {80, 1e9, Vector(440, 22, 66), 0.7}
        wagon.SoundNames["rot_off"] = "subway_trains/717/relays/lsd_2.mp3"
        wagon.SoundNames["rot_on"] = "subway_trains/717/relays/relay_on.mp3"
        wagon.SoundPositions["rot_on"] = {80, 1e9, Vector(380, -40, 40), 0.25}
        wagon.SoundPositions["rot_off"] = {80, 1e9, Vector(380, -40, 40), 0.25}
        --wagon.SoundNames["k25_on"] = "subway_trains/717/relays/new/k25_on.mp3"
        --wagon.SoundNames["k25_off"] = "subway_trains/717/relays/new/k25_off.mp3"
        wagon.SoundNames["k25_on"] = wagon.SoundNames["r1_5_on"]
        wagon.SoundNames["k25_off"] = wagon.SoundNames["r1_5_off"]
        wagon.SoundPositions["k25_on"] = {80, 1e9, Vector(440, -16, 66), 1}
        wagon.SoundPositions["k25_off"] = {80, 1e9, Vector(440, -16, 66), 0.7}
        --wagon.SoundNames["rp8_off"] = "subway_trains/717/relays/lsd_2.mp3"
        --wagon.SoundNames["rp8_on"] = "subway_trains/717/relays/rp8_on.wav"
        wagon.SoundNames["rp8_off"] = "subway_trains/717/relays/rev811t_off2.mp3"
        wagon.SoundNames["rp8_on"] = "subway_trains/717/relays/rev811t_on3.mp3"
        wagon.SoundPositions["rp8_on"] = {80, 1e9, Vector(440, -18, 66), 1}
        wagon.SoundPositions["rp8_off"] = {80, 1e9, Vector(440, -18, 66), 0.3}
        --wagon.SoundNames["kd_off"] = "subway_trains/717/relays/lsd_2.mp3"
        --wagon.SoundNames["kd_on"] = "subway_trains/717/relays/new/kd_on.mp3"
        wagon.SoundNames["kd_off"] = wagon.SoundNames["rp8_off"]
        wagon.SoundNames["kd_on"] = wagon.SoundNames["rp8_on"]
        wagon.SoundPositions["kd_on"] = {80, 1e9, Vector(440, -20, 66), 1}
        wagon.SoundPositions["kd_off"] = {80, 1e9, Vector(440, -20, 66), 0.7}
        --wagon.SoundNames["ro_on"] = "subway_trains/717/relays/ro_on.mp3"
        --wagon.SoundNames["ro_off"] = "subway_trains/717/relays/new/ro_off.mp3"
        wagon.SoundNames["ro_on"] = wagon.SoundNames["r1_5_on"]
        wagon.SoundNames["ro_off"] = wagon.SoundNames["r1_5_off"]
        wagon.SoundPositions["ro_on"] = {80, 1e9, Vector(440, -22, 66), 1}
        wagon.SoundPositions["ro_off"] = {80, 1e9, Vector(440, -22, 66), 0.7}
        wagon.SoundNames["kk_off"] = "subway_trains/717/relays/lsd_2.mp3"
        wagon.SoundNames["kk_on"] = "subway_trains/717/relays/lsd_1.mp3"
        wagon.SoundPositions["kk_on"] = {80, 1e9, Vector(280, 40, -30), 0.85}
        wagon.SoundPositions["kk_off"] = {80, 1e9, Vector(280, 40, -30), 0.85}
        wagon.SoundNames["avu_off"] = "subway_trains/common/pneumatic/ak11b_off.mp3"
        wagon.SoundNames["avu_on"] = "subway_trains/common/pneumatic/ak11b_on.mp3"
        wagon.SoundPositions["avu_on"] = {60, 1e9, Vector(432.4, -59.4, -31.6), 0.7}
        wagon.SoundPositions["avu_off"] = wagon.SoundPositions["avu_on"]
        --wagon.SoundNames["avu_off"] = "subway_trains/717/relays/lsd_2.mp3"
        --wagon.SoundNames["avu_on"] = "subway_trains/717/relays/relay_on.mp3"
        --wagon.SoundPositions["avu_off"] = {60,1e9, Vector(436.0,-63,-25),1}
        --wagon.SoundNames["r1_5_close"] = {"subway_trains/drive_on3.wav","subway_trains/drive_on4.wav"}
        wagon.SoundNames["bpsn1"] = {
            "subway_trains/717/bpsn/bpsn_ohigh.wav",
            loop = true
        }

        wagon.SoundNames["bpsn2"] = {
            "subway_trains/717/bpsn/old.wav",
            loop = true
        }

        wagon.SoundNames["bpsn3"] = {
            "subway_trains/717/bpsn/bpsn_olow.wav",
            loop = true
        }

        wagon.SoundNames["bpsn4"] = {
            "subway_trains/717/bpsn/bpsn_spb.wav",
            loop = true
        }

        wagon.SoundNames["bpsn5"] = {
            "subway_trains/717/bpsn/bpsn_tkl.wav",
            loop = true
        }

        wagon.SoundNames["bpsn6"] = {
            "subway_trains/717/bpsn/bpsn_nnov.wav",
            loop = true
        }

        wagon.SoundNames["bpsn7"] = {
            "subway_trains/717/bpsn/bpsn_kiyv.wav",
            loop = true
        }

        wagon.SoundNames["bpsn8"] = {
            "subway_trains/717/bpsn/bpsn_old.wav",
            loop = true
        }

        wagon.SoundNames["bpsn9"] = {
            "subway_trains/717/bpsn/bpsn_1.wav",
            loop = true
        }

        wagon.SoundNames["bpsn10"] = {
            "subway_trains/717/bpsn/bpsn_2.wav",
            loop = true
        }

        wagon.SoundNames["bpsn11"] = {
            "subway_trains/717/bpsn/bpsn_piter.wav",
            loop = true
        }

        wagon.SoundNames["bpsn12"] = {
            "subway_trains/717/bpsn/bpsn1.wav",
            loop = true
        }

        wagon.SoundPositions["bpsn1"] = {600, 1e9, Vector(0, 45, -448), 0.02}
        wagon.SoundPositions["bpsn2"] = {600, 1e9, Vector(0, 45, -448), 0.03}
        wagon.SoundPositions["bpsn3"] = {600, 1e9, Vector(0, 45, -448), 0.02}
        wagon.SoundPositions["bpsn4"] = {600, 1e9, Vector(0, 45, -448), 0.025}
        wagon.SoundPositions["bpsn5"] = {600, 1e9, Vector(0, 45, -448), 0.08}
        wagon.SoundPositions["bpsn6"] = {600, 1e9, Vector(0, 45, -448), 0.03}
        wagon.SoundPositions["bpsn7"] = {600, 1e9, Vector(0, 45, -448), 0.02}
        wagon.SoundPositions["bpsn8"] = {600, 1e9, Vector(0, 45, -448), 0.03}
        wagon.SoundPositions["bpsn9"] = {600, 1e9, Vector(0, 45, -448), 0.02}
        wagon.SoundPositions["bpsn10"] = {600, 1e9, Vector(0, 45, -448), 0.02}
        wagon.SoundPositions["bpsn11"] = {600, 1e9, Vector(0, 45, -448), 0.04}
        wagon.SoundPositions["bpsn12"] = {600, 1e9, Vector(0, 45, -448), 0.04}
        --Подвагонка
        wagon.SoundNames["lk2_on"] = "subway_trains/717/pneumo/lk2_on.mp3"
        wagon.SoundNames["lk5_on"] = "subway_trains/717/pneumo/lk1_on.mp3"
        wagon.SoundNames["lk2_off"] = "subway_trains/717/pneumo/lk2_off.mp3"
        wagon.SoundNames["lk2c"] = "subway_trains/717/pneumo/ksh1.mp3"
        wagon.SoundNames["lk3_on"] = "subway_trains/717/pneumo/lk3_on.mp3"
        wagon.SoundNames["lk3_off"] = "subway_trains/717/pneumo/lk3_off.mp3"
        --wagon.SoundNames["ksh1_off"] = "subway_trains/717/pneumo/ksh1.mp3"
        wagon.SoundPositions["lk2_on"] = {440, 1e9, Vector(-60, -40, -66), 0.22}
        wagon.SoundPositions["lk5_on"] = {440, 1e9, Vector(-60, -40, -66), 0.30}
        wagon.SoundPositions["lk2_off"] = wagon.SoundPositions["lk2_on"]
        wagon.SoundPositions["lk2c"] = {440, 1e9, Vector(-60, -40, -66), 0.6}
        wagon.SoundPositions["lk3_on"] = wagon.SoundPositions["lk2_on"]
        wagon.SoundPositions["lk3_off"] = wagon.SoundPositions["lk2_on"]
        --wagon.SoundPositions["ksh1_off"] = wagon.SoundPositions["lk1_on"]
        wagon.SoundNames["compressor"] = {
            loop = 2.0,
            "subway_trains/d/pneumatic/compressor/compessor_d_start.wav",
            "subway_trains/d/pneumatic/compressor/compessor_d_loop.wav",
            "subway_trains/d/pneumatic/compressor/compessor_d_end.wav"
        }

        wagon.SoundNames["compressor2"] = {
            loop = 1.79,
            "subway_trains/717/compressor/compressor_717_start2.wav",
            "subway_trains/717/compressor/compressor_717_loop2.wav",
            "subway_trains/717/compressor/compressor_717_stop2.wav"
        }

        wagon.SoundPositions["compressor"] = {600, 1e9, Vector(-118, -40, -66), 0.15}
        wagon.SoundPositions["compressor2"] = {480, 1e9, Vector(-118, -40, -66), 0.55}
        wagon.SoundNames["rk"] = {
            loop = 0.8,
            "subway_trains/717/rk/rk_start.wav",
            "subway_trains/717/rk/rk_spin.wav",
            "subway_trains/717/rk/rk_stop.mp3"
        }

        wagon.SoundPositions["rk"] = {70, 1e3, Vector(110, -40, -75), 0.5}
        wagon.SoundNames["revers_0-f"] = {"subway_trains/717/kv70/reverser_0-f_1.mp3", "subway_trains/717/kv70/reverser_0-f_2.mp3"}
        wagon.SoundNames["revers_f-0"] = {"subway_trains/717/kv70/reverser_f-0_1.mp3", "subway_trains/717/kv70/reverser_f-0_2.mp3"}
        wagon.SoundNames["revers_0-b"] = {"subway_trains/717/kv70/reverser_0-b_1.mp3", "subway_trains/717/kv70/reverser_0-b_2.mp3"}
        wagon.SoundNames["revers_b-0"] = {"subway_trains/717/kv70/reverser_b-0_1.mp3", "subway_trains/717/kv70/reverser_b-0_2.mp3"}
        wagon.SoundNames["revers_in"] = {"subway_trains/717/kv70/reverser_in1.mp3", "subway_trains/717/kv70/reverser_in2.mp3", "subway_trains/717/kv70/reverser_in3.mp3"}
        wagon.SoundNames["revers_out"] = {"subway_trains/717/kv70/reverser_out1.mp3", "subway_trains/717/kv70/reverser_out2.mp3"}
        wagon.SoundPositions["revers_0-f"] = {80, 1e9, Vector(445.5, -32 + 1.7, -7.5), 0.85}
        wagon.SoundPositions["revers_f-0"] = {80, 1e9, Vector(445.5, -32 + 1.7, -7.5), 0.85}
        wagon.SoundPositions["revers_0-b"] = {80, 1e9, Vector(445.5, -32 + 1.7, -7.5), 0.85}
        wagon.SoundPositions["revers_b-0"] = {80, 1e9, Vector(445.5, -32 + 1.7, -7.5), 0.85}
        wagon.SoundPositions["revers_in"] = {80, 1e9, Vector(445.5, -32 + 1.7, -7.5), 0.85}
        wagon.SoundPositions["revers_out"] = {80, 1e9, Vector(445.5, -32 + 1.7, -7.5), 0.85}
        wagon.SoundNames["kru_in"] = {"subway_trains/717/kru/kru_insert1.mp3", "subway_trains/717/kru/kru_insert2.mp3"}
        wagon.SoundPositions["kru_in"] = {80, 1e9, Vector(452.3, -24.0, 4.0)}
        wagon.SoundNames["kru_out"] = {"subway_trains/717/kru/kru_eject1.mp3", "subway_trains/717/kru/kru_eject2.mp3", "subway_trains/717/kru/kru_eject3.mp3",}
        wagon.SoundPositions["kru_out"] = {80, 1e9, Vector(452.3, -24.0, 4.0)}
        wagon.SoundNames["kru_0_1"] = {"subway_trains/717/kru/kru0-1_1.mp3", "subway_trains/717/kru/kru0-1_2.mp3", "subway_trains/717/kru/kru0-1_3.mp3", "subway_trains/717/kru/kru0-1_4.mp3",}
        wagon.SoundNames["kru_1_2"] = {"subway_trains/717/kru/kru1-2_1.mp3", "subway_trains/717/kru/kru1-2_2.mp3", "subway_trains/717/kru/kru1-2_3.mp3", "subway_trains/717/kru/kru1-2_4.mp3",}
        wagon.SoundNames["kru_2_1"] = {"subway_trains/717/kru/kru2-1_1.mp3", "subway_trains/717/kru/kru2-1_2.mp3", "subway_trains/717/kru/kru2-1_3.mp3", "subway_trains/717/kru/kru2-1_4.mp3",}
        wagon.SoundNames["kru_1_0"] = {"subway_trains/717/kru/kru1-0_1.mp3", "subway_trains/717/kru/kru1-0_2.mp3", "subway_trains/717/kru/kru1-0_3.mp3", "subway_trains/717/kru/kru1-0_4.mp3",}
        wagon.SoundNames["kru_2_3"] = {"subway_trains/717/kru/kru2-3_1.mp3", "subway_trains/717/kru/kru2-3_2.mp3", "subway_trains/717/kru/kru2-3_3.mp3", "subway_trains/717/kru/kru2-3_4.mp3",}
        wagon.SoundNames["kru_3_2"] = {"subway_trains/717/kru/kru3-2_1.mp3", "subway_trains/717/kru/kru3-2_2.mp3", "subway_trains/717/kru/kru3-2_3.mp3", "subway_trains/717/kru/kru3-2_4.mp3",}
        wagon.SoundPositions["kru_0_1"] = {80, 1e9, Vector(452.3, -24.0, 4.0)}
        wagon.SoundPositions["kru_1_2"] = {80, 1e9, Vector(452.3, -24.0, 4.0)}
        wagon.SoundPositions["kru_2_1"] = {80, 1e9, Vector(452.3, -24.0, 4.0)}
        wagon.SoundPositions["kru_1_0"] = {80, 1e9, Vector(452.3, -24.0, 4.0)}
        wagon.SoundPositions["kru_2_3"] = {80, 1e9, Vector(452.3, -24.0, 4.0)}
        wagon.SoundPositions["kru_3_2"] = {80, 1e9, Vector(452.3, -24.0, 4.0)}
        --[[wagon.SoundNames["pvk_0_1"] = "subway_trains/717/switches/vent0-1.mp3"
        wagon.SoundNames["pvk_1_2"] = "subway_trains/717/switches/vent1-2.mp3"
        wagon.SoundNames["pvk_2_1"] = "subway_trains/717/switches/vent2-1.mp3"
        wagon.SoundNames["pvk_1_0"] = "subway_trains/717/switches/vent1-0.mp3"]]
        --wagon.SoundNames["pvk_0_1"] = "subway_trains/717/switches/vent0-1.mp3"
        wagon.SoundNames["pvk2"] = "subway_trains/717/switches/vent1-2.mp3"
        wagon.SoundNames["pvk1"] = "subway_trains/717/switches/vent2-1.mp3"
        wagon.SoundNames["pvk0"] = "subway_trains/717/switches/vent1-0.mp3"
        wagon.SoundNames["vent_cabl"] = {
            loop = true,
            "subway_trains/717/vent/vent_cab_low.wav"
        }

        wagon.SoundPositions["vent_cabl"] = {140, 1e9, Vector(450.7, 44.5, -11.9), 0.66}
        wagon.SoundNames["vent_cabh"] = {
            loop = true,
            "subway_trains/717/vent/vent_cab_high.wav"
        }

        wagon.SoundPositions["vent_cabh"] = wagon.SoundPositions["vent_cabl"]
        for i = 1, 7 do
            wagon.SoundNames["vent" .. i] = {
                loop = true,
                "subway_trains/717/vent/vent_cab_" .. (i == 7 and "low" or "high") .. ".wav"
            }
        end

        wagon.SoundPositions["vent1"] = {120, 1e9, Vector(225, -50, -37.5), 0.23}
        wagon.SoundPositions["vent2"] = {120, 1e9, Vector(-5, 50, -37.5), 0.23}
        wagon.SoundPositions["vent3"] = {120, 1e9, Vector(-230, -50, -37.5), 0.23}
        wagon.SoundPositions["vent4"] = {120, 1e9, Vector(225, 50, -37.5), 0.23}
        wagon.SoundPositions["vent5"] = {120, 1e9, Vector(-5, -50, -37.5), 0.23}
        wagon.SoundPositions["vent6"] = {120, 1e9, Vector(-230, 50, -37.5), 0.23}
        wagon.SoundPositions["vent7"] = {120, 1e9, Vector(-432, -50, -37.5), 0.23}
        wagon.SoundNames["kr_open"] = {"subway_trains/717/cover/cover_open1.mp3", "subway_trains/717/cover/cover_open2.mp3", "subway_trains/717/cover/cover_open3.mp3",}
        wagon.SoundNames["kr_close"] = {"subway_trains/717/cover/cover_close1.mp3", "subway_trains/717/cover/cover_close2.mp3", "subway_trains/717/cover/cover_close3.mp3",}
        wagon.SoundNames["switch_off"] = {"subway_trains/717/switches/tumbler_slim_off1.mp3", "subway_trains/717/switches/tumbler_slim_off2.mp3", "subway_trains/717/switches/tumbler_slim_off3.mp3", "subway_trains/717/switches/tumbler_slim_off4.mp3",}
        wagon.SoundNames["switch_on"] = {"subway_trains/717/switches/tumbler_slim_on1.mp3", "subway_trains/717/switches/tumbler_slim_on2.mp3", "subway_trains/717/switches/tumbler_slim_on3.mp3", "subway_trains/717/switches/tumbler_slim_on4.mp3",}
        wagon.SoundNames["switchbl_off"] = {"subway_trains/717/switches/tumbler_fatb_off1.mp3", "subway_trains/717/switches/tumbler_fatb_off2.mp3", "subway_trains/717/switches/tumbler_fatb_off3.mp3",}
        wagon.SoundNames["switchbl_on"] = {"subway_trains/717/switches/tumbler_fatb_on1.mp3", "subway_trains/717/switches/tumbler_fatb_on2.mp3", "subway_trains/717/switches/tumbler_fatb_on3.mp3",}
        wagon.SoundNames["triple_down-0"] = {"subway_trains/717/switches/tumbler_triple_down-0_1.mp3", "subway_trains/717/switches/tumbler_triple_down-0_2.mp3",}
        wagon.SoundNames["triple_0-up"] = {"subway_trains/717/switches/tumbler_triple_0-up_1.mp3", "subway_trains/717/switches/tumbler_triple_0-up_2.mp3",}
        wagon.SoundNames["triple_up-0"] = {"subway_trains/717/switches/tumbler_triple_up-0_1.mp3", "subway_trains/717/switches/tumbler_triple_up-0_2.mp3",}
        wagon.SoundNames["triple_0-down"] = {"subway_trains/717/switches/tumbler_triple_0-down_1.mp3", "subway_trains/717/switches/tumbler_triple_0-down_2.mp3",}
        wagon.SoundNames["button1_off"] = {"subway_trains/717/switches/button1_off1.mp3", "subway_trains/717/switches/button1_off2.mp3", "subway_trains/717/switches/button1_off3.mp3",}
        wagon.SoundNames["button1_on"] = {"subway_trains/717/switches/button1_on1.mp3", "subway_trains/717/switches/button1_on2.mp3", "subway_trains/717/switches/button1_on3.mp3",}
        wagon.SoundNames["button2_off"] = {"subway_trains/717/switches/button2_off1.mp3", "subway_trains/717/switches/button2_off2.mp3",}
        wagon.SoundNames["button2_on"] = {"subway_trains/717/switches/button2_on1.mp3", "subway_trains/717/switches/button2_on2.mp3",}
        wagon.SoundNames["button3_off"] = {"subway_trains/717/switches/button3_off1.mp3", "subway_trains/717/switches/button3_off2.mp3",}
        wagon.SoundNames["button3_on"] = {"subway_trains/717/switches/button3_on1.mp3", "subway_trains/717/switches/button3_on2.mp3",}
        wagon.SoundNames["button4_off"] = {"subway_trains/717/switches/button4_off1.mp3", "subway_trains/717/switches/button4_off2.mp3",}
        wagon.SoundNames["button4_on"] = {"subway_trains/717/switches/button4_on1.mp3", "subway_trains/717/switches/button4_on2.mp3",}
        wagon.SoundNames["uava_reset"] = {"subway_trains/common/uava/uava_reset1.mp3", "subway_trains/common/uava/uava_reset2.mp3", "subway_trains/common/uava/uava_reset4.mp3",}
        wagon.SoundPositions["uava_reset"] = {80, 1e9, Vector(429.6, -60.8, -15.9), 0.95}
        wagon.SoundNames["gv_f"] = {"subway_trains/717/kv70/reverser_0-b_1.mp3", "subway_trains/717/kv70/reverser_0-b_2.mp3"}
        wagon.SoundNames["gv_b"] = {"subway_trains/717/kv70/reverser_b-0_1.mp3", "subway_trains/717/kv70/reverser_b-0_2.mp3"}
        wagon.SoundNames["pneumo_TL_open"] = {"subway_trains/ezh3/pneumatic/brake_line_on.mp3", "subway_trains/ezh3/pneumatic/brake_line_on2.mp3",}
        wagon.SoundNames["pneumo_TL_disconnect"] = {"subway_trains/common/334/334_close.mp3",}
        wagon.SoundPositions["pneumo_TL_open"] = {60, 1e9, Vector(431.8, -24.1 + 1.5, -33.7), 0.7}
        wagon.SoundPositions["pneumo_TL_disconnect"] = {60, 1e9, Vector(431.8, -24.1 + 1.5, -33.7), 0.7}
        wagon.SoundNames["pneumo_BL_disconnect"] = {"subway_trains/common/334/334_close.mp3",}
        wagon.SoundNames["disconnect_valve"] = "subway_trains/common/switches/pneumo_disconnect_switch.mp3"
        wagon.SoundNames["brake_f"] = {"subway_trains/common/pneumatic/vz_brake_on2.mp3", "subway_trains/common/pneumatic/vz_brake_on3.mp3", "subway_trains/common/pneumatic/vz_brake_on4.mp3"}
        wagon.SoundPositions["brake_f"] = {50, 1e9, Vector(317 - 8, 0, -82), 0.13}
        wagon.SoundNames["brake_b"] = wagon.SoundNames["brake_f"]
        wagon.SoundPositions["brake_b"] = {50, 1e9, Vector(-317 + 0, 0, -82), 0.13}
        wagon.SoundNames["release1"] = {
            loop = true,
            "subway_trains/common/pneumatic/release_0.wav"
        }

        wagon.SoundPositions["release1"] = {350, 1e9, Vector(-183, 0, -70), 1}
        wagon.SoundNames["release2"] = {
            loop = true,
            "subway_trains/common/pneumatic/release_low.wav"
        }

        wagon.SoundPositions["release2"] = {350, 1e9, Vector(-183, 0, -70), 0.4}
        wagon.SoundNames["parking_brake"] = {
            loop = true,
            "subway_trains/common/pneumatic/parking_brake.wav"
        }

        wagon.SoundNames["parking_brake_en"] = "subway_trains/common/pneumatic/parking_brake_stop.mp3"
        wagon.SoundNames["parking_brake_rel"] = "subway_trains/common/pneumatic/parking_brake_stop2.mp3"
        wagon.SoundPositions["parking_brake"] = {80, 1e9, Vector(453.6, -0.25, -39.8), 0.6}
        wagon.SoundPositions["parking_brake_en"] = wagon.SoundPositions["parking_brake"]
        wagon.SoundPositions["parking_brake_rel"] = wagon.SoundPositions["parking_brake"]
        wagon.SoundNames["front_isolation"] = {
            loop = true,
            "subway_trains/common/pneumatic/isolation_leak.wav"
        }

        wagon.SoundPositions["front_isolation"] = {300, 1e9, Vector(443, 0, -63), 1}
        wagon.SoundNames["rear_isolation"] = {
            loop = true,
            "subway_trains/common/pneumatic/isolation_leak.wav"
        }

        wagon.SoundPositions["rear_isolation"] = {300, 1e9, Vector(-456, 0, -63), 1}
        wagon.SoundNames["crane013_brake"] = {
            loop = true,
            "subway_trains/common/pneumatic/release_2.wav"
        }

        wagon.SoundPositions["crane013_brake"] = {400, 1e9, Vector(431.5, -20.3, -12), 0.86}
        wagon.SoundNames["crane013_brake2"] = {
            loop = true,
            "subway_trains/common/pneumatic/013_brake2.wav"
        }

        wagon.SoundPositions["crane013_brake2"] = {400, 1e9, Vector(431.5, -20.3, -12), 0.86}
        wagon.SoundNames["crane013_brake_l"] = {
            loop = true,
            "subway_trains/common/pneumatic/013_brake_loud2.wav"
        }

        wagon.SoundPositions["crane013_brake_l"] = {400, 1e9, Vector(431.5, -20.3, -12), 0.7}
        wagon.SoundNames["crane013_release"] = {
            loop = true,
            "subway_trains/common/pneumatic/013_release.wav"
        }

        wagon.SoundPositions["crane013_release"] = {80, 1e9, Vector(431.5, -20.3, -12), 0.4}
        wagon.SoundNames["crane334_brake_high"] = {
            loop = true,
            "subway_trains/common/pneumatic/334_brake.wav"
        }

        wagon.SoundPositions["crane334_brake_high"] = {80, 1e9, Vector(432.27, -22.83, -8.2), 0.85}
        wagon.SoundNames["crane334_brake_low"] = {
            loop = true,
            "subway_trains/common/pneumatic/334_brake_slow.wav"
        }

        wagon.SoundPositions["crane334_brake_low"] = {80, 1e9, Vector(432.27, -22.83, -8.2), 0.75}
        wagon.SoundNames["crane334_brake_2"] = {
            loop = true,
            "subway_trains/common/pneumatic/334_brake_slow.wav"
        }

        wagon.SoundPositions["crane334_brake_2"] = {80, 1e9, Vector(432.27, -22.83, -8.2), 0.85}
        wagon.SoundNames["crane334_brake_eq_high"] = {
            loop = true,
            "subway_trains/common/pneumatic/334_release_reservuar.wav"
        }

        wagon.SoundPositions["crane334_brake_eq_high"] = {80, 1e9, Vector(432.27, -22.83, -70.2), 0.2}
        wagon.SoundNames["crane334_brake_eq_low"] = {
            loop = true,
            "subway_trains/common/pneumatic/334_brake_slow2.wav"
        }

        wagon.SoundPositions["crane334_brake_eq_low"] = {80, 1e9, Vector(432.27, -22.83, -70.2), 0.2}
        wagon.SoundNames["crane334_release"] = {
            loop = true,
            "subway_trains/common/pneumatic/334_release3.wav"
        }

        wagon.SoundPositions["crane334_release"] = {80, 1e9, Vector(432.27, -22.83, -8.2), 0.2}
        wagon.SoundNames["crane334_release_2"] = {
            loop = true,
            "subway_trains/common/pneumatic/334_release2.wav"
        }

        wagon.SoundPositions["crane334_release_2"] = {80, 1e9, Vector(432.27, -22.83, -8.2), 0.2}
        wagon.SoundNames["epk_brake"] = {
            loop = true,
            "subway_trains/common/pneumatic/epv_loop.wav"
        }

        wagon.SoundPositions["epk_brake"] = {80, 1e9, Vector(437.2, -53.1, -32.0), 0.65}
        wagon.SoundNames["valve_brake"] = {
            loop = true,
            "subway_trains/common/pneumatic/epv_loop.wav"
        }

        wagon.SoundPositions["valve_brake"] = {80, 1e9, Vector(408.45, 62.15, 11.5), 1}
        --[[ wagon.SoundNames["valve_brake_l"] = {loop=true,"subway_trains/common/pneumatic/emer_low.wav"}
        wagon.SoundNames["valve_brake_m"] = {loop=true,"subway_trains/common/pneumatic/emer_medium.wav"}
        wagon.SoundNames["valve_brake_h"] = {loop=true,"subway_trains/common/pneumatic/emer_high.wav"}
        wagon.SoundPositions["valve_brake_l"] = {80,1e9,Vector(408.45,62.15,11.5),0.3}
        wagon.SoundPositions["valve_brake_m"] = {80,1e9,Vector(408.45,62.15,11.5),0.4}
        wagon.SoundPositions["valve_brake_h"] = {80,1e9,Vector(408.45,62.15,11.5),1}--]]
        wagon.SoundNames["emer_brake"] = {
            loop = true,
            "subway_trains/common/pneumatic/autostop_loop.wav"
        }

        wagon.SoundNames["emer_brake2"] = {
            loop = true,
            "subway_trains/common/pneumatic/autostop_loop_2.wav"
        }

        wagon.SoundPositions["emer_brake"] = {600, 1e9, Vector(345, -55, -84), 0.95}
        wagon.SoundPositions["emer_brake2"] = {600, 1e9, Vector(345, -55, -84), 1}
        wagon.SoundNames["pak_on"] = "subway_trains/717/switches/rc_on.mp3"
        wagon.SoundNames["pak_off"] = "subway_trains/717/switches/rc_off.mp3"
        --[[wagon.SoundNames["kv70_fix_on"] = {"subway_trains/717/kv70/kv70_fix_on1.mp3","subway_trains/717/kv70/kv70_fix_on2.mp3"}
        wagon.SoundNames["kv70_fix_off"] = {"subway_trains/717/kv70/kv70_fix_off1.mp3","subway_trains/717/kv70/kv70_fix_off2.mp3"}
        wagon.SoundNames["kv70_t1_0_fix"]= {"subway_trains/717/kv70/kv70_t1-0_fix_1.mp3","subway_trains/717/kv70/kv70_t1-0_fix_2.mp3","subway_trains/717/kv70/kv70_t1-0_fix_3.mp3","subway_trains/717/kv70/kv70_t1-0_fix_4.mp3"}
        wagon.SoundNames["kv70_0_t1"] = {"subway_trains/ezh/kv40/kv40_0_t1.mp3"}
        wagon.SoundNames["kv70_t1_0"] = {"subway_trains/ezh/kv40/kv40_t1_0.mp3"}
        wagon.SoundNames["kv70_t1_t1a"] = {"subway_trains/ezh/kv40/kv40_t1_t1a.mp3"}
        wagon.SoundNames["kv70_t1a_t1"] = {"subway_trains/ezh/kv40/kv40_t1a_t1.mp3"}
        wagon.SoundNames["kv70_t1a_t2"] = {"subway_trains/ezh/kv40/kv40_t1a_t2.mp3"}
        wagon.SoundNames["kv70_t2_t1a"] = {"subway_trains/ezh/kv40/kv40_t2_t1a.mp3"}
        wagon.SoundNames["kv70_0_x1"] = {"subway_trains/ezh/kv40/kv40_0_x1.mp3"}
        wagon.SoundNames["kv70_x1_0"] = {"subway_trains/ezh/kv40/kv40_x1_0.mp3"}
        wagon.SoundNames["kv70_x1_x2"] = {"subway_trains/ezh/kv40/kv40_x1_x2.mp3"}
        wagon.SoundNames["kv70_x2_x1"] = {"subway_trains/ezh/kv40/kv40_x2_x1.mp3"}
        wagon.SoundNames["kv70_x2_x3"] = {"subway_trains/ezh/kv40/kv40_x2_x3.mp3"}
        wagon.SoundNames["kv70_x3_x2"] = {"subway_trains/ezh/kv40/kv40_x3_x2.mp3"}--]]
        wagon.SoundNames["kv70_0_t1"] = "subway_trains/717/kv70_3/0-t1.mp3"
        wagon.SoundNames["kv70_t1_0_fix"] = "subway_trains/717/kv70_3/t1-0.mp3"
        wagon.SoundNames["kv70_t1_0"] = "subway_trains/717/kv70_3/t1-0.mp3"
        wagon.SoundNames["kv70_t1_t1a"] = "subway_trains/717/kv70_3/t1-t1a.mp3"
        wagon.SoundNames["kv70_t1a_t1"] = "subway_trains/717/kv70_3/t1a-t1.mp3"
        wagon.SoundNames["kv70_t1a_t2"] = "subway_trains/717/kv70_3/t1a-t2.mp3"
        wagon.SoundNames["kv70_t2_t1a"] = "subway_trains/717/kv70_3/t2-t1a.mp3"
        wagon.SoundNames["kv70_0_x1"] = "subway_trains/717/kv70_3/0-x1.mp3"
        wagon.SoundNames["kv70_x1_0"] = "subway_trains/717/kv70_3/x1-0.mp3"
        wagon.SoundNames["kv70_x1_x2"] = "subway_trains/717/kv70_3/x1-x2.mp3"
        wagon.SoundNames["kv70_x2_x1"] = "subway_trains/717/kv70_3/x2-x1.mp3"
        wagon.SoundNames["kv70_x2_x3"] = "subway_trains/717/kv70_3/x2-x3.mp3"
        wagon.SoundNames["kv70_x3_x2"] = "subway_trains/717/kv70_3/x3-x2.mp3"
        wagon.SoundPositions["kv70_fix_on"] = {110, 1e9, Vector(435.848, 16.1, -19.779 + 4.75), 0.4}
        wagon.SoundPositions["kv70_fix_off"] = wagon.SoundPositions["kv70_fix_on"]
        wagon.SoundPositions["kv70_0_t1"] = {110, 1e9, Vector(456.5, -45, -8), 0.7}
        wagon.SoundPositions["kv70_t1_0_fix"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_t1_0"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_t1_t1a"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_t1a_t1"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_t1a_t2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_t2_t1a"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_0_x1"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_x1_0"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_x1_x2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_x2_x1"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_x2_x3"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_x3_x2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundNames["kv70_0_t1_2"] = "subway_trains/717/kv70_4/kv70_0_t1.mp3"
        wagon.SoundNames["kv70_t1_0_2"] = "subway_trains/717/kv70_4/kv70_t1_0.mp3"
        wagon.SoundNames["kv70_t1_t1a_2"] = "subway_trains/717/kv70_4/kv70_t1_t1a.mp3"
        wagon.SoundNames["kv70_t1a_t1_2"] = "subway_trains/717/kv70_4/kv70_t1a_t1.mp3"
        wagon.SoundNames["kv70_t1a_t2_2"] = "subway_trains/717/kv70_4/kv70_t1a_t2.mp3"
        wagon.SoundNames["kv70_t2_t1a_2"] = "subway_trains/717/kv70_4/kv70_t2_t1a.mp3"
        wagon.SoundNames["kv70_0_x1_2"] = "subway_trains/717/kv70_4/kv70_0_x1.mp3"
        wagon.SoundNames["kv70_x1_0_2"] = "subway_trains/717/kv70_4/kv70_x1_0.mp3"
        wagon.SoundNames["kv70_x1_x2_2"] = "subway_trains/717/kv70_4/kv70_x1_x2.mp3"
        wagon.SoundNames["kv70_x2_x1_2"] = "subway_trains/717/kv70_4/kv70_x2_x1.mp3"
        wagon.SoundNames["kv70_x2_x3_2"] = "subway_trains/717/kv70_4/kv70_x2_x3.mp3"
        wagon.SoundNames["kv70_x3_x2_2"] = "subway_trains/717/kv70_4/kv70_x3_x2.mp3"
        wagon.SoundPositions["kv70_0_t1_2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_t1_0_fix_2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_t1_0_2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_t1_t1a_2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_t1a_t1_2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_t1a_t2_2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_t2_t1a_2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_0_x1_2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_x1_0_2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_x1_x2_2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_x2_x1_2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_x2_x3_2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundPositions["kv70_x3_x2_2"] = wagon.SoundPositions["kv70_0_t1"]
        wagon.SoundNames["ring"] = {
            loop = 0.0,
            "subway_trains/717/ring/ring_start.wav",
            "subway_trains/717/ring/ring_loop.wav",
            "subway_trains/717/ring/ring_end.wav"
        }

        wagon.SoundPositions["ring"] = {60, 1e9, Vector(443.8, 0, -3.2), 0.43}
        wagon.SoundNames["ring2"] = {
            loop = 0.25,
            "subway_trains/717/ring/ringc_start.wav",
            "subway_trains/717/ring/ringc_loop.wav",
            "subway_trains/717/ring/ringc_end.mp3"
        }

        wagon.SoundPositions["ring2"] = wagon.SoundPositions["ring"]
        wagon.SoundNames["ring3"] = {
            loop = 0.1,
            "subway_trains/717/ring/ringch_start.wav",
            "subway_trains/717/ring/ringch_loop.wav",
            "subway_trains/717/ring/ringch_end.wav"
        }

        wagon.SoundPositions["ring3"] = wagon.SoundPositions["ring"]
        wagon.SoundNames["ring4"] = {
            loop = true,
            "subway_trains/717/ring/son13s.wav"
        }

        wagon.SoundPositions["ring4"] = {60, 1e9, Vector(443.8, 0, -3.2), 0.3}
        wagon.SoundNames["ring5"] = {
            loop = true,
            "subway_trains/717/ring/son17.wav"
        }

        wagon.SoundPositions["ring5"] = wagon.SoundPositions["ring4"]
        wagon.SoundNames["ring6"] = {
            loop = 0.0,
            "subway_trains/717/ring/ring2_loop.wav",
            "subway_trains/717/ring/ring2_loop.wav",
            "subway_trains/717/ring/ring2_end.wav"
        }

        wagon.SoundPositions["ring6"] = {60, 1e9, Vector(443.8, 0, -3.2), 0.5}
        wagon.SoundNames["ring_old"] = {
            loop = 0.15,
            "subway_trains/717/ring/ringo_start.wav",
            "subway_trains/717/ring/ringo_loop.wav",
            "subway_trains/717/ring/ringo_end.mp3"
        }

        wagon.SoundPositions["ring_old"] = {60, 1e9, Vector(459, 6, 10), 0.35}
        wagon.SoundNames["IST"] = {
            loop = true,
            "subway_trains/717/ring/son17.wav"
        }

        wagon.SoundPositions["IST"] = {60, 1e9, Vector(443.8, 0, -3.2), 0.15}
        wagon.SoundNames["vpr"] = {
            loop = 0.8,
            "subway_trains/common/other/radio/vpr_start.wav",
            "subway_trains/common/other/radio/vpr_loop.wav",
            "subway_trains/common/other/radio/vpr_off.wav"
        }

        wagon.SoundPositions["vpr"] = {60, 1e9, Vector(420, -49, 61), 0.05}
        wagon.SoundNames["cab_door_open"] = "subway_trains/common/door/cab/door_open.mp3"
        wagon.SoundNames["cab_door_close"] = "subway_trains/common/door/cab/door_close.mp3"
        wagon.SoundNames["otsek_door_open"] = {"subway_trains/720/door/door_torec_open.mp3", "subway_trains/720/door/door_torec_open2.mp3"}
        wagon.SoundNames["otsek_door_close"] = {"subway_trains/720/door/door_torec_close.mp3", "subway_trains/720/door/door_torec_close2.mp3"}
        wagon.SoundNames["igla_on"] = "subway_trains/common/other/igla/igla_on1.mp3"
        wagon.SoundNames["igla_off"] = "subway_trains/common/other/igla/igla_off2.mp3"
        wagon.SoundNames["igla_start1"] = "subway_trains/common/other/igla/igla_start.mp3"
        wagon.SoundNames["igla_start2"] = "subway_trains/common/other/igla/igla_start2.mp3"
        wagon.SoundNames["igla_alarm1"] = "subway_trains/common/other/igla/igla_alarm1.mp3"
        wagon.SoundNames["igla_alarm2"] = "subway_trains/common/other/igla/igla_alarm2.mp3"
        wagon.SoundNames["igla_alarm3"] = "subway_trains/common/other/igla/igla_alarm3.mp3"
        wagon.SoundPositions["igla_on"] = {50, 1e9, Vector(458.50, -33, 34), 0.15}
        wagon.SoundPositions["igla_off"] = {50, 1e9, Vector(458.50, -33, 34), 0.15}
        wagon.SoundPositions["igla_start1"] = {50, 1e9, Vector(458.50, -33, 34), 0.33}
        wagon.SoundPositions["igla_start2"] = {50, 1e9, Vector(458.50, -33, 34), 0.15}
        wagon.SoundPositions["igla_alarm1"] = {50, 1e9, Vector(458.50, -33, 34), 0.33}
        wagon.SoundPositions["igla_alarm2"] = {50, 1e9, Vector(458.50, -33, 34), 0.33}
        wagon.SoundPositions["igla_alarm3"] = {50, 1e9, Vector(458.50, -33, 34), 0.33}
        wagon.SoundNames["upps"] = {"subway_trains/common/other/upps/upps1.mp3", "subway_trains/common/other/upps/upps2.mp3"}
        wagon.SoundPositions["upps"] = {60, 1e9, Vector(443, -64, 4), 0.33}
        wagon.SoundNames["pnm_on"] = {"subway_trains/common/pnm/pnm_switch_on.mp3", "subway_trains/common/pnm/pnm_switch_on2.mp3"}
        wagon.SoundNames["pnm_off"] = "subway_trains/common/pnm/pnm_switch_off.mp3"
        wagon.SoundNames["pnm_button1_on"] = {"subway_trains/common/pnm/pnm_button_push.mp3", "subway_trains/common/pnm/pnm_button_push2.mp3",}
        wagon.SoundNames["pnm_button2_on"] = {"subway_trains/common/pnm/pnm_button_push3.mp3", "subway_trains/common/pnm/pnm_button_push4.mp3",}
        wagon.SoundNames["pnm_button1_off"] = {"subway_trains/common/pnm/pnm_button_release.mp3", "subway_trains/common/pnm/pnm_button_release2.mp3", "subway_trains/common/pnm/pnm_button_release3.mp3",}
        wagon.SoundNames["pnm_button2_off"] = {"subway_trains/common/pnm/pnm_button_release4.mp3", "subway_trains/common/pnm/pnm_button_release5.mp3",}
        wagon.SoundNames["horn"] = {
            loop = 0.6,
            "subway_trains/common/pneumatic/horn/horn3_start.wav",
            "subway_trains/common/pneumatic/horn/horn3_loop.wav",
            "subway_trains/common/pneumatic/horn/horn3_end.wav"
        }

        wagon.SoundPositions["horn"] = {1100, 1e9, Vector(450, 0, -55), 1}
        --DOORS
        wagon.SoundNames["vdol_on"] = {"subway_trains/common/pneumatic/door_valve/VDO_on.mp3", "subway_trains/common/pneumatic/door_valve/VDO2_on.mp3",}
        wagon.SoundNames["vdol_off"] = {"subway_trains/common/pneumatic/door_valve/VDO_off.mp3", "subway_trains/common/pneumatic/door_valve/VDO2_off.mp3",}
        wagon.SoundPositions["vdol_on"] = {300, 1e9, Vector(-420, 45, -30), 1}
        wagon.SoundPositions["vdol_off"] = {300, 1e9, Vector(-420, 45, -30), 0.4}
        wagon.SoundNames["vdor_on"] = wagon.SoundNames["vdol_on"]
        wagon.SoundNames["vdor_off"] = wagon.SoundNames["vdol_off"]
        wagon.SoundPositions["vdor_on"] = wagon.SoundPositions["vdol_on"]
        wagon.SoundPositions["vdor_off"] = wagon.SoundPositions["vdol_off"]
        for i = 1, 5 do
            wagon.SoundNames["vdol_loud" .. i] = "subway_trains/common/pneumatic/door_valve/vdo" .. 2 + i .. "_on.mp3"
            wagon.SoundNames["vdop_loud" .. i] = wagon.SoundNames["vdol_loud" .. i]
            wagon.SoundNames["vzd_loud" .. i] = wagon.SoundNames["vdol_loud" .. i]
            wagon.SoundPositions["vdol_loud" .. i] = {100, 1e9, Vector(-420, 45, -30), 1}
            wagon.SoundPositions["vdop_loud" .. i] = wagon.SoundPositions["vdol_loud" .. i]
            wagon.SoundPositions["vzd_loud" .. i] = wagon.SoundPositions["vdol_loud" .. i]
        end

        wagon.SoundNames["vdz_on"] = {"subway_trains/common/pneumatic/door_valve/VDZ_on.mp3", "subway_trains/common/pneumatic/door_valve/VDZ2_on.mp3", "subway_trains/common/pneumatic/door_valve/VDZ3_on.mp3",}
        wagon.SoundNames["vdz_off"] = {"subway_trains/common/pneumatic/door_valve/VDZ_off.mp3", "subway_trains/common/pneumatic/door_valve/VDZ2_off.mp3", "subway_trains/common/pneumatic/door_valve/VDZ3_off.mp3",}
        wagon.SoundPositions["vdz_on"] = {60, 1e9, Vector(-420, 45, -30), 1}
        wagon.SoundPositions["vdz_off"] = {60, 1e9, Vector(-420, 45, -30), 0.4}
        wagon.SoundNames["RKR"] = "subway_trains/common/pneumatic/RKR2.mp3"
        wagon.SoundPositions["RKR"] = {330, 1e9, Vector(-27, -40, -66), 0.22}
        wagon.SoundNames["PN2end"] = {"subway_trains/common/pneumatic/vz2_end.mp3", "subway_trains/common/pneumatic/vz2_end_2.mp3", "subway_trains/common/pneumatic/vz2_end_3.mp3", "subway_trains/common/pneumatic/vz2_end_4.mp3"}
        wagon.SoundPositions["PN2end"] = {350, 1e9, Vector(-183, 0, -70), 0.3}
        for i = 0, 3 do
            for k = 0, 1 do
                wagon.SoundNames["door" .. i .. "x" .. k .. "r"] = {
                    "subway_trains/common/door/door_roll.wav",
                    loop = true
                }

                wagon.SoundPositions["door" .. i .. "x" .. k .. "r"] = {150, 1e9, GetDoorPosition(i, k), 0.11}
                wagon.SoundNames["door" .. i .. "x" .. k .. "o"] = {"subway_trains/common/door/door_open_end5.mp3", "subway_trains/common/door/door_open_end6.mp3", "subway_trains/common/door/door_open_end7.mp3"}
                wagon.SoundPositions["door" .. i .. "x" .. k .. "o"] = {350, 1e9, GetDoorPosition(i, k), 2}
                wagon.SoundNames["door" .. i .. "x" .. k .. "c"] = {"subway_trains/common/door/door_close_end.mp3", "subway_trains/common/door/door_close_end2.mp3", "subway_trains/common/door/door_close_end3.mp3", "subway_trains/common/door/door_close_end4.mp3", "subway_trains/common/door/door_close_end5.mp3"}
                wagon.SoundPositions["door" .. i .. "x" .. k .. "c"] = {400, 1e9, GetDoorPosition(i, k), 2}
            end
        end

        for k, v in ipairs(wagon.AnnouncerPositions) do
            wagon.SoundNames["announcer_buzz" .. k] = {
                loop = true,
                "subway_announcers/asnp/bpsn_ann.wav"
            }

            wagon.SoundPositions["announcer_buzz" .. k] = {v[2] or 600, 1e9, v[1], v[3] / 6}
            wagon.SoundNames["announcer_buzz_o" .. k] = {
                loop = true,
                "subway_announcers/upo/noiseT2.wav"
            }

            --wagon.SoundNames["announcer_buzz_o"..k] = {loop=true,"subway_announcers/riu/bpsn_ann.wav"}
            wagon.SoundPositions["announcer_buzz_o" .. k] = {v[2] or 600, 1e9, v[1], v[3] / 6}
        end

        for _, v in pairs(ARSRelays) do
            wagon.SoundNames[v .. "_on"] = "subway_trains/common/relays/ars_relays_on1.mp3"
            wagon.SoundNames[v .. "_off"] = "subway_trains/common/relays/ars_relays_off1.mp3"
            wagon.SoundPositions[v .. "_on"] = {10, 1e9, Vector(385, -32, 10), 0.03}
            wagon.SoundPositions[v .. "_off"] = {10, 1e9, Vector(385, -32, 10), 0.03}
        end

        wagon:SetRelays()
    end

    function ent.PostInitializeSystems(wagon)
        if CLIENT then return end
        wagon.Electric:TriggerInput("NoRT2", 0)
        wagon.Electric:TriggerInput("HaveRO", 1)
        wagon.Electric:TriggerInput("GreenRPRKR", 0)
        wagon.Electric:TriggerInput("Type", wagon.Electric.MVM)
        wagon.Electric:TriggerInput("X2PS", 0)
        wagon.Electric:TriggerInput("HaveVentilation", 1)
        wagon.BIS200:TriggerInput("SpeedDec", 1)
        wagon.KRU:TriggerInput("LockX3", 1)
    end

    ent.NumberRanges = {
        --717 МВМ
        {true, {0001, 0002, 0003, 0004, 0007, 0008, 0009, 0010, 0011, 0012, 0013, 0014, 0015, 0015, 0016, 0017, 0018, 0019, 0020, 0021, 0022, 0023, 0044, 0045, 0046, 0047, 0048, 0049, 0050, 0051, 0052, 0053, 0054, 0055, 0056, 0066, 0068, 0069, 0070, 0071, 0072, 0073, 0078, 0080, 0084, 0085, 0086, 0123, 0124, 0125, 0126, 0127, 0128, 0130, 0131, 0132, 0133, 0134, 0135, 0136, 0137, 0138, 0139, 0140, 0141, 0142, 0143, 0144, 0145, 0146, 0147, 0148, 0149, 0150, 0151, 0152, 0153}, {false, false, true, true, {"Def_717MSKWhite", "Def_717MSKWood4"}, true}},
        {
            true,
            {9052, 9053, 9054, 9055, 9056, 9057, 9058, 9059, 9060, 9061, 9062, 9063, 9064, 9065, 9066, 9067, 9068, 9069, 9070, 9071, 9072, 9074, 9076, 9078, 9079, 9092, 9093, 9094, 9095, 9096, 9097, 9098, 9099, 9100, 9101, 9102, 9103, 9104, 9105, 9106, 9107, 9108, 9109, 9110, 9111, 9112, 9113, 9114, 9115, 9116, 9117, 9118, 9119, 9120, 9121, 9122, 9123, 9124, 9125, 9126, 9127, 9128, 9139, 9142, 9146, 9147, 9148, 9149, 9150, 9151, 9152, 9153, 9154, 9155, 9156, 9157, 9158, 9159, 9160, 9161, 9162, 9163, 9167, 9169, 9173, 9180, 9182, 9185, 9186, 9187, 9188, 9189, 9190, 9191, 9192, 9193, 9194, 9195, 9196, 9197, 9198, 9199, 9200, 9201, 9202, 9203, 9204, 9205, 9206, 9207, 9208, 9209, 9210, 9211, 9212, 9213, 9214, 9215, 9216, 9217, 9218, 9219, 9220, 9221, 9222, 9223, 9224, 9225, 9226, 9227, 9228, 9229, 9230, 9231, 9232, 9233, 9234, 9235, 9239, 9240, 9241, 9242, 9243, 9244, 9247, 9248, 9249, 9251, 9253, 9268, 9269, 9270, 9271, 9272, 9273, 9274, 9275, 9276, 9277, 9278, 9280, 9281, 9282, 9283, 9284, 9285, 9286, 9287, 9288, 9289, 9290, 9291, 9293, 9311, 9312, 9313, 9314, 9336, 9337, 9338, 9339, 9342, 9347, 9349},
            {
                false, --[[ "Def_717MSKWood",--]]
                false,
                false,
                true,
                {"Def_717MSKBlue", "Def_717MSKWhite", "Def_717MSKWood2"},
                function(id, tex) return tex == "Def_717MSKWhite" or math.random() > 0.5 end
            }
        },
        --717 ЛВЗ
        {true, {8400, 8401, 8411, 8412, 8413, 8414, 8415, 8416, 8417, 8418, 8419, 8420, 8421, 8422, 8423, 8424, 8425, 8426, 8427, 8428, 8429, 8459, 8460, 8461, 8462, 8465, 8466, 8499, 8500, 8501, 8502, 8503, 8504, 8505, 8506, 8507, 8508, 8509, 8510, 8511, 8512, 8513, 8514, 8515, 8516, 8517, 8518, 8519, 8520, 8521, 8522, 8523, 8524, 8525, 8526, 8527, 8528, 8529, 8530, 8531, 8532, 8533, 8534, 8535, 8536, 8537, 8538, 8539, 8547, 8548, 8549, 8550, 8551, 8552, 8553, 8554, 8555, 8556, 8557, 8558, 8559, 8560, 8561, 8586, 8587, 8596, 8597, 8611, 8612, 8613, 8614, 8615, 8616, 8617, 8618, 8619, 8620, 8621, 8705, 8706, 8707, 8708, 8709, 8710, 8711, 8712, 8713, 8714, 8715, 8716, 8717, 8718, 8719, 8720, 8721, 8722, 8723, 8724, 8725, 8726, 8727, 8728, 8730, 8731, 8732, 8733, 8734, 8745, 8746, 8753, 8760, 8791, 8792, 8802, 8803, 8804, 8816, 8828, 8829, 8831}, {true, false, false, false, {"Def_717MSKWhite"}, true}},
        --717.5 МВМ
        {true, {0154, 0155, 0156, 0157, 0158, 0159, 0160, 0161, 0162, 0163, 0164, 0165, 0166, 0167, 0168, 0169, 0170, 0172, 0173, 0174, 0175, 0176, 0177}, {false, true, false, true, {"Def_717MSKWhite", "Def_717MSKWood4"}, true, true}},
        {true, {0218, 0219, 0220, 0221, 0222, 0223, 0224, 0225, 0226, 0227, 0228, 0229, 0236, 0241, 0242, 0243, 0244, 0249, 0252, 0253, 0254, 0255, 0263, 0264, 0265, 0266, 0267, 0284, 0285, 0286, 0287, 0290, 0292, 0293, 0294, 0295, 0297, 0298, 0299, 0300, 0301, 0308, 0315, 0320, 0333, 0334}, {false, true, true, true, {"Def_717MSKWhite", "Def_717MSKWood4"}, true, true}},
        --717.5 ЛВЗ
        {true, {8876, 8877, 8881, 8882, 8883, 8884, 8885, 8886, 8891, 8892, 8893, 8894, 8931, 8932, 8933, 8934, 8935, 8936, 8937, 8938, 8939, 8940, 8941, 8941, 8942, 8943, 8944, 8945, 8946, 8947, 8965, 8966, 8967, 8968, 8969, 8970, 8983, 8984, 8985, 8986, 8987, 8988, 8989, 8995, 8996, 8997, 8998, 8999}, {true, true, false, true, {"Def_717MSKWhite", "Def_717MSKWood4"}, true, true}},
        {true, {10000, 10001, 10002, 10008, 10009, 10010, 10011, 10012, 10013, 10034, 10035, 10038, 10039, 10040, 10057, 10058, 10059, 10060, 10077, 10078, 10079, 10087, 10088, 10089, 10090, 10091, 10092, 10093, 10094, 10099, 10100, 10101, 10102, 10103, 10106, 10107, 10108, 10109, 10113, 10114, 10115, 10116, 10118, 10119, 10120, 10121, 10122, 10123, 10131, 10132, 10141, 10142, 10143, 10144, 10145, 10146, 10149, 10150, 10151, 10152, 10153, 10154, 10155, 10156, 10157, 10158, 10159, 10160, 10161, 10164, 10165, 10166, 10167, 10168, 10169, 10170, 10190, 10191, 10197, 10199, 10206, 10207}, {true, true, true, true, {"Def_717MSKWhite", "Def_717MSKWood4"}, function(id) return id <= 10010 end, true}},
    }

    if CLIENT then
        if ent.ButtonMap then
            local LampLEKK = {
                ID = "!LampLEKK",
                x = 215.5 - 0.4 * 1,
                y = 31.8 + 19.7 * 0,
                tooltip = "",
                radius = 3,
                model = {
                    name = "RLEKK",
                    lamp = {
                        speed = 24,
                        model = "models/metrostroi_train/81-502/lamps/svetodiod_small_502.mdl",
                        color = Color(175, 250, 20),
                        z = -3.5,
                        var = "LN"
                    },
                    sprite = {
                        bright = 0.5,
                        size = 0.25,
                        scale = 0.01,
                        color = Color(175, 250, 20),
                        z = -1,
                    }
                }
            }

            table.insert(ent.ButtonMap["Block2_1"].buttons, LampLEKK)
            table.insert(ent.ButtonMapCopy["Block2_1"].buttons, LampLEKK)
            local VKSTToggle = {
                ID = "VKSTToggle",
                x = 28,
                y = 57,
                radius = 20,
                tooltip = "",
                model = {
                    model = "models/metrostroi_train/81-717/udkst.mdl",
                    ang = 180,
                    z = -2.4,
                    var = "VKST",
                    speed = 16,
                    sndvol = 1,
                    snd = function(val) return val and "switch_on" or "switch_off" end,
                    sndmin = 90,
                    sndmax = 1e3,
                    sndang = Angle(-90, 0, 0),
                }
            }

            table.insert(ent.ButtonMapCopy["Block7"].buttons, table.Copy(VKSTToggle))
            table.insert(ent.ButtonMap["Block7"].buttons, VKSTToggle)
            local IST = {
                ID = "!IST",
                x = 43,
                y = 57,
                radius = 8,
                tooltip = "",
                model = {
                    lamp = {
                        model = "models/metrostroi_train/81-502/lamps/svetodiod_small_502.mdl",
                        z = 0,
                        color = Color(255, 50, 45),
                        var = "IST"
                    },
                    sprite = {
                        bright = 0.5,
                        size = 0.25,
                        scale = 0.01,
                        color = Color(255, 50, 45),
                        z = -1.4,
                    }
                }
            }

            table.insert(ent.ButtonMapCopy["Block7"].buttons, table.Copy(IST))
            table.insert(ent.ButtonMap["Block7"].buttons, IST)

            ent.ButtonMap["AutostopValve"] = {
                pos = Vector(365.8, -67.6, -56),
                ang = Angle(0, 0, 90),
                width = 130,
                height = 40,
                scale = 0.1,
                hideseat = 0.1,
                -- hide = true,
                -- screenHide = true,
                buttons = {
                    {
                        ID = "AutostopValveSet",
                        x = 0,
                        y = 0,
                        w = 130,
                        h = 40,
                        tooltip = "Сорвать срывной клапан"
                    },
                }
            }
        end

        if not ent.ButtonMap then print("lol wtf") end
        function ent.Initialize(wagon)
            wagon.BaseClass.Initialize(wagon)
            --wagon.Train:SetPackedRatio("EmergencyValve_dPdT",leak)
            --wagon.Train:SetPackedRatio("EmergencyValveEPK_dPdT",leak)
            --wagon.Train:SetPackedRatio("EmergencyBrakeValve_dPdT",leak)
            wagon.ASNP = wagon:CreateRT("717ASNP", 512, 128)
            wagon.IGLA = wagon:CreateRT("717IGLA", 512, 128)
            wagon.LeftMirror = wagon:CreateRT("LeftMirror", 128, 256)
            wagon.RightMirror = wagon:CreateRT("RightMirror", 128, 256)
            wagon.CraneRamp = 0
            wagon.CraneLRamp = 0
            wagon.CraneRRamp = 0
            wagon.ReleasedPdT = 0
            wagon.EmergencyValveRamp = 0
            wagon.EmergencyValveEPKRamp = 0
            wagon.EmergencyBrakeValveRamp = 0
            wagon.FrontLeak = 0
            wagon.RearLeak = 0
            wagon.VentCab = 0
            wagon.VentG1 = 0
            wagon.VentG2 = 0
            wagon.Door1 = false
            wagon.Door2 = false
            wagon.Door3 = false
            wagon.Otsek1 = false
            wagon.Otsek2 = false
            wagon.ParkingBrake1 = true
            wagon.ParkingBrake2 = true
            wagon.DoorStates = {}
            wagon.DoorLoopStates = {}
            for i = 0, 3 do
                for k = 0, 1 do
                    wagon.DoorStates[(k == 1 and "DoorL" or "DoorR") .. i + 1] = false
                end
            end
        end
    end

    if SERVER then
        function ent.Initialize(wagon)
            wagon.Plombs = {
                VAH = true,
                VP = true,
                OtklAVU = true,
                OVT = true,
                --KAH = {true,"KAHK"},
                KAH = {true},
                OtklBV = {true},
                RC1 = true,
                UOS = true,
                VBD = true,
                UAVA = true,
                UPPS_On = true,
                Init = true,
            }

            -- Set model and initialize
            wagon.MaskType = 10
            wagon.LampType = 1
            wagon:SetModel("models/metrostroi_train/81-717/81-717_mvm.mdl")
            wagon:SetRenderMode(RENDERMODE_TRANSALPHA)
            wagon.BaseClass.Initialize(wagon)
            wagon:SetPos(wagon:GetPos() + Vector(0, 0, 140))
            -- Create seat entities
            wagon.DriverSeat = wagon:CreateSeat("driver", Vector(417, 0, -22.5))
            wagon.InstructorsSeat = wagon:CreateSeat("instructor", Vector(425, 50, -28 + 3), Angle(0, 270, 0))
            wagon.ExtraSeat1 = wagon:CreateSeat("instructor", Vector(410, 30, -43), Angle(0, 90, 0), "models/vehicles/prisoner_pod_inner.mdl")
            wagon.ExtraSeat2 = wagon:CreateSeat("instructor", Vector(422, -45, -43), Angle(0, 90, 0), "models/vehicles/prisoner_pod_inner.mdl")
            wagon.ExtraSeat3 = wagon:CreateSeat("instructor", Vector(402, 50, -43), Angle(0, 50, 0), "models/vehicles/prisoner_pod_inner.mdl")
            -- Hide seats
            wagon.DriverSeat:SetColor(Color(0, 0, 0, 0))
            wagon.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
            wagon.InstructorsSeat:SetColor(Color(0, 0, 0, 0))
            wagon.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
            wagon.ExtraSeat1:SetColor(Color(0, 0, 0, 0))
            wagon.ExtraSeat1:SetRenderMode(RENDERMODE_TRANSALPHA)
            wagon.ExtraSeat2:SetColor(Color(0, 0, 0, 0))
            wagon.ExtraSeat2:SetRenderMode(RENDERMODE_TRANSALPHA)
            wagon.ExtraSeat3:SetColor(Color(0, 0, 0, 0))
            wagon.ExtraSeat3:SetRenderMode(RENDERMODE_TRANSALPHA)
            -- Create bogeys
            if Metrostroi.BogeyOldMap then
                wagon.FrontBogey = wagon:CreateBogey(Vector(317 - 5, 0, -84), Angle(0, 180, 0), true, "717")
                wagon.RearBogey = wagon:CreateBogey(Vector(-317 + 0, 0, -84), Angle(0, 0, 0), false, "717")
                wagon.FrontCouple = wagon:CreateCouple(Vector(419.5, 0, -62), Angle(0, 0, 0), true, "717")
                wagon.RearCouple = wagon:CreateCouple(Vector(-419.5 - 6.545, 0, -62), Angle(0, 180, 0), false, "717")
            else
                wagon.FrontBogey = wagon:CreateBogey(Vector(317 - 11, 0, -80), Angle(0, 180, 0), true, "717")
                wagon.RearBogey = wagon:CreateBogey(Vector(-317 + 0, 0, -80), Angle(0, 0, 0), false, "717")
                wagon.RearCouple = wagon:CreateCouple(Vector(-421, 0, -66), Angle(0, 180, 0), false, "717")
                wagon.FrontCouple = wagon:CreateCouple(Vector(410 - 3, 0, -66), Angle(0, 0, 0), true, "717")
            end

            local pneumoPow = 0.8 + math.random() ^ 1.55 * 0.4
            wagon.FrontBogey.PneumaticPow = pneumoPow
            wagon.RearBogey.PneumaticPow = pneumoPow
            wagon.FrontCouple.EKKDisconnected = true
            wagon.LightSensor = wagon:AddLightSensor(Vector(414 - 7.5, -130, -100), Angle(0, 90, 0))
            -- Initialize key mapping
            wagon.KeyMap = {
                [KEY_1] = "KVSetX1B",
                [KEY_2] = "KVSetX2",
                [KEY_3] = "KVSetX3",
                [KEY_4] = "KVSet0",
                [KEY_5] = "KVSetT1B",
                [KEY_6] = "KVSetT1AB",
                [KEY_7] = "KVSetT2",
                [KEY_8] = "KRPSet",
                [KEY_EQUAL] = {
                    "R_Program1Set",
                    helper = "R_Program1HSet"
                },
                [KEY_MINUS] = {
                    "R_Program2Set",
                    helper = "R_Program2HSet"
                },
                [KEY_G] = "VozvratRPSet",
                [KEY_0] = "KVReverserUp",
                [KEY_9] = "KVReverserDown",
                [KEY_PAD_PLUS] = "KVReverserUp",
                [KEY_PAD_MINUS] = "KVReverserDown",
                [KEY_W] = "KVUp",
                [KEY_S] = "KVDown",
                [KEY_F] = "PneumaticBrakeUp",
                [KEY_R] = "PneumaticBrakeDown",
                [KEY_A] = {
                    "KDL",
                    helper = "VDLSet"
                },
                [KEY_D] = "KDP",
                [KEY_V] = {
                    "VUD1Toggle",
                    helper = "VUD2Toggle"
                },
                [KEY_L] = "HornEngage",
                [KEY_N] = "VZ1Set",
                [KEY_PAD_1] = "PneumaticBrakeSet1",
                [KEY_PAD_2] = "PneumaticBrakeSet2",
                [KEY_PAD_3] = "PneumaticBrakeSet3",
                [KEY_PAD_4] = "PneumaticBrakeSet4",
                [KEY_PAD_5] = "PneumaticBrakeSet5",
                [KEY_PAD_6] = "PneumaticBrakeSet6",
                [KEY_PAD_7] = "PneumaticBrakeSet7",
                [KEY_PAD_DIVIDE] = "KRPSet",
                [KEY_PAD_MULTIPLY] = "KAH",
                [KEY_SPACE] = "PBSet",
                [KEY_BACKSPACE] = {
                    "EmergencyBrake",
                    helper = "EmergencyBrakeValveToggle"
                },
                [KEY_PAD_ENTER] = "KVWrenchKV",
                [KEY_PAD_0] = "DriverValveDisconnect",
                [KEY_PAD_DECIMAL] = "EPKToggle",
                [KEY_LSHIFT] = {
                    def = "KV_Unlock",
                    [KEY_SPACE] = "KVT",
                    [KEY_2] = "RingSet",
                    [KEY_4] = "KVSet0Fast",
                    [KEY_L] = "DriverValveDisconnect",
                    [KEY_7] = "KVWrenchNone",
                    [KEY_8] = "KVWrenchKRU",
                    [KEY_9] = "KVWrenchKV9",
                    [KEY_0] = "KVWrenchKV",
                    [KEY_6] = "KVSetT1A",
                },
                [KEY_LALT] = {
                    [KEY_V] = "VUD1Toggle",
                    [KEY_L] = "EPKToggle",
                    [KEY_RIGHT] = "R_ASNPMenuSet",
                    [KEY_UP] = "R_ASNPUpSet",
                    [KEY_DOWN] = "R_ASNPDownSet",
                },
            }

            wagon.KeyMap[KEY_RALT] = wagon.KeyMap[KEY_LALT]
            wagon.KeyMap[KEY_RSHIFT] = wagon.KeyMap[KEY_LSHIFT]
            wagon.KeyMap[KEY_RCONTROL] = wagon.KeyMap[KEY_LCONTROL]
            wagon.InteractionZones = {
                {
                    ID = "FrontBrakeLineIsolationToggle",
                    Pos = Vector(461.5, -34, -53),
                    Radius = 8,
                },
                {
                    ID = "FrontTrainLineIsolationToggle",
                    Pos = Vector(461.5, 33, -53),
                    Radius = 8,
                },
                {
                    ID = "RearBrakeLineIsolationToggle",
                    Pos = Vector(-474.5, 33, -53),
                    Radius = 8,
                },
                {
                    ID = "RearTrainLineIsolationToggle",
                    Pos = Vector(-474.5, -34, -53),
                    Radius = 8,
                },
                {
                    ID = "CabinDoor",
                    Pos = Vector(456, 66, 3),
                    Radius = 12,
                },
                {
                    ID = "CabinDoor",
                    Pos = Vector(385, 66, 0),
                    Radius = 16,
                },
                {
                    ID = "RearDoor",
                    Pos = Vector(-464.8, -35, 4),
                    Radius = 20,
                },
                {
                    ID = "PassengerDoor",
                    Pos = Vector(375.5, 13.5, 12),
                    Radius = 20,
                },
                {
                    ID = "GVToggle",
                    Pos = Vector(140.50, 62, -64),
                    Radius = 10,
                },
                {
                    ID = "AirDistributorDisconnectToggle",
                    Pos = Vector(-177, -66, -50),
                    Radius = 20,
                },
                {
                    ID = "AutostopValveToggle",
                    Pos = Vector(377, -66, -50),
                    Radius = 20,
                },
            }

            local vX = Angle(0, -90 - 0.2, 56.3):Forward() -- For ARS panel
            local vY = Angle(0, -90 - 0.2, 56.3):Right()
            -- Cross connections in train wires
            wagon.TrainWireInverts = {
                [28] = true,
                [34] = true,
            }

            wagon.TrainWireCrossConnections = {
                [5] = 4, -- Reverser F<->B
                [31] = 32, -- Doors L<->R
            }

            wagon.RearDoor = false
            wagon.CabinDoor = false
            wagon.PassengerDoor = false
            wagon.OtsekDoor1 = false
            wagon.OtsekDoor2 = false
            wagon.Lamps = {
                broken = {},
            }

            local rand = math.random() > 0.8 and 1 or math.random(0.95, 0.99)
            for i = 1, 25 do
                if math.random() > rand then wagon.Lamps.broken[i] = math.random() > 0.5 end
            end

            wagon:TrainSpawnerUpdate()
            wagon:OnButtonPress("KVWrenchNone")
        end
    end

    if SERVER then
        table.insert(ent.SyncTable, "VKST")
        function ent.TriggerLightSensor(wagon, coil, plate)
            if plate.PlateType == METROSTROI_UPPSSENSOR then wagon.UPPS:TriggerSensor(coil, plate) end
        end

        function ent.OnButtonPress(wagon, button, ply)
            if string.find(button, "PneumaticBrakeSet") then
                wagon.Pneumatic:TriggerInput("BrakeSet", tonumber(button:sub(-1, -1)))
                return
            end

            if button == "IGLA23" then
                wagon.IGLA2:TriggerInput("Set", 1)
                wagon.IGLA3:TriggerInput("Set", 1)
            end

            if button == "RearDoor" then wagon.RearDoor = not wagon.RearDoor end
            if button == "PassengerDoor" then wagon.PassengerDoor = not wagon.PassengerDoor end
            if button == "CabinDoor" then wagon.CabinDoor = not wagon.CabinDoor end
            if button == "OtsekDoor1" then wagon.OtsekDoor1 = not wagon.OtsekDoor1 end
            if button == "OtsekDoor2" then wagon.OtsekDoor2 = not wagon.OtsekDoor2 end
            if button == "KVUp" then wagon.KV:TriggerInput("ControllerUp", 1.0) end
            if button == "KVDown" then wagon.KV:TriggerInput("ControllerDown", 1.0) end
            if button == "KV_Unlock" then wagon.KV:TriggerInput("ControllerUnlock", 1.0) end
            if wagon.KVWrenchMode == 2 and button == "KVReverserUp" then wagon.KRU:TriggerInput("Up", 1) end
            if wagon.KVWrenchMode == 2 and button == "KVReverserDown" then wagon.KRU:TriggerInput("Down", 1) end
            if wagon.KVWrenchMode == 2 and button == "KVSetX1B" then wagon.KRU:TriggerInput("SetX1", 1) end
            if wagon.KVWrenchMode == 2 and button == "KVSetX2" then wagon.KRU:TriggerInput("SetX2", 1) end
            if wagon.KVWrenchMode == 2 and button == "KVSet0" then wagon.KRU:TriggerInput("Set0", 1) end
            if button == "KVSetT1B" then
                if wagon.KV.ControllerPosition == -1 then
                    wagon.KV:TriggerInput("ControllerSet", -2)
                else
                    wagon.KV:TriggerInput("ControllerSet", -1)
                end
            end

            if button == "KVSetX1B" then
                if wagon.KV.ControllerPosition == 1 then
                    wagon.KV:TriggerInput("ControllerSet", 2)
                else
                    wagon.KV:TriggerInput("ControllerSet", 1)
                end
            end

            if button == "KVSetT1AB" then
                if wagon.KV.ControllerPosition == -2 then
                    wagon.KV:TriggerInput("ControllerSet", -1)
                else
                    wagon.KV:TriggerInput("ControllerSet", -2)
                end
            end

            if button == "KVWrenchKV" or button == "KVWrenchKV9" then
                if wagon.KVWrenchMode == 0 then
                    wagon:PlayOnce("revers_in", "cabin", 0.7)
                    wagon.KVWrenchMode = 1
                    wagon.KV:TriggerInput("Enabled", 1)
                else
                    wagon:TriggerInput(button == "KVWrenchKV9" and "KVReverserDown" or "KVReverserUp", 1)
                end
            end

            if button == "KVWrenchNone" then
                if wagon.KVWrenchMode ~= 0 and wagon.KV.ReverserPosition == 0 and wagon.KRU.Position == 0 then
                    if wagon.KVWrenchMode == 2 then
                        wagon:PlayOnce("kru_out", "cabin", 0.7)
                    else
                        wagon:PlayOnce("revers_out", "cabin", 0.7)
                    end

                    wagon.KVWrenchMode = 0
                    wagon.KV:TriggerInput("Enabled", 0)
                    wagon.KRU:TriggerInput("Enabled", 0)
                end
            end

            if button == "KVWrenchKRU" then
                if wagon.KVWrenchMode == 0 then
                    wagon:PlayOnce("kru_in", "cabin", 0.7)
                    wagon.KVWrenchMode = 2
                    wagon.KRU:TriggerInput("Enabled", 1)
                end
            end

            if button == "KAH" and not wagon.Plombs.KAH then
                wagon.KAHK:TriggerInput("Open", 1)
                wagon.KAH:TriggerInput("Close", 1)
            end

            if button == "KDL" and wagon.VUD1.Value < 1 then wagon.KDL:TriggerInput("Close", 1) end
            if button == "KDP" and wagon.VUD1.Value < 1 then wagon.KDP:TriggerInput("Close", 1) end
            if button == "VDL" and wagon.VUD1.Value < 1 then wagon.VDL:TriggerInput("Close", 1) end
            if button == "EmergencyBrake" then
                wagon.KV:TriggerInput("ControllerSet", -3)
                wagon.Pneumatic:TriggerInput("BrakeSet", 7)
                return
            end

            if button == "KVT" then
                wagon.KVT:TriggerInput("Set", 1)
                wagon.KVTR:TriggerInput("Set", 1)
            end

            if button == "VDL" or button == "KDL" then
                wagon.DoorSelect:TriggerInput("Open", 1)
                wagon.KDLK:TriggerInput("Open", 1)
            end

            if button == "KDP" then
                wagon.DoorSelect:TriggerInput("Close", 1)
                wagon.KDPK:TriggerInput("Open", 1)
            end

            if button == "VUD1Set" or button == "VUD1Toggle" or button == "VUD2Set" or button == "VUD2Toggle" then
                wagon.VDL:TriggerInput("Open", 1)
                wagon.KDL:TriggerInput("Open", 1)
                wagon.KDP:TriggerInput("Open", 1)
            end

            -- Special sounds
            if button == "DriverValveDisconnect" then
                if wagon.Pneumatic.ValveType == 1 then
                    if wagon.DriverValveBLDisconnect.Value == 0 or wagon.DriverValveTLDisconnect.Value == 0 then
                        wagon.DriverValveBLDisconnect:TriggerInput("Set", 1)
                        wagon.DriverValveTLDisconnect:TriggerInput("Set", 1)
                    else
                        wagon.DriverValveBLDisconnect:TriggerInput("Set", 0)
                        wagon.DriverValveTLDisconnect:TriggerInput("Set", 0)
                    end
                else
                    if wagon.DriverValveDisconnect.Value == 1.0 then
                        wagon.DriverValveDisconnect:TriggerInput("Set", 0)
                    else
                        wagon.DriverValveDisconnect:TriggerInput("Set", 1)
                    end
                end
                return
            end
        end

        function ent.OnButtonRelease(wagon, button, ply)
            if string.find(button, "PneumaticBrakeSet") then
                if button == "PneumaticBrakeSet1" and wagon.Pneumatic.DriverValvePosition == 1 then wagon.Pneumatic:TriggerInput("BrakeSet", 2) end
                return
            end

            if button == "KAH" then wagon.KAH:TriggerInput("Open", 1) end
            if button == "KDL" then wagon.KDL:TriggerInput("Open", 1) end
            if button == "KDP" then wagon.KDP:TriggerInput("Open", 1) end
            if button == "VDL" then wagon.VDL:TriggerInput("Open", 1) end
            if button == "KV_Unlock" then wagon.KV:TriggerInput("ControllerUnlock", 0.0) end
            if button == "IGLA23" then
                wagon.IGLA2:TriggerInput("Set", 0)
                wagon.IGLA3:TriggerInput("Set", 0)
            end

            if button == "KVT" then
                wagon.KVT:TriggerInput("Set", 0)
                wagon.KVTR:TriggerInput("Set", 0)
            end

            if button == "KVSetT1AB" then if wagon.KV.ControllerPosition > -2 then wagon.KV:TriggerInput("ControllerSet", -2) end end
            if button == "KVSetX1B" then if wagon.KV.ControllerPosition > 1 then wagon.KV:TriggerInput("ControllerSet", 1) end end
            if button == "KVSetT1B" then if wagon.KV.ControllerPosition < -1 then wagon.KV:TriggerInput("ControllerSet", -1) end end
        end
    end

    ent.InitializeSystems = function(wagon)
        -- Электросистема 81-710
        wagon:LoadSystem("Electric", "81_717_Electric_EXT")
        -- Токоприёмник
        wagon:LoadSystem("TR", "TR_3B")
        -- Электротяговые двигатели
        wagon:LoadSystem("Engines", "DK_117DM")
        -- Резисторы для реостата/пусковых сопротивлений
        wagon:LoadSystem("KF_47A", "KF_47A1")
        -- Резисторы для ослабления возбуждения
        wagon:LoadSystem("KF_50A")
        -- Ящик с предохранителями
        wagon:LoadSystem("YAP_57")
        -- Резисторы для цепей управления
        --wagon:LoadSystem("YAS_44V")
        wagon:LoadSystem("Reverser", "PR_722D")
        -- Реостатный контроллер для управления пусковыми сопротивления
        wagon:LoadSystem("RheostatController", "EKG_17B")
        -- Групповой переключатель положений
        wagon:LoadSystem("PositionSwitch", "PKG_761")
        -- Кулачковый контроллер
        wagon:LoadSystem("KV", "KV_70")
        -- Контроллер резервного управления
        wagon:LoadSystem("KRU")
        -- Ящики с реле и контакторами
        wagon:LoadSystem("BV", "BV_630")
        wagon:LoadSystem("LK_755A")
        wagon:LoadSystem("YAR_13B", "YAR_13B_EXT")
        wagon:LoadSystem("YAR_27", "YAR_27_EXT", "MSK")
        wagon:LoadSystem("YAK_36")
        wagon:LoadSystem("YAK_37E")
        wagon:LoadSystem("YAS_44V")
        wagon:LoadSystem("YARD_2")
        wagon:LoadSystem("PR_14X_Panels")
        -- Пневмосистема 81-717
        wagon:LoadSystem("Pneumatic", "81_717_Pneumatic_EXT")
        -- Панель управления 81-717
        wagon:LoadSystem("Panel", "81_717_Panel_EXT")
        -- Everything else
        wagon:LoadSystem("Battery")
        wagon:LoadSystem("PowerSupply", "BPSN_EXT")
        wagon:LoadSystem("ALS_ARS", "ALS_ARS_D")
        wagon:LoadSystem("Horn")
        wagon:LoadSystem("IGLA_CBKI", "IGLA_CBKI1_EXT")
        wagon:LoadSystem("IGLA_PCBK")
        wagon:LoadSystem("UPPS")
        wagon:LoadSystem("BZOS", "81_718_BZOS")
        wagon:LoadSystem("Announcer", "81_71_Announcer", "AnnouncementsASNP")
        wagon:LoadSystem("ASNP", "81_71_ASNP_EXT")
        wagon:LoadSystem("ASNP_VV", "81_71_ASNP_VV")
        wagon:LoadSystem("RouteNumber", "81_71_RouteNumber", 2)
        wagon:LoadSystem("LastStation", "81_71_LastStation", "717", "destination")
    end

    function ent.UpdateLampsColors(wagon)
        local lCol, lCount = Vector(), 0
        local rand = math.random() > 0.8 and 1 or math.random(0.95, 0.99)
        if wagon.LampType == 1 then
            local r, g, col = 15, 15
            local typ = math.Round(math.random())
            local rnd = 0.5 + math.random() * 0.5
            for i = 1, 12 do
                local chtp = math.random() > rnd
                if typ == 0 and not chtp or typ == 1 and chtp then
                    g = math.random() * 15
                    col = Vector(240 + g, 240 + g, 255)
                else
                    b = -5 + math.random() * 20
                    col = Vector(255, 255, 235 + b)
                end

                lCol = lCol + col
                lCount = lCount + 1
                if i % 4 == 0 then
                    local id = 10 + math.ceil(i / 4)
                    local tcol = (lCol / lCount) / 255
                    --wagon.Lights[id][4] = Vector(tcol.r,tcol.g^3,tcol.b^3)*255
                    wagon:SetNW2Vector("lampD" .. id, Vector(tcol.r, tcol.g ^ 3, tcol.b ^ 3) * 255)
                    lCol = Vector()
                    lCount = 0
                end

                wagon:SetNW2Vector("lamp" .. i, col)
                wagon.Lamps.broken[i] = math.random() > rand and math.random() > 0.7
            end
        else
            local rnd1, rnd2, col = 0.7 + math.random() * 0.3, math.random()
            local typ = math.Round(math.random())
            local r, g = 15, 15
            for i = 1, 25 do
                local chtp = math.random() > rnd1
                if typ == 0 and not chtp or typ == 1 and chtp then
                    if math.random() > rnd2 then
                        r = -20 + math.random() * 25
                        g = 0
                    else
                        g = -5 + math.random() * 15
                        r = g
                    end

                    col = Vector(245 + r, 228 + g, 189)
                else
                    if math.random() > rnd2 then
                        g = math.random() * 15
                        b = g
                    else
                        g = 15
                        b = -10 + math.random() * 25
                    end

                    col = Vector(255, 235 + g, 235 + b)
                end

                lCol = lCol + col
                lCount = lCount + 1
                if i % 8.3 < 1 then
                    local id = 9 + math.ceil(i / 8.3)
                    local tcol = (lCol / lCount) / 255
                    --wagon.Lights[id][4] = Vector(tcol.r,tcol.g^3,tcol.b^3)*255
                    wagon:SetNW2Vector("lampD" .. id, Vector(tcol.r, tcol.g ^ 3, tcol.b ^ 3) * 255)
                    lCol = Vector()
                    lCount = 0
                end

                wagon:SetNW2Vector("lamp" .. i, col)
                wagon.Lamps.broken[i] = math.random() > rand and math.random() > 0.7
            end
        end
    end

    MEL.FindSpawnerField(ent, "SpawnMode")[MEL.Constants.Spawner.List.WAGON_CALLBACK] = function(wagon, val, rot, i, wagnum, rclk)
        if rclk then return end
        if wagon._SpawnerStarted ~= val then
            wagon.VB:TriggerInput("Set", val <= 2 and 1 or 0)
            wagon.ParkingBrake:TriggerInput("Set", val == 3 and 1 or 0)
            if wagon.AR63 then
                local first = i == 1 or _LastSpawner ~= CurTime()
                wagon.A53:TriggerInput("Set", val <= 2 and 1 or 0)
                wagon.A49:TriggerInput("Set", val <= 2 and 1 or 0)
                wagon.AR63:TriggerInput("Set", val <= 2 and 1 or 0)
                wagon.R_UNch:TriggerInput("Set", val == 1 and 1 or 0)
                wagon.R_Radio:TriggerInput("Set", val == 1 and 1 or 0)
                wagon.BPSNon:TriggerInput("Set", val == 1 and first and 1 or 0)
                wagon.VMK:TriggerInput("Set", val == 1 and first and 1 or 0)
                wagon.ARS:TriggerInput("Set", wagon.Plombs.RC1 and val == 1 and first and 1 or 0)
                wagon.ALS:TriggerInput("Set", val == 1 and 1 or 0)
                wagon.L_1:TriggerInput("Set", val == 1 and 1 or 0)
                wagon.L_4:TriggerInput("Set", val == 1 and 1 or 0)
                wagon.EPK:TriggerInput("Set", wagon.Plombs.RC1 and val == 1 and 1 or 0)
                wagon.DriverValveDisconnect:TriggerInput("Set", val == 4 and first and 1 or 0)
                _LastSpawner = CurTime()
                wagon.CabinDoor = val == 4 and first
                wagon.PassengerDoor = val == 4
                wagon.RearDoor = val == 4
            else
                wagon.FrontDoor = val == 4
                wagon.RearDoor = val == 4
            end

            if val == 1 then
                timer.Simple(1, function()
                    if not IsValid(ent) then return end
                    wagon.BV:TriggerInput("Enable", 1)
                end)
            end

            wagon.GV:TriggerInput("Set", val < 4 and 1 or 0)
            wagon._SpawnerStarted = val
        end

        wagon.Pneumatic.TrainLinePressure = val == 3 and math.random() * 4 or val == 2 and 4.5 + math.random() * 3 or 7.6 + math.random() * 0.6
        wagon.Pneumatic.WorkingChamberPressure = val == 3 and math.random() * 1.0 or val == 2 and 4.0 + math.random() * 1.0 or 5.2
        if val == 4 then wagon.Pneumatic.BrakeLinePressure = 5.2 end
    end
end

function RECIPE:InjectNeeded()
    if Metrostroi.Version > 1537278077 then return false end
    return true
end