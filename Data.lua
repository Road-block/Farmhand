local _, FH = ...
local L=FH.L
FH.M = FH.M or { }

FH.Tools = {
	89815, --Master Plow
	89880, --Dented Shovel
	80513, --Vintage Bug Sprayer
	79104, --Rusty Watering Can
}

FH.MiscTools = {
	86425, --Cooking School Bell
}

FH.Portals = {
	91860, --Stormwind Portal Shard
	91864, --Ironforge Portal Shard
	91865, --Darnassus Portal Shard
	91866, --Exodar Portal Shard
	91850, --Orgrimmar Portal Shard
	91862, --Undercity Portal Shard
	91861, --Thunder Bluff Portal Shard
	91863, --Silvermoon Portal Shard
}

FH.Seeds = {
	79102, --Green Cabbage Seeds
	89328, --Jade Squash Seeds
	80590, --Juicycrunch Carrot Seeds
	80592, --Mogu Pumpkin Seeds
	80594, --Pink Turnip Seeds
	80593, --Red Blossom Leek Seeds
	80591, --Scallion Seeds
	89329, --Striped Melon Seeds
	80595, --White Turnip Seeds
	89326, --Witchberry Seeds
	85219, --Ominous Seed
	85216, --Enigma Seed
	85217, --Magebulb Seed
	89202, --Raptorleaf Seed
	85215, --Snakeroot Seed
	89233, --Songbell Seed
	89197, --Windshear Cactus Seed
	91806, --Unstable Portal Shard
	85267, --Autumn Blossom Sapling
	85268, --Spring Blossom Sapling
	85269, --Winter Blossom Sapling
}

FH.SeedBags = {
	95434,    --Bag of Green Cabbage Seeds
	80809,    --Bag of Green Cabbage Seeds
	95437,    --Bag of Jade Squash Seeds
	89848,    --Bag of Jade Squash Seeds
	95436,    --Bag of Juicycrunch Carrot Seeds
	84782,    --Bag of Juicycrunch Carrot Seeds
	95438,    --Bag of Mogu Pumpkin Seeds
	85153,    --Bag of Mogu Pumpkin Seeds
	85162,    --Bag of Pink Turnip Seeds
	95439,    --Bag of Pink Turnip Seeds
	95440,    --Bag of Red Blossom Leek Seeds
	85158,    --Bag of Red Blossom Leek Seeds
	84783,    --Bag of Scallion Seeds
	95441,    --Bag of Scallion Seeds
	89849,    --Bag of Striped Melon Seeds
	95442,    --Bag of Striped Melon Seeds
	85163,    --Bag of White Turnip Seeds
	95443,    --Bag of White Turnip Seeds
	95444,    --Bag of Witchberry Seeds
	89847,    --Bag of Witchberry Seeds
	95450,    --Bag of Enigma Seeds
	95449,    --Bag of Enigma Seeds
	95451,    --Bag of Magebulb Seeds
	95452,    --Bag of Magebulb Seeds
	95458,    --Bag of Raptorleaf Seeds
	95457,    --Bag of Raptorleaf Seeds
	95448,    --Bag of Snakeroot Seeds
	95447,    --Bag of Snakeroot Seeds
	95446,    --Bag of Songbell Seeds
	95445,    --Bag of Songbell Seeds
	95454,    --Bag of Windshear Cactus Seeds
	95456,    --Bag of Windshear Cactus Seeds
}

FH.VeggiesBySeed = {
	[79102] = 74840, --Green Cabbage
	[89328] = 74847, --Jade Squash
	[80590] = 74841, --Juicycrunch Carrot
	[80592] = 74842, --Mogu Pumpkin
	[80594] = 74849, --Pink Turnip
	[80593] = 74844, --Red Blossom Leek
	[80591] = 74843, --Scallions
	[89329] = 74848, --Striped Melon
	[80595] = 74850, --White Turnip
	[89326] = 74846, --Witchberries
}

