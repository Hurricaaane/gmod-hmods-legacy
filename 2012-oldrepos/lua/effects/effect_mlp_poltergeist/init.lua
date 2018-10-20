local maxiter = 72

function EFFECT:Init( data )
	self.Ent = data:GetEntity( ) 
	
	self.LastTime = 0
	self.DieTime  = CurTime() + 1
	
	self.ESize = (self.Ent:OBBMaxs() - self.Ent:OBBMins()):Length()
	self.PartNum = math.Clamp(math.floor(self.ESize * 0.2), 1, maxiter)
	
end

function EFFECT:Think( )
	if not ValidEntity( self.Ent ) then return false end
	if CurTime() > self.DieTime then return false end
	if CurTime() < (self.LastTime + 0.1) then return true end
	
	self.LastTime = CurTime()
	self.Pos = self.Ent:LocalToWorld(self.Ent:OBBCenter())
	
	local emitter = ParticleEmitter( self.Pos )
	for i=1,self.PartNum do		
		local myOrigin = self.Pos + VectorRand() * self.ESize * 0.5
		
		local particle = emitter:Add( "ha3mats/sparkle", myOrigin)
		
		particle:SetVelocity( VectorRand() * 2 )
		
		particle:SetColor(255, 255, 255)
		particle:SetStartSize( math.random(2,4) )
		particle:SetEndSize( math.random(1,2) )
		
		particle:SetStartAlpha( 192 )
		particle:SetEndAlpha( 128 )
		
		particle:SetDieTime( 0.15 )
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( false )
		
	end
	
	emitter:Finish( )
	return true
	
end

function EFFECT:Render( )

end
