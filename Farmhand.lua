local addonName, FH = ...
local L = FH.L
FH.M = FH.M or {} -- methods
FH.E = FH.E or {} -- exports
FH._i = FH._i or {} -- internal state
local ValleyMapID,PandariaContID,_ = 376,870

local msq, msqGroups = nil, {}
if LibStub then
  msq = LibStub("Masque",true)
  if msq then
    msqGroups = {
      FarmhandTools = msq:Group(addonName,"Tools"),
      FarmhandSeeds = msq:Group(addonName,"Seeds"),
      FarmhandPortals = msq:Group(addonName,"Portals"),
      FarmhandTurnins = msq:Group(addonName,"Turnins"),
    }
  end
end

local GREEN   = "|cFF00FF00"
local WHITE   = "|cFFFFFFFF"
local ORANGE  = "|cFFFF7F00"
local TEAL    = "|cFF00FF9A"
local LABEL   = format("|T134435:16|t%s%s|r:",TEAL,addonName)

local FarmhandDataDefaults = {
  X = 0,
  Y = -UIParent:GetHeight() / 5,
  PrintScannerMessages = true,
  PlayScannerSounds = true,
  ShowPortals = true,
  HideInCombat = true,
  ShowStockTip = true,
  StockTipPosition = "BELOW",
  ShowVeggieIconsForSeeds = false,
  ShowVeggieIconsForBags = false,
  DarkSoilHelpers = true,
  ShowTurnins = true,
  minimap = {
    hide = true,
    lock = false,
    minimapPos = 250,
  }
}

function FH.M.Initialize()

  FarmhandData = FarmhandData or CopyTable(FarmhandDataDefaults)
  for k, v in pairs(FarmhandDataDefaults) do
    if FarmhandData[k] == nil then
      if type(v)=="table" then
        FarmhandData[k] = CopyTable(v)
      else
        FarmhandData[k] = v
      end
    end
  end

  FarmhandMinimapHideOption:SetChecked(FarmhandData.minimap.hide)
  FarmhandMessagesOption:SetChecked(FarmhandData.PrintScannerMessages)
  FarmhandSoundsOption:SetChecked(FarmhandData.PlayScannerSounds)
  FarmhandPortalsOption:SetChecked(FarmhandData.ShowPortals)
  FarmhandTurninsOption:SetChecked(FarmhandData.ShowTurnins)
  FarmhandHideInCombatOption:SetChecked(FarmhandData.HideInCombat)
  FarmhandDarkSoilOption:SetChecked(FarmhandData.DarkSoilHelpers)
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

  Farmhand:SetPoint("CENTER",UIParent,"CENTER",FarmhandData.X,FarmhandData.Y)

  FarmhandSeeds.Update = FH.M.UpdateBar
  FarmhandTools.Update = FH.M.UpdateBar
  FarmhandPortals.Update = FH.M.UpdateBar
  FarmhandTurnins.Update = FH.M.UpdateBar

  hooksecurefunc(GameTooltip, "SetMerchantItem", FH.M.SetMerchantItemTooltip)
  GameTooltip:HookScript("OnTooltipSetUnit",FH.M.SetUnitTooltip)
  hooksecurefunc(GameTooltip, "SetBagItem", FH.M.SetBagItemTooltip)
  hooksecurefunc(GameTooltip, "SetTradeSkillItem", FH.M.SetTradSkillItemTooltip)
  GameTooltip:HookScript("OnHide", FH.M.HideStockTip)

  hooksecurefunc(C_CVar, "SetCVar", FH.M.PostHookSetCVar)

  FH.LDB = LibStub("LibDataBroker-1.1",true)
  FH.LDBIcon = LibStub("LibDBIcon-1.0",true)
  if FH.LDB and FH.LDBIcon then
    FH.LDBObject = FH.LDB:NewDataObject(addonName,
      {
        type = "launcher",
        text = addonName,
        icon = 609616,
        label = "FH",
        OnTooltipShow = FH.M.OnLDBIconTooltipShow,
        OnClick = FH.M.OnLDBIconClick,
      })
    FH.LDBIcon:Register(addonName, FH.LDBObject, FarmhandData.minimap)
  end

