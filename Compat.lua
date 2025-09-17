local addonName, FH = ...
FH.M = FH.M or {}
FH.E = FH.E or {}

local ShowContainerSellCursor = function(...)
  if C_Container and C_Container.ShowContainerSellCursor then
    return C_Container.ShowContainerSellCursor(...)
  elseif _G.ShowContainerSellCursor then
    return _G.ShowContainerSellCursor(...)
  end
end
local GetContainerItemInfo = function(...)
  if C_Container and C_Container.GetContainerItemInfo then
    local ci = C_Container.GetContainerItemInfo(...)
    if ci then
      return ci.iconFileID, ci.stackCount, ci.isLocked, ci.quality, ci.isReadable, ci.hasLoot, ci.hyperlink, ci.isFiltered, ci.hasNoValue, ci.itemID, ci.isBound
    end
  elseif _G.GetContainerItemInfo then
    return _G.GetContainerItemInfo(...)
  end
end
local PickupContainerItem = function(...)
  if C_Container and C_Container.PickupContainerItem then
    return C_Container.PickupContainerItem(...)
  elseif _G.PickupContainerItem then
    return _G.PickupContainerItem(...)
  end
end
local GetContainerNumSlots = function(...)
  if C_Container and C_Container.GetContainerNumSlots then
    return C_Container.GetContainerNumSlots(...)
  elseif _G.GetContainerNumSlots then
    return _G.GetContainerNumSlots(...)
  end
end
local GetContainerItemID = function(...)
  if C_Container and C_Container.GetContainerItemID then
    return C_Container.GetContainerItemID(...)
  elseif _G.GetContainerItemID then
    return _G.GetContainerItemID(...)
  end
end
local GetItemInfo = function(...)
  if C_Item and C_Item.GetItemInfo then
    return C_Item.GetItemInfo(...)
  elseif _G.GetItemInfo then
    return _G.GetItemInfo(...)
  end
end
local GetItemCount = function(...)
  if C_Item and C_Item.GetItemCount then
    return C_Item.GetItemCount(...)
  elseif _G.GetItemCount then
    return _G.GetItemCount(...)
  end
end
local GetItemIcon = function(...)
  if C_Item and C_Item.GetItemIconByID then
    return C_Item.GetItemIconByID(...)
  elseif _G.GetItemIcon then
    return _G.GetItemIcon(...)
  end
end
local GetItemInfoInstant = function(...)
  if C_Item and C_Item.GetItemInfoInstant then
    return C_Item.GetItemInfoInstant(...)
  elseif _G.GetItemInfoInstant then
    return _G.GetItemInfoInstant(...)
  end
end
local GetSpellCooldown = function(...)
  if C_Spell and C_Spell.GetSpellCooldown then
    return C_Spell.GetSpellCooldown(...)
  elseif _G.GetSpellCooldown then
    local cdInfo = {}
    cdInfo.startTime, cdInfo.duration, cdInfo.isEnabled, cdInfo.modRate = _G.GetSpellCooldown(...)
    return cdInfo
  end
end

FH.ShowContainerSellCursor = ShowContainerSellCursor
FH.GetContainerItemInfo = GetContainerItemInfo
FH.PickupContainerItem = PickupContainerItem
FH.GetContainerNumSlots = GetContainerNumSlots
FH.GetContainerItemID = GetContainerItemID
FH.GetItemInfo = GetItemInfo
FH.GetItemCount = GetItemCount
FH.GetItemIcon = GetItemIcon
FH.GetItemInfoInstant = GetItemInfoInstant
FH.GetSpellCooldown = GetSpellCooldown