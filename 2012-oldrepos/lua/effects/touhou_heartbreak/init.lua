-- Touhou : Heartbreak

EFFECT.ColorRed   = Color(255, 255, 255)
EFFECT.ColorWhite = Color(255, 255, 255)

function EFFECT:Init( data )
	self.Parent = data:GetEntity( ) 
	self.LastTime = 0

end

function EFFECT:Think( )
	if not ValidEntity( self.Parent ) then return false end
	
	if CurTime() < (self.LastTime + 0.1) then return true end
	self.LastTime = CurTime()
	
	self.Pos    = self.Parent:GetPos()
	self.Normal = self.Parent:GetAngles():Forward()
	
	print( self.Pos )
	
	local emitter = ParticleEmitter( self.Pos )
	
	-- Rings
	do
		local myOrigin = self.Pos
		local particle = emitter:Add("touhou/ring_aura", myOrigin)
		
		particle:SetColor( self.ColorRed )		
		particle:SetStartSize( 24 )
		particle:SetEndSize( 32 )
		
		particle:SetStartAlpha( 128 )
		particle:SetEndAlpha( 0 )
		
		particle:SetDieTime( 0.3 )
		--particle:SetVelocity( self.Parent:GetVelocity() )
		
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( false )

	end
	
	--Close Sparklings
	do
		local myOrigin = self.Pos
		local particle = emitter:Add( "touhou/disc_blur", myOrigin)

		particle:SetColor( self.ColorRed )	
		
		particle:SetStartLength( 512 )
		particle:SetEndLength( 512 )
			
		particle:SetStartSize( 32 )
		particle:SetEndSize( 16 )
		
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		
		particle:SetDieTime( 0.7 )
		--particle:SetVelocity( self.Parent:GetVelocity() )
		
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( false )
	end
	
	emitter:Finish( )
	return true
end

function EFFECT:Render( )

end
