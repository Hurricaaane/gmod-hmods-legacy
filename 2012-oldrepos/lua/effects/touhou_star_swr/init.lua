-- Touhou : Star

EFFECT.ColorSet = {
	Color(255,255,0),
	Color(0,255,255),
	Color(255,0,255),
	Color(255,128,0),
	Color(0,255,128),
	Color(128,0,255),
	Color(0,128,255),
	Color(128,255,0),
	Color(255,0,128)
}
EFFECT.AttackSound = Sound("touhou/marisa_staremit1.wav")

function EFFECT:Init( data )
	self.Pos = data:GetOrigin( ) 
	self.Normal = data:GetNormal( ) 
	
	self.LastTime = 0
	self.DieTime  = CurTime() + 1
	self.DidAttack  = false
end

function EFFECT:Think( )
	if CurTime() > self.DieTime then return false end
	if CurTime() < (self.LastTime + 0.1) then return true end
	self.LastTime = CurTime()
	
	WorldSound( self.AttackSound, self.Pos )
	
	local emitter = ParticleEmitter( self.Pos )
	
	do
		-- *1 to duplicate the vector as .Rotate mods the original
		local myNormal = self.Normal*1
		local intens = 20
		myNormal:Rotate( Angle(math.Rand(-intens,intens), math.Rand(-intens,intens), math.Rand(-intens,intens)) )
		local myOrigin = self.Pos + self.Normal * 32
		local tParticles = {
			emitter:Add( "touhou/star_aura", myOrigin)
			--,
			--emitter:Add( "touhou/disc_blur", myOrigin)
		}
		local dice = math.random(1, #self.ColorSet)
		
		for k,particle in pairs(tParticles) do
			if k == 1 then
				particle.CS = self.ColorSet
				particle.dice = dice
				particle:SetThinkFunction(
					function(self)
						self:SetNextThink( CurTime() + 0.5 )
						local mimiter = ParticleEmitter( self:GetPos() )
						local particle = mimiter:Add( "touhou/star_edge" , self:GetPos() )
						
						particle:SetVelocity( self:GetVelocity() * 0.7 )
						particle:SetColor(self.CS[self.dice].r, self.CS[self.dice].g, self.CS[self.dice].b)
									
						particle:SetStartSize( 34 )
						particle:SetEndSize( 48 )
						
						particle:SetStartAlpha( 255 )
						particle:SetEndAlpha( 0 )
						
						particle:SetDieTime( 1 )
						particle:SetBounce( 1 )
						particle:SetGravity( Vector(0,0,-12) )
						particle:SetCollide( true )
						
						particle:SetRoll( math.random(0, 35) )
						particle:SetRollDelta( math.random(3, 5) )
						
					end
				)
				particle:SetStartAlpha( 255 )
				particle:SetRoll( math.random(0, 35) )
				particle:SetRollDelta( math.random(3, 5) )
				particle:SetNextThink( CurTime() )
				
			else
				particle:SetStartAlpha( 64 )
				particle:SetStartLength( 256 )
				particle:SetEndLength( 200 )
			
			end
			particle:SetVelocity( myNormal * 512 )
			
			particle:SetColor(self.ColorSet[dice].r, self.ColorSet[dice].g, self.ColorSet[dice].b)		
			particle:SetStartSize( 34 )
			particle:SetEndSize( 48 )
			
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			
			particle:SetDieTime( 3 )
			particle:SetBounce( 1 )
			particle:SetGravity( Vector(0,0,0) )
			particle:SetCollide( true )
			
		end
		
	end
	
	-- Blue sparks on Spellcaster hands
	do
		local myOrigin = self.Pos + self.Normal * 32
		
		local particle = emitter:Add( "touhou/arch_aura", myOrigin)
		local dice = math.random(1, #self.ColorSet)
		particle:SetColor(self.ColorSet[dice].r, self.ColorSet[dice].g, self.ColorSet[dice].b)
		
		particle:SetStartSize( 48 )
		particle:SetEndSize( 32 )
		
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		
		particle:SetDieTime( 0.3 )
			
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( false )
	end
	
	emitter:Finish( )
	return true
end

function EFFECT:Render( )

end
