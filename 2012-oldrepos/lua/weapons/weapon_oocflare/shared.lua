
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.PrintName       = "Electroworks 1st"
SWEP.Author          = "Hurricaaane (Ha3)"           
SWEP.Slot            = 4
SWEP.SlotPos         = 10
SWEP.DrawAmmo        = false
SWEP.DrawCrosshair   = true
SWEP.Weight          = 5
SWEP.AutoSwitchTo    = false
SWEP.AutoSwitchFrom  = false
SWEP.Author          = ""
SWEP.Contact         = ""
SWEP.Purpose         = ""
SWEP.Instructions    = "Aim at the air, Primary to fire, secondary to detonate."
SWEP.ViewModel       = "models/weapons/v_rpg.mdl"
SWEP.WorldModel      = "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.ClipSize       = 10
SWEP.Primary.DefaultClip    = 10
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "ha3_flare"
SWEP.Primary.Delay          = 0.1

SWEP.Secondary.ClipSize     = 10
SWEP.Secondary.DefaultClip  = 10
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay          = 0.4

SWEP.HoldType = "rpg"

SWEP.OwnerLastVelocity     = 0
SWEP.OwnerLastGroundEntity = nil

do
	SWEP.Sounds = {}
	SWEP.Sounds["fire"]			= Sound("weapons/airboat/airboat_gun_energy1.wav")
	SWEP.Sounds["detonate"]	    = Sound("buttons/button4.wav")
	
end


function SWEP:Initialize()
	
	
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return false end
	
	if SERVER then
		self:EmitSound( self.Sounds.fire, 100, math.random(150, 200) )
		
		local ent = ents.Create( "ha3_oocflare_entity_type1" )
		local ang = self.Owner:GetAimVector():Angle()
		ent:SetPos( self.Owner:GetShootPos() + ang:Right() * 6 + ang:Up() * -4 )
		ent:SetAngles( ang )
		ent:Spawn()
		
		ent:SetOwner( self.Owner )
		
	end
	
	self:ShootEffects()
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) // Use primary delay
	
    return true
    
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then return false end
	
	if SERVER then
		self:EmitSound( self.Sounds.detonate, 100, 200 )
		
		for k,ent in pairs( ents.FindByClass( "ha3_oocflare_entity_type1" ) ) do
			if ent:GetOwner() == self.Owner then
				ent:Drop()
				ent:Remove()
				
			end
		
		end
	
	
	end
	
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
    return false
    
end

function SWEP:ShouldDropOnDie()
    return false
	
end

do
	local ENT = {}
	ENT.Type = "anim"
	
	ENT.Model = Model( "models/Items/AR2_Grenade.mdl" )
	
	ENT.Sounds = {}
	ENT.Sounds["explode"]		= Sound("weapons/airboat/airboat_gun_lastshot2.wav")
	
	ENT.ModelScale = Vector(1, 0.7, 0.7)
	
	ENT.Speed = 768
	ENT.Disruption = 32

	function ENT:Think( )
		if CLIENT then return end
		
	end
		
	function ENT:Initialize()		
		self.Entity:PhysicsInit( SOLID_OBB )
		self.Entity:SetMoveType( MOVETYPE_FLY )
		self.Entity:SetSolid( SOLID_OBB )
        self.Entity:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self.Entity:DrawShadow( false )
		
		self:SetModel( self.Model )
		
		self:SetVelocity( self:GetAngles():Forward() * self.Speed )
		
		if SERVER then
			local effect = EffectData()
			effect:SetEntity( self )
			effect:SetStart( Vector(128, 192, 255) )
			effect:SetScale( 16 )
			util.Effect( "ha3_oocflare_effect_type1", effect )
			
			self.DisruptionAccumulator = Vector(0, 0, 0)
			
		end
		
		if CLIENT then
			self:SetModelScale( self.ModelScale )
			
		end
		
	end
	
	function ENT:Touch( ent )
		self:Remove()
		
	end
	
	function ENT:OnRemove( )
		if CLIENT then return end
		
		util.BlastDamage( self, self:GetOwner(), self:GetPos(), 32, 8 ) -- Last 2 : rad, dmg
		
		self:EmitSound( self.Sounds.explode, 100, math.random( 150, 200 ) )
	
	end
	
	function ENT:Drop()
		if self.Dropped then return end
		self.Dropped = true
		
		self.Entity:SetMoveType( MOVETYPE_FLYGRAVITY )
		for i=1,3 do
			local ent = ents.Create( "ha3_oocflare_entity_type2" )
			ent:SetAngles( (Vector(0,0,1) + VectorRand()):Angle() )
			ent:SetPos( self:GetPos() )
			ent:Spawn()
			ent:SetOwner( self:GetOwner() )
			
		end
	
	end
	
	function ENT:Draw()
		return true
		
	end
	
	scripted_ents.Register(ENT, "ha3_oocflare_entity_type1", true)

