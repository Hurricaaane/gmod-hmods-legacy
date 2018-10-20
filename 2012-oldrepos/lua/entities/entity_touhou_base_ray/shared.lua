ENT.Type = "anim"
ENT.Base = "base_anim"
ENT._DeriveTouhou = true
ENT._IsDanmaku    = true
ENT._IsRay        = true

ENT.DispellOnFirstTouch = true
ENT.TravelSpeed         = 512

function ENT:Initialize()
    self:SetModel("models/Items/AR2_Grenade.mdl")
	--self.Entity:PhysicsInitBox( Vector(-2, -2, -2), Vector(2, 2, 2) )
	self.Entity:SetMoveType( MOVETYPE_FLY )
	self.Entity:SetSolid( SOLID_BBOX )
	
	self:Travel()
	self:Live()
	
end

function ENT:Travel()
	self:SetVelocity( self:GetAngles():Forward() * self.TravelSpeed )
end

function ENT:Live()

end
