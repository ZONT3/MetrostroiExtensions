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
local function newConvars()
    if SERVER then
        CreateConVar("metrostroi_maxtrains", 3, {FCVAR_ARCHIVE}, "Maximum of allowed trains")
        CreateConVar("metrostroi_maxwagons", 3, {FCVAR_ARCHIVE}, "Maximum of allowed wagons in 1 train")
        CreateConVar("metrostroi_maxtrains_onplayer", 1, {FCVAR_ARCHIVE}, "Maximum of allowed trains by player")
    end

    if CLIENT then
        CreateClientConVar("metrostroi_shadows4", 0, true)
        CreateClientConVar("metrostroi_sprites", 1, true)
        CreateClientConVar("metrostroi_cabz", 0, true)
        CreateClientConVar("metrostroi_disableseatshadows", 1, true)
        CreateClientConVar("metrostroi_disablehovertextpos", 0, true)
        CreateClientConVar("metrostroi_signal_distance",8192,true)
        CreateClientConVar("metrostroi_route_number",61,true,true)
    end
end

local function newSpriteEnt()
    ENT = {}
    ENT.Type = "anim"
    ENT.PrintName = "Clientside sprite"
    ENT.Spawnable = false
    ENT.AdminSpawnable = false
    MetrostroiSprites = MetrostroiSprites or {}
    MetrostroiSprites2D = MetrostroiSprites2D or {}
    local function colAlpha(col, a)
        return Color(col.r * a, col.g * a, col.b * a)
    end

    hook.Add("PostDrawTranslucentRenderables", "MetrostroiClientSprite", function(_, isSkybox)
        if isSkybox then return end
        for i = 1, #MetrostroiSprites do
            local ent = MetrostroiSprites[i]
            if not ent.Visible or ent.Brightness <= 0 then continue end
            local pos = ent:GetPos()
            local visibility = util.PixelVisible(pos, 5, ent.vHandle) --math.max(0,util.PixelVisible(pos, 5, vHandle)-0.25)/0.75
            if visibility > 0 then
                render.SetMaterial(ent.Material)
                render.DrawSprite(pos, 128 * ent.Scale, 128 * ent.Scale, colAlpha(ent:GetColor(), visibility * ent.Brightness))
            end
        end

        for i = 1, #MetrostroiSprites2D do
            local ent = MetrostroiSprites2D[i]
            if not ent.Visible or ent.Brightness <= 0 then continue end
            local pos = ent:GetPos()
            local visibility = util.PixelVisible(pos, 5, ent.vHandle) --math.max(0,util.PixelVisible(pos, 5, vHandle)-0.25)/0.75
            if visibility > 0 then
                render.SetMaterial(ent.Material)
                cam.IgnoreZ(true)
                render.DrawSprite(pos, 128 * ent.Scale, 128 * ent.Scale, colAlpha(ent:GetColor(), visibility * ent.Brightness))
                cam.IgnoreZ(false)
                --render.DrawQuadEasy( ent:GetPos(),-EyeVector(), 128*ent.Scale, 128*ent.Scale, ent:GetColor())
            end
        end
    end)

    hook.Remove("PreDrawViewModel", "MetrostroiClientSprite", function() end)
    function ENT:Initialize()
        self:SetSize(self.Scale or 1)
        self:SetTexture(self.Texture or "sprites/glow1.vmt")
        self:SetColor(self.Color or Color(255, 255, 255))
        self:SetBrightness(1)
        self:SetVisible(true)
        self.vHandle = util.GetPixelVisibleHandle()
        table.insert(MetrostroiSprites2D, self)
    end

    function ENT:OnRemove()
        if self.Is3D then
            for i, v in ipairs(MetrostroiSprites) do
                if self == v then table.remove(MetrostroiSprites, i) end
            end
        else
            for i, v in ipairs(MetrostroiSprites2D) do
                if self == v then table.remove(MetrostroiSprites2D, i) end
            end
        end
    end

    function ENT:SetSize(scale)
        self.Scale = math.max(scale, 0)
    end

    function ENT:SetTexture(texture, isSprite)
        self.Texture = texture
        self.Material = Metrostroi.MakeSpriteTexture(texture, isSprite)
    end

    function ENT:SetSColor(col)
        self.Color = colAlpha(col, col.a / 255)
    end

    function ENT:SetBrightness(brightness)
        self.Brightness = brightness
    end

    function ENT:SetVisible(vis)
        self.Visible = vis
    end

    function ENT:Set3D(is3D)
        self:OnRemove()
        if is3D then
            table.insert(MetrostroiSprites, self)
        else
            table.insert(MetrostroiSprites2D, self)
        end

        self.Is3D = is3D
    end

    scripted_ents.Register(ENT, "gmod_train_sprite")
end

