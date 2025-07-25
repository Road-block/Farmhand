local addonName, FH = ...
local L = FH.L
FH.M = FH.M or {}
FH.E = FH.E or {} -- exports
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

local GREEN		= "|cFF00FF00"
local WHITE		= "|cFFFFFFFF"
local ORANGE	= "|cFFFF7F00"
local TEAL		= "|cFF00FF9A"

local FarmhandDataDefaults = {
	X = 0,
	Y = -UIParent:GetHeight() / 5,
	ToolsLocked = false,
	PrintScannerMessages = true,
	PlayScannerSounds = true,
	ShowPortals = true,
	HideInCombat = true,
	ShowStockTip = true,
	StockTipPosition = "BELOW",
	ShowVeggieIconsForSeeds = false,
	ShowVeggieIconsForBags = false,
}

function FH.M.Initialize()
	
	if FarmhandData == nil then
		FarmhandData = FarmhandDataDefaults
	else
		for k, v in pairs(FarmhandDataDefaults) do
			if FarmhandData[k] == nil then FarmhandData[k] = v end
		end
	end

--	FarmhandToolsLockOption:SetChecked(FarmhandData.ToolsLocked)
	FarmhandMessagesOption:SetChecked(FarmhandData.PrintScannerMessages)
	FarmhandSoundsOption:SetChecked(FarmhandData.PlayScannerSounds)
	FarmhandPortalsOption:SetChecked(FarmhandData.ShowPortals)
	FarmhandHideInCombatOption:SetChecked(FarmhandData.HideInCombat)
	FarmhandStockTipOption:SetChecked(FarmhandData.ShowStockTip)

	FarmhandSeedIconOption:SetChecked(FarmhandData.ShowVeggieIconsForSeeds)
	FarmhandBagIconOption:SetChecked(FarmhandData.ShowVeggieIconsForBags)
	
	FH.M.UpdateMiscToolsCheckboxes()
	
	if not FarmhandData.ShowStockTip then UIDropDownMenu_DisableDropDown(Farmhand.StockTipPositionDropdown) end
	
	if FarmhandData.StockTipPosition == "BELOW" then
		UIDropDownMenu_SetText(Farmhand.StockTipPositionDropdown, L["Below Normal Tooltip"])
	else
		UIDropDownMenu_SetText(Farmhand.StockTipPositionDropdown, L["Right of Normal Tooltip"])
	end
	
	for Seed, Veggie in pairs(FH.VeggiesBySeed) do --Attempt to pre-cache item info
		FH.GetItemInfo(Seed)
		FH.GetItemInfo(Veggie)
	end

	--print("Intial X="..FarmhandData.X.." Y="..FarmhandData.Y)
	Farmhand:SetPoint("CENTER",UIParent,"CENTER",FarmhandData.X,FarmhandData.Y)
	
	FarmhandSeeds.Update = FH.M.UpdateBar
	FarmhandTools.Update = FH.M.UpdateBar
	FarmhandPortals.Update = FH.M.UpdateBar
	
	hooksecurefunc(GameTooltip, "SetMerchantItem", FH.M.SetMerchantItem)
	GameTooltip:HookScript("OnHide", FH.M.HideStockTip)
	
end

function FH.M.UpdateMiscToolsCheckboxes()
	local AllChecked = true
	local Choices = FarmhandData.ShowMiscTools or {}
  local btn
	for _, v in ipairs(FH.MiscTools) do
		btn = _G["FarmhandMiscToolsOption"..v]
		if btn then
			btn:SetChecked(Choices[v] or false)
			AllChecked = AllChecked and Choices[v] or false
		end
	end
	btn = _G["FarmhandMiscToolsOption"]
	btn:SetChecked(AllChecked)
end

function FH.M.MerchantEvent(MerchantOpen)
	FH.MerchantOpen = MerchantOpen
end

