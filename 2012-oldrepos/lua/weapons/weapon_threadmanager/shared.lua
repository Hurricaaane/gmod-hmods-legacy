
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false


SWEP.PrintName       = "Thread Manager"            
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

function SWEP:Think()	
	if CLIENT then return end
	
end

function SWEP:PrimaryAttack()
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

/*SWEP.Irons = {
    Normal = {
        Pos = Vector(-24.88, -13.115, 21.399),
        Ang = Vector(46.474, 2.868, -130)
    }
}

function SWEP:GetViewModelPosition( pos, ang )
    local b, r, u, f, n, x, y, z
    
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
	
end*/
