
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false


SWEP.PrintName       = "Motion Crowbar"            
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
SWEP.Instructions    = "<<<>>>"
SWEP.ViewModel       = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel      = "models/weapons/w_crowbar.mdl"

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
	// (!) Client and server have different values.
	// - Client simulates viewmodel.
	// - Server calculates damage.
	
	if not self.LastAng then
		self.LastAng = self.Owner:EyeAngles()
	end
	local thisAng = self.Owner:EyeAngles()
	
	local smooth = math.Clamp( FrameTime() / 0.03, 0, 1 )
	
	local xDiff = math.AngleDifference( self.LastAng.y, thisAng.y )
	local yDiff = math.AngleDifference( self.LastAng.p, thisAng.p )
	local power = (xDiff^2 + yDiff^2) * smooth
	if power > 0 then print( xDiff, yDiff ) end
	
	if CLIENT then
		local pos = self.Irons.Normal.Pos
		local ang = self.Irons.Normal.Ang
		
		ang.z = ang.z * 0.95
		
		local xDiffs = math.Clamp( math.abs(xDiff) * smooth * 0.05, 0, 1 )
		if xDiff < 0 then 
			ang.z = ang.z + xDiffs * (90 - ang.z)
		else
			ang.z = ang.z + xDiffs * (-90 - ang.z)
		
		end
		
		if self.Owner:KeyPressed( IN_ATTACK ) then
			self.Lock = self.Owner:EyeAngles()
			
		elseif self.Owner:KeyReleased( IN_ATTACK ) then
			self.Lock = nil
			
		end
		
	end
	
	self.LastAng = thisAng
	
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

SWEP.Irons = {
    Normal = {
        Pos = Vector( 0 ),
        Ang = Vector( 0 )
    }
}


function SWEP:CalcView( ply, origin, ang, fov )
	if self.Lock then
		return origin, self.Lock, fov

	end
	
end

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