local itemCounts = {}
local itemCountsLabels = {	L["Bags"], L["Bank"], L["AH"], L["Mail"] }
local function AddCharacterCountLine(character, searchedID)
	itemCounts[1], itemCounts[2] = DataStore:GetContainerItemCount(character, searchedID)
	itemCounts[3] = DataStore:GetAuctionHouseItemCount(character, searchedID)
	itemCounts[4] = DataStore:GetMailItemCount(character, searchedID)
	
	local charCount = 0
	for _, v in pairs(itemCounts) do
		charCount = charCount + v
	end
	
	if charCount > 0 then
		local account, _, char = strsplit(".", character)
		local name = DataStore:GetColoredCharacterName(character) or char		-- if for any reason this char isn't in DS_Characters.. use the name part of the key
		
		local t = {}
		for k, v in pairs(itemCounts) do
			if v > 0 then	-- if there are more than 0 items in this container
				table.insert(t, WHITE .. itemCountsLabels[k] .. ": "  .. TEAL .. v)
			end
		end

		-- charInfo should look like 	(Bags: 4, Bank: 8, Equipped: 1, Mail: 7), table concat takes care of this
		Farmhand.StockTip:AddDoubleLine(name, format("%s (%s%s)", ORANGE .. charCount .. WHITE, table.concat(t, WHITE..", "), WHITE))
	end
end

function FH.M.HideStockTip(tooltip)
	local tooltip = tooltip or GameTooltip
	if Farmhand.StockTip:IsOwned(tooltip) then
		Farmhand.StockTip:ClearLines()
		Farmhand.StockTip:Hide()
	end
end

function FH.M.SetMerchantItem(tooltip, slot)
	if ( MerchantFrame.selectedTab == 1 ) and FarmhandData.ShowStockTip and FH.MerchantOpen then
		local tooltip = tooltip or GameTooltip
		local ItemID = GetMerchantItemID(slot)
		if ItemID == nil then return end
		local VeggieID = FH.VeggiesBySeed[ItemID]
		if VeggieID == nil then
			ItemID = FH.SeedsBySeedBag[ItemID]
			if ItemID == nil then return end
			VeggieID = FH.VeggiesBySeed[ItemID]
		end
		if VeggieID then
			local veggieName = FH.GetItemInfo(VeggieID)
			local onHand = FH.GetItemCount(VeggieID,false)
			local inBank = FH.GetItemCount(VeggieID,true) - onHand

			local icon = FH.GetItemIcon(VeggieID)
			icon = icon and "|T"..icon..":14:14:0:0:32:32:3:29:3:29|t" or "??"
			veggieName = veggieName and icon.." "..veggieName or icon.." ".."ItemID: "..VeggieID
			--print(VeggieID, veggieName, onHand, inBank,icon)
			Farmhand.StockTip:SetOwner(tooltip, "ANCHOR_NONE");
			Farmhand.StockTip:ClearAllPoints();
			if FarmhandData.StockTipPosition == "BELOW" then
				Farmhand.StockTip:SetPoint("TOPLEFT", tooltip, "BOTTOMLEFT", 0, 0);
			else
				Farmhand.StockTip:SetPoint("TOPLEFT", tooltip, "TOPRIGHT", 0, 0);
			end
			Farmhand.StockTip:AddDoubleLine(L["Produces"],veggieName,0,1,0)

			if DataStore then

				Farmhand.StockTip:AddLine(" ")
				
				local ThisChar = DataStore:GetCharacter()
				
				AddCharacterCountLine(ThisChar,VeggieID)

				Farmhand.StockTip:AddLine(" ")
				
				for name, character in pairs(DataStore:GetCharacters(GetRealmName(), "Default")) do
					if name ~= UnitName("player") and DataStore:GetCharacterFaction(character) == UnitFactionGroup("player") then
						AddCharacterCountLine(character, VeggieID)
					end
				end

				Farmhand.StockTip:AddLine(" ")

				for guildName, guildKey in pairs(DataStore:GetGuilds(GetRealmName())) do				-- this realm only
					local guildCount = DataStore:GetGuildBankItemCount(guildKey, VeggieID) or 0
					if guildCount > 0 then
						Farmhand.StockTip:AddDoubleLine(GREEN..guildName, format("%s(%s: %s%s)", WHITE, "Guild Bank", TEAL..guildCount, WHITE))
					end
				end

			else
				Farmhand.StockTip:AddDoubleLine(L["On Hand"],onHand,0,1,0,1,1,1)
				Farmhand.StockTip:AddDoubleLine(L["In Bank"],inBank,0,1,0,1,1,1)
				FarmhandMerchantStockTipTextRight2:ClearAllPoints()
				FarmhandMerchantStockTipTextRight2:SetPoint("TOPLEFT",FarmhandMerchantStockTipTextRight1,"BOTTOMLEFT",0,-2)
				FarmhandMerchantStockTipTextRight3:ClearAllPoints()
				FarmhandMerchantStockTipTextRight3:SetPoint("TOPLEFT",FarmhandMerchantStockTipTextRight2,"BOTTOMLEFT",0,-2)
			end

			if TipTac then TipTac:AddModifiedTip(Farmhand.StockTip) end
			Farmhand.StockTip:Show()

		end
	end