FH.SeedsBySeedBag = {
	[95434] = 79102,    --Bag of Green Cabbage Seeds
	[80809] = 79102,    --Bag of Green Cabbage Seeds
	[95437] = 89328,    --Bag of Jade Squash Seeds
	[89848] = 89328,    --Bag of Jade Squash Seeds
	[95436] = 80590,    --Bag of Juicycrunch Carrot Seeds
	[84782] = 80590,    --Bag of Juicycrunch Carrot Seeds
	[95438] = 80592,    --Bag of Mogu Pumpkin Seeds
	[85153] = 80592,    --Bag of Mogu Pumpkin Seeds
	[85162] = 80594,    --Bag of Pink Turnip Seeds
	[95439] = 80594,    --Bag of Pink Turnip Seeds
	[95440] = 80593,    --Bag of Red Blossom Leek Seeds
	[85158] = 80593,    --Bag of Red Blossom Leek Seeds
	[84783] = 80591,    --Bag of Scallion Seeds
	[95441] = 80591,    --Bag of Scallion Seeds
	[89849] = 89329,    --Bag of Striped Melon Seeds
	[95442] = 89329,    --Bag of Striped Melon Seeds
	[85163] = 80595,    --Bag of White Turnip Seeds
	[95443] = 80595,    --Bag of White Turnip Seeds
	[95444] = 89326,    --Bag of Witchberry Seeds
	[89847] = 89326,    --Bag of Witchberry Seeds
	[95450] = 85216,    --Bag of Enigma Seeds
	[95449] = 85216,    --Bag of Enigma Seeds
	[95451] = 85217,    --Bag of Magebulb Seeds
	[95452] = 85217,    --Bag of Magebulb Seeds
	[95458] = 89202,    --Bag of Raptorleaf Seeds
	[95457] = 89202,    --Bag of Raptorleaf Seeds
	[95448] = 85215,    --Bag of Snakeroot Seeds
	[95447] = 85215,    --Bag of Snakeroot Seeds
	[95446] = 89233,    --Bag of Songbell Seeds
	[95445] = 89233,    --Bag of Songbell Seeds
	[95454] = 89197,    --Bag of Windshear Cactus Seeds
	[95456] = 89197,    --Bag of Windshear Cactus Seeds
}

FH.Turnins = {
	-- dark soil
	79264,
	79265,
	79266,
	79267,
	79268,
	-- foods
	74642,
	74643,
	74644,
	74645,
	74647,
	74649,
	74651,
	74652,
	74654,
	74655,
	-- debug
	--79871,
}

FH.TurninGift = {
	[79264]=true,
	[79265]=true,
	[79266]=true,
	[79267]=true,
	[79268]=true,
}
FH.TurninFood = {
	[74642]=true,
	[74643]=true,
	[74644]=true,
	[74645]=true,
	[74647]=true,
	[74649]=true,
	[74651]=true,
	[74652]=true,
	[74654]=true,
	[74655]=true,
}

FH.CropStates = {
	{ CropName = L["Occupied"], CropNames = L["Occupied Soil"], Icon = 8 },
	{ CropName = L["Stubborn"], CropNames = L["Stubborn Weed"], Icon = 4 },
	{ CropName = L["Alluring"], CropNames = L["AlluringCropNames"], Icon = 5 },
	{ CropName = L["Wild"], CropNames = L["WildCropNames"], Icon = 3 },
	{ CropName = L["Tangled"], CropNames = L["TangledCropNames"], Icon = 7 },
	{ CropName = L["Parched"], CropNames = L["ParchedCropNames"], Icon = 6 },
	{ CropName = L["Infested"], CropNames = L["InfestedCropNames"], Icon = 4 },
	{ CropName = L["Wiggling"], CropNames = L["WigglingCropNames"], Icon = 8 },
	{ CropName = L["Smothered"], CropNames = L["SmotheredCropNames"], Icon = 2 },
	{ CropName = L["Unstable"], CropNames = L["Unstable Portal Shard"], Icon = 3 },
	{ CropName = L["Bursting"], CropNames = L["BurstingCropNames"], Icon = 2 },
	{ CropName = L["Runty"], CropNames = L["RuntyCropNames"], Icon = 1 },
	--{ CropName = "Plump", CropNames = "", Icon = 2 }, -- debug
}