end

function FH.M.IsOptionEnabled(option)
  if option == "minimap.hide" then
    return FarmhandData.minimap.hide
  elseif option == "minimap.lock" then
    return FarmhandData.minimap.lock
  else
    return FarmhandData[option]
  end
end

function FH.M.ToggleQuickOption(option)
  if option == "minimap.hide" then
    FH.M.SetMinimapHideOption(not FarmhandData.minimap.hide)
  elseif option == "minimap.lock" then
    FH.M.SetMinimapLockOption(not FarmhandData.minimap.lock)
  elseif option == "PrintScannerMessages" then
    FH.M.SetMessagesOption(not FarmhandData.PrintScannerMessages)
  elseif option == "PlayScannerSounds" then
    FH.M.SetSoundsOption(not FarmhandData.PlayScannerSounds)
  elseif option == "ShowStockTip" then
    FH.M.SetStockTipOption(not FarmhandData.ShowStockTip)
  elseif option == "ShowPortals" then
    FH.M.SetPortalsOption(not FarmhandData.ShowPortals)
  elseif option == "ShowTurnins" then
    FH.M.SetTurninsOption(not FarmhandData.ShowTurnins)
  elseif option == "HideInCombat" then
    FH.M.SetHideInCombatOption(not FarmhandData.HideInCombat)
  elseif option == "DarkSoilHelpers" then
    FH.M.SetDarkSoilOption(not FarmhandData.DarkSoilHelpers)
  end
end

function FH.M.OnLDBIconTooltipShow(tip)
  local tip = tip or GameTooltip
  tip:SetText(LABEL)
  tip:AddDoubleLine(L["Left-Click"],L["Clear TomTom Waypoints"],1,0.65,0,1,1,0,false)
  tip:AddDoubleLine(L["Right-Click"],L["Quick Options"],1,0.65,0,1,1,0,false)
  tip:AddDoubleLine(L["Middle-Click"],L["Blizzard Options"],1,0.65,0,1,1,0,false)
end
function FH.M.OnLDBIconClick(frame, mouseButton, Down)
  if mouseButton == "LeftButton" then
    if FH.M.RemoveAllWaypoints then
      FH.M.RemoveAllWaypoints()
    end
  elseif mouseButton == "RightButton" then
    local menu = MenuUtil.CreateCheckboxContextMenu(frame,
        FH.M.IsOptionEnabled,
        FH.M.ToggleQuickOption,
        {L["Chat info messages"],"PrintScannerMessages"},
        {L["Notification sounds"],"PlayScannerSounds"},
        {L["Extra tooltip"],"ShowStockTip"},
        {L["Portal shard icons"],"ShowPortals"},
        {L["Turn-in icons"],"ShowTurnins"},
        {L["Auto-hide in combat"],"HideInCombat"},
        {L["Dark Soil helpers"],"DarkSoilHelpers"},
        {L["Hide Minimap icon"],"minimap.hide"},
        {L["Lock Minimap icon"],"minimap.lock"}
    )
  elseif mouseButton == "MiddleButton" then
    Settings.OpenToCategory(FH.optionsCategory:GetID())
  end
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

function FH.M.PostHookSetCVar(cvar, value)
  if not (cvar:lower() == "graphicsgroundclutter") then return end
  if FH._i.cvarChanged then return end -- we only care for player changes
  FH._i.cvarOrig = value
end

