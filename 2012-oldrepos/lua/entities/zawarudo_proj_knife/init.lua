AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self.Entity:SetModel ("models/weapons/w_knife_t.mdl")
	
	self.Entity:PhysicsInit (SOLID_VPHYSICS)
    self.Entity:SetMoveType (MOVETYPE_VPHYSICS)   
    self.Entity:SetSolid (SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup (COLLISION_GROUP_INTERACTIVE_DEBRIS)
	
	self.SpawnTime = CurTime()
	
	self.PhysObj = self.Entity:GetPhysicsObject()
    if (self.PhysObj:IsValid()) then
		self.PhysObj:SetMass(1)
		self.PhysObj:EnableDrag(false)
		self.PhysObj:EnableGravity(false)
        self.PhysObj:Wake()
    end
	
	--self.Entity:EmitSound (self.LaunchSound)
	
	self.DeathTime = CurTime() + 7
end

function ENT:Think()
	if self.DeathTime < CurTime() then
		self:Remove ()
	end
	
	self.Entity:NextThink (CurTime() + 1)
	
	return true
end

function ENT:PhysicsUpdate(phys)	
	phys:AddVelocity (self:GetForward() * 2000)
	phys:AddAngleVelocity (phys:GetAngleVelocity() * -1)
end

function ENT:PhysicsCollide (data, phys)
	print (data.HitEntity, data.HitEntity:IsValid())
	local ent = data.HitEntity
	if not ent:IsValid() then
		self.PhysObj:EnableMotion (false)
		self.Entity:SetCollisionGroup (COLLISION_GROUP_NONE)
		local trc = util.QuickTrace (self.Entity:GetPos(), self:GetAngles():Forward():Normalize() * 16, self.Entity)
		self.Entity:SetPos (trc.HitPos)
	else
		--fire bullet
		self.Entity:FireBullets ({
			Num = 1,
			Src = self:GetPos(),
			Dir = self:GetAngles():Forward(),
			Spread = Vector (0,0,0),
			Tracer = 0,
			Force = 12,
			Damage = 500,
			Attacker = self:GetOwner()
		})
		if ent:IsPlayer() then
			if ValidEntity (self:GetOwner():GetActiveWeapon()) then
				self:GetOwner():GetActiveWeapon().Target = ent
			end
		end
		--we're done
		self:Remove()
	end
end

function ENT:Touch () end