FH.DarkSoil = {
	name = L["Dark Soil"],
	object = 210565,
	contents = {[79264]=1,[79265]=1,[79266]=1,[79267]=1,[79268]=1,}
}

FH.NpcInfo = { -- Valley of the Four Winds zoneid 5805 mapid 376
	[58710] = { -- Jogu the Drunk
		Faction = 1273,
		Gifts = {[79267]=1}, -- Lovely Apple
		FoodGifts = {[74643] = {[74841]=2}},
		Reward = {[85271]=1},
		Location = {{376, 53.6, 52.6}}
	},
	[58647] = { -- Ella
		Faction = 1275,
		Gifts = {[79266]=1}, -- Jade Cat
		FoodGifts = {[74651] = {[74859]=1}},
		Reward = {[85272]={[85267]=1,[85268]=1,[85269]=1}},
		Location = {{376,53.0,51.6},{376,31.6,58.0}}
	},
	[58707] = { -- Old Hillpaw
		Faction = 1276,
		Gifts = {[79265]=1}, -- Blue Feather
		FoodGifts = {[74649] = {[74837]=1,[74841]=5}},
		Reward = {[90042]=1},
		Location = {{376,53.0,51.8},{376,31.0,53.0}}
	},
	[58709] = { -- Chee Chee
		Faction = 1277,
		Gifts = {[79265]=1}, -- Blue Feather
		FoodGifts = {[74647] = {[74864]=1,[74839]=1}},
		Reward = {[85275]=1},
		Location = {{376,53.0,52.0},{376,34.4,46.8}},
	},
	[58708] = { -- Sho
		Faction = 1278,
		Gifts = {[79267]=1}, -- Lovely Apple
		FoodGifts = {[74645] = {[74856]=1,[74848]=5}},
		Reward = {[85497]={[85222]=1}},
		Location = {{376,53.0,52.0},{376,29.6,30.6}}
	},
	[57402] = { -- Haohan Mudclaw
		Faction = 1279,
		Gifts = {[79264]=1}, -- Ruby Shard
		FoodGifts = {[74642] = {[74833]=1}},
		Reward = {[89233]=3},
		Location = {{376,53.0,51.6},{376,44.6,34.0}}
	},
	[58761] = { -- Tina Mudclaw
		Faction = 1280,
		Gifts = {[79264]=1}, -- Ruby Shard
		FoodGifts = {[74652] = {[74859]=1,[74843]=5}},
		Reward = {},
		Location = {{376,53.0,51.6},{376,45.0,33.8}}
	},
	[58706] = { -- Gina Mudclaw
		Faction = 1281,
		Gifts = {[79268]=1}, -- Marsh Lily
		FoodGifts = {[74644] = {[74856]=1}},
		Reward = {[85276]=1},
		Location = {{376,53.2,51.6}}
	},
	[58705] = { -- Fish Fellreed
		Faction = 1282,
		Gifts = {[79266]=1}, -- Jade Cat
		FoodGifts = {[74655] = {[74865]=2}},
		Reward = {[85227]={[85215]=1,[85217]=1,[89197]=1,[89202]=1,[89233]=1}},
		Location = {{376,52.8,51.8},{376,41.6,30.0}}
	},
	[57298] = { -- Farmer Fung
		Faction = 1283,
		Gifts = {[79268]=1}, -- Marsh Lily
		FoodGifts = {[74654] = {[74839]=1}},
		Reward = {[85216]=1},
		Location = {{376,53.0,51.4},{376,48.2,33.8}}
	},
}
local nameCache = {}
function FH.M.GetNPCName(npcid)
	if nameCache[npcid] then return nameCache[npcid] end
	local npcData = FH.NpcInfo[npcid]
	if npcData then
		local info = C_GossipInfo.GetFriendshipReputation(npcData.Faction)
		if info then
			nameCache[npcid] = info.name
			return nameCache[npcid]
		end
	end
