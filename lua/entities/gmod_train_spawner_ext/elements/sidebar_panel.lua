local utils = include("../utils.lua")
PANEL = {}
function PANEL:Init()
    self:Dock(TOP)
    self:SetSize(utils.resizeWidth(200), utils.resizeHeight(70))
    self:DockMargin(utils.resizeWidth(10), 0, utils.resizeWidth(10), 0)
    self:SetPaintBackground(false)
    self.Label = vgui.Create("DLabel", self)
    self.Label:SetText("Sidebar Panel")
    self.Label:SetFont("Arial17")
    self.Label:Dock(TOP)
    self.Label:DockMargin(0, 10, 0, 0)
end

function PANEL:SetText(text)
    self.Label:SetText(text)
end
-- return PANEL
return vgui.Register("ExtSpawnerSidebarPanel", PANEL, "DPanel")