local itemCounts = {}
local itemCountsLabels = {  L["Bags"], L["Bank"], L["AH"], L["Mail"] }
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
    local name = DataStore:GetColoredCharacterName(character) or char   -- if for any reason this char isn't in DS_Characters.. use the name part of the key

    local t = {}
    for k, v in pairs(itemCounts) do
      if v > 0 then -- if there are more than 0 items in this container
        table.insert(t, WHITE .. itemCountsLabels[k] .. ": "  .. TEAL .. v)
      end
    end

    -- charInfo should look like  (Bags: 4, Bank: 8, Equipped: 1, Mail: 7), table concat takes care of this
    Farmhand.StockTip:AddDoubleLine(name, format("%s (%s%s)", ORANGE .. charCount .. WHITE, table.concat(t, WHITE..", "), WHITE),1,1,1,1,1,1,false)
  end
end

function FH.M.ParseGUID(guid)
  if not guid or guid == "" then return end
  local guidType, arg2, arg3, arg4, arg5, arg6, arg7 = ("-"):split(guid)
  if guidType == "Creature" then
    local _, serverID, instanceID, zoneUID, npc, spawnUID = arg2, arg3, arg4, arg5, arg6, arg7
    local npcid = npc and tonumber(npc) or 0
    return npcid, guidType
  end
end

function FH.M.IsCookingOpen()
  if not TradeSkillFrame:IsVisible() then return end
  local prof1, prof2, arch, fishing, cooking, firstaid = GetProfessions()
  if not cooking then return end
  local cookingName = GetProfessionInfo(cooking)
  local tradeSkill = GetTradeSkillLine()
  if tradeSkill and cookingName and (tradeSkill == cookingName) then
    return true
  end
end

function FH.M.HideStockTip(tooltip)
  local tooltip = tooltip or GameTooltip
  if Farmhand.StockTip:IsOwned(tooltip) then
    Farmhand.StockTip:ClearLines()
    Farmhand.StockTip:Hide()
  end
end

function FH.M.SetUnitTooltip(tooltip, unitid)
  if not (FarmhandData.ShowStockTip and FH.InValley) then
    return
  end
  local tooltip = tooltip or GameTooltip
  local name,unitid = tooltip:GetUnit()
  local npcid = FH.M.ParseGUID(UnitGUID(unitid or "none"))
  if npcid and FH.NpcInfo[npcid] then
    Farmhand.StockTip:SetOwner(tooltip, "ANCHOR_NONE")
    Farmhand.StockTip:ClearAllPoints()
    if FarmhandData.StockTipPosition == "BELOW" then
      Farmhand.StockTip:SetPoint("TOPLEFT", tooltip, "BOTTOMLEFT", 0, 0)
    else
      Farmhand.StockTip:SetPoint("TOPLEFT", tooltip, "TOPRIGHT", 0, 0)
    end
    local info = FH.M.GetUnitTooltipData(npcid)
    if info then
      Farmhand.StockTip:AddDoubleLine(L["Likes"],info.gift,0,1,0,1,1,1,false)
      Farmhand.StockTip:AddDoubleLine(L["Eats"],info.foodgift.food.."(x5)",0,1,0,1,1,1,false)
      for material,amount in pairs(info.foodgift.craft) do
        Farmhand.StockTip:AddDoubleLine(" ",material .. format("x%d(%d)",amount,amount*5),1,1,1,0.7,0.7,0.7,false)
      end
      Farmhand.StockTip:AddDoubleLine(L["Best Friend"],info.reward,0,1,0,1,1,1,false)
      if TipTac then TipTac:AddModifiedTip(Farmhand.StockTip) end
      Farmhand.StockTip:Show()
    end
  else
    FH.M.HideStockTip(tooltip)
  end
end

