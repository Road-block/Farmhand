local addonName, FH = ...
local L = FH.L
FH.M = FH.M or {}
local _

local msq, msqGroups = nil, {}
if LibStub then
	msq = LibStub("Masque",true)
	if msq then
		msqGroups = {
			FarmhandTools = msq:Group(addonName,"Tools"),
			FarmhandSeeds = msq:Group(addonName,"Seeds"),
			FarmhandPortals = msq:Group(addonName,"Portals"),
		}
	end
end

local function NewFarmhandButton(Name,Parent,ItemID,ItemType)
	--print(Name,Parent,ItemID)
	local f = CreateFrame("Button", Name, Parent, "SecureActionButtonTemplate")
	f:SetSize(32,32)
	f:SetPushedTexture([[Interface\Buttons\UI-Quickslot-Depress]])
	f:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]],"ADD")
	f.Icon = f:CreateTexture(Name.."Icon","BACKGROUND")
	f.Icon:SetDrawLayer("BACKGROUND",0)
	f.Icon:SetAllPoints()
	f.SmallIcon = f:CreateTexture(Name.."SmallIcon","BACKGROUND")
	f.SmallIcon:SetDrawLayer("BACKGROUND",1)
	f.SmallIcon:SetPoint("BOTTOMRIGHT",f.Icon,"CENTER",-4,4)
	f.SmallIcon:SetSize(12,12)
	
	f.Count = f:CreateFontString(Name.."Count","ARTWORK","NumberFontNormal")
	f.Count:SetJustifyH("RIGHT")
	f.Count:SetPoint("BottomRight",-2,2)
	
	f.ItemType = ItemType

	f:RegisterForClicks("AnyUp","AnyDown")

	if ItemID then
		f.ItemID = ItemID
		f:SetAttribute("downbutton","ignore")
		f:SetAttribute("*type-ignore", "")
		f:SetAttribute("type","item")
		f:SetAttribute("item","item:"..ItemID)
		f:SetScript("PreClick", FH.M.ItemPreClick)
		f:SetScript("PostClick", FH.M.ItemPostClick)
	end
	
	f:SetScript("OnEnter", FH.M.ItemOnEnter)
	f:SetScript("OnLeave", FH.M.ItemOnLeave)

	f:SetScript("OnMouseDown", FH.M.ButtonOnMouseDown)
	f:SetScript("OnMouseUp", FH.M.ButtonOnMouseUp)
	f:SetScript("OnHide", FH.M.ButtonOnHide)
	
	return f
end

local function CreateBarButtons(Bar, Items, ItemType)
	if Bar.Buttons == nil then
		Bar.Buttons = {}
	end
	local Buttons = Bar.Buttons
	local indexOffset = #Buttons
	for Index, ItemID in ipairs(Items) do
		--print(Index,ItemID)
		Index = Index + indexOffset
		local Button = NewFarmhandButton(Bar:GetName().."Button"..Index, Bar, ItemID, ItemType)
		tinsert(Buttons,Button)
		
		if msqGroups[Bar:GetName()] then
			msqGroups[Bar:GetName()]:AddButton(Button)
		end

	end
	return Buttons
end

local function NewMacroButton(Step, SubStep, MacroText)
	--print("Creating ".."FHSBE_"..Step.."_"..SubStep)
	local f = CreateFrame("Button", "FHSBE_"..Step.."_"..SubStep, FarmhandScanButton, "SecureActionButtonTemplate")
	f:SetSize(32,32)
	f:RegisterForClicks("AnyUp","AnyDown")
	f:SetAttribute("type", "macro")
	f:SetAttribute("macrotext", MacroText)
	f:Hide()
	return f
end