end

function FH.M.ZoneChanged()

	local Zone, SubZone = GetZoneText(), GetSubZoneText()

	local InSunsong = SubZone == L["Sunsong Ranch"]
	local InMarket = SubZone == L["The Halfhill Market"]
	local InHalfhill = InSunsong or InMarket or SubZone == L["Halfhill"] or Zone == L["Halfhill"]
	
	if not InHalfhill and not FH.InHalfhill then return end

	local LeavingHalfhill = not InHalfhill and FH.InHalfhill

	local EnteringSunsong = InSunsong and not FH.InSunsong
	local LeavingSunsong = not InSunsong and FH.InSunsong

	local EnteringMarket = InMarket and not FH.InMarket
	local LeavingMarket = not InMarket and FH.InMarket
	
	
	if (LeavingSunsong or LeavingMarket) and not (EnteringSunsong or EnteringMarket) then
		--print("Leaving Sunsong area. Hiding Farmhand")
		Farmhand:UnregisterEvent("BAG_UPDATE_DELAYED")
		Farmhand:UnregisterEvent("MERCHANT_SHOW")
		Farmhand:UnregisterEvent("MERCHANT_CLOSED")
		Farmhand:UnregisterEvent("MERCHANT_UPDATE")
		FarmhandSeeds:Hide()
		FarmhandTools:Hide()
		FarmhandPortals:Hide()
		Farmhand:Hide()
		UnregisterStateDriver(Farmhand,"visibility")
	end
	
	if (EnteringSunsong or EnteringMarket) and not (FH.InSunsong or FH.InMarket) then
		--print("Entering Sunsong area. Updating Farmhand.")
		Farmhand:RegisterEvent("BAG_UPDATE_DELAYED")
		Farmhand:RegisterEvent("MERCHANT_SHOW")
		Farmhand:RegisterEvent("MERCHANT_CLOSED")
		Farmhand:RegisterEvent("MERCHANT_UPDATE")
		FarmhandSeeds:Show()
		Farmhand:Show()

		if FarmhandData.HideInCombat then
			RegisterStateDriver(Farmhand,"visibility","[combat]hide;show")
		end
		
	end
	
	if EnteringSunsong then
		FarmhandTools:Show()
		if FarmhandData.ShowPortals then FarmhandPortals:Show() end
		Farmhand:RegisterEvent("BAG_UPDATE_COOLDOWN")
	elseif LeavingSunsong then
		Farmhand:UnregisterEvent("BAG_UPDATE_COOLDOWN")
		FarmhandTools:Hide()
		FarmhandPortals:Hide()
	end
	
	if EnteringSunsong or EnteringMarket then
		Farmhand:Show()
		FH.M.Update()
	end
	
	if LeavingHalfhill then
		--FH.M.DropTools() -- protected action in classic
	end
	
	FH.InHalfhill = InHalfhill
	FH.InMarket = InMarket
	FH.InSunsong = InSunsong
	