function FH.M.SetTradSkillItemTooltip(tooltip, skillIndex)
  if not (FarmhandData.ShowStockTip) then return end
  if not FH.M.IsCookingOpen() then return end
  local tooltip = tooltip or GameTooltip
  local itemlink = GetTradeSkillItemLink(skillIndex)
  local _,ttItemlink = tooltip:GetItem()
  local itemID = itemlink and FH.GetItemInfoInstant(itemlink)
  local testID = ttItemlink and FH.GetItemInfoInstant(ttItemlink)
  if itemID and testID and (itemID == testID) then
    if not FH.TurninFood[itemID] then return end
    Farmhand.StockTip:SetOwner(tooltip, "ANCHOR_NONE")
    Farmhand.StockTip:ClearAllPoints()
    if FarmhandData.StockTipPosition == "BELOW" then
      Farmhand.StockTip:SetPoint("TOPLEFT", tooltip, "BOTTOMLEFT", 0, 0)
    else
      Farmhand.StockTip:SetPoint("TOPLEFT", tooltip, "TOPRIGHT", 0, 0)
    end
    local info = FH.M.GetBagItemTooltipData(itemID)
    if info then
      for npcid,data in pairs(info) do
        if npcid ~= "craft" then
          Farmhand.StockTip:AddDoubleLine(data.npc,data.reaction,0,1,0,1,1,0,false)
          Farmhand.StockTip:AddDoubleLine(L["Best Friend"],data.reward,0,1.0,1,1,1,false)
        end
      end
      if TipTac then TipTac:AddModifiedTip(Farmhand.StockTip) end
      Farmhand.StockTip:Show()
    end
  else
    FH.M.HideStockTip(tooltip)
  end
end

function FH.M.SetBagItemTooltip(tooltip, bag, slot)
  if not (FarmhandData.ShowStockTip) then return end
  local tooltip = tooltip or GameTooltip
  local itemID = FH.GetContainerItemID(bag, slot)
  if not itemID then return end
  if not (FH.TurninGift[itemID] or FH.TurninFood[itemID] or FH.FoodGiftIngredient) then return end
  Farmhand.StockTip:SetOwner(tooltip, "ANCHOR_NONE")
  Farmhand.StockTip:ClearAllPoints()
  if FarmhandData.StockTipPosition == "BELOW" then
    Farmhand.StockTip:SetPoint("TOPLEFT", tooltip, "BOTTOMLEFT", 0, 0)
  else
    Farmhand.StockTip:SetPoint("TOPLEFT", tooltip, "TOPRIGHT", 0, 0)
  end
  if FH.TurninGift[itemID] then
    local info = FH.M.GetBagItemTooltipData(itemID)
    if info then
      for npcid,data in pairs(info) do
        Farmhand.StockTip:AddDoubleLine(data.npc,data.reaction,0,1,0,1,1,0,false)
        Farmhand.StockTip:AddDoubleLine(L["Best Friend"],data.reward,0,1.0,1,1,1,false)
      end
      if TipTac then TipTac:AddModifiedTip(Farmhand.StockTip) end
      Farmhand.StockTip:Show()
    end
  elseif FH.TurninFood[itemID] then
    local info = FH.M.GetBagItemTooltipData(itemID)
    if info then
      if info.craft then
        for ingredient,amount in pairs(info.craft) do
          Farmhand.StockTip:AddDoubleLine(" ",format("%sx%d",ingredient,amount),1,1,1,0.7,0.7,0.7,false)
        end
      end
      for npcid,data in pairs(info) do
        if npcid ~= "craft" then
          Farmhand.StockTip:AddDoubleLine(data.npc,data.reaction,0,1,0,1,1,0,false)
          Farmhand.StockTip:AddDoubleLine(L["Best Friend"],data.reward,0,1.0,1,1,1,false)
        end
      end
      if TipTac then TipTac:AddModifiedTip(Farmhand.StockTip) end
      Farmhand.StockTip:Show()
    end
  elseif FH.FoodGiftIngredient[itemID] then
    local info = FH.M.GetBagItemTooltipData(itemID)
    if info then
      for foodgift,data in pairs(info) do
        Farmhand.StockTip:AddDoubleLine(data.amount,data.food,0.7,0.7,0.7,1,1,1,false)
        Farmhand.StockTip:AddDoubleLine(" ",data.npc,1,1,1,0,1,0,false)
      end
      if TipTac then TipTac:AddModifiedTip(Farmhand.StockTip) end
      Farmhand.StockTip:Show()
    end
  else
    FH.M.HideStockTip(tooltip)
  end
