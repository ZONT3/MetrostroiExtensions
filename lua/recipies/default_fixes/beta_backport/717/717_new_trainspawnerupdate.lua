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
MEL.DefineRecipe("717_new_trainspawnerupdate", "gmod_subway_81-717_mvm")
RECIPE.BackportPriority = 8
function RECIPE:Inject(ent)
    if SERVER then
        ent.TrainSpawnerUpdate = function(wagon)
            local num = wagon.WagonNumber
            wagon:SetNW2Bool("Custom", wagon.CustomSettings)
            math.randomseed(num + 817171)
            if wagon.CustomSettings then
                local dot5 = wagon:GetNW2Int("Type") == 2
                local typ = wagon:GetNW2Int("BodyType")
                if typ == 2 then
                    wagon:SetModel("models/metrostroi_train/81-717/81-717_lvz.mdl")
                else
                    wagon:SetModel("models/metrostroi_train/81-717/81-717_mvm.mdl")
                end

                wagon:SetNW2Int("Crane", wagon:GetNW2Int("Cran"))
                local lampType = wagon:GetNW2Int("LampType")
                local ARSType = wagon:GetNW2Int("ARSType")
                local RingType = wagon:GetNW2Int("RingType")
                local BPSNType = wagon:GetNW2Int("BPSNType")
                local SeatType = wagon:GetNW2Int("SeatType")
                wagon:SetNW2Bool("HandRails", dot5)
                wagon:SetNW2Bool("Dot5", dot5)
                wagon:SetNW2Bool("LVZ", typ == 2)
                wagon:SetNW2Int("LampType", lampType == 1 and (math.random() > 0.5 and 2 or 1) or lampType - 1)
                wagon.NewBortlamps = typ ~= 2 or math.random() > 0.5
                if ARSType == 1 then
                    ARSType = math.ceil(math.random() * 4 + 0.5)
                else
                    ARSType = ARSType - 1
                end

                wagon:SetNW2Int("ARSType", ARSType)
                wagon:SetNW2Int("KVType", math.ceil(math.random() * 3 + 0.5))
                wagon:SetNW2Bool("NewBortlamps", wagon.NewBortlamps)
                wagon:SetNW2Int("BPSNType", BPSNType == 1 and math.ceil(math.random() * 12 + 0.5) or BPSNType - 1)
                wagon:SetNW2Int("RingType", RingType == 1 and math.ceil(math.random() * 8 + 0.5) or RingType - 1)
                if SeatType == 1 then
                    wagon:SetNW2Int("SeatType", math.random(1, 2))
                else
                    wagon:SetNW2Int("SeatType", SeatType - 1)
                end
            else
                local typ = wagon.WagonNumberConf or {}
                local lvz = typ[1]
                wagon.Dot5 = typ[2]
                wagon.NewBortlamps = typ[4]
                if lvz then
                    wagon:SetModel("models/metrostroi_train/81-717/81-717_lvz.mdl")
                else
                    wagon:SetModel("models/metrostroi_train/81-717/81-717_mvm.mdl")
                end

                wagon:SetNW2Bool("Dot5", wagon.Dot5)
                wagon:SetNW2Bool("LVZ", lvz)
                wagon:SetNW2Int("SeatType", typ[3] and 2 or 1)
                wagon:SetNW2Bool("NewBortlamps", wagon.NewBortlamps)
                wagon:SetNW2Int("LampType", math.random() > 0.5 and 2 or 1)
                local tex = typ[5] and typ[5][math.random(1, #typ[5])] or "Def_717MSKWhite"
                wagon:SetNW2String("PassTexture", tex)
                local mask = typ[6] == true or typ[6] and typ[6](num, tex)
                wagon:SetNW2Int("MaskType", mask and 3 or 1)
                wagon:SetNW2String("CabTexture", typ[7] and ((lvz and math.random() > 0.2) and "Def_ClassicY" or "Def_ClassicG") or ((lvz and math.random() > 0.2) and "Def_HammeriteY" or "Def_HammeriteG"))
                local ARSchance = math.random()
                wagon:SetNW2Int("ARSType", (not mask and not wagon.Dot5 and not lvz or ARSchance > 0.8) and (ARSchance > 0.93 and 5 or 4) or ARSchance > 0.54 and (ARSchance > 0.75 and 3 or 2) or 1)
                local KVChance = math.random()
                local RingChance = math.random()
                if wagon.Dot5 then
                    wagon:SetNW2Int("KVType", math.Clamp(math.floor(KVChance * 4) + 1, 1, 4))
                    if RingChance > 0.7 then
                        wagon:SetNW2Int("RingType", RingChance > 0.8 and 9 or RingChance > 0.9 and 6 or 5)
                    elseif RingChance > 0.45 then
                        wagon:SetNW2Int("RingType", RingChance > 0.67 and 8 or 7)
                    else
                        wagon:SetNW2Int("RingType", math.Clamp(math.floor(KVChance / 0.45 * 4) + 1, 1, 4))
                    end
                else
                    if RingChance > 0.6 then
                        wagon:SetNW2Int("RingType", RingChance > 0.8 and 9 or RingChance > 0.9 and 6 or 5)
                    else
                        wagon:SetNW2Int("RingType", math.Clamp(math.floor(KVChance / 0.9 * 4) + 1, 1, 4))
                    end

                    wagon:SetNW2Int("KVType", math.Clamp(math.floor(KVChance * 3) + 1, 1, 3))
                end

                local oldType = not wagon.Dot5 and not mask and not lvz
                wagon:SetNW2String("Texture", oldType and "Def_717MSKClassic3" or "Def_717MSKClassic1")
                wagon:SetNW2Int("BPSNType", oldType and (math.random() > 0.7 and 2 or 1) or 2 + math.Clamp(math.floor(math.random() * 11) + 1, 1, 11))
                wagon:SetNW2Int("Crane", not oldType and 2 or 1)
                if wagon.Dot5 then
                    wagon.FrontCouple.CoupleType = "717"
                else
                    wagon.FrontCouple.CoupleType = "702"
                end

                wagon.RearCouple.CoupleType = wagon.FrontCouple.CoupleType
                wagon.FrontCouple:SetParameters()
                wagon.RearCouple:SetParameters()
                wagon.MaskType = wagon:GetNW2Int("MaskType", 1)
                wagon.SeatType = wagon:GetNW2Int("SeatType", 1)
                wagon.HandRail = wagon:GetNW2Int("HandRail", 1)
                wagon.BortLampType = wagon:GetNW2Int("BortLampType", 1)
            end

            wagon.Announcer.AnnouncerType = wagon:GetNW2Int("Announcer", 1)
            wagon.LampType = wagon:GetNW2Int("LampType", 1)
            wagon.Pneumatic.ValveType = wagon:GetNW2Int("Crane", 1)
            wagon:SetPackedBool("Crane013", wagon.Pneumatic.ValveType == 2)
            wagon:SetNW2Float("Crane013Loud", (wagon.Pneumatic.ValveType == 2 and math.random() > 0.9) and 1.1 + math.random() * 0.3 or 0)
            wagon:UpdateLampsColors()
            wagon:UpdateTextures()
            local used = {}
            local str = ""
            for i, k in ipairs(wagon.PR14XRelaysOrder) do
                local v = wagon.PR14XRelays[k]
                repeat
                    local rndi = math.ceil(math.random() * #v)
                    if not used[v[rndi][1]] then
                        str = str .. rndi
                        used[v[rndi][1]] = true
                        break
                    end
                until not used[v[rndi][1]]
            end

            wagon:SetNW2String("RelaysConfig", str)
            local pneumoPow = 0.8 + math.random() ^ 1.55 * 0.4
            if IsValid(wagon.FrontBogey) then
                wagon.FrontBogey:SetNW2Int("SquealType", math.floor(math.random(4, 7)))
                wagon.FrontBogey.PneumaticPow = pneumoPow
            end

            if IsValid(wagon.RearBogey) then
                wagon.RearBogey:SetNW2Int("SquealType", math.floor(math.random(4, 7)))
                wagon.RearBogey.PneumaticPow = pneumoPow
            end

            wagon.Pneumatic.VDLoud = math.random() < 0.06 and 0.9 + math.random() * 0.2
            if wagon.Pneumatic.VDLoud then wagon.Pneumatic.VDLoudID = math.random(1, 5) end
            wagon:SetNW2Bool("SecondKV", math.random() > 0.7)
            math.randomseed(os.time())
        end
    end
end

function RECIPE:InjectNeeded()
    if Metrostroi.Version > 1537278077 then return false end
    return true
end