end

function FH.M.ItemPreClick(Button,MouseButton,Down)
	if Down and not InCombatLockdown() then
		local Bag, Slot = FH.M.FindItemInBags(Button.ItemID)
		if IsShiftKeyDown() then
			Button:SetAttribute("type",nil)
		elseif FH.InSunsong and Button.ItemType == "Seed" and UnitName("target") ~= L["Tilled Soil"] then
			Button:SetAttribute("type","macro")
			Button:SetAttribute("macrotext","/targetexact "..L["Tilled Soil"].."\n/use "..Bag.." "..Slot)
		else
			Button:SetAttribute("type","item")
			Button:SetAttribute("item",Bag.." "..Slot)
		end
	end
end

function FH.M.ItemPostClick(Button,MouseButton,Down)
	if Down then return end
	if not InCombatLockdown() then
		Button:SetAttribute("type","item")
		Button:SetAttribute("item","item:"..Button.ItemID)
		Button:SetAttribute("shift-item*","")
	end
end

function FH.M.ItemOnEnter(Button)
	if FH.MerchantOpen and Button.ItemType == "Seed" then
		FH.ShowContainerSellCursor(Button.Bag,Button.Slot)
	end
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	GameTooltip:SetBagItem(Button.Bag,Button.Slot)
	GameTooltip:Show()
end

function FH.M.ItemOnLeave(Button)
	if FH.MerchantOpen and Button.ItemType == "Seed" then
		ResetCursor()
	end
	GameTooltip_Hide()
end

function FH.M.ButtonOnMouseDown(Button, MouseButton)
	if IsShiftKeyDown() and MouseButton == "LeftButton" and not Farmhand.isMoving then
		_,_,_, Farmhand.InitialOffsetX, Farmhand.InitialOffsetY = Farmhand:GetPoint(1)
--		print("InitialOffsetX: "..Farmhand.InitialOffsetX.." InitialOffsetY: "..Farmhand.InitialOffsetY)
		Farmhand:StartMoving()
		_,_,_, Farmhand.PickupOffsetX, Farmhand.PickupOffsetY = Farmhand:GetPoint(1)
--		print("PickupOffsetX: "..Farmhand.PickupOffsetX.." PickupOffsetY: "..Farmhand.PickupOffsetY)
		Farmhand.isMoving = true
	elseif MouseButton == "RightButton" and Farmhand.isMoving then
		Farmhand:StopMovingOrSizing()
		Farmhand.isMoving = false
		FarmhandData.X, FarmhandData.Y = 0, - UIParent:GetHeight() / 5
		FH.M.RunAfterCombat(FH.M.ResetAnchors)
	end
end

function FH.M.ButtonOnMouseUp(Button, MouseButton)
	if MouseButton == "LeftButton" and Farmhand.isMoving then
		local _,_,_, DropOffsetX, DropOffsetY = Farmhand:GetPoint(1)
--		print("DropOffsetX: "..DropOffsetX.." DropOffsetY: "..DropOffsetY)
		Farmhand:StopMovingOrSizing()
		Farmhand.isMoving = false
		FarmhandData.X = DropOffsetX - Farmhand.PickupOffsetX + Farmhand.InitialOffsetX
		FarmhandData.Y = DropOffsetY - Farmhand.PickupOffsetY + Farmhand.InitialOffsetY
--		print("FinalOffsetX: "..FarmhandData.X.." FinalOffsetY: "..FarmhandData.Y)
		FH.M.RunAfterCombat(FH.M.ResetAnchors)
   end
end

function FH.M.ResetAnchors()
	Farmhand:ClearAllPoints()
	Farmhand:SetPoint("CENTER",UIParent,FarmhandData.X,FarmhandData.Y)
end