end

function FH.M.SetMerchantItemTooltip(tooltip, slot)
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

      Farmhand.StockTip:SetOwner(tooltip, "ANCHOR_NONE")
      Farmhand.StockTip:ClearAllPoints()
      if FarmhandData.StockTipPosition == "BELOW" then
        Farmhand.StockTip:SetPoint("TOPLEFT", tooltip, "BOTTOMLEFT", 0, 0)
      else
        Farmhand.StockTip:SetPoint("TOPLEFT", tooltip, "TOPRIGHT", 0, 0)
      end
      Farmhand.StockTip:AddDoubleLine(L["Produces"],veggieName,0,1,0,1,1,1,false)

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

        for guildName, guildKey in pairs(DataStore:GetGuilds(GetRealmName())) do        -- this realm only
          local guildCount = DataStore:GetGuildBankItemCount(guildKey, VeggieID) or 0
          if guildCount > 0 then
            Farmhand.StockTip:AddDoubleLine(GREEN..guildName, format("%s(%s: %s%s)", WHITE, "Guild Bank", TEAL..guildCount, WHITE),1,1,1,1,1,1,false)
          end
        end

      else
        Farmhand.StockTip:AddDoubleLine(L["On Hand"],onHand,0,1,0,1,1,1,false)
        Farmhand.StockTip:AddDoubleLine(L["In Bank"],inBank,0,1,0,1,1,1,false)
        FarmhandMerchantStockTipTextRight2:ClearAllPoints()
        FarmhandMerchantStockTipTextRight2:SetPoint("TOPLEFT",FarmhandMerchantStockTipTextRight1,"BOTTOMLEFT",0,-2)
        FarmhandMerchantStockTipTextRight3:ClearAllPoints()
        FarmhandMerchantStockTipTextRight3:SetPoint("TOPLEFT",FarmhandMerchantStockTipTextRight2,"BOTTOMLEFT",0,-2)
      end

      local copper
      if Auctionator and Auctionator.API and Auctionator.API.v1 then
        copper = Auctionator.API.v1.GetAuctionPriceByItemID(addonName, VeggieID)
      elseif TSM_API and TSM_API.GetCustomPriceValue then
        copper = TSM_API.GetCustomPriceValue("dbminbuyout", "i:"..VeggieID)
      end
      if copper then
        local moneyString = GetMoneyString(copper)
        Farmhand.StockTip:AddDoubleLine(L["Market Price"],moneyString,1,1,0,1,1,1,false)
      end

      if TipTac then TipTac:AddModifiedTip(Farmhand.StockTip) end
      Farmhand.StockTip:Show()
    else
      FH.M.HideStockTip(tooltip)
    end
  end
end

