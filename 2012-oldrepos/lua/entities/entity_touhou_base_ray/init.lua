AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT._Owner = nil

function ENT:SetOwner( entity )
	self._Owner = entity
end

function ENT:PassesTriggerFilters( target )
	if target ~= self._Owner and (target._IsDanmaku or (target == GetWorldEntity())) then
		return true
	end
	
	return false
	
end

function ENT:StartTouch( target )
	local bIsWorld = (target == GetWorldEntity())

	if bIsWorld or self.DispellOnFirstTouch then
		if not bIsWorld and self.Inflict then
			self:Inflict( target )
		end
		
		self:_CastRemove()
	end
	
end

function ENT:_CastRemove()
	if self.RemoveActions then
		self:RemoveActions()
	end
	
	self:Remove()
	
end
