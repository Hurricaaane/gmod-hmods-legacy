ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName 		= "mega bass 2000 watt rms"
ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT

-- Not Toybox
ENT.Spawnable = false
ENT.AdminSpawnable = true

ENT.IsRunning = false
ENT.StartTime = 0
ENT.SoundObj = nil

function ENT:Initialize()
	if CLIENT then return end
	
	self:SetModel( "models/props_lab/citizenradio.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetColor( 12, 12, 12, 255 )
	self:SetUseType( SIMPLE_USE )
	
	self.IsRunning = false
	self.StartTime = 0
	self.SoundObj = CreateSound( self, Sound("ha3weapons/MEGA_BASS_LOOP.wav") )
	
	self:TogFunc()
	
end

function ENT:SpawnFunction( ply, tr )
	if not tr.Hit then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16

	local ent = ents.Create( ClassName )
	if not ValidEntity( ent ) then return end
	
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	local physObj = ent:GetPhysicsObject()
	if physObj:IsValid() then
		physObj:Wake()
		
	end

	return ent

end

function ENT:Use()
	self:TogFunc()

end

function ENT:TogFunc()
	self.IsRunning = not self.IsRunning
	
	if self.IsRunning then
		self.StartTime = CurTime()
		self.SoundObj:Play()
		
	else
		self.SoundObj:Stop()
		
	end
	
	
end

function ENT:Think()
	if CLIENT then return false end
	if not self.IsRunning then return false end
	
	if ((CurTime() - self.StartTime) > 13.78) then	
		local intensity = 3 + math.Clamp((CurTime() - self.StartTime - 13.78) / 5.0, 0, 1) * 12
		local intensitycam = intensity * 0.5
		
		for k,ent in pairs( ents.FindInSphere( self:GetPos(), 768 ) ) do
			if ValidEntity( ent ) and ent:GetPhysicsObject() ~= nil and ent:GetPhysicsObject():IsValid() then
				local phys = ent:GetPhysicsObject()
				
				phys:Wake()
				phys:ApplyForceCenter( VectorRand() * intensity )
				phys:AddAngleVelocity( VectorRand() * intensity * phys:GetMass() )
				
			end
			
			if ValidEntity( ent ) and ent:IsPlayer() then
				ent:ViewPunch( Angle( math.random(-intensitycam, intensitycam), math.random(-intensitycam, intensitycam), math.random(-intensitycam, intensitycam) ) )
				
			end
			
		end
		
	end
	
	
	self:NextThink( CurTime() + 0.1 )
	return true
	
end

function ENT:OnRemove()
	if (self.SoundObj != nil) then
		self.SoundObj:Stop()
	end
	
	
end