end
local ingredientCache = {}
function FH.M.GetFoodIngredients(itemid)
	if ingredientCache[itemid] then	return ingredientCache[itemid] end
	for npcid, data in pairs(FH.NpcInfo) do
		local foodgift = data.FoodGifts
		for food,ingredients in pairs(foodgift) do
			if food == itemid then
				ingredientCache[itemid] = ingredients
				return ingredientCache[itemid]
			end
		end
	end
end
function FH.M.GetNPCStanding(npcid)
	local npcData = FH.NpcInfo[npcid]
	if npcData then
		local rank = C_GossipInfo.GetFriendshipReputationRanks(npcData.Faction)
		if rank then
			local info = C_GossipInfo.GetFriendshipReputation(npcData.Faction)
			local reaction = info and info.reaction or ""
			return rank.currentLevel, rank.maxLevel, rank.currentLevel == rank.maxLevel, reaction
		end
	end
end
function FH.M.GetNPCRewardsAsText(npcid,addLabel)
	local npcData = FH.NpcInfo[npcid]
	local label = format("%s%s",_G.REWARDS,_G.HEADER_COLON)
	local out = addLabel and label or ""
	if npcData then
		for reward, contents in pairs(npcData.Reward) do
			out = out .. FH.RewardLink[reward] .." "
			if type(contents) == "table" then
				--out = out .. ">"
				for content, amount in pairs(contents) do
					--out = out .. FH.RewardLink[content] .. " "
				end
			end
		end
		out = out:trim()
	end
	if out ~= label then
		return out
	end
end
local return_t = {}
function FH.M.GetGiftTargets(item)
	local giftTargets = FH.GiftTargets[item]
	if not giftTargets then
		giftTargets = FH.FoodGiftTargets[item]
	end
	if giftTargets then
		local found
		return_t = wipe(return_t)
		for npcid,data in pairs(giftTargets) do
			local _,_,maxed = FH.M.GetNPCStanding(npcid)
			if not maxed then
				local name = FH.M.GetNPCName(npcid)
				return_t[name] = return_t[name] or {}
				return_t[name].turnin = FH.TurninLink[item] or format("ItemID:%d",item)
				return_t[name].location = data.location
				return_t[name].reward = data.reward
				return_t[name].reward_txt = FH.M.GetNPCRewardsAsText(npcid,true) or ""
				found = true
			end
		end
		if found then
			return return_t
		end
	end
end
function FH.M.GetUnitTooltipData(npcid)
	--[[NPC
	Likes: gift
	Eats: food
			ingredients
	Best Friend: Reward]]
	local npcData = FH.NpcInfo[npcid]
	local found
	if npcData then
		local _,_,maxed = FH.M.GetNPCStanding(npcid)
		if not maxed then
			found = true
			return_t = wipe(return_t)
			local icon = ""
			for gift,amount in pairs(npcData.Gifts) do
				icon = FH.GetItemIcon(gift)
				icon = icon and "|T"..icon..":14:14:0:0:32:32:3:29:3:29|t" or ""
				local link = FH.TurninLink[gift]
				return_t.gift = link and (icon..link) or format("ItemID:%d",gift)
			end
			for foodgift,ingredients in pairs(npcData.FoodGifts) do
				return_t.foodgift = return_t.foodgift or {}
				icon = FH.GetItemIcon(foodgift)
				icon = icon and "|T"..icon..":14:14:0:0:32:32:3:29:3:29|t" or ""
				local link = FH.TurninLink[foodgift]
				return_t.foodgift.food = link and (icon..link) or format("ItemID:%d",foodgift)
				for ingredient,amount in pairs(ingredients) do
					local link = FH.IngredientLink[ingredient] or format("ItemID:%d",ingredient)
					return_t.foodgift.craft = return_t.foodgift.craft or {}
					return_t.foodgift.craft[link] = amount
				end
			end
			return_t.reward = FH.M.GetNPCRewardsAsText(npcid) or ""
		end
		if found then
			return return_t
		end
	end