end

do
	local ENT = {}
	ENT.Type = "anim"
	
	ENT.Model = Model( "models/Items/AR2_Grenade.mdl" )
	
	ENT.Sounds = {}
	ENT.Sounds["explode"]		= Sound("weapons/airboat/airboat_gun_lastshot2.wav")
	
	ENT.ModelScale = Vector(1, 0.7, 0.7)
	
	ENT.Speed = 768
	ENT.Disruption = 32

	function ENT:Think( )
		if CLIENT then return end
		
	end
		
	function ENT:Initialize()
		self.Entity:PhysicsInit( SOLID_OBB )
		self.Entity:SetMoveType( MOVETYPE_FLYGRAVITY )
		self.Entity:SetSolid( SOLID_OBB )
        self.Entity:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self.Entity:DrawShadow( false )
		
		self:SetModel( self.Model )
		
		self:SetVelocity( self:GetAngles():Forward() * self.Speed )
		
		if SERVER then
			local effect = EffectData()
			effect:SetEntity( self )
			effect:SetStart( Vector(128, 192, 255) )
			effect:SetScale( 32 )
			util.Effect( "ha3_oocflare_effect_type2", effect )
			
			self.DisruptionAccumulator = Vector(0, 0, 0)
			
		end
		
		if CLIENT then
			self:SetModelScale( self.ModelScale )
			
		end
		
	end
	
	function ENT:Touch( ent )
		util.BlastDamage( self, self:GetOwner(), self:GetPos(), 16, 8 ) -- Last 2 : rad, dmg
		
		self:EmitSound( self.Sounds.explode, 100, math.random( 230, 255 ) )
		self:Remove()
		
	end
	
	function ENT:Draw()
		return true
		
	end
	
	scripted_ents.Register(ENT, "ha3_oocflare_entity_type2", true)

end

