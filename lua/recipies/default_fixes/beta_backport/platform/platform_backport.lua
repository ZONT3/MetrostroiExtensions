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
MEL.DefineRecipe("platform_backport", {"gmod_track_platform"})
RECIPE.BackportPriority = 2
function RECIPE:Inject(ent)
    -- MEL.InjectIntoClientFunction(ent, "Initialize", function(wagon) wagon:DrawShadow(false) end, 1)
    -- MEL.InjectIntoServerFunction(ent, "Initialize", function(wagon) wagon:DrawShadow(false) end, 1)
    if CLIENT then
        function ent.Think(wagon)
            wagon.PrevTime = wagon.PrevTime or CurTime()
            wagon.DeltaTime = CurTime() - wagon.PrevTime
            wagon.PrevTime = CurTime()
            if wagon:IsDormant() then
                if wagon.Pool then wagon:OnRemove() end
                return
            end

            if wagon:GetNW2Bool("MustPlayAnnounces") then
                wagon.PassengerSounds:SetSoundLevel(105)
                wagon.PassengerSounds:Play()
                wagon.PassengerSounds:SetSoundLevel(105)
                wagon.PassengerSounds:ChangeVolume(0.3)
            else
                if wagon.PassengerSounds:IsPlaying() then wagon.PassengerSounds:Stop() end
            end

            if wagon:GetNW2Bool("MustPlaySpooky") then
                wagon.NonPassengerSounds:SetSoundLevel(105)
                wagon.NonPassengerSounds:Play()
                wagon.NonPassengerSounds:SetSoundLevel(105)
                wagon.NonPassengerSounds:ChangeVolume(1)
            else
                if wagon.NonPassengerSounds:IsPlaying() then wagon.NonPassengerSounds:Stop() end
            end

            -- Platform parameters
            local platformStart = wagon:GetNW2Vector("PlatformStart", false)
            local platformEnd = wagon:GetNW2Vector("PlatformEnd", false)
            local stationCenter = wagon:GetPos() --wagon:GetNW2Vector("StationCenter",false)
            if not platformStart or not platformEnd or not stationCenter or not wagon:GetNW2Float("X0", false) or not wagon:GetNW2Float("Sigma", false) then return end
            -- Platforms with tracks in middle
            local dot = (stationCenter - platformStart):Cross(platformEnd - platformStart)
            if dot.z > 0.0 then
                local a, b = platformStart, platformEnd
                platformStart, platformEnd = b, a
            end

            -- If platform is defined and pool is not
            --print(wagon:GetNW2Vector("StationCenter"))
            --print(entStart,entEnd,wagon.Pool)
            local dataReady = (wagon:GetNW2Float("X0", -1) >= 0) and (wagon:GetNW2Float("Sigma", -1) > 0)
            local poolReady = wagon.Pool and (#wagon.Pool == wagon:PoolSize())
            if (not poolReady) and (stationCenter:Length() > 0.0) then wagon:PopulatePlatform(platformStart, platformEnd, stationCenter) end
            local modelCount = 0
            -- Check if set of models changed
            if (CurTime() - (wagon.ModelCheckTimer or 0) > 1.0) and poolReady then
                wagon.ModelCheckTimer = CurTime()
                local WindowStart = wagon:GetNW2Int("WindowStart")
                local WindowEnd = wagon:GetNW2Int("WindowEnd")
                for i = 1, wagon:PoolSize() do
                    local in_bounds = false
                    if WindowStart <= WindowEnd then in_bounds = (i >= WindowStart) and (i < WindowEnd) end
                    if WindowStart > WindowEnd then in_bounds = (i >= WindowStart) or (i <= WindowEnd) end
                    if in_bounds then
                        -- Model in window
                        if not wagon.ClientModels[i] then
                            --wagon.ClientModels[i] = ents.CreateClientProp("models/metrostroi/81-717/reverser.mdl")
                            --wagon.ClientModels[i]:SetModel(wagon.Pool[i].model)
                            --hook.Add("MetrostroiBigLag",wagon.ClientModels[i],function(ent)
                            --    if not wagon.Pool then return end
                            --    ent:SetPos(wagon.Pool[i].pos)
                            --    ent:SetAngles(wagon.Pool[i].ang)
                            --    --if ent.Spawned then hook.Remove("MetrostroiBigLag",ent) end
                            --    --ent.Spawned = true
                            --end)
                            wagon.ClientModels[i] = ClientsideModel(wagon.Pool[i].model, RENDERGROUP_OPAQUE)
                            wagon.ClientModels[i]:SetPos(wagon.Pool[i].pos)
                            wagon.ClientModels[i]:SetAngles(wagon.Pool[i].ang)
                            wagon.ClientModels[i]:SetSkin(math.floor(wagon.ClientModels[i]:SkinCount() * wagon.Pool[i].skin))
                            wagon.ClientModels[i]:SetModelScale(wagon.Pool[i].scale, 0)
                            wagon.ClientModels[i]:DestroyShadow()
                            wagon.ClientModels[i]:DrawShadow(false)
                            modelCount = modelCount + 1
                            if modelCount > 15 then
                                poolReady = false
                                wagon.ModelCheckTimer = wagon.ModelCheckTimer - 0.9
                                break
                            end
                        end
                    else
                        -- Model found that is not in window
                        if IsValid(wagon.ClientModels[i]) then
                            -- Get nearest door
                            local count = wagon:GetNW2Int("TrainDoorCount", 0)
                            local distance = 1e9
                            local target = Vector(0, 0, 0)
                            for j = 1, count do
                                local vec = wagon:GetNW2Vector("TrainDoor" .. j, Vector(0, 0, 0))
                                local d = vec:DistToSqr(wagon.ClientModels[i]:GetPos())
                                if d < distance then
                                    target = vec
                                    distance = d
                                end
                            end

                            -- Add to list of cleanups
                            table.insert(wagon.CleanupModels, {
                                ent = wagon.ClientModels[i],
                                target = target,
                            })

                            wagon.ClientModels[i] = nil
                        end
                    end
                end
            end

            -- Add models for cleanup of people who left trains
            wagon.PassengersLeft = wagon.PassengersLeft or wagon:GetNW2Int("PassengersLeft")
            while poolReady and (wagon.PassengersLeft < wagon:GetNW2Int("PassengersLeft")) do
                -- Get random door
                local count = wagon:GetNW2Int("TrainDoorCount", 0)
                local i = math.max(1, math.min(count, 1 + math.floor((count - 1) * math.random() + 0.5)))
                local pos = wagon:GetNW2Vector("TrainDoor" .. i, Vector(0, 0, 0))
                pos.z = wagon:GetPos().z
                -- Create clientside model
                local i = math.max(1, math.min(wagon:PoolSize(), 1 + math.floor(math.random() * wagon:PoolSize() + 0.5)))
                --local ent = ents.CreateClientProp("models/metrostroi/81-717/reverser.mdl")
                --ent:SetModel(wagon.Pool[i].model)
                --hook.Add("MetrostroiBigLag",ent,function(ent)
                --    ent:SetPos(pos)
                --    --if ent.Spawned then hook.Remove("MetrostroiBigLag",ent) end
                --    --ent.Spawned = true
                --end)
                local ent = ClientsideModel(wagon.Pool[i].model, RENDERGROUP_OPAQUE)
                ent:SetPos(pos)
                ent:SetSkin(math.floor(ent:SkinCount() * wagon.Pool[i].skin))
                ent:SetModelScale(wagon.Pool[i].scale, 0)
                -- Generate target pos
                local platformDir = platformEnd - platformStart
                local platformN = (platformDir:Angle() + Angle(0, 90, 0)):Forward()
                local platformD = platformDir:GetNormalized()
                local platformWidth = ((platformStart - stationCenter) - (platformStart - stationCenter):Dot(platformD) * platformD):Length()
                local target = pos + platformN * platformWidth
                pos = pos - platformN * 4.0 * math.random()
                pos = pos + platformD * 16.0 * math.random()
                target = target + platformD * 128.0 * math.random()
                -- Add to list of cleanups
                table.insert(wagon.CleanupModels, {
                    ent = ent,
                    target = target,
                })

                -- Add passenger
                wagon.PassengersLeft = wagon.PassengersLeft + 1
            end

            -- Animate models for cleanup
            for k, v in pairs(wagon.CleanupModels) do
                --  if not v or not IsValid(v) then wagon.CleanupModels[k] = nil return end
                if not IsValid(v.ent) then
                    wagon.CleanupModels[k] = nil
                    continue
                end

                -- Get pos and target in XY plane
                local pos = v.ent:GetPos()
                local target = v.target
                pos.z = 0
                target.z = 0
                local distance = pos:DistToSqr(target)
                local count = wagon:GetNW2Int("TrainDoorCount", 0)
                -- Delete if reached the target point
                if distance < 2 * 256 or math.abs(LocalPlayer():GetPos().z - v.ent:GetPos().z) > 256 or count == 0 then --[[threshold]]
                    v.ent:Remove()
                    wagon.CleanupModels[k] = nil
                    continue
                end

                -- Find direction in which pedestrians must walk
                local targetDir = (target - pos):GetNormalized()
                -- Make it go along the platform if too far
                local threshold = 16
                if distance > 36864 then --[[192]]
                    local platformDir = (platformEnd - platformStart):GetNormalized()
                    local projection = targetDir:Dot(platformDir)
                    if math.abs(projection) > 0.1 then targetDir = (platformDir * projection):GetNormalized() end
                end

                -- Move pedestrian
                local speed = 150
                if distance > 1048576 then --[[1024]]
                    speed = 256
                end

                v.ent:SetPos(v.ent:GetPos() + targetDir * math.min(threshold, speed * wagon.DeltaTime))
                -- Rotate pedestrian
                v.ent:SetAngles(targetDir:Angle() + Angle(0, 180, 0))
                --[[ Check if door can be reached at all (it still exists)

        local distance = 1e9

        local new_target = target

        for j=1,count do

            local vec = wagon:GetNW2Vector("TrainDoor"..j,Vector(0,0,0))

            local d = vec:DistToSqr(v.target)

            if d < distance then

                new_target = vec

                distance = d

            end

        end



        --if distance > 32

        --then v.target = wagon:GetPos()

        --else v.target = new_target

        --end]]
            end
        end
    end

    if SERVER then
        local function getPassengerRate(passCount)
            if passCount < 80 then
                return 1 - ((passCount / 80) ^ 3) * 0.2
            else
                return 1 - math.min(1, (((passCount - 80) / 220) ^ 0.6) * 0.85 + 0.2)
            end
        end

        function ent.Think(wagon)
            if not Metrostroi.Stations[self.StationIndex] then return end
            -- Send update to client
            self:SetNW2Int("WindowStart", self.WindowStart)
            self:SetNW2Int("WindowEnd", self.WindowEnd)
            self:SetNW2Int("PassengersLeft", self.PassengersLeft)
            -- Check if any trains are at the platform
            if Metrostroi.Stations[self.StationIndex] then
                self.MustPlayAnnounces = not Metrostroi.Stations[self.StationIndex][self.PlatformIndex == 2 and 1 or 2] or self.PlatformIndex == 1
                self:SetNW2Bool("MustPlaySpooky", (not Metrostroi.Stations[self.StationIndex][self.PlatformIndex == 2 and 1 or 2]) and self.PlatformIndex == 1)
                if self:GetNW2Bool("MustPlaySpooky") then end
                if not timer.Exists("metrostroi_station_announce_" .. self:EntIndex()) and self.MustPlayAnnounces then timer.Create("metrostroi_station_announce_" .. self:EntIndex(), 0, 0, function() self:PlayAnnounce() end) end
                self.SyncAnnounces = self.InvertSides and Metrostroi.Stations[self.StationIndex][self.PlatformIndex == 2 and 1 or 2]
                self:SetNW2Bool("MustPlayAnnounces", self.MustPlayAnnounces or self.InvertSides)
            end

            local boardingDoorList = {}
            local CurrentTrain
            local TrainArrivedDist
            local PeopleGoing = false
            local boarding = false
            local BoardTime = 8 + 7 * self.HorliftStation
            for k, v in pairs(ents.FindByClass("gmod_subway_*")) do
                if v.Base ~= "gmod_subway_base" and v:GetClass() ~= "gmod_subway_base" then continue end
                if not IsValid(v) or v:GetPos():DistToSqr(self:GetPos()) > self.PlatformStart:DistToSqr(self.PlatformEnd) then continue end
                local platform_distance = ((self.PlatformStart - v:GetPos()) - (self.PlatformStart - v:GetPos()):Dot(self.PlatformNorm) * self.PlatformNorm):Length()
                local vertical_distance = math.abs(v:GetPos().z - self.PlatformStart.z)
                if vertical_distance >= 192 or platform_distance >= 256 then continue end
                local minb, maxb = v:LocalToWorld(Vector(-480, 0, 0)), v:LocalToWorld(Vector(480, 0, 0)) --FIXME
                --[[
        local minb,maxb = v:WorldSpaceAABB() --FIXME
        if (self:GetAngles()-v:GetAngles()):Forward().y > 0 then
            local temp = maxb
            maxb = minb
            minb = temp
        end
        --local train_start     = (v:LocalToWorld(Vector(480,0,0)) - self.PlatformStart):Dot(self.PlatformDir) / (self.PlatformDir:Length()^2)
        --local train_end           = (v:LocalToWorld(Vector(-480,0,0)) - self.PlatformStart):Dot(self.PlatformDir) / (self.PlatformDir:Length()^2)]]
                local train_start = (maxb - self.PlatformStart):Dot(self.PlatformDir) / (self.PlatformDir:Length() ^ 2)
                local train_end = (minb - self.PlatformStart):Dot(self.PlatformDir) / (self.PlatformDir:Length() ^ 2)
                local left_side = train_start > train_end
                if self.InvertSides then left_side = not left_side end
                local doors_open = left_side and v.LeftDoorsOpen or not left_side and v.RightDoorsOpen
                if (train_start < 0) and (train_end < 0) then doors_open = false end
                if (train_start > 1) and (train_end > 1) then doors_open = false end
                if -0.2 < train_start and train_start < 1.2 then
                    v.BoardTime = self.Timer and CurTime() - self.Timer
                    v.Horlift = self.HorliftStation > 0
                end

                if 0 < train_start and train_start < 1 and (not TrainArrivedDist or TrainArrivedDist < train_start) then
                    TrainArrivedDist = train_start
                    CurrentTrain = v
                end

                -- Check horizontal lift station logic
                local passengers_can_board = false
                if self.HorliftStation > 0 then
                    -- Check fine stop
                    local stopped_fine = false
                    for i = 0, 4 do
                        local x_s = 0.99086 - i * 0.1929
                        local x_e = 0.97668 - i * 0.1929
                        stopped_fine = stopped_fine or ((train_start < x_s) and (train_start > x_e))
                    end

                    -- Open doors on station
                    if stopped_fine and (v.SOSD or self.OldOpened and not self.OpenedBySOSD) then
                        self.OpenedBySOSD = v.SOSD
                        self.HorliftTimer1 = self.HorliftTimer1 or CurTime()
                        if (CurTime() - self.HorliftTimer1) > 0.5 then
                            if not self.HorliftTimer2 then self:FireHorliftDoors("Open") end
                            self.HorliftTimer2 = CurTime()
                        end
                    end

                    -- Allow boarding
                    if self.HorliftTimer2 and self:GetDoorState() then passengers_can_board = doors_open end
                else
                    passengers_can_board = doors_open
                end

                -- Board passengers
                if passengers_can_board then
                    -- Find player of the train
                    local driver = getTrainDriver(v)
                    -- Limit train to platform
                    train_start = math.max(0, math.min(1, train_start))
                    train_end = math.max(0, math.min(1, train_end))
                    -- Check if this was the last stop
                    if v.LastPlatform ~= self then
                        v.LastPlatform = self
                        if v.AnnouncementToLeaveWagonAcknowledged then v.AnnouncementToLeaveWagonAcknowledged = nil end
                        -- How many passengers must leave on this station
                        local proportion = math.random() * math.max(0, 1.0 + math.log(self.PopularityIndex))
                        if self.PlatformLast then proportion = 1 end
                        if v.AnnouncementToLeaveWagon == true then proportion = 1 end
                        -- Total count
                        v.PassengersToLeave = math.floor(proportion * v:GetNW2Float("PassengerCount") + 0.5)
                    end

                    -- Check for announcement
                    if v.AnnouncementToLeaveWagon and not v.AnnouncementToLeaveWagonAcknowledged then v.AnnouncementToLeaveWagonAcknowledged = true end
                    -- Calculate number of passengers near the train
                    local passenger_density = math.abs(CDF(train_start, self.PlatformX0, self.PlatformSigma) - CDF(train_end, self.PlatformX0, self.PlatformSigma))
                    local passenger_count = passenger_density * self:PopulationCount()
                    -- Get number of doors
                    local door_count = #v.LeftDoorPositions
                    if not left_side then door_count = #v.RightDoorPositions end
                    -- Get maximum boarding rate for normal russian subway train doors
                    local max_boarding_rate = getPassengerRate(v:GetNW2Int("PassengerCount")) * 1.4 * door_count * dT
                    --print(Format("R:%.2f\tS:%.2f\tP:% 3d",max_boarding_rate,getPassengerRate(v:GetNW2Int("PassengerCount")),v:GetNW2Int("PassengerCount")))
                    -- Get boarding rate based on passenger density
                    local boarding_rate = math.min(max_boarding_rate, passenger_count)
                    if self.PlatformLast then boarding_rate = 0 end
                    -- Get rate of leaving
                    local leaving_rate = 1.4 * door_count * dT
                    if v.PassengersToLeave == 0 and not v.AnnouncementToLeaveWagonAcknowledged then leaving_rate = 0 end
                    -- Board these passengers into train
                    local speedLimit = math.max(0, 1 - math.abs(v.Speed / 5))
                    local boarded, left, count
                    --if v.AnnouncementToLeaveWagonAcknowledged then
                    if v.AnnouncementToLeaveWagonAcknowledged then
                        boarded = 0
                        left = math.ceil(math.min(math.max(2, leaving_rate + 0.5), v:GetNW2Int("PassengerCount")) * speedLimit * 1.5)
                        count = v:GetNW2Int("PassengerCount")
                    else
                        count = self:PopulationCount() + v.PassengersToLeave
                        boarded = math.ceil(math.min(math.max(2, boarding_rate + 0.5), self:PopulationCount()) * speedLimit)
                        left = math.ceil(math.min(math.max(2, leaving_rate + 0.5), v.PassengersToLeave) * speedLimit)
                    end

                    if v.PrevLeftDoorsOpening ~= v.LeftDoorsOpening then
                        v.CanStuckPassengerLeft = not v.LeftDoorsOpening and ((boarded > 0 or left > 0) and math.min(1, count / 100) or math.min(1, count / 400))
                        v.PrevLeftDoorsOpening = v.LeftDoorsOpening
                        if v.LeftDoorsOpening then v.LastPlatform = nil end
                    end

                    if v.PrevRightDoorsOpening ~= v.RightDoorsOpening then
                        v.CanStuckPassengerRight = not v.RightDoorsOpening and ((boarded > 0 or left > 0) and math.min(1, count / 100) or math.min(1, count / 400))
                        v.PrevRightDoorsOpening = v.RightDoorsOpening
                        if v.RightDoorsOpening then v.LastPlatform = nil end
                    end

                    if math.random() <= math.Clamp(17 - passenger_count, 0, 17) / 17 * 0.5 then boarded = 0 end
                    if math.random() <= math.Clamp(17 - v.PassengersToLeave, 0, 17) / 17 * 0.5 then left = 0 end
                    local passenger_delta = boarded - left
                    -- People board from platform
                    if boarded > 0 then
                        PeopleGoing = true
                        self.WindowStart = (self.WindowStart + boarded) % self:PoolSize()
                    end

                    -- People leave to
                    if left > 0 then
                        PeopleGoing = true
                        if IsValid(driver) then
                            driver:AddFrags(left)
                            driver.MTransportedPassengers = (driver.MTransportedPassengers or 0) + left
                        end

                        -- Move passengers
                        v.PassengersToLeave = v.PassengersToLeave - left
                        self.PassengersLeft = self.PassengersLeft + left
                        if v.AnnouncementToLeaveWagonAcknowledged and not self.PlatformLast then
                            if math.random() > 0.3 then self.WindowStart = (self.WindowStart - left) % self:PoolSize() end
                        elseif not self.PlatformLast and math.random() > 0.9 then
                            self.WindowStart = (self.WindowStart - left) % self:PoolSize()
                        end
                    end

                    --[[ People boarded train
            if boarded > 0 then
                if IsValid(driver) then
                    driver:AddDeaths(boarded)
                end
            end]]
                    -- Change number of people in train
                    v:BoardPassengers(passenger_delta)
                    -- Keep list of door positions
                    if left_side then
                        for k, vec in ipairs(v.LeftDoorPositions) do
                            table.insert(boardingDoorList, v:LocalToWorld(vec))
                        end
                    else
                        for k, vec in ipairs(v.RightDoorPositions) do
                            table.insert(boardingDoorList, v:LocalToWorld(vec))
                        end
                    end

                    if v.AnnouncementToLeaveWagonAcknowledged then
                        BoardTime = math.max(BoardTime, 8 + 7 * self.HorliftStation + (v.PassengersToLeave or 0) * dT * 0.6)
                    else
                        BoardTime = math.max(BoardTime, 8 + 7 * self.HorliftStation + math.max((v.PassengersToLeave or 0) * dT, self:PopulationCount() * dT) * 0.5)
                    end
                    -- Add doors to boarding list
                    --print("BOARDING",boarding_rate,"DELTA = "..passenger_delta,self.PlatformLast,v:GetNW2Int("PassengerCount"))
                end

                if v.UPO then v.UPO.AnnouncerPlay = self.AnnouncerPlay end
                v.BoardTimer = self.BoardTimer
                boarding = boarding or passengers_can_board
            end

            --if not boarding then CurrentTrain = nil end
            self.BoardTime = BoardTime
            if CurrentTrain and not self.CurrentTrain then
                self.CurrentTrain = CurrentTrain
                self:PlayAnnounce(1)
            elseif not CurrentTrain and self.CurrentTrain then
                self.CurrentTrain = nil
            end

            --PUI Timer
            if boarding and not self.Timer then self.Timer = math.max(CurTime() + 20, CurTime() + self.BoardTime) end
            if not self.CurrentTrain and self.Timer then self.Timer = nil end
            if self.Timer then
                self.BoardTimer = -(CurTime() - self.Timer)
                self.AnnouncerPlay = self.BoardTimer < 8 + 7 * self.HorliftStation + 0.2
                --print(self.PlatformIndex,self.BoardTimer,self.AnnouncerPlay)
            else
                self.BoardTimer = 20
                self.AnnouncerPlay = false
            end

            if IsValid(self.PUI) then
                local train = self.CurrentTrain
                if IsValid(train) and Metrostroi.EndStations and Metrostroi.EndStations[1] and type(train.SignsIndex) == "number" then
                    local id = Metrostroi.EndStations[1][1]
                    for k, v in pairs(train.SignsList or {}) do
                        if v == train.SignsIndex then
                            id = k
                            break
                        end
                    end

                    local ends = false
                    for k, v in pairs(Metrostroi.EndStations) do
                        if id == v[1] or id == v[#v] then
                            ends = true
                            break
                        end
                    end

                    if ends then
                        self.PUI.Last = 0
                    else
                        self.PUI.Last = id
                    end
                else
                    self.PUI.Last = 0
                end

                if IsValid(self.CurrentTrain) and IsValid(self.PUI) and self.Timer then
                    if not self.PUI.Work then self.PUI.Work = true end
                    self.PUI.BoardTime = self.BoardTimer
                    local time = 8 + 7 * self.HorliftStation
                    self.PUI.Lamp = time - 0.2 < self.BoardTimer and self.BoardTimer < time + 0.3
                else
                    self.PUIStartGoing = false
                    self.PUI.Work = false
                    self.PUI.Lamp = false
                end
            end

            --[[
    if self.CurrentTrain and not self.SignOff then
        if not self.TritonePlayed then
            if false and self.CurrentTrain.SignsList and (self.CurrentTrain.SignsList[self.CurrentTrain.SignsIndex] == "" or self.CurrentTrain.SignsList[self.CurrentTrain.SignsIndex] and self.CurrentTrain.SignsList[self.CurrentTrain.SignsIndex][3]) then
                self:PlayAnnounce(2,self.NoEntry.arr)
                timer.Simple(20,function()
                    if not IsValid(self.CurrentTrain) then return end
                    self:PlayAnnounce(2,self.NoEntry.dep)
                    if self.CurrentTrain.SignsIndex == #self.CurrentTrain.SignsList-3 then
                        timer.Simple(15,function() self:PlayAnnounce(2,self.NoEntry.depot) end)
                    end
                end)
            else
                local spec = false
                if self.NoEntry.specarr then
                    for k,v in pairs( self.CurrentTrain.SignsList or {}) do
                        if v ==  self.CurrentTrain.SignsIndex then
                            if Metrostroi.StationAnnouncesTo[self.StationIndex][2] == k then
                                spec = true
                                break
                            end
                        end
                    end
                end
                if spec then
                    self:PlayAnnounce(2,self.NoEntry.specarr)
                    timer.Simple(20,function()
                        if not IsValid(self.CurrentTrain) then return end
                        self:PlayAnnounce(2,self.NoEntry.specdep)
                    end)
                else
                    self:PlayAnnounce(1)
                end
            end
            self.TritonePlayed = true
        end
    else
        self.TritonePlayed = nil
    end]]
            -- Add passengers
            if (not self.PlatformLast) and (#boardingDoorList == 0) then
                local target = (Metrostroi.PassengersScale or 50) * self.PopularityIndex --300
                -- then target = target*0.1 end
                if target <= 0 then
                    self.WindowEnd = self.WindowStart
                elseif self.WindowEnd < self:PoolSize() then
                    local growthDelta = math.max(0, (target - self:PopulationCount()) * 0.005)
                    if growthDelta > 0.0 and growthDelta < 1.0 then -- Accumulate fractional rate
                        self.GrowthAccumulation = (self.GrowthAccumulation or 0) + growthDelta
                        if self.GrowthAccumulation > 1.0 then
                            growthDelta = 1
                            self.GrowthAccumulation = self.GrowthAccumulation - 1.0
                        end
                    end

                    self.WindowEnd = math.min(self:PoolSize(), self.WindowEnd + math.floor(growthDelta + 0.5))
                end
            end

            if self.HorliftStation > 0 then
                if self.HorliftTimer2 then
                    if (CurTime() - self.HorliftTimer2) > 1 then
                        self:FireHorliftDoors("Close")
                        self.HorliftTimer1 = nil
                        self.HorliftTimer2 = nil
                        self.HorliftTimer3 = CurTime()
                    end
                end

                if self.HorliftTimer3 and (CurTime() - self.HorliftTimer3) > 2.5 then self.HorliftTimer3 = nil end
            end

            if self.OldOpened ~= self:GetDoorState() or self.OldPeopleGoing ~= PeopleGoing then
                self.ARSOverride = true
                self.OldOpened = self:GetDoorState()
                self.OldPeopleGoing = PeopleGoing
                if not self.OldOpened then self.OpenedBySOSD = false end
            end

            -- Block local ARS sections
            if self.ARSOverride ~= nil then
                -- Signal override to all signals
                local ars_ents = ents.FindInSphere(self.PlatformEnd, 768)
                for k, v in pairs(ars_ents) do
                    local delta_z = math.abs(self.PlatformEnd.z - v:GetPos().z)
                    if (v:GetClass() == "gmod_track_signal") and (delta_z < 128) then v.OverrideTrackOccupied = self:GetDoorState() end
                    if (v:GetClass() == "gmod_track_horlift_signal") and (delta_z < 90 and v:GetNWInt("Type") == 0 or v:GetNWInt("Type") == 1) then
                        v.WhiteSignal = self:GetDoorState()
                        v.YellowSignal = not self:GetDoorState()
                        v.PeopleGoing = PeopleGoing
                    end
                end

                -- Finish override
                self.ARSOverride = nil
            end

            if self.BoardingDoorListLength ~= #boardingDoorList then
                -- Send boarding list FIXME make this nicer
                for k, v in ipairs(boardingDoorList) do
                    self:SetNW2Vector("TrainDoor" .. k, v)
                end

                self:SetNW2Int("TrainDoorCount", #boardingDoorList)
            end

            self.BoardingDoorListLength = #boardingDoorList
            self:NextThink(CurTime() + dT)
            return true
        end
    end
end