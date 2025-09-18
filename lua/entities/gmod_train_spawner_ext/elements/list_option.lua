PANEL = {}

function PANEL:Init()
	self.DefaultIndex = 1
	self:SetSize(200, 50)
	self:SetPaintBackground(false)
	self.Label = vgui.Create("DLabel", self)
	self.Label:Dock(TOP)
	self.ComboBox = vgui.Create("DComboBox", self)
	self.ComboBox:Dock(TOP)
	self.ComboBox:SetSize(0, 30)
	self.ComboBox:SetSortItems(false)
end

function PANEL:SetText(text)
	self.Label:SetText(text)
	self:SetTooltip(text)
	self:SetTooltipDelay(1)
end

function PANEL:ChooseID(index)
	-- Set and select default value
	self.ComboBox:ChooseOptionID(index)
end

function PANEL:AddChoice(value, data)
	self.ComboBox:AddChoice(value, data)
end

return vgui.Register("ExtSpawnerListOption", PANEL, "DPanel")