function FH.M.ZoneChanged()

  local Zone, SubZone = GetZoneText(), GetSubZoneText()

  local InSunsong = SubZone == L["Sunsong Ranch"]
  local InMarket = SubZone == L["The Halfhill Market"]
  local InHalfhill = InSunsong or InMarket or SubZone == L["Halfhill"] or Zone == L["Halfhill"]
  local ShowTurnins = FarmhandData.ShowTurnins and FH.M.CheckInValley()

  if FarmhandData.DarkSoilHelpers then
    FH.M.SetDarkSoilHelpers()
  else
    FH.M.ResetDarkSoilHelpers()
  end

  if not (InHalfhill or FH.InHalfhill or ShowTurnins) then return end

  local LeavingHalfhill = not InHalfhill and FH.InHalfhill

  local EnteringSunsong = InSunsong and not FH.InSunsong
  local LeavingSunsong = not InSunsong and FH.InSunsong

  local EnteringMarket = InMarket and not FH.InMarket
  local LeavingMarket = not InMarket and FH.InMarket

  if ((LeavingSunsong or LeavingMarket) and not (EnteringSunsong or EnteringMarket)) then
    Farmhand:UnregisterEvent("BAG_UPDATE_DELAYED")
    Farmhand:UnregisterEvent("MERCHANT_SHOW")
    Farmhand:UnregisterEvent("MERCHANT_CLOSED")
    Farmhand:UnregisterEvent("MERCHANT_UPDATE")
    FarmhandSeeds:Hide()
    FarmhandTools:Hide()
    FarmhandPortals:Hide()
    if not ShowTurnins then
      FarmhandTurnins:Hide()
      Farmhand:Hide()
      UnregisterStateDriver(Farmhand,"visibility")
    end
  end

  if ((EnteringSunsong or EnteringMarket) and not (FH.InSunsong or FH.InMarket)) or ShowTurnins then
    Farmhand:RegisterEvent("BAG_UPDATE_DELAYED")
    if ((EnteringSunsong or EnteringMarket) and not (FH.InSunsong or FH.InMarket)) then
      Farmhand:RegisterEvent("MERCHANT_SHOW")
      Farmhand:RegisterEvent("MERCHANT_CLOSED")
      Farmhand:RegisterEvent("MERCHANT_UPDATE")
      FarmhandSeeds:Show()
    end
    if ShowTurnins then
      FarmhandTurnins:Show()
    end
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
    if not ShowTurnins then
      Farmhand:UnregisterEvent("BAG_UPDATE_COOLDOWN")
    end
    FarmhandTools:Hide()
    FarmhandPortals:Hide()
  end

  if EnteringSunsong or EnteringMarket or ShowTurnins then
    Farmhand:Show()
    FH.M.Update()
  end

  FH.InHalfhill = InHalfhill
  FH.InMarket = InMarket
  FH.InSunsong = InSunsong

end

