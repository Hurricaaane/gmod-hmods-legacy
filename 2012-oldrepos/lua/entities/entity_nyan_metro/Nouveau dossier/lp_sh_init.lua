if !SLVBase then
	include("autorun/slvbase_sh_init.lua")
	if !SLVBase then return end
end
local addon = "Liberty_Prime"
if SLVBase.AddonInitialized(addon) then return end

SLVBase.AddDerivedAddon(addon,{})
if SERVER then
	Add_NPC_Class("CLASS_ROBOT")
	util.SetNPCClassAllies(CLASS_ROBOT, {"npc_libertyprime"})
end
SLVBase.InitLua("lp_init")

local function AddToList(Category, Name, Class, KeyValues, fOffset, bOnCeiling, bOnFloor)
	list.Set("NPC", Class, {Name = Name, Class = Class, Category = Category, Offset = fOffset, KeyValues = KeyValues, OnCeiling = bOnCeiling, OnFloor = bOnFloor})
end

local Category = "Fallout 3"
AddToList(Category, "Liberty Prime", "npc_libertyprime")

hook.Add("InitPostEntity", "FLT_PrecacheModels", function()
	local models = {}
	local function AddDir(path)
		for k, v in pairs(file.Find("../" .. path .. "*.mdl")) do
			table.insert(models, path .. v)
		end
		for _, dir in pairs(file.FindDir("../" .. path .. "*")) do
			AddDir(path .. dir .. "/")
		end
	end
	AddDir("models/fallout/")
	
	for k, v in pairs(models) do
		util.PrecacheModel(v)
	end
	hook.Remove("InitPostEntity", "FLT_PrecacheModels")
end)