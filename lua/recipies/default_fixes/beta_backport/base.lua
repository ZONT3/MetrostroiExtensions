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
MEL.DefineRecipe("base_backport", "gmod_subway_base")
RECIPE.Description = "This recipe backports changes for gmod_subway_base from metrostroi beta"
-- local C_DisableHUD          = GetConVar("metrostroi_disablehud")
local C_RenderDistance = GetConVar("metrostroi_renderdistance")
local C_SoftDraw = GetConVar("metrostroi_softdrawmultipier")
local C_ScreenshotMode = GetConVar("metrostroi_screenshotmode")
local C_DrawDebug = GetConVar("metrostroi_drawdebug")
-- local C_CabFOV              = GetConVar("metrostroi_cabfov")
-- local C_CabZ                = GetConVar("metrostroi_cabz")
-- local C_FovDesired          = GetConVar("fov_desired")
-- local C_MinimizedShow       = GetConVar("metrostroi_minimizedshow")
local C_Shadows1 = GetConVar("metrostroi_shadows1")
local C_Shadows2 = GetConVar("metrostroi_shadows2")
local C_Shadows3 = GetConVar("metrostroi_shadows3")
local C_Shadows4 = GetConVar("metrostroi_shadows4")
local C_AA = GetConVar("mat_antialias")
local C_Sprites = GetConVar("metrostroi_sprites")
local C_DisableSeatShadows = GetConVar("metrostroi_disableseatshadows")
function RECIPE:Init()

end