function FH.M.ButtonOnHide()
	if InCombatLockdown() then 
		FH.M.RunAfterCombat(FH.M.ButtonOnHide)
		return
	end
	if Farmhand.isMoving then
		Farmhand:StopMovingOrSizing()
		Farmhand.isMoving = false
		FH.M.RunAfterCombat(FH.M.ResetAnchors)
	end
end

function FH.M.SetHideInCombatOption(Value)
	FarmhandData.HideInCombat = Value
	if Value and Farmhand:IsShown() then
		RegisterStateDriver(Farmhand,"visibility","[combat]hide;show")
	else
		UnregisterStateDriver(Farmhand,"visibility")
	end
end

function FH.M.SetBagIconOption(Value)
	FarmhandData.ShowVeggieIconsForBags = Value
	FH.M.UpdateButtonIcons(FarmhandSeeds)
end

function FH.M.SetSeedIconOption(Value)
	FarmhandData.ShowVeggieIconsForSeeds = Value
	FH.M.UpdateButtonIcons(FarmhandSeeds)
end
	
function FH.M.SetStockTipOption(Value)
	FarmhandData.ShowStockTip = Value

	if FarmhandData.ShowStockTip then
		UIDropDownMenu_EnableDropDown(Farmhand.StockTipPositionDropdown)
	else
		UIDropDownMenu_DisableDropDown(Farmhand.StockTipPositionDropdown)
	end

end

