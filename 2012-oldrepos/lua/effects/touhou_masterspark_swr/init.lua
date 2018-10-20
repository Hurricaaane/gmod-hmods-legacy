-- Touhou : First Spark

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

function EFFECT:Init( data )
	self.Pos = data:GetOrigin( ) 
	self.Normal = data:GetNormal( ) 
	
	self.LastTime = 0
	self.DieTime  = CurTime() + 2
	self.DidSpark  = false
end

function EFFECT:Think( )
	if CurTime() > self.DieTime then return false end
	if CurTime() < (self.LastTime + 0.1) then return true end
	self.LastTime = CurTime()
	
	local emitter = ParticleEmitter( self.Pos )
	
	-- Moving ring towards players when initiated
	if not self.DidSpark then
		self.DidSpark = true
		
		local MAX_ITER = 4
		for i=1,MAX_ITER do
			local myOrigin = self.Pos + self.Normal * (64 + 192)
			local particle = emitter:Add( "touhou/ring_aura", myOrigin)
			
			particle:SetVelocity( self.Normal * -128 )

			local dice = math.random(1, #self.ColorSet)
			particle:SetColor(self.ColorSet[dice].r, self.ColorSet[dice].g, self.ColorSet[dice].b)		
			particle:SetStartSize( 90 + math.random(0,16) + i/MAX_ITER * 20 )
			particle:SetEndSize( 360 + math.random(0,16) + i/MAX_ITER * 20 )
			
			particle:SetStartAlpha( 128 )
			particle:SetEndAlpha( 0 )
			
			particle:SetDieTime( 1 )
			particle:SetBounce( 0 )
			particle:SetGravity( Vector(0,0,0) )
			particle:SetCollide( false )
		end
		
	end
	
	-- Blue sparks on Spellcaster hands
	local MAX_ITER = 10
	for i=1,MAX_ITER do
		local dir = VectorRand()
		local myOrigin = self.Pos + self.Normal * 24 - dir * 32
		
		local particle = emitter:Add( "touhou/disc_aura", myOrigin)
		particle:SetVelocity( dir * 4 )
		particle:SetAirResistance( 20 )
		particle:SetStartLength( 64 )
		particle:SetEndLength( 128 )
		
		particle:SetColor(0, 128, 255)
		
		particle:SetStartSize( 8 )
		particle:SetEndSize( 8 )
		
		particle:SetStartAlpha( 64 )
		particle:SetEndAlpha( 0 )
		
		particle:SetDieTime( 0.2 )
			
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( false )
	end
	
	-- Collapsing light on caster hands
	--[[
	do
		local myOrigin = self.Pos + self.Normal * 24
		
		local particle = emitter:Add( "touhou/disc_blur", myOrigin)
		
		particle:SetColor(128, 192, 255)
		
		particle:SetStartSize( 48 )
		particle:SetEndSize( 16 )
		
		particle:SetStartAlpha( 192 )
		particle:SetEndAlpha( 0 )
		
		particle:SetDieTime( 0.4 )
			
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( false )
	end
	]]--
	
	-- White light balls in frong of spellcaster hands
	local MAX_ITER = 2
	for i=1,MAX_ITER do
		local dir = VectorRand()
		local myOrigin = self.Pos + self.Normal * 24 + dir * 8
		
		local particle = emitter:Add( "touhou/disc_aura", myOrigin)
		particle:SetVelocity( dir * 256 )
		particle:SetAirResistance( 20 )
		
		local dice = 7
		particle:SetColor(255, 255, 255)
		particle:SetRoll( math.Rand( -25, 25 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		
		particle:SetStartSize( 4 )
		particle:SetEndSize( 8 )
		
		particle:SetStartAlpha( 128 )
		particle:SetEndAlpha( 0 )
		
		particle:SetDieTime( 0.4 )
			
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( false )
	end
	
	-- Inner love-couloured accentuation
	local MAX_ITER = 10
	for i=1,MAX_ITER do
		local myOrigin = self.Pos + self.Normal * (64 + ((i <= 3) and 0 or (i - 3)) * 32)
		
		local particle = emitter:Add( "touhou/disc_aura", myOrigin)
		particle:SetVelocity( self.Normal * 500 )
		particle:SetAirResistance( 50 )
		
		local dice = math.random(1, #self.ColorSet)
		particle:SetColor(self.ColorSet[dice].r, self.ColorSet[dice].g, self.ColorSet[dice].b)
		
		local itey = (1-(1-i/MAX_ITER)^2)
		particle:SetStartSize( 24 + itey * 92 * 1.5 )
		particle:SetEndSize( 24 + itey * 80   * 1.5 )
		
		particle:SetStartAlpha( 8 )
		particle:SetEndAlpha( 0 )
		
		particle:SetDieTime( 0.3 )
			
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( false )
	end
	
	-- Inner love-couloured mist
	--[[
	local MAX_ITER = 5
	for i=1,MAX_ITER do
		local myOrigin = self.Pos + self.Normal * (64 + ((i <= 3) and 0 or (i - 3)) * 48)
		
		local particle = emitter:Add( "touhou/disc_blur", myOrigin)
		particle:SetVelocity( self.Normal * 500 )
		particle:SetAirResistance( 50 )
		
		local dice = math.random(1, #self.ColorSet)
		particle:SetColor(self.ColorSet[dice].r, self.ColorSet[dice].g, self.ColorSet[dice].b)
		particle:SetRoll( math.Rand( -25, 25 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		
		local itey = (1-(1-i/MAX_ITER)^2)
		local mrand = math.random(-8,8)
		particle:SetStartSize( 48 + itey * 92 + mrand )
		particle:SetEndSize( 48 + itey * 80 + mrand )
		
		particle:SetStartAlpha( 8 )
		particle:SetEndAlpha( 0 )
		
		particle:SetDieTime( 0.3 )
			
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( false )
	end
	]]--
	-- Rings
	do
		local myOrigin = self.Pos + self.Normal * (64 + 192)
		local particle = emitter:Add( "touhou/ring_aura", myOrigin)
		

		local dice = math.random(1, #self.ColorSet)
		particle:SetColor(self.ColorSet[dice].r, self.ColorSet[dice].g, self.ColorSet[dice].b)		
		particle:SetStartSize( 86 + math.random(0,16) )
		particle:SetEndSize( 60 + math.random(0,16) )
		
		particle:SetStartAlpha( 128 )
		particle:SetEndAlpha( 0 )
		
		particle:SetDieTime( 0.3 )
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( false )
	end
	
	-- Direct Sparklings
	do
		local myOrigin = self.Pos
		local particle = emitter:Add( "touhou/disc_blur", myOrigin)

		local dice = math.random(1, #self.ColorSet)
		
		particle:SetVelocity( self.Normal * 2048 )
		particle:SetStartLength( 2048 )
		particle:SetEndLength( 2048 )
		
		particle:SetColor(255, 255, 255)		
		particle:SetStartSize( math.random(14,16) )
		particle:SetEndSize( 0 )
		
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 192 )
		
		particle:SetDieTime( 0.4 )
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( true )
	end
	
	--Close Sparklings
	do
		local myOrigin = self.Pos
		local particle = emitter:Add( "touhou/disc_blur", myOrigin)

		local dice = math.random(1, #self.ColorSet)
		
		particle:SetVelocity( self.Normal * 8 )
		particle:SetStartLength( 512 )
		particle:SetEndLength( 512 )
		
		particle:SetColor(255, 255, 255)		
		particle:SetStartSize( math.random(14,20) )
		particle:SetEndSize( 0 )
		
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 192 )
		
		particle:SetDieTime( 0.4 )
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( true )
	end
	
	-- Arch
	do
		local myOrigin = self.Pos + self.Normal * 16
		local particle = emitter:Add( "touhou/arch_aura", myOrigin)

		local dice = math.random(1, #self.ColorSet)
		
		particle:SetVelocity( self.Normal * 16 )
		particle:SetStartLength( 400 )
		particle:SetEndLength( 550 )
		
		local dice = math.random(1, #self.ColorSet)
		particle:SetColor(self.ColorSet[dice].r, self.ColorSet[dice].g, self.ColorSet[dice].b)		
		particle:SetStartSize( 164 )
		particle:SetEndSize( 150 )
		
		particle:SetStartAlpha( 128 )
		particle:SetEndAlpha( 64 )
		
		particle:SetDieTime( 0.4 )
		particle:SetBounce( 0 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( false )
	end
	
	emitter:Finish( )
	return true
end

function EFFECT:Render( )

end