local function newDLightEnt()
    ENT = {}
    ENT.Type = "anim"
    ENT.PrintName = "Clientside dlight"
    ENT.Spawnable = false
    ENT.AdminSpawnable = false
    if SERVER then return end
    MetrostroiDLights = MetrostroiDLights or 0
    function ENT:Initialize()
        self.ID = 817200 - MetrostroiDLights
        MetrostroiDLights = MetrostroiDLights + 3
        self.Strength = self.Strength or 1
        self.Color = self.Color or Color(255, 220, 80)
        self.Brightness = self.Brightness or 1
        if self.AffectW == nil then self.AffectW = true end
        self:SetSize(self.Size or 512)
        self:MakeDLight()
    end

    function ENT:Think()
        self:MakeDLight()
    end

    function ENT:SetDColor(col)
        self.Color = col
    end

    function ENT:SetLightStrength(br)
        self.Strength = br or 1
    end

    function ENT:SetBrightness(br)
        self.Brightness = br
    end

    function ENT:SetSize(sz)
        self.Size = sz
    end

    function ENT:SetStyle(style)
        self.Style = style
    end

    function ENT:MakeDLight()
        if DLightFreeze ~= RealTime() then self.Created = true end
        DLightFreeze = RealTime()
        self.DLight = DynamicLight(self.ID, not self.AffectW)
        self.DLight.Style = self.Style
        self.DLight.r = self.Color.r * self.Strength
        self.DLight.g = self.Color.g * self.Strength
        self.DLight.b = self.Color.b * self.Strength
        self.DLight.nomodel = self.nomodel
        self.DLight.Brightness = self.Brightness
        self.DLight.Pos = self:GetPos()
        self.DLight.Size = self.Size
        self.DLight.Decay = self.Size * 50
        self.DLight.DieTime = CurTime() + 1
    end

    function ENT:AffectWorld(affect)
    end

    function ENT:OnRemove()
        if self.Created then self.DLight.DieTime = 0 end
    end

    function ENT:AffectModels(affect)
        self.nomodel = not affect
    end

    function ENT:Draw()
    end

    scripted_ents.Register(ENT, "gmod_train_dlight")
end

local function addMakeSpriteTexture()
    Metrostroi.SpriteCache1 = Metrostroi.SpriteCache1 or {}
    Metrostroi.SpriteCache2 = Metrostroi.SpriteCache2 or {}
    local matSprite = {
        ["$basetexture"] = "",
        ["$spriteorientation"] = "vp_parallel",
        ["$spriteorigin"] = "[ 0.50 0.50 ]",
        ["$illumfactor"] = 7,
        ["$spriterendermode"] = 3,
    }

    local matUnlit = {
        ["$basetexture"] = "",
        ["$translucent"] = 1,
        ["$additive"] = 1,
        ["$vertexcolor"] = 1,
    }

    --["$vertexalpha"] = 1,
    function Metrostroi.MakeSpriteTexture(path, isSprite)
        if isSprite then
            if Metrostroi.SpriteCache1[path] then return Metrostroi.SpriteCache1[path] end
            matSprite["$basetexture"] = path
            Metrostroi.SpriteCache1[path] = CreateMaterial(path .. ":sprite", "Sprite", matSprite)
            return Metrostroi.SpriteCache1[path]
        else
            if Metrostroi.SpriteCache1[path] then return Metrostroi.SpriteCache1[path] end
            matUnlit["$basetexture"] = path
            Metrostroi.SpriteCache2[path] = CreateMaterial(path .. ":spriteug", "UnlitGeneric", matUnlit)
            return Metrostroi.SpriteCache2[path]
        end
    end
end

local function addSpawnedTrains()
    Metrostroi.SpawnedTrains = {}
    for k, ent in pairs(ents.GetAll()) do
        if ent.Base == "gmod_subway_base" or ent:GetClass() == "gmod_subway_base" then Metrostroi.SpawnedTrains[ent] = true end
    end

    hook.Add("EntityRemoved", "MetrostroiTrains", function(ent) if Metrostroi.SpawnedTrains[ent] then Metrostroi.SpawnedTrains[ent] = nil end end)
    if SERVER then
        hook.Add("OnEntityCreated", "MetrostroiTrains", function(ent) if ent.Base == "gmod_subway_base" or ent:GetClass() == "gmod_subway_base" then Metrostroi.SpawnedTrains[ent] = true end end)
    else
        hook.Add("OnEntityCreated", "MetrostroiTrains", function(ent) if ent:GetClass() == "gmod_subway_base" or scripted_ents.IsBasedOn(ent:GetClass(), "gmod_subway_base") then Metrostroi.SpawnedTrains[ent] = true end end)
    end
end

function MEL.ApplyBackports()
    if Metrostroi.Version > 1537278077 then return end
    MEL._LogInfo("applying backports")
    newConvars()
    newSpriteEnt()
    newDLightEnt()
    addMakeSpriteTexture()
    addSpawnedTrains()
end

hook.Add("MetrostroiLoaded", "MetrostroiExtApplyBackports", function() MEL.ApplyBackports() end)