function FH.M.InitializeStockTipDropdown(frame, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	info.func = FH.M.SetStockTipPosition

	info.text = L["Below Normal Tooltip"]
	info.value = "BELOW"
	info.checked = FarmhandData and FarmhandData.StockTipPosition == "BELOW" or FarmhandData == nil and false
	UIDropDownMenu_AddButton(info)

	info.text = L["Right of Normal Tooltip"]
	info.value = "RIGHT"
	info.checked = FarmhandData and FarmhandData.StockTipPosition == "RIGHT"
	UIDropDownMenu_AddButton(info)
end

function FH.M.SetStockTipPosition(info)
	FarmhandData.StockTipPosition = info.value
	if FarmhandData.StockTipPosition == "BELOW" then
		UIDropDownMenu_SetText(Farmhand.StockTipPositionDropdown, L["Below Normal Tooltip"])
	else
		UIDropDownMenu_SetText(Farmhand.StockTipPositionDropdown, L["Right of Normal Tooltip"])
	end
end

function FH.M.SetLockToolsOption(Value)
	FarmhandData.ToolsLocked = Value
end

function FH.M.SetMessagesOption(Value)
	FarmhandData.PrintScannerMessages = Value
end

function FH.M.SetSoundsOption(Value)
	FarmhandData.PlayScannerSounds = Value
end

function FH.M.SetPortalsOption(Value)
	FarmhandData.ShowPortals = Value
	if Value then
		if FH.InSunsong then 
			FarmhandPortals:Show()
		else
			FarmhandPortals:Hide()
		end
	else
		FarmhandPortals:Hide()
	end
end

function FH.M.SetMiscToolsOption(Value, ItemID)
	if ItemID == nil then
		if Value then
			FarmhandData.ShowMiscTools = FarmhandData.ShowMiscTools or {}
			for _, v in ipairs(FH.MiscTools) do
				FarmhandData.ShowMiscTools[v] = true
			end
		else
			FarmhandData.ShowMiscTools = nil
		end
	else
		if Value then
			FarmhandData.ShowMiscTools = FarmhandData.ShowMiscTools or {}
			FarmhandData.ShowMiscTools[ItemID] = true
		else
			if FarmhandData.ShowMiscTools then
				FarmhandData.ShowMiscTools[ItemID] = nil
			end
		end
	end
	FH.M.UpdateMiscToolsCheckboxes()
	FH.M.Update()
end

function FH.M.UpdateButtonIcons(Bar)
	for _, Button in ipairs(Bar.Buttons) do
		local Icon, SmallIcon
		if Button.ItemType == "Seed" then
			Icon = select(10,FH.GetItemInfo(FarmhandData.ShowVeggieIconsForSeeds and (FH.VeggiesBySeed[Button.ItemID] or Button.ItemID) or Button.ItemID))
			Button.Icon:SetTexture(Icon)
		elseif Button.ItemType == "SeedBag" then
			Icon = FarmhandData.ShowVeggieIconsForBags and (FH.VeggiesBySeed[FH.SeedsBySeedBag[Button.ItemID]] or FH.SeedsBySeedBag[Button.ItemID]) or Button.ItemID
			Icon = select(10,FH.GetItemInfo(Icon))
			SmallIcon = FarmhandData.ShowVeggieIconsForBags and select(10,FH.GetItemInfo(Button.ItemID))
			Button.Icon:SetTexture(Icon)
			Button.SmallIcon:SetTexture(SmallIcon)
		else
			if Button.Bag and Button.Slot then
				Icon = FH.GetContainerItemInfo(Button.Bag,Button.Slot)
				Button.Icon:SetTexture(Icon)
				Button.SmallIcon:SetTexture(nil)
			end
		end
	end
end

function FH.M.UpdateBar(Bar)
	local Last
	local Shown = 0
	local ButtonSpacing = 6
	local MiscTools = FarmhandData.ShowMiscTools or {}
	
	for _, Button in ipairs(Bar.Buttons) do
		local ItemCount = Button.ItemID and FH.GetItemCount(Button.ItemID,false,true) or 0
		if ItemCount > 0 or Button.ItemType == "CropScanner" then
			if Button.ItemType ~= "MiscTool" or MiscTools[Button.ItemID] then

				if Shown % 8 == 0 then
					local Row = math.floor(Shown/8)
					Button:SetPoint("TOPLEFT",Bar,"TOPLEFT", ButtonSpacing/2, -ButtonSpacing/2 - Row*Button:GetHeight() - Row*ButtonSpacing)
					Last = Button
				else
					Button:SetPoint("TOPLEFT",Last,"TOPRIGHT",ButtonSpacing,0)
					Last = Button
				end
				if Button.ItemID then
					Button.Bag, Button.Slot = FH.M.FindItemInBags(Button.ItemID)
					if Bar.ShowItemCount then
						if ItemCount > 999 then
							Button.Count:SetText("***")
						else
							Button.Count:SetText(ItemCount)
						end
					end
				end
				Button:Show()
				Shown = Shown + 1
			else
				Button:Hide()
			end
		else
			Button:Hide()
		end
	end
	
	FH.M.UpdateButtonIcons(Bar)

	if msqGroups[Bar:GetName()] then msqGroups[Bar:GetName()]:ReSkin() end

	local Width, Height
	if Last then
		Width = math.min(8,Shown) * (Last:GetWidth() + ButtonSpacing) 
		Height = math.ceil(Shown/8) * (Last:GetHeight() + ButtonSpacing)
	end
	Bar:SetWidth(Width or (32 + ButtonSpacing))
	Bar:SetHeight(Height or (32 + ButtonSpacing))
end

function FH.M.UpdateSeedBagCharges()
	for _, Button in ipairs(FarmhandSeeds.Buttons) do
		local ItemCount = FH.GetItemCount(Button.ItemID,false,true)
		if ItemCount > 999 then
			Button.Count:SetText("***")
		else
			Button.Count:SetText(ItemCount)
		end
	end
end

function FH.M.Update()

	FarmhandSeeds:Update()
	FarmhandTools:Update()
	FarmhandPortals:Update()
	
	local SBH = FarmhandSeeds:GetHeight() * FarmhandSeeds:GetScale()
	local TBH = FarmhandTools:GetHeight() * FarmhandTools:GetScale()
	local PBH = FarmhandPortals:GetHeight() * FarmhandPortals:GetScale()
	local FHH = SBH + TBH + PBH -- + Farmhand.Backdrop:GetBackdrop().insets.top + Farmhand.Backdrop:GetBackdrop().insets.bottom
	Farmhand:SetHeight(FHH)
	
	local SBW = FarmhandSeeds:GetWidth() * FarmhandSeeds:GetScale()
	local TBW = FarmhandTools:GetWidth() * FarmhandTools:GetScale()
	local PBW = FarmhandPortals:GetWidth() * FarmhandPortals:GetScale()
	local FHW = max(SBW,TBW,PBW) -- + Farmhand.Backdrop:GetBackdrop().insets.left + Farmhand.Backdrop:GetBackdrop().insets.right
	Farmhand:SetWidth(FHW)

end

function FH.M.ScanButtonOnEnter()
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(L["Crop Scanner"],0,255,0,false)
	GameTooltip:AddLine(L["Scan your farm for crops or soil that need attention."],255,255,255,true)
	GameTooltip:Show()
end

function FH.M.ScanButtonOnLeave()
	GameTooltip_Hide()
end

function FH.M.DropTools()
	if FarmhandData.ToolsLocked then
		print(L["Leaving Halfhill."].." "..L["Tools are Locked."])
	else
		ClearCursor()
		for _, ItemID in ipairs(FH.Tools) do
			local Bag, Slot = FH.M.FindItemInBags(ItemID)
			if Bag and Slot then
				FH.PickupContainerItem(Bag,Slot)
				if CursorHasItem() then
					local _, ID, Link = GetCursorInfo()
					if ID == ItemID then
						print(L["Leaving Halfhill."].." "..L["Dropping"].." "..Link..".")
						DeleteCursorItem()
					end
				end
			end
		end
	end
end

function FH.M.FindItemInBags(ItemID)
	local NumSlots
	for Container = 0, NUM_BAG_SLOTS do
		NumSlots = FH.GetContainerNumSlots(Container)
		if NumSlots then
			for Slot = 1, NumSlots do
				if ItemID == FH.GetContainerItemID(Container, Slot) then
					return Container, Slot
				end
			end
		end
	end
end

FH.PostCombatQueue = {}
function FH.M.RunAfterCombat(Func,Args)
	if InCombatLockdown() then
		Farmhand:RegisterEvent("PLAYER_REGEN_ENABLED")
		tinsert(FH.PostCombatQueue,{Func=Func,Args=Args})
		return
	else
		Func(unpack(Args or {}))
	end
end
function FH.M.CombatEnded()
	for _, Item in ipairs(FH.PostCombatQueue) do
		Item.Func(unpack(Item.Args or {}))
	end
	wipe(FH.PostCombatQueue)
end

function FH.E.Mark(_,button,down)
	if down then return end
	local name = UnitExists("target") and UnitName("target") or ""
	local found
	for k,crop in pairs(FH.CropStates) do
		local cropname, mark = crop.CropName, crop.Icon
		if strfind(name,cropname) then
			if GetRaidTargetIndex("target") ~= mark then
				SetRaidTarget("target",mark)
			end
			local Icon = ICON_LIST[GetRaidTargetIndex("target")] and ICON_LIST[mark].."0|t" or ""
			local msg = L["Crop Scanner found:"].." "..Icon.." "..name
			if FarmhandData.PrintScannerMessages then
				print(msg)
				RaidNotice_AddMessage(RaidBossEmoteFrame,L["Some crops need attention!"], ChatTypeInfo["RAID_BOSS_EMOTE"])
			end
			if FarmhandData.PlayScannerSounds then
				PlaySound(SOUNDKIT.IG_QUEST_LOG_ABANDON_QUEST,"SFX")
			end
			found = true
			return
		end
	end
	if not found then
		if FarmhandData.PrintScannerMessages then
			print(L["Crop Scanner finished."].." "..L["The crops are looking good!"])
			RaidNotice_AddMessage(RaidBossEmoteFrame,L["The crops are looking good!"], ChatTypeInfo["RAID_BOSS_EMOTE"])
		end
		if FarmhandData.PlayScannerSounds then
			PlaySound(SOUNDKIT.IG_QUEST_LIST_COMPLETE,"SFX")
		end
	end
end

_G[addonName.."Exp"] = FH.E