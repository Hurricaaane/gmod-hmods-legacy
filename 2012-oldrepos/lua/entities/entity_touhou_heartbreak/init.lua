AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.TravelSpeed         = 2048

function ENT:Live()
	self:EmitSound("touhou/remilia/heartbreak_swipe.wav")

	local effectData = EffectData()
	effectData:SetEntity( self.Entity )
	util.Effect("touhou_heartbreak", effectData, true, true)
	
end

function ENT:RemoveActions()
	
end