local f = CreateFrame("Frame",addonName,UIParent, BackdropTemplateMixin and "BackdropTemplate")
f:SetDontSavePosition(true)
f:SetClampedToScreen(true)
f:SetMovable(true)

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("ZONE_CHANGED")
f:RegisterEvent("ZONE_CHANGED_INDOORS")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("GET_ITEM_INFO_RECEIVED")
f:SetScript("OnEvent",function(self,event,...)
	if event == "ADDON_LOADED" then
		local AddOn = ...
		if AddOn == addonName then
--			f:RegisterEvent("GET_ITEM_INFO_RECEIVED ")
			FH.M.UpdateMiscToolOptionText()
			FH.M.RunAfterCombat(FH.M.Initialize)
			self:UnregisterEvent("ADDON_LOADED")
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		FH.M.RunAfterCombat(FH.M.ZoneChanged)
	elseif event == "ZONE_CHANGED_NEW_AREA" or
		   event == "ZONE_CHANGED" or 
		   event == "ZONE_CHANGED_INDOORS" then
		FH.M.RunAfterCombat(FH.M.ZoneChanged)
	elseif event == "BAG_UPDATE" then
		FH.M.RunAfterCombat(FH.M.Update)
	elseif event == "MERCHANT_SHOW" or event == "MERCHANT_CLOSED" then
		if self:IsShown() then
			FH.M.RunAfterCombat(FH.M.MerchantEvent,{event == "MERCHANT_SHOW"})
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		FH.M.CombatEnded()
	elseif event == "BAG_UPDATE_COOLDOWN" then
		FH.M.UpdateSeedBagCharges()
	elseif event == "GET_ITEM_INFO_RECEIVED" then
		FH.M.UpdateMiscToolOptionText()
		FH.M.UpdateButtonIcons(FarmhandSeeds)
	end
end)

f = CreateFrame("Frame","FarmhandSeeds",Farmhand, BackdropTemplateMixin and "BackdropTemplate")
f:SetPoint("Top")
f:SetScale(1)
f:Hide()
CreateBarButtons(f, FH.Seeds, "Seed")
CreateBarButtons(f, FH.SeedBags, "SeedBag")
f.ShowItemCount = true

f = CreateFrame("Frame","FarmhandTools",Farmhand, BackdropTemplateMixin and "BackdropTemplate")
f:SetPoint("Top",FarmhandSeeds,"Bottom")
f:SetScale(1.5)
f:Hide()
CreateBarButtons(f, FH.Tools, "FarmTool")
CreateBarButtons(f, FH.MiscTools, "MiscTool")

f = CreateFrame("Frame","FarmhandPortals",Farmhand, BackdropTemplateMixin and "BackdropTemplate")
f:SetPoint("Top",FarmhandTools,"Bottom")
f:SetScale(.75)
f:Hide()
CreateBarButtons(f, FH.Portals, "Portal")
f.ShowItemCount = true

f = NewFarmhandButton("FarmhandScanButton",FarmhandTools)
f.Icon:SetTexture([[Interface\AddOns\Farmhand\RadarIcon.tga]])
f.ItemType = "CropScanner"
tinsert(FarmhandTools.Buttons,f)

for Step, State in ipairs(FH.CropStates) do
	local SubStep = 1
	local MacroText = "/cleartarget\n"
	local IconLine = "/run if UnitExists(\"target\") and GetRaidTargetIndex(\"target\") ~= "..State.Icon.." then SetRaidTarget(\"target\","..State.Icon..") end\n"

	local Lines = { strsplit("\n", gsub(State.CropNames,"\r","")) }
	for i,line in ipairs(Lines) do
		line = "/tar "..strtrim(line).."\n"
		if strlen(MacroText) + strlen(line) + strlen(IconLine) + strlen("/click FHSBE_9999_9999\n") > 1023 then
			MacroText = MacroText..format("/click FHSBE_%d_%d\n",Step,SubStep+1)
			NewMacroButton(Step, SubStep, MacroText)
			SubStep = SubStep + 1
			MacroText = ""
		end
		MacroText = MacroText..line
	end
	MacroText = MacroText..IconLine
	MacroText = MacroText..format("/click FHSBE_%d_%d\n",Step+1,1)
	local f = NewMacroButton(Step, SubStep, MacroText)
	if Step > 1 then
		f:SetScript("PreClick", function() FH.M.CropScannerCheckForTarget(false) end)
	end
	if Step == #FH.CropStates then
		f:SetScript("PostClick", function() FH.M.CropScannerCheckForTarget(false) end)
	end
