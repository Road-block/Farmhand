local _, FH = ...
local L=FH.L

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

FH.CropStates = {
	{ CropNames = L["Occupied Soil"], Icon = 8 },
	{ CropNames = L["Stubborn Weed"], Icon = 4 },
	{ CropNames = L["AlluringCropNames"], Icon = 5 },
	{ CropNames = L["WildCropNames"], Icon = 3 },
	{ CropNames = L["TangledCropNames"], Icon = 7 },
	{ CropNames = L["ParchedCropNames"], Icon = 6 },
	{ CropNames = L["InfestedCropNames"], Icon = 4 },
	{ CropNames = L["WigglingCropNames"], Icon = 8 },
	{ CropNames = L["SmotheredCropNames"], Icon = 2 },
	{ CropNames = L["Unstable Portal Shard"], Icon = 3 },
	{ CropNames = L["BurstingCropNames"], Icon = 2 },
	{ CropNames = L["RuntyCropNames"], Icon = 1 },
}