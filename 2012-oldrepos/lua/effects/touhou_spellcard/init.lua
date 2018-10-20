-- Touhou : Spellcard


function EFFECT:Init( data )
	self.Pos = data:GetOrigin( ) 
	self.Normal = data:GetNormal( ) 
	
	local emitter = ParticleEmitter( self.Pos )
	
	do
		local particle = emitter:Add( "touhou/spellcard", self.Pos)
		particle:SetColor(0, 0, 250)
		particle:SetRoll( math.Rand( -25, 25 ) )
		particle:SetRollDelta( 4 * ((math.random(0, 1) == 1) and 1 or -1) )
		
		particle:SetStartSize( 32 )
		particle:SetEndSize( 330 )
		
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		
		particle:SetDieTime( 0.7 )
		particle:SetVelocity( Vector(0,0,0) )
			
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
	end
	
	do
		local particle = emitter:Add( "touhou/ring_blur", self.Pos)
		particle:SetColor(180, 192, 255)
		
		particle:SetStartSize( 32 )
		particle:SetEndSize( 360 )
		
		particle:SetStartAlpha( 210 )
		particle:SetEndAlpha( 0 )
		
		particle:SetDieTime( 0.7 )
		particle:SetVelocity( Vector(0,0,0) )
			
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
	end
	
	local MAX_ITER = 40
	for i=1,MAX_ITER do
		local dir = VectorRand()
		local myOrigin = self.Pos +  self.Normal * 32 + dir * 32
		local particle = emitter:Add( "touhou/disc_aura", myOrigin)
		particle:SetColor(180, 192, 255)
		
		particle:SetVelocity( dir * 256 )
		particle:SetStartLength( 128 )
		particle:SetEndLength( 192 )
		
		particle:SetStartSize( 4 )
		particle:SetEndSize( 4 )
		
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		
		particle:SetDieTime( 0.4 )
			
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
	end
	
	emitter:Finish( )
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render( )

end