end
function FH.M.GetBagItemTooltipData(itemid)
	--[[
	Gift
	NPC  Standing
	       Reward
	NPC  Standing
		     Reward

	Food
		Ingredients
	NPC  Standing
				Reward
	NPC  Standing
				Reward

	Ingredient
	xN>Food    NPC
  xN>Food 	 NPC

	]]
	local gift = FH.GiftTargets[itemid]
	local foodgift = FH.FoodGiftTargets[itemid]
	local foodgiftingredient = FH.FoodGiftIngredient[itemid]
	local found
	if gift then
		return_t = wipe(return_t)
		for npcid,data in pairs(gift) do
			local _,_,maxed,reaction = FH.M.GetNPCStanding(npcid)
			local icon = ""
			if not maxed then
				found = true
				icon = FH.FactionInfo[npcid].icon
				icon = icon and "|T"..icon..":14:14:0:0:32:32:3:29:3:29|t" or ""
				local name = FH.FactionInfo[npcid].name
				return_t[npcid] = return_t[npcid] or {}
				return_t[npcid].npc = name and (icon..name) or format("NPCid:%d",npcid)
				return_t[npcid].reaction = reaction
				return_t[npcid].reward = FH.M.GetNPCRewardsAsText(npcid) or ""
			end
		end
		if found then
			return return_t
		end
	elseif foodgift then
		return_t = wipe(return_t)
		for npcid,data in pairs(foodgift) do
			local _,_,maxed,reaction = FH.M.GetNPCStanding(npcid)
			if not maxed then
				found = true
				icon = FH.FactionInfo[npcid].icon
				icon = icon and "|T"..icon..":14:14:0:0:32:32:3:29:3:29|t" or ""
				local name = FH.FactionInfo[npcid].name
				return_t[npcid] = return_t[npcid] or {}
				return_t[npcid].npc = name and (icon..name) or format("NPCid:%d",npcid)
				return_t[npcid].reaction = reaction
				return_t[npcid].reward = FH.M.GetNPCRewardsAsText(npcid) or ""
			end
		end
		if found then
			local ingredients = FH.M.GetFoodIngredients(itemid)
			for ingredient, amount in pairs(ingredients) do
				local link = FH.IngredientLink[ingredient] or format("ItemID:%d",ingredient)
				return_t.craft = return_t.craft or {}
				return_t.craft[link] = amount
			end
			return return_t
		end
	elseif foodgiftingredient then
		return_t = wipe(return_t)
		for foodgift,data in pairs(foodgiftingredient) do
			local npcid = data.npc
			local _,_,maxed = FH.M.GetNPCStanding(npcid)
			if not maxed then
				found = true
				icon = FH.FactionInfo[npcid].icon
				icon = icon and "|T"..icon..":14:14:0:0:32:32:3:29:3:29|t" or ""
				local name = FH.FactionInfo[npcid].name
				return_t[foodgift] = return_t[foodgift] or {}
				return_t[foodgift].npc = name and (icon..name) or format("NPCid:%d",npcid)
				icon = "|T135805:14:14:0:0:32:32:3:29:3:29|t"
				return_t[foodgift].amount = icon..data.amount
				return_t[foodgift].food = FH.TurninLink[foodgift] or format("ItemID:%d",foodgift)
			end
		end
		if found then
			return return_t
		end
	end
end

