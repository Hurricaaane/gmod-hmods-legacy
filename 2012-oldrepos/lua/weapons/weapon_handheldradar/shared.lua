
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.PrintName       = "Handheld Radar"
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
SWEP.Instructions    = "Aim at stuff and their speed will show up."
SWEP.ViewModel       = "models/weapons/v_rpg.mdl"
SWEP.WorldModel      = "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.ClipSize       = 10
SWEP.Primary.DefaultClip    = 10
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "ha3_gban"
SWEP.Primary.Delay          = 0.7

SWEP.Secondary.ClipSize     = 10
SWEP.Secondary.DefaultClip  = 10
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay          = 0.4

SWEP.HoldType = "rpg"

SWEP.PingDelay = 0.2
SWEP.Distance  = 2048
SWEP.FOV = 75

SWEP.Color = Color( 128, 192, 255 )

if CLIENT then
	SWEP.Material = Material( "effects/yellowflare" )
	
end

function SWEP:Initialize()
	if SERVER then return end
	
	self.LastThink = 0
	self.Ents = {}
	
	self.Radius = math.tan( math.rad( self.FOV / 2 ) ) * self.Distance
	
end

function SWEP:LevybreakFindInConeFix(p1,p2,Radius) -- apex, base point, base radius
	local tbl = {}
	local dist = p1:Distance(p2)
	local v1 = p2-p1
	v1:Normalize()
	for k,v in ipairs(ents.GetAll()) do
		local v2 = v:GetPos()-p1
		v2:Normalize()
		if v1:Dot(v2) >= (math.atan2(Radius,dist)*2) then
			table.insert(tbl,v)
		end
	end
	return tbl
end

function SWEP:Think()
	if SERVER then return end
	
	if CurTime() < (self.LastThink + self.PingDelay) then return end
	self.LastThink = CurTime()
	
	self.Ents = ents.FindInSphere( self.Owner:GetShootPos(), self.Radius )
	
	local i = 1
	while #self.Ents >= i do
		local ent = self.Ents[ i ]
		
		if ValidEntity( ent ) and ( ent:IsNPC() or ent:IsPlayer() or string.find( ent:GetClass(), "prop" ) ) then
			i = i + 1
		
		else
			table.remove( self.Ents, i )
			
		end
		
	end
	
end

function SWEP:BeamCircle( vPos, vNormal, iRadius, iRes, fWidth, cColor )

	local angPar = 360 / iRes
	local normPar = vNormal:Angle():Up():Angle()
	
	render.StartBeam( iRes )
	for i = 1, iRes do
		render.AddBeam( vPos + normPar:Forward() * iRadius, fWidth, 0.375 + 0 * 0.125 * math.sin( math.pi * 2 * i / iRes + CurTime() * 0.2 ) , cColor )
		normPar:RotateAroundAxis( vNormal, angPar )
		
	
	end
	render.EndBeam( )
	
end

function SWEP:DrawHUD()
	render.SetMaterial( self.Material )
	for k,ent in pairs( self.Ents ) do
		print( ent )
		local pos = ent:GetPos()
		self:BeamCircle( ent:GetPos(), self.Owner:GetAimVector(), 48, 24, 16, self.Color )
		
	end
	
    return
	
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