end

f:SetAttribute("downbutton","ignore")
f:SetAttribute("type", "click")
f:SetAttribute("clickbutton", FHSBE_1_1)
f:SetAttribute("*type-ignore", "")

f:SetScript("PreClick", FH.M.CropScannerPreClick)
f:SetScript("PostClick",FH.M.CropScannerPostClick)
f:SetScript("OnEnter", FH.M.ScanButtonOnEnter)
f:SetScript("OnLeave", FH.M.ScanButtonOnLeave)

f:SetScript("OnMouseDown", FH.M.ButtonOnMouseDown)
f:SetScript("OnMouseUp", FH.M.ButtonOnMouseUp)
f:SetScript("OnHide", FH.M.ButtonOnHide)

f.ScannerOutput = {}

if msqGroups["FarmhandTools"] then
	msqGroups["FarmhandTools"]:AddButton(f)
end

f = CreateFrame("Frame","FarmhandOptionsPanel",nil)
f.name = addonName
if _G.InterfaceOptions_AddCategory then
	InterfaceOptions_AddCategory(f)
elseif Settings and Settings.RegisterCanvasLayoutCategory then
  local cat = Settings.RegisterCanvasLayoutCategory(f, f.name)
  FH.optionsCategory = cat
  Settings.RegisterAddOnCategory(cat)
end

--[[f = CreateFrame("CheckButton","FarmhandToolsLockOption",FarmhandOptionsPanel,"UICheckButtonTemplate")
f:SetPoint("TopLeft",50,-50)
f:SetScript("OnClick",function(self) FH.M.SetLockToolsOption(self:GetChecked()) end)
FarmhandToolsLockOptionText:SetText(L["Lock tools to prevent them being dropped when you leave the farm."])]]

f = CreateFrame("CheckButton","FarmhandMessagesOption",FarmhandOptionsPanel,"UICheckButtonTemplate")
f:SetPoint("TopLeft",50,-50)-- FarmhandToolsLockOption,"Bottomleft",0,-15)
f:SetScript("OnClick",function(self) FH.M.SetMessagesOption(self:GetChecked()) end)
FarmhandMessagesOptionText:SetText(L["Show crop scanner findings in the chat window."])

f = CreateFrame("CheckButton","FarmhandSoundsOption",FarmhandOptionsPanel,"UICheckButtonTemplate")
f:SetPoint("TopLeft",FarmhandMessagesOption,"Bottomleft",0,-15)
f:SetScript("OnClick",function(self) FH.M.SetSoundsOption(self:GetChecked()) end)
FarmhandSoundsOptionText:SetText(L["Play sounds when crop scanner finishes."])

f = CreateFrame("CheckButton","FarmhandPortalsOption",FarmhandOptionsPanel,"UICheckButtonTemplate")
f:SetPoint("TopLeft",FarmhandSoundsOption,"Bottomleft",0,-15)
f:SetScript("OnClick",function(self) FH.M.RunAfterCombat(FH.M.SetPortalsOption,{self:GetChecked()}) end)
FarmhandPortalsOptionText:SetText(L["Show Portal Shard icons below the tools buttons."])

f = CreateFrame("CheckButton","FarmhandHideInCombatOption",FarmhandOptionsPanel,"UICheckButtonTemplate")
f:SetPoint("TopLeft",FarmhandPortalsOption,"Bottomleft",0,-15)
f:SetScript("OnClick",function(self) FH.M.RunAfterCombat(FH.M.SetHideInCombatOption,{self:GetChecked()}) end)
FarmhandHideInCombatOptionText:SetText(L["Hide Farmhand entirely during combat."])

