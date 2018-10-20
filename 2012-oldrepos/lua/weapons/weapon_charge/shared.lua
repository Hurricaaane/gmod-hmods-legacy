
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false


SWEP.PrintName       = "Dash attack"            
SWEP.Slot            = 3
SWEP.SlotPos         = 10
SWEP.DrawAmmo        = false
SWEP.DrawCrosshair   = true
SWEP.Weight          = 5
SWEP.AutoSwitchTo    = false
SWEP.AutoSwitchFrom  = false
SWEP.Author          = ""
SWEP.Contact         = ""
SWEP.Purpose         = ""
SWEP.Instructions    = ""
SWEP.ViewModel       = "models/weapons/v_hands.mdl"
SWEP.WorldModel      = ""

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 0.75

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.HoldType = "ar2"

function SWEP:Deploy()
	self.LastAng  = self.Owner:EyeAngles()
	
end

function SWEP:Reload()
end

SWEP.MinSpeed = 400
SWEP.MaxSpeed = 800

SWEP.Damage = 80
SWEP.DamageExp = 2

SWEP.LastDamaged = 0
SWEP.DamageDelay = 0.1

SWEP.PrevSpeed = 0
SWEP.PrevVel = nil

function SWEP:Think()	
	if CLIENT then return end
	if CurTime() < (self.LastDamaged + self.DamageDelay) then return end
	
	if not ValidEntity( self.Owner ) then return end
	
	local velocityVect = self.Owner:GetVelocity()
	local speed = velocityVect:Length()
	
	local headPosVect = self.Owner:GetShootPos()
	
	local gEnt = self.Owner:TraceHullAttack( (headPosVect + self.Owner:GetPos()) * 0.5, (headPosVect + self.Owner:GetPos()) * 0.5 + velocityVect:Normalize() * 16, Vector( -18, -18, -18 ), Vector( 18, 18, 18 ), 0, DMG_GENERIC, 0 )
	
	if (self.PrevSpeed > self.MinSpeed) and (self.PrevVel ~= nil) && ((speed - self.PrevSpeed) < -10) and ValidEntity( gEnt ) then
		local gEntPhysObj = gEnt:GetPhysicsObject()
		if (gEntPhysObj ~= nil) && (gEntPhysObj:IsValid())
		then
			gEntPhysObj:ApplyForceCenter( self.PrevVel * gEntPhysObj:GetMass() * 0.5)
			local q = 100
			gEntPhysObj:AddAngleVelocity(Angle(math.random(-q,q),math.random(-q,q),math.random(-q,q))) 
			
		end
		
		
		local damage = self.PrevSpeed * 0.1
		damage = damage > 1 and 1 or damage
		
		damage = damage ^ self.DamageExp * self.Damage
		
		local dmgInfo = DamageInfo()
		dmgInfo:SetDamage( damage )
		---- Disabled : Does this cause damage filtering ?
		--dmgInfo:SetDamageType( DMG_CRUSH )
		dmgInfo:SetAttacker( self.Owner )
		dmgInfo:SetInflictor( self.Weapon )
		dmgInfo:SetDamageForce( self.PrevVel * 500 )
		dmgInfo:SetDamagePosition( headPosVect )
		
		gEnt:TakeDamageInfo( dmgInfo )
		self.LastDamaged = CurTime()
		
		print("BOOM!")
		
		self.Owner:SetVelocity( self.PrevVel * 0.5 )
		self:EmitSound("ha3weapons/00" .. math.random(1,2) .. ".wav", 100, math.random(90,110))
		
	end
	
	self.PrevSpeed = speed
	self.PrevVel = self.Owner:GetVelocity()
	
end

function SWEP:PrimaryAttack()
	if (self.Owner:GetVelocity():Length() > self.MaxSpeed) then
	return false end
	
	if (self.Owner:GetVelocity():Length() < 10) then return false end
	
	if (self.Owner:GetGroundEntity() == GetWorldEntity()) then
	self.Owner:SetVelocity( self.Owner:GetVelocity():Normalize() * self.MaxSpeed * 2 )
	
	else
	self.Owner:SetVelocity( self.Owner:EyeAngles():Forward() * self.MaxSpeed )
	
	
	end
	self:EmitSound("ha3weapons/043.wav", 100, math.random(90,110))
	local rant = math.Rand(15,20)
	local lorant = math.random(0,1) == 0
	self.Owner:ViewPunch( Angle( rant * 0.4, lorant and rant or -rant, lorant and 8 or -8 ) )
	return false
    
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
        Pos = Vector( 0, 8, 32 ),
        Ang = Vector( 180, 180, 0 )
    }
}

--[[
function SWEP:CalcView( ply, origin, ang, fov )
	if self.Lock then
		return origin, self.Lock, fov

	end
	
end
]]--

function SWEP:GetViewModelPosition( pos, ang )
	--[[if not self.Irons.Normal then
		self.Irons.Normal = {}
		self.Irons.Normal.Pos = self.Irons.Base.Pos * 1
		self.Irons.Normal.Ang = self.Irons.Base.Ang * 1
		
	end
	
	local velocityVect = self.Owner:GetVelocity()
	local speed = velocityVect:Length()
	local damage = (speed - self.MinSpeed) / (self.MaxSpeed - self.MaxSpeed)
	damage = damage > 1 and 1 or damage < 0 and 0 or damage
	self.Irons.Normal.Pos.z = self.Irons.Base.Pos.z + damage * 10
	self.Irons.Normal.Pos.y = self.Irons.Base.Pos.y + damage * -25
	self.Irons.Normal.Ang.x = self.Irons.Base.Ang.x + damage * -70]]--

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