if CLIENT then
	local EFFECT = {}
	
	EFFECT.Dist    = 512^2
	EFFECT.DieDelay = 5
	EFFECT.MaxTravelData = 128
	
	EFFECT.RandomnessDistance = 64
	EFFECT.RB = Vector(1,1,1)*2048
	
	EFFECT.ThinkDelay = 0.05
	EFFECT.WhenNextThink = 0
	
	if CLIENT then
		EFFECT.Material = Material( "effects/yellowflare" )
		
	end
	
	function EFFECT:Init( data )
		local colVec = data:GetStart()
		self.Parent = data:GetEntity()
		self.Color  = Color( colVec.x, colVec.g, colVec.b )
		self.Width = data:GetScale()
		
		self.WillDie = false
		self.DieTime = 0
		self.DisappearTime = 0
		
		self.TravelSaturation = false
		
		self.TravelTable = {}
		self.RandomTable = {}
		
		self:SetRenderBounds( self.RB, -1 * self.RB )
		
	end
	
	function EFFECT:Think()
		if (CurTime() - self.WhenNextThink) < 0 then return true end
		self.WhenNextThink = CurTime() + self.ThinkDelay
		
		if self.WillDie and ( CurTime() - self.DisappearTime ) > 0 then
			return false
			
		end
		
		if not ValidEntity( self.Parent ) then
			if not self.WillDie then
				self.WillDie = true
				self.DieTime = CurTime()
				self.DisappearTime = self.DieTime + self.DieDelay
			
			end
		
		else
			self:SetPos( self.Parent:GetPos() )
			
			if not self.TravelTable[1] then
				self.TravelTable[1] = self.Parent:GetPos()
				self.RandomTable[1] = VectorRand()
				
			end
			
			local parentPos = self.Parent:GetPos()
			if (self.Parent:GetPos() - self.TravelTable[1]):LengthSqr() > 32 then
				table.insert( self.TravelTable, 1, parentPos )
				table.insert( self.RandomTable, 1, VectorRand() )
				
				if not self.TravelSaturation and (#self.TravelTable > self.MaxTravelData) then
					self.TravelSaturation = true
					
				end
				
				if self.TravelSaturation then
					table.remove( self.TravelTable, self.MaxTravelData )
					table.remove( self.RandomTable, self.MaxTravelData )
					
				end
				
			end
			
		end
		return true
		
	end
	
	function EFFECT:Render()
		local num = #self.TravelTable
		if num == 0 then return end
		
		render.SetMaterial( self.Material )
		
		self.Color.a = 255
		render.StartBeam( num )
		for n,pos in pairs( self.TravelTable ) do
			local demRatio = ((n - 1) / num)
			local demLight = (  1 + demRatio + ( self.WillDie and ((1 - demRatio) * (1 + (CurTime() - self.DisappearTime) / self.DieDelay) ) or 0 )  ) * 0.5
			render.AddBeam( pos + self.RandomTable[n] * demRatio * self.RandomnessDistance, self.Width * (1 - demRatio), demLight, self.Color )
			
		end
		render.EndBeam( num )
		
		if self.WillDie then
			local spell = 1 + (CurTime() - self.DisappearTime) / self.DieDelay
			local invSpellFast = (1 - spell)^10
			
			self.Color.a = (1 - spell) * 255
			render.DrawSprite( self.TravelTable[1], self.Width * 4, self.Width * 4, self.Color )
			self.Color.a = invSpellFast * 255
			render.DrawSprite( self.TravelTable[1], (1 - invSpellFast) * self.Width * 16, (1 - invSpellFast) * self.Width * 16, self.Color )
			
		end
		
		
	end
	
	effects.Register(EFFECT, "ha3_oocflare_effect_type1", true)

end


if CLIENT then
	local EFFECT = {}
	
	EFFECT.Dist    = 64^2
	EFFECT.DieDelay = 5
	EFFECT.MaxTravelData = 30
	
	EFFECT.RandomnessDistance = 32
	EFFECT.RB = Vector(1,1,1)*2048
	
	EFFECT.LifeTime = 10
	EFFECT.WhenNextThink = 0
	EFFECT.ThinkDelay = 0.05
	
	if CLIENT then
		EFFECT.Material = Material( "effects/yellowflare" )
		
	end
	
	function EFFECT:Init( data )
		local colVec = data:GetStart()
		self.Parent = data:GetEntity()
		self.Color  = Color( colVec.x, colVec.g, colVec.b )
		self.Width = data:GetScale()
		
		self.WillDie = false
		self.DieTime = 0
		self.DisappearTime = 0
		
		self.TravelSaturation = false
		self.BirthTime = CurTime()
		
		self.TravelTable = {}
		self.RandomTable = {}
		
		self:SetRenderBounds( self.RB, -1 * self.RB )
		
	end
	
	function EFFECT:Think()
		if (CurTime() - self.WhenNextThink) < 0 then return true end
		self.WhenNextThink = CurTime() + self.ThinkDelay
		
		if self.WillDie and ( CurTime() - self.DisappearTime ) > 0 then
			return false
			
		end
		
		if not ValidEntity( self.Parent ) then
			if not self.WillDie then
				self.WillDie = true
				self.DieTime = CurTime()
				self.DisappearTime = self.DieTime + self.DieDelay
			
			end
		
		elseif not self.TravelSaturation then
			self:SetPos( self.Parent:GetPos() )
			
			if not self.TravelTable[1] then
				self.TravelTable[1] = self.Parent:GetPos()
				self.RandomTable[1] = VectorRand()
				
			end
			
			local parentPos = self.Parent:GetPos()
			if (self.Parent:GetPos() - self.TravelTable[1]):LengthSqr() > 32 then
				table.insert( self.TravelTable, 1, parentPos )
				table.insert( self.RandomTable, 1, VectorRand() )
				
				if (#self.TravelTable > self.MaxTravelData) then
					self.TravelSaturation = true
					
				end
				
			end
			
		end
		return true
		
	end
	
	function EFFECT:Render()
		local num = #self.TravelTable
		if num == 0 then return end
		
		render.SetMaterial( self.Material )
		
		render.StartBeam( num )
		for n,pos in pairs( self.TravelTable ) do
			local demRatio = (n - 1) / num
			local demLight = 0.5 + 0.25 * demRatio /*- 0.5 * ((self.MaxTravelData - n - num ) / self.MaxTravelData)^10*/
			local evo = math.Clamp((CurTime() - self.BirthTime) / self.LifeTime, 0, 1)
			--demLight = (1 - evo^2) * demLight
			self.Color.a = 255 * ( self.WillDie and ( 1 - ((CurTime() - self.DisappearTime) / self.DieDelay) ) or 1 )
			render.AddBeam( pos + self.RandomTable[n] * evo * self.RandomnessDistance, self.Width * (1 - (1 - demRatio)^2), demLight, self.Color )
			
		end
		render.EndBeam( num )
		
		
	end
	
	effects.Register(EFFECT, "ha3_oocflare_effect_type2", true)

end