-- Caching
FH.GiftTargets, FH.FoodGiftTargets = { }, { } -- item = {[npcid] = locationtable}
function FH.M.GenGiftTargets()
	for npcid,data in pairs(FH.NpcInfo) do
		for item,amount in pairs(data.Gifts) do
			FH.GiftTargets[item] = FH.GiftTargets[item] or {}
			FH.GiftTargets[item][npcid] = FH.GiftTargets[item][npcid] or {}
			FH.GiftTargets[item][npcid].location = CopyTable(data.Location)
			FH.GiftTargets[item][npcid].reward = CopyTable(data.Reward)
		end
		for item,ingredients in pairs(data.FoodGifts) do
			FH.FoodGiftTargets[item] = FH.FoodGiftTargets[item] or {}
			FH.FoodGiftTargets[item][npcid] = FH.FoodGiftTargets[item][npcid] or {}
			FH.FoodGiftTargets[item][npcid].location = CopyTable(data.Location)
			FH.FoodGiftTargets[item][npcid].reward = CopyTable(data.Reward)
			FH.FoodGiftTargets[item][npcid].ingredients = CopyTable(ingredients)
		end
	end
end
FH.RewardLink = { } -- itemid = itemlink
function FH.M.GenRewards()
	for npcid,data in pairs(FH.NpcInfo) do
		for reward,contents in pairs(data.Reward) do
			if not FH.RewardLink[reward] then
				local itemAsync = Item:CreateFromItemID(reward)
				itemAsync:ContinueOnItemLoad(function()
					FH.RewardLink[reward] = itemAsync:GetItemLink()
				end)
			end
			if type(contents) == "table" then
				for content,amount in pairs(contents) do
					if not FH.RewardLink[content] then
						local itemAsync = Item:CreateFromItemID(content)
						itemAsync:ContinueOnItemLoad(function()
							FH.RewardLink[content] = itemAsync:GetItemLink()
						end)
					end
				end
			end
		end
	end
end
FH.TurninLink = { }
function FH.M.GenTurnins()
	for _,turnin in pairs(FH.Turnins) do
		if not FH.TurninLink[turnin] then
			local itemAsync = Item:CreateFromItemID(turnin)
			itemAsync:ContinueOnItemLoad(function()
			FH.TurninLink[turnin] = itemAsync:GetItemLink()
			end)
		end
	end
end
FH.IngredientLink = { }
FH.FoodGiftIngredient = { }
function FH.M.GenIngredients()
	for npcid,data in pairs(FH.NpcInfo) do
		for foodgift, ingredients in pairs(data.FoodGifts) do
			for ingredient, amount in pairs(ingredients) do
				FH.FoodGiftIngredient[ingredient] = FH.FoodGiftIngredient[ingredient] or {}
				FH.FoodGiftIngredient[ingredient][foodgift] = {amount=amount,npc=npcid}
				local itemAsync = Item:CreateFromItemID(ingredient)
				itemAsync:ContinueOnItemLoad(function()
					FH.IngredientLink[ingredient] = itemAsync:GetItemLink()
				end)
			end
		end
	end
end
FH.FactionInfo = { }
function FH.M.GenFactions()
	for npcid,data in pairs(FH.NpcInfo) do
		local info = C_GossipInfo.GetFriendshipReputation(data.Faction)
		if info then
			FH.FactionInfo[npcid] = FH.FactionInfo[npcid] or {}
			FH.FactionInfo[npcid].name = info.name
			FH.FactionInfo[npcid].faction = info.friendshipFactionID
			FH.FactionInfo[npcid].icon = info.texture
		end
	end
end
C_Timer.After(1,FH.M.GenGiftTargets)
C_Timer.After(2,FH.M.GenRewards)
C_Timer.After(3,FH.M.GenTurnins)
C_Timer.After(4,FH.M.GenIngredients)
C_Timer.After(5,FH.M.GenFactions)
