SWEP.PrintName       = "Stomp Rocketjump"            
SWEP.Slot            = 3
SWEP.SlotPos         = 1
SWEP.DrawAmmo        = false
SWEP.DrawCrosshair   = true
SWEP.Weight          = 5
SWEP.AutoSwitchTo    = false
SWEP.AutoSwitchFrom  = false
SWEP.Author          = ""
SWEP.Contact         = ""
SWEP.Purpose         = ""
SWEP.Instructions    = "Rocketjump and try to land on NPCs"
SWEP.ViewModel       = "models/weapons/v_rpg.mdl"
SWEP.WorldModel      = "models/weapons/w_rpg.mdl"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 0.75

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.HoldType = "rpg"

SWEP.OwnerLastVelocity     = 0
SWEP.OwnerLastGroundEntity = nil

SWEP.Stomp_MinVelocity = 32
SWEP.Stomp_MaxVelocity = 512
SWEP.Stomp_MinDamage = 10
SWEP.Stomp_MaxDamage = 300

local ShootSound = Sound( "npc/env_headcrabcanister/launch.wav" )

function SWEP:Reload()
end

function SWEP:Think()   
	local gEnt = self.Owner:GetGroundEntity()
	if gEnt ~= self.OwnerLastGroundEntity then
		if gEnt:IsNPC() then
			if self.OwnerLastVelocity > self.Stomp_MinVelocity then
				local ratio = (self.OwnerLastVelocity - self.Stomp_MinVelocity) / self.Stomp_MaxVelocity
				ratio = (damage < 1) and damage or 1
				local damage = self.Stomp_MinDamage + ratio * (self.Stomp_MaxDamage - self.Stomp_MinDamage)
				gEnt:TakeDamage( damage, self.Owner, self.Weapon )
				
				self.OwnerLastVelocityVector.z = math.abs(self.OwnerLastVelocityVector.z)
				self.Owner:SetVelocity( self.OwnerLastVelocityVector, 0 )
				
				
			end
			
		end
		self.OwnerLastGroundEntity = self.Owner:GetGroundEntity()
		
	end
	self.OwnerLastVelocityVector = self.Owner:GetVelocity()
	self.OwnerLastVelocity = self.OwnerLastVelocityVector:Length()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return false end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
    local effectdata = EffectData()
        effectdata:SetOrigin( self.Owner:GetPos() )
        effectdata:SetNormal( Vector(0,0,1) )
        effectdata:SetMagnitude( 8 )
        effectdata:SetScale( 1 )
        effectdata:SetRadius( 16 )
    util.Effect( "Sparks", effectdata )
    
    self:EmitSound( ShootSound )

    self:ShootEffects( self )
    
	local eyeAngles = self.Owner:EyeAngles()
	eyeAngles.p = eyeAngles.p + 90
	
	self.Owner:SetVelocity( eyeAngles * -500, 0 )
	return true
    
end

function SWEP:SecondaryAttack()
	return false
    
end

function SWEP:ShouldDropOnDie()
    return false
end

-- THIS THING WAS TAKEN FROM Kogitsune's Midas Cannon, I suppose
-- it was itself borrowed from Devenger code (since Kogitsune left a comment about him).

SWEP.Irons = {
    Normal = {
        Pos = Vector( -12.5, -4, 4.5 ),
        Ang = Vector( 0 )
    }
}

function SWEP:GetViewModelPosition( pos, ang )
    local b, r, u, f, n, x, y, z
    
    self.BobScale = 3
    self.SwayScale = 3
    
    r, u, f = ang:Right( ), ang:Up( ), ang:Forward( )
    
    x = self.Irons.Normal.Ang.x
    y = self.Irons.Normal.Ang.y
    z = self.Irons.Normal.Ang.z
    
    ang:RotateAroundAxis( r, x )
    ang:RotateAroundAxis( u, y )
    ang:RotateAroundAxis( f, z )
        
    r, u, f = ang:Right( ), ang:Up( ), ang:Forward( )
    
    x = self.Irons.Normal.Pos.x
    y = self.Irons.Normal.Pos.y
    z = self.Irons.Normal.Pos.z
        
    pos = pos + x * r
    pos = pos + y * f
    pos = pos + z * u
    
    return pos, ang
end