function RECIPE:Inject(ent, entclass)
    ent.CustomThinks = ent.CustomThinks or {}
    ent.CustomSpawnerUpdates = ent.CustomSpawnerUpdates or {}
    local function destroySound(snd, nogc)
        -- if IsValid(snd) then snd:Stop() end -- ????
        if not nogc and snd and snd.__gc then snd:__gc() end
    end

    local function PauseBASS(snd)
        snd:Pause()
        snd:SetTime(0)
    end

    function ent.DestroySound(snd, nogc)
        destroySound(snd, nogc)
    end

    ent.LeftDoorPositions = {Vector(0, 0, 0)}
    ent.RightDoorPositions = {Vector(0, 0, 0)}
    ent.MirrorCams = {Vector(450, 71, 24), Angle(1, 180, 0), 15, Vector(450, -71, 24), Angle(1, 180, 0), 15,}
    function ent.CreateBASSSound(wagon, name, callback, noblock, onerr)
        if wagon.StopSounds or not wagon.ClientPropsInitialized or wagon.CreatingCSEnts then return end
        --if wagon.SoundSpawned and name:find(".wav") then return end
        --wagon.SoundSpawned = true
        sound.PlayFile(Sound("sound/" .. name), "3d noplay mono" .. (noblock and " noblock" or ""), function(snd, err, errName)
            if not IsValid(wagon) then
                destroySound(snd)
                return
            end

            if err then
                wagon:DestroySound(snd)
                if err == 4 or err == 37 then wagon.StopSounds = true end
                if err ~= 41 then
                    MsgC(Color(255, 0, 0), Format("Sound:%s\n\tErrCode:%s, ErrName:%s\n", name, err, errName))
                    if onerr then callback(false) end
                elseif GetConVar("metrostroi_drawdebug"):GetInt() ~= 0 then
                    MsgC(Color(255, 255, 0), Format("Sound:%s\n\tBASS_ERROR_UNKNOWN (it's normal),ErrCode:%s, ErrName:%s\n", name, err, errName))
                    wagon:CreateBASSSound(name, callback)
                end
                return
            elseif not wagon.Sounds then
                wagon:DestroySound(snd)
                if onerr then callback(false) end
            else
                callback(snd)
            end
        end)
    end

    function ent.SetSoundState(wagon, soundid, volume, pitch, time)
        --volume = (input.IsKeyDown( KEY_LALT ) and soundid == "horn") and 0 or 1+math.sin(CurTime()*3)*0.2
        --pitch = (input.IsKeyDown( KEY_LALT ) and soundid == "horn") and 1 or 1+math.sin(CurTime()*3)*0.2
        if wagon.StopSounds or not wagon.ClientPropsInitialized or wagon.CreatingCSEnts then return end
        local name = wagon.SoundNames and wagon.SoundNames[soundid]
        local tbl = wagon.SoundPositions[soundid]
        local looptbl = type(name) == "table" and name
        if looptbl and #name > 1 then --triple-looped sound
            if not wagon.Sounds.loop[soundid] then
                wagon.Sounds.loop[soundid] = {
                    state = false,
                    newstate = false,
                    pitch = 0
                }
            end

            local sndtbl = wagon.Sounds.loop[soundid]
            if volume > 0 then sndtbl.volume = volume end
            if pitch > 0 then sndtbl.pitch = pitch end
            for i, v in ipairs(name) do
                if not sndtbl[i] then sndtbl[i] = {} end
                if not IsValid(sndtbl[i].sound) and sndtbl[i].sound ~= false then
                    wagon:CreateBASSSound(v, function(snd)
                        if not snd then
                            destroySound(sndtbl[i].sound)
                            sndtbl[i].sound = nil
                            return
                        end

                        snd:SetPos(wagon:LocalToWorld(tbl[3]), wagon:GetAngles():Forward())
                        sndtbl[i].sound = snd
                        sndtbl[i].volume = volume > 0 and sndtbl.volume or volume or 0
                        wagon:SetBassParameters(snd, pitch, sndtbl[i].volume, tbl, i == 2)
                    end, true, true)

                    sndtbl[i].sound = false
                end
            end

            local state = volume > 0
            if sndtbl.state ~= state then
                sndtbl[1].state = state
                if not state then sndtbl[2].state = false end
                sndtbl[3].state = not state
                sndtbl.control = state and 1 or 3
                sndtbl.state = state
            end
        else
            if looptbl then name = name[1] end
            local snd = wagon.Sounds[soundid]
            if not IsValid(snd) and name and snd ~= false then
                wagon:CreateBASSSound(name, function(snd)
                    if not snd then
                        destroySound(wagon.Sounds[soundid])
                        wagon.Sounds[soundid] = nil
                        return
                    end

                    wagon.Sounds[soundid] = snd
                    wagon.Sounds.isloop[soundid] = true
                    wagon:SetBassParameters(snd, pitch, volume, tbl, looptbl and looptbl.loop)
                end, true, true)

                wagon.Sounds[soundid] = false
                return
            end

            if not IsValid(snd) then return end
            if (volume <= 0) or (pitch <= 0) then
                if snd:GetTime() > 0 then PauseBASS(snd) end
                return
            end

            if snd:GetState() ~= GMOD_CHANNEL_PLAYING then
                if timeout then snd:SetTime(time) end
                snd:Play()
            end

            snd:SetPlaybackRate(pitch)
            if tbl and tbl[4] then
                snd:SetVolume(tbl[4] * volume)
            else
                snd:SetVolume(volume)
            end
        end
    end

    function ent.PlayOnceFromPos(wagon, id, sndname, volume, pitch, min, max, location)
        if wagon.StopSounds or not wagon.ClientPropsInitialized or wagon.CreatingCSEnts then return end
        wagon:DestroySound(wagon.Sounds[id], true)
        wagon.Sounds[id] = nil
        if sndname == "_STOP" then return end
        wagon.SoundPositions[id] = {min, max, location}
        wagon:CreateBASSSound(sndname, function(snd)
            wagon.Sounds[id] = snd
            wagon:SetBassParameters(wagon.Sounds[id], pitch, volume, wagon.SoundPositions[id], false)
            snd:Play()
        end)
    end

    function ent.PlayOnce(wagon, soundid, location, range, pitch, randoff)
        if wagon.StopSounds or not wagon.ClientPropsInitialized or wagon.CreatingCSEnts then return end
        if not soundid then ErrorNoHalt(debug.Trace()) end
        -- Emit sound from right location
        if wagon.ClientSounds and wagon.ClientSounds[soundid] then
            local entsound = wagon.ClientSounds[soundid]
            for i, esnd in ipairs(entsound) do
                soundid = esnd[2](wagon, range, location)
                local soundname = wagon.SoundNames[soundid]
                if not soundname then
                    print("NO SOUND", soundname, soundid)
                    continue
                end

                if type(soundname) == "table" then soundname = table.Random(soundname) end
                if IsValid(wagon.ClientEnts[esnd[1]]) and not wagon.ClientEnts[esnd[1]].snd then
                    local ent = wagon.ClientEnts[esnd[1]]
                    sound.PlayFile("sound/" .. soundname, "3d noplay mono", function(snd, err, errName)
                        if not IsValid(wagon) then
                            destroySound(snd)
                            return
                        end

                        if err then
                            wagon:DestroySound(snd)
                            if err == 4 or err == 37 then wagon.StopSounds = true end
                            if err ~= 41 then
                                MsgC(Color(255, 0, 0), Format("Sound:%s\n\tErrCode:%s, ErrName:%s\n", name, err, errName))
                            elseif GetConVar("metrostroi_drawdebug"):GetInt() ~= 0 then
                                MsgC(Color(255, 255, 0), Format("Sound:%s\n\tBASS_ERROR_UNKNOWN (it's normal),ErrCode:%s, ErrName:%s\n", name, err, errName))
                                --wagon:PlayOnce(soundid,location,range,pitch,randoff)
                            end
                            return
                        elseif not IsValid(ent) then
                            wagon:DestroySound(snd)
                        else
                            snd:SetPos(ent:GetPos(), ent:LocalToWorldAngles(esnd[7]):Forward())
                            snd:SetPlaybackRate(esnd[4])
                            snd:SetVolume(esnd[3])
                            if esnd[5] then snd:Set3DFadeDistance(esnd[5], esnd[6]) end
                            table.insert(ent.BASSSounds, snd)
                            snd:Play()
                            --local siz1,siz2 = snd:Get3DFadeDistance()
                            --debugoverlay.Sphere(snd:GetPos(),4,2,Color(0,255,0),true)
                            --debugoverlay.Sphere(snd:GetPos(),siz1,2,Color(255,0,0,100),false)
                            --debugoverlay.Sphere(snd:GetPos(),siz2,2,Color(0,0,255,100),false)
                        end
                    end)
                end
            end
            return
        end

        local tbl = wagon.SoundPositions[soundid]
        local soundname = wagon.SoundNames[soundid]
        if type(soundname) == "table" then soundname = table.Random(soundname) end
        if not soundname or not tbl then
            --print("NO SOUND",soundname,soundid)
            return
        end

        if IsValid(wagon.Sounds[soundid]) then
            wagon:DestroySound(wagon.Sounds[soundid])
            wagon.Sounds[soundid] = nil
        end

        wagon:CreateBASSSound(soundname, function(snd)
            wagon.Sounds[soundid] = snd
            wagon:SetBassParameters(wagon.Sounds[soundid], pitch, range, tbl, false)
            snd:Play()
        end)
    end

    if CLIENT then
        function ent.ShouldDrawClientEnt(wagon, k, v)
            if wagon.Hidden[k] or wagon.Hidden.anim[k] then return false end
            v = v or wagon.ClientProps[k]
            if not v then return false end
            local distance = LocalPlayer():GetPos():Distance(wagon:LocalToWorld(v.pos))
            local renderDist = C_RenderDistance:GetFloat()
            if v.nohide then return true end
            if v.hideseat then
                local seat = LocalPlayer():GetVehicle()
                if IsValid(seat) and wagon ~= seat:GetParent() then return false end
                if v.hideseat ~= true then return distance <= renderDist * v.hideseat end
            elseif v.hide then
                return distance <= renderDist * v.hide
            else
                return distance <= renderDist
            end
        end

        function ent.SpawnCSEnt(wagon, k, override)
            if override and (wagon.Hidden[k] or wagon.Hidden.anim[k]) or not override and not wagon:ShouldDrawClientEnt(k, wagon.ClientProps[k]) then return false end
            local v = wagon.ClientPropsOv and wagon.ClientPropsOv[k] or wagon.ClientProps[k]
            if v and not IsValid(wagon.ClientEnts[k]) and v.model ~= "" then
                local model = v.model
                if v.modelcallback then model = v.modelcallback(wagon) or v.model end
                local cent = ClientsideModel(model, RENDERGROUP_OPAQUE)
                cent.GetBodyColor = function()
                    if not IsValid(wagon) then return Vector(1) end
                    return wagon:GetBodyColor()
                end

                cent.GetDirtLevel = function()
                    if not IsValid(wagon) then return 0.25 end
                    return wagon:GetDirtLevel()
                end

                cent:SetParent(wagon)
                cent:SetPos(wagon:LocalToWorld(v.pos))
                cent:SetAngles(wagon:LocalToWorldAngles(v.ang))
                cent:SetLOD(C_ScreenshotMode:GetBool() and 0 or -1)
                cent:SetSkin(v.skin or 0)
                if v.scale then cent:SetModelScale(v.scale) end
                if v.bscale then cent:ManipulateBoneScale(0, v.bscale) end
                if wagon.Anims[k] and wagon.Anims[k].value and type(wagon.Anims[k].value) == "number" then cent:SetPoseParameter("position", wagon.Anims[k].value) end
                if v.bodygroup then
                    for k1, v1 in pairs(v.bodygroup) do
                        cent:SetBodygroup(v1, k1)
                    end
                end

                if v.lamps then
                    for i, k in ipairs(v.lamps) do
                        wagon.HiddenLamps[k] = false
                    end
                end

                cent.lamps = v.lamps
                local texture = Metrostroi.Skins["train"][wagon:GetNW2String("Texture")]
                local passtexture = Metrostroi.Skins["pass"][wagon:GetNW2String("PassTexture")]
                local cabintexture = Metrostroi.Skins["cab"][wagon:GetNW2String("CabTexture")]
                for k1, v1 in pairs(cent:GetMaterials() or {}) do
                    local tex = v1:gsub("^.+/", "")
                    if cabintexture and cabintexture.textures and cabintexture.textures[tex] then if type(cabintexture.textures[tex]) ~= "table" then cent:SetSubMaterial(k1 - 1, cabintexture.textures[tex]) end end
                    if passtexture and passtexture.textures and passtexture.textures[tex] then cent:SetSubMaterial(k1 - 1, passtexture.textures[tex]) end
                    if texture and texture.textures and texture.textures[tex] then cent:SetSubMaterial(k1 - 1, texture.textures[tex]) end
                end

                wagon.ClientEnts[k] = cent
                if wagon.SmoothHide[k] then
                    if wagon.SmoothHide[k] > 0 then
                        cent:SetColor(ColorAlpha(v.color or color_white, wagon.SmoothHide[k] * 255))
                        cent:SetRenderMode(RENDERMODE_TRANSALPHA)
                    else
                        cent:Remove()
                        wagon:ShowHide(k, false, true)
                    end
                elseif v.colora then
                    cent:SetRenderMode(RENDERMODE_TRANSCOLOR)
                    cent:SetColor(v.colora)
                else
                    cent:SetColor(v.color or color_white)
                end

                cent.BASSSounds = {}
                cent.DestroySound = wagon.DestroySound
                cent.Think = function(ent)
                    for k, v in pairs(ent.BASSSounds) do
                        if not IsValid(v) or v:GetState() == GMOD_CHANNEL_STOPPED then
                            wagon:DestroySound(v)
                            table.remove(ent.BASSSounds, k)
                        end
                    end

                    ent:SetNextClientThink(CurTime() + 0.5)
                    return true
                end

                cent.CalcAbsolutePosition = function(ent, pos, ang)
                    for k, v in pairs(ent.BASSSounds) do
                        if IsValid(v) and v:GetState() ~= GMOD_CHANNEL_STOPPED then v:SetPos(pos, ang:Forward()) end
                    end
                end

                if v.lamps then
                    cent:CallOnRemove("RemoveLights", function(ent)
                        if IsValid(wagon) then
                            for i, k in ipairs(ent.lamps) do
                                wagon:SetLightPower(k, false)
                                wagon.HiddenLamps[k] = true
                            end
                        end
                    end)
                end

                wagon:ShowHide(k, not wagon.Hidden[k], true)
                if v.callback then v.callback(wagon, cent) end
                return true
            end
            return false
        end

        hook.Remove("EntityRemoved", "metrostroi_bass_disable")
        hook.Add("EntityRemoved", "metrostroi_bass_disable", function(wagon)
            if wagon.BASSSounds then
                for k, v in pairs(wagon.BASSSounds) do
                    wagon:DestroySound(v)
                    wagon.BASSSounds[k] = nil
                end
            end
        end)

        local spawnedCount = 0
        hook.Remove("Think", "SpwanElasped")
        hook.Add("Think", "SpawnElasped", function()
            elapsed = SysTime()
            spawnedCount = 0
        end)

        function ent.CreateCSEnts(wagon)
            local mul = C_SoftDraw:GetFloat() / 100
            local time = mul * 0.01
            if wagon.ClientPropsOv then
                for k in pairs(wagon.ClientPropsOv) do
                    if k ~= "BaseClass" and not IsValid(wagon.ClientEnts[k]) and wagon:SpawnCSEnt(k) and SysTime() - elapsed > time then return false end
                end
            end

            for k in pairs(wagon.ClientProps) do
                if k ~= "BaseClass" and not IsValid(wagon.ClientEnts[k]) then
                    if spawnedCount * mul * 3 > 4 and SysTime() - elapsed > time then return false end
                    if wagon:SpawnCSEnt(k) then spawnedCount = spawnedCount + 1 end
                end
            end
            return true
        end

        function ent.CanDrawThings(wagon)
            return not LocalPlayer().InMetrostroiTrain or wagon == LocalPlayer().InMetrostroiTrain
        end

        local function colAlpha(col, a)
            return Color(col.r * a, col.g * a, col.b * a)
        end

        hook.Remove("PostDrawTranslucentRenderables", "metrostroi_base_draw")
        hook.Add("PostDrawTranslucentRenderables", "metrostroi_base_draw", function(_, isDD)
            if isDD then return end
            local inSeat = LocalPlayer().InMetrostroiTrain
            for wagon in pairs(Metrostroi.SpawnedTrains) do
                if wagon:IsDormant() then continue end
                if MetrostroiStarted and MetrostroiStarted ~= true or wagon.RenderBlock then
                    if not inSeat then
                        local timeleft = math.max(0, (MetrostroiStarted and MetrostroiStarted ~= true) and 3 - (RealTime() - MetrostroiStarted) or 3 - (RealTime() - wagon.RenderBlock)) + 0.99
                        cam.Start3D2D(wagon:LocalToWorld(Vector(0, -150, 100)), wagon:LocalToWorldAngles(Angle(0, 90, 90)), 1.5)
                        draw.SimpleText("Wait, train will be available across " .. string.NiceTime(timeleft))
                        cam.End3D2D()
                        cam.Start3D2D(wagon:LocalToWorld(Vector(0, 150, 100)), wagon:LocalToWorldAngles(Angle(0, -90, 90)), 1.5)
                        draw.SimpleText("Wait, train will be available across " .. string.NiceTime(timeleft))
                        cam.End3D2D()
                    end

                    continue
                end

                cam.IgnoreZ(true)
                for i, vHandle in pairs(wagon.Sprites or {}) do
                    local br = wagon.LightBrightness[i]
                    local lightData = wagon.LightsOverride[i] or wagon.Lights[i]
                    if lightData[1] ~= "glow" and lightData[1] ~= "light" or br <= 0 then continue end
                    local pos = wagon:LocalToWorld(lightData[2])
                    local visibility = util.PixelVisible(pos, lightData.size or 5, vHandle) --math.max(0,util.PixelVisible(pos, 5, vHandle)-0.25)/0.75
                    if visibility > 0 then
                        render.SetMaterial(lightData.mat)
                        render.DrawSprite(pos, 128 * lightData.scale, 128 * (lightData.vscale or lightData.scale), colAlpha(lightData[4] or Color(255, 255, 255), visibility * br))
                    end
                end

                cam.IgnoreZ(false)
                if not wagon.ShouldRenderClientEnts or not wagon:ShouldRenderClientEnts() then continue end
                if wagon.DrawPost then wagon:DrawPost(not wagon:CanDrawThings()) end
                if not wagon:CanDrawThings() then continue end
                wagon.CLDraw = true
                if wagon.Systems then
                    for _, v in pairs(wagon.Systems) do
                        v:ClientDraw()
                    end
                end
            end
        end)

        local function enableDebug()
            -- if C_DrawDebug:GetInt() > 0 then
            if false then
                hook.Add("PostDrawTranslucentRenderables", "MetrostroiTrainDebug", function(bDrawingDepth, bDrawingSkybox)
                    if bDrawingSkybox then return end
                    for wagon in pairs(Metrostroi.SpawnedTrains) do
                        -- Debug draw for buttons
                        if wagon.ButtonMap ~= nil then
                            draw.NoTexture()
                            for kp, panel in pairs(wagon.ButtonMap) do
                                if kp ~= "BaseClass" and LocalPlayer():GetPos():DistToSqr(wagon:LocalToWorld(panel.pos)) < 262144 then
                                    wagon:DrawOnPanel(kp, function()
                                        surface.SetDrawColor(0, 0, 255)
                                        if not wagon:ShouldDrawPanel(kp) then surface.SetDrawColor(255, 0, 0) end
                                        surface.DrawOutlinedRect(0, 0, panel.width, panel.height)
                                        if panel.aimX and panel.aimY then
                                            surface.SetTextColor(255, 255, 255)
                                            surface.SetFont("BudgetLabel")
                                            surface.SetTextPos(panel.width / 2, 5)
                                            surface.DrawText(string.format("%d %d", panel.aimX, panel.aimY))
                                        end

                                        --surface.SetDrawColor(255,255,255)
                                        --surface.DrawRect(0,0,panel.width,panel.height)
                                        if panel.buttons then
                                            surface.SetAlphaMultiplier(0.2)
                                            if wagon.HiddenPanels[kp] then surface.SetAlphaMultiplier(0.1) end
                                            for kb, button in pairs(panel.buttons) do
                                                if wagon.Hidden[button.PropName] or wagon.Hidden[button.ID] or wagon.Hidden.anim[button.PropName] or wagon.Hidden.anim[button.ID] or wagon.Hidden.button[button.PropName] or wagon.Hidden.button[button.ID] then
                                                    surface.SetDrawColor(255, 255, 0)
                                                elseif wagon.Hidden[kb] or wagon.Hidden.anim[kb] then
                                                    surface.SetDrawColor(255, 255, 0)
                                                elseif wagon.HiddenPanels[kp] then
                                                    surface.SetDrawColor(100, 0, 0)
                                                elseif not button.ID or button.ID[1] == "!" then
                                                    surface.SetDrawColor(25, 40, 180)
                                                elseif button.state then
                                                    surface.SetDrawColor(255, 0, 0)
                                                else
                                                    surface.SetDrawColor(0, 255, 0)
                                                end

                                                if button.w and button.h then
                                                    surface.DrawRect(button.x, button.y, button.w, button.h)
                                                    surface.DrawRect(button.x + button.w / 2 - 8, button.y + button.h / 2 - 8, 16, 16)
                                                else
                                                    wagon:DrawCircle(button.x, button.y, button.radius or 10)
                                                    surface.DrawRect(button.x - 8, button.y - 8, 16, 16)
                                                end
                                            end

                                            --Gotta reset this otherwise the qmenu draws transparent as well
                                            surface.SetAlphaMultiplier(1)
                                        end
                                    end, true)
                                end
                            end
                        end
                    end
                end)
            else
                hook.Remove("PostDrawTranslucentRenderables", "MetrostroiTrainDebug")
            end
        end

        hook.Remove("PostDrawTranslucentRenderables", "MetrostroiTrainDebug")
        cvars.AddChangeCallback("metrostroi_drawdebug", enableDebug)
        enableDebug()
        MEL.InjectIntoClientFunction(ent, "Initialize", function(wagon)
            wagon.HiddenLamps = {}
            wagon.Sounds = {
                loop = {},
                isloop = {},
            }

            wagon.Sprites = {}
            wagon.PassengerEntsStucked = {}
            wagon.GlowingLights = {}
            wagon.LightBrightness = {}
            wagon.LightsOverride = {}
            if wagon.Lights then
                for i, lightData in pairs(wagon.Lights) do
                    if lightData.changable then wagon.LightsOverride[i] = table.Copy(lightData) end
                end
            end
        end, 1)

        function ent.OnRemove(wagon, nfinal)
            wagon.RenderBlock = RealTime()
            if nfinal then
                drawCrosshair = false
                canDrawCrosshair = false
                toolTipText = nil
            end

            wagon:RemoveCSEnts()
            wagon.RenderClientEnts = false
            for _, v in pairs(wagon.Sounds) do
                if type(v) ~= "function" and type(v) ~= "table" then wagon:DestroySound(v) end
            end

            for k, v in pairs(wagon.Sounds.loop) do
                for i, sndt in ipairs(v) do
                    wagon:DestroySound(sndt.sound)
                end
            end

            for _, v in pairs(wagon.PassengerEnts or {}) do
                SafeRemoveEntity(v)
            end

            for _, v in pairs(wagon.PassengerEntsStucked or {}) do
                SafeRemoveEntity(v)
            end

            if wagon.GUILocker then wagon:BlockInput(false) end
            wagon.Sounds = {
                loop = {},
                isloop = {}
            }

            wagon.PassengerEnts = {}
            wagon.PassengerEntsStucked = {}
        end

        function ent.CalcAbsolutePosition(wagon, pos, ang)
            if wagon.RenderClientEnts then
                if wagon.Lights and wagon.GlowingLights then
                    for id, light in pairs(wagon.GlowingLights) do
                        if not IsValid(light) then continue end
                        local lightData = wagon.Lights[id]
                        light:SetPos(wagon:LocalToWorld(lightData[2]))
                        light:SetAngles(wagon:LocalToWorldAngles(lightData[3]))
                    end
                end

                for k, v in pairs(wagon.Sounds) do
                    if type(v) == "IGModAudioChannel" then
                        if not IsValid(v) then
                            wagon.Sounds[k] = nil
                            continue
                        end

                        if v:GetState() ~= GMOD_CHANNEL_STOPPED then
                            local tbl = wagon.SoundPositions[k]
                            if tbl then
                                local lpos, lang = LocalToWorld(tbl[3], Angle(0, 0, 0), pos, ang)
                                v:SetPos(lpos, ang:Forward())
                            else
                                v:SetPos(pos)
                            end

                            continue
                        end
                    end
                end

                for k, v in pairs(wagon.Sounds.loop) do
                    local tbl = wagon.SoundPositions[k]
                    for i, stbl in ipairs(v) do
                        local snd = stbl.sound
                        if not IsValid(snd) then continue end
                        if snd:GetState() == GMOD_CHANNEL_PLAYING and tbl then
                            local lpos, lang = LocalToWorld(tbl[3], Angle(0, 0, 0), pos, ang)
                            snd:SetPos(lpos, ang:Forward())
                        end
                    end
                end
            end
            return pos, ang
        end

        hook.Remove("KeyPress", "MetrostroiStarted")
        hook.Add("KeyPress", "MetrostroiStarted", function(_, key)
            if key ~= IN_FORWARD and key ~= IN_BACK and key ~= IN_MOVELEFT and key ~= IN_MOVERIGHT then return end
            hook.Add("Think", "MetrostroiStarted", function()
                if MetrostroiStarted == nil then
                    MetrostroiStarted = RealTime()
                elseif MetrostroiStarted == true or MetrostroiStarted and RealTime() - MetrostroiStarted > 3 then
                    MetrostroiStarted = true
                    hook.Remove("Think", "MetrostroiStarted")
                end
            end)

            hook.Remove("KeyPress", "MetrostroiStarted")
        end)

        local function SoundTrace(startv, endv)
            local tr = util.TraceLine({
                start = startv,
                endpos = endv,
                mask = MASK_NPCWORLDSTATIC,
            })

            --debugoverlay.Line(startv,endv,FrameTime(),Color( 255, 0, tr.Hit and 255 or 0 ))
            if tr.Hit then
                --debugoverlay.Sphere(tr.HitPos,4,FrameTime(),Color( 255, 200, 100))
                return startv:Distance(tr.HitPos)
            end
            return 1000
        end

        function ent.Think(wagon)
            wagon.PrevTime = wagon.PrevTime or RealTime()
            wagon.DeltaTime = RealTime() - wagon.PrevTime
            wagon.PrevTime = RealTime()
            if MetrostroiStarted ~= true then return end
            if not wagon.FirstTick then
                wagon.FirstTick = true
                wagon.RenderClientEnts = true
                wagon.CreatingCSEnts = false
                return
            end

            if wagon.RenderClientEnts ~= wagon:ShouldRenderClientEnts() then
                wagon.RenderClientEnts = wagon:ShouldRenderClientEnts()
                if wagon.RenderClientEnts then
                    wagon.CreatingCSEnts = true
                    wagon:BlockInput(wagon.HandleMouseInput)
                    --wagon:CreateCSEnts()
                    --if wagon.UpdateTextures then wagon:UpdateTextures() end
                    --local _,ent = next(wagon.ClientEnts)
                    --if not IsValid(ent) then wagon.RenderClientEnts = false end
                else
                    wagon:OnRemove(true)
                    return
                end
            end

            if not wagon.RenderClientEnts then return end
            if wagon.RenderBlock then
                if RealTime() - wagon.RenderBlock < 3 then
                    wagon.ClientPropsInitialized = false
                    return
                else
                    wagon.RenderBlock = false
                end
            end

            if not wagon.ClientPropsInitialized then
                wagon.ClientPropsInitialized = true
                wagon:RemoveCSEnts()
                wagon:InitializeSounds()
                wagon.RenderClientEnts = false
                wagon.StopSounds = false
            end

            -- if wagon.GlowingLights and (wagon.HeadlightShadows ~= C_Shadows1:GetBool() or wagon.OtherShadows ~= C_Shadows2:GetBool() or wagon.RedLights ~= C_Shadows3:GetBool() or wagon.OtherLights ~= C_Shadows4:GetBool() or wagon.AAEnabled ~= (C_AA:GetInt() > 1) or wagon.SpritesEnabled ~= C_Sprites:GetBool()) then
            if wagon.GlowingLights and (wagon.HeadlightShadows ~= C_Shadows1:GetBool() or wagon.OtherShadows ~= C_Shadows2:GetBool() or wagon.RedLights ~= C_Shadows3:GetBool() or wagon.OtherLights ~= C_Shadows4:GetBool() or wagon.AAEnabled ~= (C_AA:GetInt() > 1) or wagon.SpritesEnabled ~= C_Sprites:GetBool()) then
                wagon.HeadlightShadows = C_Shadows1:GetBool()
                wagon.OtherShadows = C_Shadows2:GetBool()
                wagon.RedLights = C_Shadows3:GetBool()
                wagon.OtherLights = C_Shadows4:GetBool()
                wagon.SpritesEnabled = C_Sprites:GetBool()
                wagon.AAEnabled = C_AA:GetInt() > 1
                for k, v in pairs(wagon.GlowingLights) do
                    if IsValid(v) then v:Remove() end
                end

                wagon.GlowingLights = {}
                wagon.LightBrightness = {}
                wagon.Sprites = {}
            end

            if wagon.RenderClientEnts and wagon.CreatingCSEnts then
                wagon.CreatingCSEnts = not wagon:CreateCSEnts()
                if not wagon.CreatingCSEnts then
                    wagon:UpdateTextures()
                    if wagon.Systems then
                        for _, v in pairs(wagon.Systems) do
                            if v.ClientReload then v:ClientReload() end
                        end
                    end
                end
            end

            if not wagon.RenderClientEnts or wagon.CreatingCSEnts then return end
            if wagon.WagonNumber ~= wagon:GetWagonNumber() then
                wagon.WagonNumber = wagon:GetWagonNumber()
                wagon:UpdateWagonNumber()
            end

            if wagon.Texture ~= wagon:GetNW2String("Texture") then wagon:UpdateTextures() end
            if wagon.PassTexture ~= wagon:GetNW2String("PassTexture") then wagon:UpdateTextures() end
            if wagon.CabinTexture ~= wagon:GetNW2String("CabTexture") then wagon:UpdateTextures() end
            local hasGoldenReverser = wagon:GetNW2Bool("GoldenReverser")
            if wagon.HasGoldenReverser ~= hasGoldenReverser then
                wagon.HasGoldenReverser = hasGoldenReverser
                for id, v in pairs(wagon.ClientProps) do
                    if v.model == "models/metrostroi_train/reversor/reversor_classic.mdl" and v.modelcallback and IsValid(wagon.ClientEnts[id]) then
                        wagon:RemoveCSEnt(id)
                        wagon:SpawnCSEnt(id)
                    end
                end
            end

            local disableSeatShadows = false
            if wagon.DisableSeatShadows ~= disableSeatShadows then
                for i = 1, wagon:GetNW2Int("seats", 0) do
                    local seat = wagon:GetNW2Entity("seat_" .. i)
                    if IsValid(seat) then
                        seat:SetRenderMode(disableSeatShadows and RENDERMODE_NONE or RENDERMODE_TRANSALPHA)
                        if disableSeatShadows then
                            seat:AddEffects(EF_NODRAW)
                        else
                            seat:RemoveEffects(EF_NODRAW)
                        end
                    end
                end

                wagon.DisableSeatShadows = disableSeatShadows
            end

            if GetConVar("metrostroi_disablecamaccel"):GetInt() == 0 then
                wagon.HeadAcceleration = wagon:Animate("accel", (wagon:GetNW2Float("Accel", 0) + 1) / 2, 0, 1, 4, 1) * 30 - 15
            else
                wagon.HeadAcceleration = 0
            end

            -- Simulate systems
            if wagon.Systems then
                for _, v in pairs(wagon.Systems) do
                    v:ClientThink(wagon.DeltaTime)
                end
            end

            if not wagon.StopSounds then
                local soundPos = wagon.SoundPositions
                local soundNames = wagon.SoundNames
                for k, v in pairs(wagon.Sounds.loop) do
                    local tbl = soundPos[k]
                    local ntbl = soundNames[k]
                    local good = true
                    for i, stbl in ipairs(v) do
                        if not stbl.volume then good = false end
                    end

                    if not good then continue end
                    for i, stbl in ipairs(v) do
                        local snd = stbl.sound
                        if not IsValid(snd) then continue end
                        if snd:GetState() == GMOD_CHANNEL_PLAYING then
                            wagon:SetPitchVolume(snd, v.pitch or 1, stbl.volume, tbl)
                            if stbl.volume == 0 and not stbl.time then
                                snd:Pause()
                                snd:SetTime(0)
                            end
                        end

                        if snd:GetState() ~= GMOD_CHANNEL_PLAYING and stbl.volume ~= 0 then stbl.volume = 0 end
                        if stbl.time then
                            local targetvol = stbl.state and v.volume or 0
                            if stbl.time == true then
                                stbl.volume = targetvol
                            else
                                stbl.volume = math.Clamp((stbl.volume or 0) + FrameTime() / (stbl.time / v.pitch) * (stbl.state and 1 or -1) * v.volume, 0, v.volume)
                            end

                            if stbl.volume == targetvol then stbl.time = nil end
                        end

                        if i == 1 then
                            local no1 = ntbl.loop and ntbl.loop == 0
                            local endt = (ntbl.loop and snd:GetTime() > ntbl.loop or snd:GetTime() / snd:GetLength() >= 0.8) or no1
                            if stbl.state and stbl.volume < v.volume and not no1 then
                                if snd:GetState() ~= GMOD_CHANNEL_PLAYING then
                                    snd:Play()
                                    wagon:SetBASSPos(snd, tbl)
                                end

                                stbl.volume = v.volume
                                wagon:SetPitchVolume(snd, v.pitch, stbl.volume, tbl)
                                for i = 2, 3 do
                                    if not v[i].volume or v[i].volume > 0 then
                                        v[i].time = 2
                                        if v[i].GetState and v[i]:GetState() ~= GMOD_CHANNEL_PLAYING then
                                            v[i]:EnableLooping(i == 2)
                                            v[i]:Play()
                                            wagon:SetBASSPos(v[i], tbl)
                                        end

                                        wagon:SetPitchVolume(v[i].sound, v.pitch, v[i].volume, tbl)
                                    end
                                end

                                stbl.time = nil
                            end

                            if stbl.state and endt then
                                stbl.state = false
                                if no1 then
                                    stbl.time = true
                                    v[2].state = not v[3].state
                                end
                            end

                            if not stbl.state and stbl.volume == v.volume and not stbl.time then
                                stbl.time = not ntbl.loop or 0.1 / v.pitch --endt and (snd:GetLength()-snd:GetTime())*0.8 or 0.05
                                v[2].state = not v[3].state
                            end
                        end

                        if i == 2 then
                            if stbl.state and not stbl.time and stbl.volume == 0 then
                                if snd:GetState() ~= GMOD_CHANNEL_PLAYING then
                                    snd:EnableLooping(true)
                                    snd:Play()
                                    wagon:SetBASSPos(snd, tbl)
                                end

                                if v[1].time == true then
                                    stbl.volume = v.volume
                                elseif v[1].time then
                                    stbl.time = v[1].time
                                    stbl.volume = 0
                                end

                                wagon:SetPitchVolume(snd, v.pitch, stbl.volume, tbl)
                            end

                            if not stbl.state and not stbl.time and stbl.volume > 0 then stbl.time = 0.07 / v.pitch end
                        end

                        if i == 3 then
                            local time = v[2].time or v[1].time
                            if stbl.state and time and not stbl.time then
                                if snd:GetState() ~= GMOD_CHANNEL_PLAYING then
                                    snd:Play()
                                    wagon:SetBASSPos(snd, tbl)
                                end

                                stbl.volume = 0
                                wagon:SetPitchVolume(snd, v.pitch, stbl.volume, tbl)
                                stbl.time = 0.1 / v.pitch
                                for i = 1, 2 do
                                    if v[i].volume > 0 then
                                        v[i].time = 0.07 / v.pitch
                                        if v[i].GetState and v[i]:GetState() ~= GMOD_CHANNEL_PLAYING then
                                            v[i]:Play()
                                            wagon:SetBASSPos(v[i], tbl)
                                        end

                                        wagon:SetPitchVolume(v[i].sound, v.pitch, v[i].volume, tbl)
                                    end
                                end
                            elseif (not stbl.state or (snd:GetTime() / snd:GetLength() >= 0.9)) and stbl.time then
                                stbl.time = nil
                                stbl.volume = 0
                                stbl.state = false
                            end
                        end
                    end
                end
            end

            if not wagon.NoTrain then
                wagon.SoundTraceI = wagon.SoundTraceI or 0
                local min, max = wagon:OBBMins(), wagon:OBBMaxs()
                local x = wagon.SoundTraceI == 2 and max.x or wagon.SoundTraceI == 1 and 0 or min.x
                local leftt = SoundTrace(wagon:LocalToWorld(Vector(x, min.y, 0)), wagon:LocalToWorld(Vector(x, min.y - 128, 0)))
                local leftst = SoundTrace(wagon:LocalToWorld(Vector(x, min.y, -64)), wagon:LocalToWorld(Vector(x, min.y - 48, -64)))
                local rightst = SoundTrace(wagon:LocalToWorld(Vector(x, max.y, -64)), wagon:LocalToWorld(Vector(x, max.y + 48, -64)))
                local rightt = SoundTrace(wagon:LocalToWorld(Vector(x, max.y, 0)), wagon:LocalToWorld(Vector(x, max.y + 128, 0)))
                local upt = SoundTrace(wagon:LocalToWorld(Vector(x, 0, max.z)), wagon:LocalToWorld(Vector(x, 0, max.z + 256))) --[[ 384--]]
                wagon.SoundTraceI = wagon.SoundTraceI + 1
                if wagon.SoundTraceI > 2 then wagon.SoundTraceI = 0 end
                if upt > 350 then
                    local coeff = 1 - math.min((math.min(130, leftt) / 130 + math.min(130, rightt) / 130) / 2, math.Clamp((leftst - 10) / 40, 0, 1), math.Clamp((rightst - 10) / 40, 0, 1))
                    --print(math.Clamp((leftst-10)/40,0,1))
                    --print(Format("%02d %.2f %02d %.2f",leftst,math.Clamp((leftst-30)/20,0,1),rightst,)
                    --[[ if leftst < 30 or rightst < 30 then
                LocalPlayer():ChatPrint(Format("I AM ON A STREET STATION, %.2f",coeff))
            elseif coeff > 1.3 then
                LocalPlayer():ChatPrint(Format("I AM ON A STREET, %.2f",coeff))
            else
                LocalPlayer():ChatPrint(Format("I AM ON A STREET WITH WALLS, %.2f",coeff))
            end--]]
                    wagon.TunnelCoeff = math.Clamp(wagon.TunnelCoeff + (0 - wagon.TunnelCoeff) * wagon.DeltaTime * 4, 0, 1)
                    wagon.StreetCoeff = math.Clamp(wagon.StreetCoeff + ((0.8 + coeff * 0.2) - wagon.StreetCoeff) * wagon.DeltaTime * 4, 0, 1)
                    wagon.Street = 1
                else
                    local coeff = 1 - math.min(math.Clamp((leftt - 80) / 40, 0, 1) + math.Clamp((rightt - 80) / 40, 0, 1) / 2, (math.Clamp((leftst - 10) / 40, 0, 1) + math.Clamp((rightst - 10) / 40, 0, 1)) / 2)
                    --,
                    --(math.Clamp((leftst-30)/20,0,1)+math.Clamp((rightst-30)/20,0,1))*0.6
                    --[[ if (leftst < 30 or rightst < 30) and coeff > 1.2 then
                LocalPlayer():ChatPrint(Format("I AM ON A STATION L%.2f R%.2f C:%.2f",leftt/55,rightt/55,coeff))
            elseif coeff > 1.3 then
                LocalPlayer():ChatPrint(Format("I AM IN A BIG TUNNEL L%.2f R%.2f C:%.2f",leftt/55,rightt/55,coeff))
            else
                LocalPlayer():ChatPrint(Format("I AM IN A TUNNEL L%.2f R%.2f C:%.2f",leftt/55,rightt/55,coeff))
            end--]]
                    wagon.TunnelCoeff = math.Clamp(wagon.TunnelCoeff + ((0.4 + coeff * 0.6) - wagon.TunnelCoeff) * wagon.DeltaTime * 4, 0, 1)
                    wagon.StreetCoeff = math.Clamp(wagon.StreetCoeff + ((0.5 - math.max(0, wagon.TunnelCoeff - 0.5)) - wagon.StreetCoeff) * wagon.DeltaTime * 4, 0, 1)
                    wagon.Street = 0
                end
            end

            if not wagon.HandleMouseInput and wagon.ButtonMap then
                if wagon == LocalPlayer().InMetrostroiTrain then
                    for kp, pan in pairs(wagon.ButtonMap) do
                        if not wagon:ShouldDrawPanel(kp) then continue end
                        --If player is looking at this panel
                        if pan.mouse and not pan.outside and pan.aimX and pan.aimY then
                            local aimX, aimY = math.floor(math.Clamp(pan.aimX, 0, pan.width)), math.floor(math.Clamp(pan.aimY, 0, pan.height))
                            if pan.OldAimX ~= aimX or pan.OldAimY ~= aimY then
                                net.Start("metrostroi-mouse-move", true)
                                net.WriteEntity(wagon)
                                net.WriteString(kp)
                                net.WriteFloat(aimX)
                                net.WriteFloat(aimY)
                                net.SendToServer()
                                pan.OldAimX = aimX
                                pan.OldAimY = aimY
                            end
                        end
                    end
                end
            end

            if wagon.ButtonMap and (not wagon.LastCheck or RealTime() - wagon.LastCheck > 0.5) then
                wagon.LastCheck = RealTime()
                local screenshotMode = C_ScreenshotMode:GetBool()
                if wagon.ScreenshotMode ~= screenshotMode then
                    wagon:SetLOD(screenshotMode and 0 or -1)
                    for k, cent in pairs(wagon.ClientEnts) do
                        if IsValid(cent) then cent:SetLOD(screenshotMode and 0 or -1) end
                    end

                    wagon.ScreenshotMode = screenshotMode
                end

                for k in pairs(wagon.HiddenLamps) do
                    wagon.HiddenLamps[k] = false
                end

                for k, v in pairs(wagon.ClientProps) do
                    if not v.pos then continue end
                    local cent = wagon.ClientEnts[k]
                    if v.nohide or screenshotMode then
                        if not IsValid(cent) then wagon:SpawnCSEnt(k, true) end
                        continue
                    end

                    local hidden = not wagon:ShouldDrawClientEnt(k, v)
                    if IsValid(cent) and hidden then
                        cent:Remove()
                        wagon.ClientEnts[k] = nil
                    elseif not IsValid(cent) and not hidden then
                        wagon:SpawnCSEnt(k, true)
                    end

                    if v.lamps and hidden then
                        for i, k in ipairs(v.lamps) do
                            wagon:SetLightPower(k, false)
                            wagon.HiddenLamps[k] = true
                        end
                    end
                end

                for k, v in pairs(wagon.Sounds) do
                    if type(v) ~= "function" and type(v) ~= "table" and not wagon.Sounds.isloop[k] and (not IsValid(v) or v:GetState() == GMOD_CHANNEL_STOPPED) then
                        wagon:DestroySound(v)
                        wagon.Sounds[k] = nil
                    end
                end

                for k, v in pairs(wagon.ButtonMap) do
                    if not v.pos then continue end
                    if not v.hide or (v.nohide or screenshotMode) then
                        wagon.HiddenPanelsDistance[k] = v.screenHide
                        continue
                    end

                    wagon.HiddenPanelsDistance[k] = not wagon:ShouldDrawClientEnt(k, wagon.ButtonMap[k])
                end
            end

            if wagon.AutoAnims and wagon.AutoAnimNames then
                local aAnims = wagon.AutoAnims
                local aAnimNames = wagon.AutoAnimNames
                local hidden = wagon.Hidden
                for i = 1, #aAnims do
                    if not aAnimNames[i] or not hidden[aAnimNames[i]] then aAnims[i](wagon) end
                end
            end

            if wagon.Lights and wagon.GlowingLights then
                for id, light in pairs(wagon.GlowingLights) do
                    if light.Update then light:Update() end
                end
            end

            -- Update passengers
            if wagon.RenderClientEnts and wagon.PassengerEnts then
                if #wagon.PassengerEnts ~= wagon:GetNW2Float("PassengerCount") then
                    -- Passengers go out
                    while #wagon.PassengerEnts > wagon:GetNW2Float("PassengerCount") do
                        local ent = wagon.PassengerEnts[#wagon.PassengerEnts]
                        table.remove(wagon.PassengerPositions, #wagon.PassengerPositions)
                        table.remove(wagon.PassengerEnts, #wagon.PassengerEnts)
                        ent:Remove()
                    end

                    -- Passengers go in
                    while #wagon.PassengerEnts < wagon:GetNW2Float("PassengerCount") do
                        local min, max = wagon:GetStandingArea()
                        local pos = min + Vector((max.x - min.x) * math.random(), (max.y - min.y) * math.random(), (max.z - min.z) * math.random())
                        --local ent = ents.CreateClientProp("models/metrostroi/81-717/reverser.mdl")
                        --ent:SetModel(table.Random(wagon.PassengerModels))
                        local ent = ClientsideModel(table.Random(wagon.PassengerModels), RENDERGROUP_OPAQUE)
                        ent:SetPos(wagon:LocalToWorld(pos))
                        ent:SetAngles(Angle(0, math.random(0, 360), 0))
                        --[[
                        hook.Add("MetrostroiBigLag",ent,function(ent)
                            ent:SetPos(wagon:LocalToWorld(pos))
                            ent:SetAngles(Angle(0,math.random(0,360),0))
                            --if ent.Spawned then hook.Remove("MetrostroiBigLag",ent) end
                            --ent.Spawned = true
                        end)]]
                        ent:SetSkin(math.floor(ent:SkinCount() * math.random()))
                        ent:SetModelScale(0.98 + (-0.02 + 0.04 * math.random()), 0)
                        ent:SetParent(wagon)
                        table.insert(wagon.PassengerPositions, pos)
                        table.insert(wagon.PassengerEnts, ent)
                    end
                end
            elseif wagon.PassengerEnts then
                for k, v in pairs(wagon.PassengerEnts) do
                    if IsValid(v) then v:Remove() end
                    wagon.PassengerEnts[k] = nil
                end
            end

            for k, v in pairs(wagon.CustomThinks) do
                if k ~= "BaseClass" then v(wagon) end
            end
        end

        hook.Remove("Think", "metrostroi_mouse_handle")
        local OldTrainHandle, OldSeat
        local function isValidTrainDriver(ply)
            if IsValid(ply.InMetrostroiTrain) then return ply.InMetrostroiTrain end
            local weapon = IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass()
            if weapon ~= "train_kv_wrench" and weapon ~= "train_kv_wrench_gold" then return end
            local train = util.TraceLine({
                start = LocalPlayer():GetPos(),
                endpos = LocalPlayer():GetPos() - LocalPlayer():GetAngles():Up() * 100,
                filter = function(wagon) if wagon.ButtonMap ~= nil then return true end end
            }).Entity

            if not IsValid(train) then
                train = util.TraceLine({
                    start = LocalPlayer():EyePos(),
                    endpos = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 300,
                    filter = function(wagon) if wagon.ButtonMap ~= nil then return true end end
                }).Entity
            end
            return IsValid(train) and train, true
        end

        hook.Add("Think", "metrostroi_mouse_handle", function()
            local train, outside = isValidTrainDriver(LocalPlayer())
            if outside then train = nil end
            if OldTrainHandle ~= train then
                if IsValid(OldTrainHandle) and OldTrainHandle.BlockInput then OldTrainHandle:BlockInput(false) end
                if IsValid(train) and train.BlockInput then train:BlockInput(train.HandleMouseInput) end
                if IsValid(train) then
                    OldSeat = LocalPlayer():GetVehicle()
                elseif IsValid(OldSeat) then
                    OldSeat.CalcAbsolutePosition = OldSeat.OldCalcAbsolutePosition or OldSeat.CalcAbsolutePosition
                    OldSeat.OldCalcAbsolutePosition = nil
                    OldSeat = nil
                end

                OldTrainHandle = train
            end
        end)

        function ent.Animate(wagon, clientProp, value, min, max, speed, damping, stickyness)
            local id = clientProp
            local anims = wagon.Anims
            if not anims[id] then
                anims[id] = {}
                anims[id].val = value
                anims[id].value = min + (max - min) * value
                anims[id].V = 0.0
                anims[id].block = false
                anims[id].stuck = false
                anims[id].P = value
            end

            if wagon.Hidden[id] or wagon.Hidden.anim[id] then return 0 end
            if anims[id].Ignore then
                if RealTime() - anims[id].Ignore < 0 then
                    return anims[id].value
                else
                    anims[id].Ignore = nil
                end
            end

            local val = anims[id].val
            if value ~= val then anims[id].block = false end
            if anims[id].block then
                if anims[id].reload and IsValid(wagon.ClientEnts[clientProp]) then
                    wagon.ClientEnts[clientProp]:SetPoseParameter("position", anims[id].value)
                    anims[id].reload = false
                end
                return anims[id].value --min + (max-min)*anims[id].val
            end

            --if wagon["_anim_old_"..id] == value then return wagon["_anim_old_"..id] end
            -- Generate sticky value
            if stickyness and damping then
                if (math.abs(anims[id].P - value) < stickyness) and anims[id].stuck then
                    value = anims[id].P
                    anims[id].stuck = false
                else
                    anims[id].P = value
                end
            end

            local dT = FrameTime() --wagon.DeltaTime
            if damping == false then
                local dX = speed * dT
                if value > val then val = val + dX end
                if value < val then val = val - dX end
                if math.abs(value - val) < dX then
                    val = value
                    anims[id].V = 0
                else
                    anims[id].V = dX
                end
            else
                -- Prepare speed limiting
                local delta = math.abs(value - val)
                local max_speed = 1.5 * delta / dT
                local max_accel = 0.5 / dT
                -- Simulate
                local dX2dT = (speed or 128) * (value - val) - anims[id].V * (damping or 8.0)
                if dX2dT > max_accel then dX2dT = max_accel end
                if dX2dT < -max_accel then dX2dT = -max_accel end
                anims[id].V = anims[id].V + dX2dT * dT
                if anims[id].V > max_speed then anims[id].V = max_speed end
                if anims[id].V < -max_speed then anims[id].V = -max_speed end
                val = math.max(0, math.min(1, val + anims[id].V * dT))
                -- Check if value got stuck
                if (math.abs(dX2dT) < 0.001) and stickyness and (dT > 0) then anims[id].stuck = true end
            end

            local retval = min + (max - min) * val
            if IsValid(wagon.ClientEnts[clientProp]) then wagon.ClientEnts[clientProp]:SetPoseParameter("position", retval) end
            if math.abs(anims[id].V) == 0 and math.abs(val - value) == 0 and not anims[id].stuck then anims[id].block = true end
            anims[id].val = val
            anims[id].oldival = value
            anims[id].oldspeed = speed
            anims[id].value = retval
            return retval
        end

        function ent.ShowHide(wagon, clientProp, value, over)
            if wagon.Hidden.override[clientProp] then return end
            if value == true and (wagon.Hidden[clientProp] or over) then
                wagon.Hidden[clientProp] = false
                if not IsValid(wagon.ClientEnts[clientProp]) and wagon:SpawnCSEnt(clientProp) then wagon.UpdateRender = true end
                return true
            elseif value ~= true and (not wagon.Hidden[clientProp] or over) then
                if IsValid(wagon.ClientEnts[clientProp]) then
                    wagon.ClientEnts[clientProp]:Remove()
                    wagon.UpdateRender = true
                end

                wagon.Hidden[clientProp] = true
                return true
            end
        end

        function ent.ShowHideSmooth(wagon, clientProp, value, color)
            if wagon.Hidden.override[clientProp] then return value end
            if not IsValid(wagon.ClientEnts[clientProp]) and wagon.SmoothHide[clientProp] then wagon.SmoothHide[clientProp] = 0 end
            if wagon.SmoothHide[clientProp] and (wagon.SmoothHide[clientProp] == value and not color) then return value end
            wagon.SmoothHide[clientProp] = value
            wagon.Hidden.anim[clientProp] = value == 0
            if value > 0 and not IsValid(wagon.ClientEnts[clientProp]) and wagon:ShowHide(clientProp, true) then wagon.SmoothHide[clientProp] = nil end
            if value == 0 and IsValid(wagon.ClientEnts[clientProp]) and wagon:ShowHide(clientProp, false) then wagon.SmoothHide[clientProp] = nil end
            if IsValid(wagon.ClientEnts[clientProp]) then
                local v = wagon.ClientPropsOv and wagon.ClientPropsOv[clientProp] or wagon.ClientProps[clientProp]
                wagon.ClientEnts[clientProp]:SetRenderMode(RENDERMODE_TRANSALPHA)
                if color then
                    wagon.ClientEnts[clientProp]:SetColor(ColorAlpha(color, value * 255))
                else
                    wagon.ClientEnts[clientProp]:SetColor(ColorAlpha(v.color or color_white, value * 255))
                end
            end
            return value
        end

        function ent.SetLightPower(wagon, index, power, brightness)
            if wagon.HiddenLamps[index] then return end
            local lightData = wagon.LightsOverride[index] or wagon.Lights[index]
            brightness = brightness or 1
            if lightData[1] == "glow" or lightData[1] == "light" then
                if lightData.panel and not wagon.SpritesEnabled or lightData.aa and wagon.AAEnabled then return end
                wagon.LightBrightness[index] = brightness * (lightData.brightness or 0.5)
                if power and wagon.Sprites[index] then return end
                wagon.Sprites[index] = nil
                if not power then return end
                wagon.Sprites[index] = util.GetPixelVisibleHandle()
                lightData.mat = Metrostroi.MakeSpriteTexture(lightData.texture or "sprites/light_glow02", lightData[1] == "light")
                return
            end

            if power and IsValid(wagon.GlowingLights[index]) then
                if lightData[1] == "headlight" and IsValid(wagon.GlowingLights[index]) then
                    -- Check if light already glowing
                    if brightness ~= wagon.LightBrightness[index] then
                        local light = wagon.GlowingLights[index]
                        light:SetBrightness(brightness * (lightData.brightness or 1.25))
                        light:Update()
                        wagon.LightBrightness[index] = brightness
                    end
                    return
                elseif (lightData[1] == "glow") or (lightData[1] == "light") then
                    local brightness = brightness * (lightData.brightness or 0.5)
                    if brightness ~= wagon.LightBrightness[index] then
                        local light = wagon.GlowingLights[index]
                        light:SetBrightness(brightness)
                        wagon.LightBrightness[index] = brightness
                    end
                    return
                elseif lightData[1] == "dynamiclight" then
                    if brightness ~= wagon.LightBrightness[index] then
                        local light = wagon.GlowingLights[index]
                        light:SetLightStrength(brightness)
                        wagon.LightBrightness[index] = brightness
                    end
                    return
                end
            end

            if IsValid(wagon.GlowingLights[index]) then wagon.GlowingLights[index]:Remove() end
            wagon.GlowingLights[index] = nil
            wagon.LightBrightness[index] = brightness
            if not power then return end
            -- Create light
            if lightData[1] == "light" or lightData[1] == "glow" then
                local light = ents.CreateClientside("gmod_train_sprite")
                light:SetPos(wagon:LocalToWorld(lightData[2]))
                --light:SetLocalAngles(lightData[3])
                -- Set parameters
                local brightness = brightness * (lightData.brightness or 0.5)
                light:SetColor(lightData[4])
                light:SetBrightness(brightness)
                light:SetTexture((lightData.texture or "sprites/light_glow02") .. ".vmt", lightData[1] == "light")
                light:SetSize(lightData.scale or 1.0)
                light:Set3D(false)
                wagon.GlowingLights[index] = light
            elseif (lightData[1] == "headlight") and (not lightData.backlight or wagon.RedLights) and (not lightData.panellight or wagon.OtherLights) then
                local light = ProjectedTexture()
                light:SetPos(wagon:LocalToWorld(lightData[2]))
                light:SetAngles(wagon:LocalToWorldAngles(lightData[3]))
                --light:SetParent(wagon)
                --light:SetLocalPos(lightData[2])
                --light:SetLocalAngles(lightData[3])
                -- Set parameters
                if lightData.headlight and wagon.HeadlightShadows or not lightData.headlight and wagon.OtherShadows then
                    light:SetEnableShadows((lightData.shadows or 0) > 0)
                else
                    light:SetEnableShadows(false)
                end

                if (lightData.shadows or 0) > 0 then
                    light:SetFarZ(math.max(lightData.farz or 2048, 10))
                else
                    light:SetFarZ(lightData.farz or 2048)
                end

                light:SetNearZ(lightData.nearz or 16)
                if lightData.fov then light:SetFOV(lightData.fov or 120) end
                if lightData.hfov then light:SetHorizontalFOV(lightData.hfov) end
                if lightData.vfov then light:SetVerticalFOV(lightData.vfov or 120) end
                light:SetOrthographic(false)
                -- Set Brightness
                light:SetBrightness(brightness * (lightData.brightness or 1.25))
                light:SetColor(lightData[4])
                light:SetTexture(lightData.texture or "effects/flashlight001")
                -- Turn light on
                light:Update() --"effects/flashlight/caustics"
                wagon.GlowingLights[index] = light
            elseif lightData[1] == "dynamiclight" then
                local light = ents.CreateClientside("gmod_train_dlight")
                light:SetParent(wagon)
                -- Set position
                light:SetLocalPos(lightData[2])
                --light:SetLocalAngles(lightData[3])
                -- Set parameters
                light:SetDColor(lightData[4])
                light:SetSize(lightData.distance)
                light:SetBrightness(lightData.brightness or 2)
                light:SetLightStrength(brightness)
                -- Turn light on
                light:Spawn()
                wagon.GlowingLights[index] = light
            end
        end
    end
end