function FH.M.LootDarkSoil(autoLoot)
  local numLoot = GetNumLootItems()
  if numLoot == 0 then return end
  local autoLooting = autoLoot or (GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE"))
  for slot=numLoot,1,-1 do
    if LootSlotHasItem(slot) then
      local itemLink = GetLootSlotLink(slot)
      if (itemLink) then
        local itemID = C_Item.GetItemInfoInstant(itemLink)
        if itemID and FH.DarkSoil.contents[itemID] then
          if not autoLooting then
            LootSlot(slot)
          end
          ConfirmLootSlot(slot)
          local dialog = StaticPopup_FindVisible("LOOT_BIND")
          if dialog then _G[dialog:GetName().."Button1"]:Click() end
        end
      end
    end
  end
end

function FH.M.SetDarkSoilHelpers()
  if FH.M.CheckInValley() then
    FH._i.cvarChanged = true
    local from = C_CVar.GetCVar("graphicsGroundClutter")
    if from ~= "0" then
      FH._i.cvarOrig = from
      C_CVar.SetCVar("graphicsGroundClutter","0")
      C_Timer.After(0.2, function() FH._i.cvarChanged = false end)
    end
    Farmhand:RegisterEvent("LOOT_READY")
    if not FH._i.tooltipHook then
      GameTooltip:HookScript("OnShow", FH.M.SearchInTooltip)
    end
    FH._i.searchTooltip = true
  else
    FH.M.ResetDarkSoilHelpers()
  end
end

function FH.M.ResetDarkSoilHelpers(logout)
  if FH._i.cvarOrig then
    if not logout then
      FH._i.cvarChanged = true
    end
    C_CVar.SetCVar("graphicsGroundClutter",FH._i.cvarOrig)
    C_Timer.After(0.2, function() FH._i.cvarChanged = false end)
  end
  Farmhand:UnregisterEvent("LOOT_READY")
  FH._i.searchTooltip = false
end

function FH.M.CheckInValley()
  local mapID = C_Map.GetBestMapForUnit("player")
  local mapInfo = mapID and C_Map.GetMapInfo(mapID)
  FH.InValley = false
  if mapID and mapInfo then
    if mapID == ValleyMapID then
      FH.InValley = true
      return FH.InValley
    else
      if mapInfo.mapType == Enum.UIMapType.Micro then
        mapID = mapInfo.parentMapID
        if mapID == ValleyMapID then
          FH.InValley = true
          return FH.InValley
        end
      end
    end
  end
  return FH.InValley
end

function FH.M.CheckInPandaria()
  local mapID = C_Map.GetBestMapForUnit("player")
  local mapPosition = mapID and C_Map.GetPlayerMapPosition(mapID,"player")
  FH.InPandaria = false
  if mapID and mapPosition then
    local contID, position = C_Map.GetWorldPosFromMapPos(mapID,mapPosition)
    if contID and contID == PandariaContID then
      FH.InPandaria = true
      return FH.InPandaria
    end
  end
  return FH.InPandaria
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
      if Button.ItemType ~= "Turnin" then
        Button:SetAttribute("type","item")
        Button:SetAttribute("item",Bag.." "..Slot)
      end
    end
  end
end

function FH.M.ItemPostClick(Button,MouseButton,Down)
  if Down then return end
  if not InCombatLockdown() then
    if Button.ItemType ~= "Turnin" then
      Button:SetAttribute("type","item")
      Button:SetAttribute("item","item:"..Button.ItemID)
    end
    Button:SetAttribute("shift-item*","")
  end
  if Button.ItemType == "Turnin" then
    if MouseButton == "LeftButton" then
      if FH.M.AddGiftWaypoint and Button.ItemID then
        FH.M.AddGiftWaypoint(Button.ItemID)
      end
    elseif MouseButton == "RightButton" then
      if FH.M.RemoveGiftWaypoint and Button.ItemID then
        FH.M.RemoveGiftWaypoint(Button.ItemID)
      end
    end
  end
end

function FH.M.ItemOnEnter(Button)
  if FH.MerchantOpen and Button.ItemType == "Seed" then
    FH.ShowContainerSellCursor(Button.Bag,Button.Slot)
  end
  GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
  GameTooltip:SetBagItem(Button.Bag,Button.Slot)
  if Button.ItemType == "Turnin" then
    GameTooltip:AddDoubleLine(L["Left-Click for Directions"],L["Right-Click to Clear"],0,1,0,1,1,0,false)
  end
  GameTooltip:Show()
end

function FH.M.ItemOnLeave(Button)
  if FH.MerchantOpen and Button.ItemType == "Seed" then
    ResetCursor()
  end
  GameTooltip_Hide()
end

function FH.M.AlertWithThrottle(interval)
  local now = GetTime()
  if (not FH._i.lastAlert) or ((now - FH._i.lastAlert) > interval) then
    FH._i.lastAlert = now
    if FarmhandData.PlayScannerSounds then
      PlaySoundFile(567574,"SFX")
    end
    if FarmhandData.PrintScannerMessages then
      local msg = format("Found "..GREEN.."%s|r Nearby.",FH.DarkSoil.name)
      FH.M.Print(msg)
    end
  end
end

function FH.M.SearchInTooltip(self)
  local self = self or GameTooltip
  if not FH._i.searchTooltip then return end
  if self:GetItem() or self:GetSpell() or self:GetUnit() then return end
  if WorldMapFrame and WorldMapFrame:IsVisible() and WorldMapFrame:IsMouseOver() then return end
  if WatchFrame and WatchFrame:IsVisible() and WatchFrame:IsMouseOver() then return end
  if Minimap and Minimap:IsVisible() and Minimap:IsMouseOver() then return end
  local chatFrame = (DEFAULT_CHAT_FRAME or SELECTED_CHAT_FRAME)
  if chatFrame:IsVisible() and chatFrame:IsMouseOver() then return end
  local fString = _G[self:GetName().."TextLeft1"]
  local leftText = fString and fString.GetText and fString:GetText() or ""
  if leftText and strfind(leftText, FH.DarkSoil.name) then
    FH.M.AlertWithThrottle(5)
    return true
  end
end

function FH.M.ButtonOnMouseDown(Button, MouseButton)
  if IsShiftKeyDown() and MouseButton == "LeftButton" and not Farmhand.isMoving then
    _,_,_, Farmhand.InitialOffsetX, Farmhand.InitialOffsetY = Farmhand:GetPoint(1)
    Farmhand:StartMoving()
    _,_,_, Farmhand.PickupOffsetX, Farmhand.PickupOffsetY = Farmhand:GetPoint(1)
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
    Farmhand:StopMovingOrSizing()
    Farmhand.isMoving = false
    FarmhandData.X = DropOffsetX - Farmhand.PickupOffsetX + Farmhand.InitialOffsetX
    FarmhandData.Y = DropOffsetY - Farmhand.PickupOffsetY + Farmhand.InitialOffsetY
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

function FH.M.SetDarkSoilOption(Value)
  FarmhandData.DarkSoilHelpers = Value
  if Value then
    FH.M.SetDarkSoilHelpers()
  else
    FH.M.ResetDarkSoilHelpers()
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

function FH.M.SetMinimapHideOption(Value)
  FarmhandData.minimap.hide = Value
  if FarmhandData.minimap.hide then
    FH.LDBIcon:Hide(addonName)
  else
    FH.LDBIcon:Show(addonName)
  end
end

function FH.M.SetMinimapLockOption(Value)
  FarmhandData.minimap.lock = Value
  if FarmhandData.minimap.lock then
    FH.LDBIcon:Lock(addonName)
  else
    FH.LDBIcon:Unlock(addonName)
  end
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

function FH.M.SetTurninsOption(Value)
  FarmhandData.ShowTurnins = Value
  if Value then
    if FH.M.CheckInValley() then
      FarmhandTurnins:Show()
    else
      FarmhandTurnins:Hide()
    end
  else
    FarmhandTurnins:Hide()
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
            local FoodGift = FH.TurninFood[Button.ItemID]
            if ItemCount > 999 then
              Button.Count:SetText("***")
            else
              Button.Count:SetText(FoodGift and format("%d |cffff0000/|cff00ff005|r",ItemCount) or ItemCount)
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
  FarmhandTurnins:Update()

  local SBH = FarmhandSeeds:GetHeight() * FarmhandSeeds:GetScale()
  local TBH = FarmhandTools:GetHeight() * FarmhandTools:GetScale()
  local PBH = FarmhandPortals:GetHeight() * FarmhandPortals:GetScale()
  local IBH = FarmhandTurnins:GetHeight() * FarmhandTurnins:GetScale()
  local FHH = SBH + TBH + PBH + IBH
  Farmhand:SetHeight(FHH)

  local SBW = FarmhandSeeds:GetWidth() * FarmhandSeeds:GetScale()
  local TBW = FarmhandTools:GetWidth() * FarmhandTools:GetScale()
  local PBW = FarmhandPortals:GetWidth() * FarmhandPortals:GetScale()
  local IBW = FarmhandTurnins:GetWidth() * FarmhandTurnins:GetScale()
  local FHW = max(SBW,TBW,PBW,IBW)
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

function FH.M.TableCount(t)
  local count = 0
  if type(t)=="table" then
    for k,v in pairs(table) do
      count = count + 1
    end
  end
  return count
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

function FH.M.Print(msg)
  if not msg or msg:trim() == "" then return end
  local chatFrame = (DEFAULT_CHAT_FRAME or SELECTED_CHAT_FRAME)
  local out = LABEL..msg
  chatFrame:AddMessage(out)
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
        FH.M.Print(msg)
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
      FH.M.Print(L["Crop Scanner finished."].." "..L["The crops are looking good!"])
      RaidNotice_AddMessage(RaidBossEmoteFrame,L["The crops are looking good!"], ChatTypeInfo["RAID_BOSS_EMOTE"])
    end
    if FarmhandData.PlayScannerSounds then
      PlaySound(SOUNDKIT.IG_QUEST_LIST_COMPLETE,"SFX")
    end
  end
end

_G[addonName.."Exp"] = FH.E
