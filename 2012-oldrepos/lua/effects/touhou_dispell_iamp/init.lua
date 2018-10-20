-- Touhou : Dispell


function EFFECT:Init( data )
	self.Pos = data:GetOrigin( ) 
	self.Normal = data:GetNormal( ) 
	
	local emitter = ParticleEmitter( self.Pos )
	
	local particles = {
		emitter:Add( "touhou/square_aura", self.Pos),
		emitter:Add( "touhou/square_aura", self.Pos),
		emitter:Add( "touhou/square_aura", self.Pos)
	}
	local rolldelta = 4 * ((math.random(0, 1) == 1) and 1 or -1)
	for k,particle in pairs(particles) do
		if k <= 2 then
			particle:SetColor(64, 64, 250)
			particle:SetStartAlpha( 128 )
		else
			particle:SetColor(255, 255, 255)
			particle:SetStartAlpha( 128 )
		end
		particle:SetRoll( k * 45 )
		particle:SetRollDelta( rolldelta )
		
		particle:SetStartSize( 32 )
		particle:SetEndSize( 330 )
		
		particle:SetEndAlpha( 0 )
		
		particle:SetDieTime( 0.4 )
		particle:SetBounce( 0 )
	end
	
	emitter:Finish( )
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render( )

end