f = CreateFrame("CheckButton","FarmhandStockTipOption",FarmhandOptionsPanel,"UICheckButtonTemplate")
f:SetPoint("TopLeft",FarmhandHideInCombatOption,"Bottomleft",0,-15)
f:SetScript("OnClick",function(self) FH.M.RunAfterCombat(FH.M.SetStockTipOption,{self:GetChecked()}) end)
FarmhandStockTipOptionText:SetText(L["Show special tooltip for vegetable seeds in merchant window."])

f = CreateFrame("Frame", "FarmhandStockTipPositionDropdown", FarmhandOptionsPanel, "UIDropDownMenuTemplate")
f:SetPoint("TopLeft",FarmhandStockTipOption,"Bottomleft",10,0)
UIDropDownMenu_SetWidth(f, 300)
UIDropDownMenu_JustifyText(f,"LEFT")
UIDropDownMenu_Initialize(f, FH.M.InitializeStockTipDropdown)
Farmhand.StockTipPositionDropdown = f

f = CreateFrame("GameTooltip","FarmhandMerchantStockTip",Farmhand,"GameTooltipTemplate")
Farmhand.StockTip = f

f = CreateFrame("CheckButton","FarmhandSeedIconOption",FarmhandOptionsPanel,"UICheckButtonTemplate")
f:SetPoint("TopLeft",FarmhandStockTipOption,"Bottomleft",0,-45)
f:SetScript("OnClick",function(self) FH.M.RunAfterCombat(FH.M.SetSeedIconOption,{self:GetChecked()}) end)
FarmhandSeedIconOptionText:SetText(L["Show Vegetable Icon on Seed Buttons"])

f = CreateFrame("CheckButton","FarmhandBagIconOption",FarmhandOptionsPanel,"UICheckButtonTemplate")
f:SetPoint("TopLeft",FarmhandSeedIconOption,"Bottomleft",0,0)
f:SetScript("OnClick",function(self) FH.M.RunAfterCombat(FH.M.SetBagIconOption,{self:GetChecked()}) end)
FarmhandBagIconOptionText:SetText(L["Show Vegetable Icon on Seed Bag Buttons"])

f = CreateFrame("CheckButton","FarmhandMiscToolsOption",FarmhandOptionsPanel,"UICheckButtonTemplate")
f:SetPoint("TopLeft",FarmhandBagIconOption,"Bottomleft",0,-15)
f:SetScript("OnClick",function(self) FH.M.RunAfterCombat(FH.M.SetMiscToolsOption,{self:GetChecked()}) end)
FarmhandMiscToolsOptionText:SetText(L["Show Optional Miscellaneous Tools"])

local LastTool
for _,v in ipairs(FH.MiscTools) do
	f = CreateFrame("CheckButton","FarmhandMiscToolsOption"..v,FarmhandOptionsPanel,"UICheckButtonTemplate")
	f:SetPoint("TopLeft",LastTool or FarmhandMiscToolsOption,"Bottomleft",LastTool == nil and 20 or 0, 0)
	f:SetScript("OnClick",function(self) FH.M.RunAfterCombat(FH.M.SetMiscToolsOption,{self:GetChecked(), v}) end)
	f:SetScript("OnEnter",function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetHyperlink("item:"..v)
		GameTooltip:Show()
	end)
	LastTool = f
end

function FH.M.UpdateMiscToolOptionText()
	for _,v in ipairs(FH.MiscTools) do
		local Txt = _G["FarmhandMiscToolsOption"..v.."Text"]
		if Txt:GetText() == nil then
			local ToolName, ToolLink, _, _, _, _, _, _, _, ToolIcon = FH.GetItemInfo(v)
			if ToolName ~= nil then
				Txt:SetText(format("|T%s:0|t %s",ToolIcon,ToolLink))
			end
		end
	end
end

f = CreateFrame("GameTooltip","FarmhandScanningTooltip",nil,"GameTooltipTemplate")
f:SetOwner( WorldFrame, "ANCHOR_NONE" );
f.ScanningTooltip = f
