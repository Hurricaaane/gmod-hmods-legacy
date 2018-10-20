if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	
end

SWEP.Category			= "Dear Sistah"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/v_357.mdl"
SWEP.WorldModel			= "models/weapons/w_357.mdl"
SWEP.HoldType			= "pistol"

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true


function SWEP:GetPrimaryDelay()
	return 1
end

function SWEP:GetSecondaryDelay()
	return 0.15
end

function SWEP:Initialize() 
	
end 

function SWEP:ShootEffects()
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

end

local num_bullets = 1
local damage = 10000
local aimcone = 0

local iIter = 0
local bSlowing = false

function SISTAH_RemoveSlow( iRecv )
	
end

function SISTAH_EFFECT( time, self, cb )
	timer.Simple( time, function(mah, self) if SISTAH_CanEffect(mah) then
		cb( self )
		
	end end, iIter, self )
end

function SISTAH_BeginSlow( self )
	RunConsoleCommand( "host_timescale", 0.1 )
	self:EmitSound("ha3weapons/LOL_WATCHA_SAY.mp3")
	self:ConCommand("pp_motionblur 1")
	bSlowing = true
	
	iIter = iIter + 1
	local accel = 0.40
	local par = 0.07
	for i=0,30 do
		SISTAH_EFFECT( accel * (0.2*i + 0), self, function(self)
			if self then self:SetFOV( 60, accel*(0.1+par) ) end
		end)
		SISTAH_EFFECT( accel * (0.2*i + 0.1+par), self, function(self)
			if self then self:SetFOV( 75, accel*(0.1 - par) ) end
		end)
		
	end
	
	
	SISTAH_EFFECT( 1.05, self, function(self)
		RunConsoleCommand( "host_timescale", 1 )
		self:SetFOV( nil )
		self:ConCommand("pp_motionblur 0")
		bSlowing = false
	end)
	
end

function SISTAH_CanEffect( iRecv )
	return iRecv == iIter
	
end

function SWEP:PrimaryAttack()
	--if not self:CanPrimaryAttack() then return false end
	
	if SERVER then
		SISTAH_BeginSlow( self:GetOwner() )
		self:EmitSound("weapons/357/357_fire2.wav")
		self.Weapon:SetNextPrimaryFire( CurTime() + self:GetPrimaryDelay() )
		
		local bullet = {}
		bullet.Num 		= num_bullets
		bullet.Src 		= self.Owner:GetShootPos()
		bullet.Dir 		= self.Owner:GetAimVector()
		bullet.Spread 	= Vector( aimcone, aimcone, 0 )
		bullet.Tracer	= 1
		bullet.TracerName = "Tracer"
		bullet.Force	= 100
		bullet.Damage	= damage
		bullet.AmmoType = "Pistol"
	 
		self.Owner:FireBullets( bullet )
		self.Weapon:ShootEffects()
	end
	
	return true
end

function SWEP:SecondaryAttack()
	--if not self:CanSecondaryAttack() then return false end
	
	return false
end

function SWEP:Reload()

	return false
end

local resque = 0
local oor = Angle(0,0,0)
function SWEP:CalcView( ply, ori, ang, fov )
	if LocalPlayer():GetInfoNum( "pp_motionblur" ) ~= 1 then return ori, ang, fov end
	
	local rr = math.floor(CurTime() * 40)
	if resque ~= rr then
		resque = rr
		oor.r = math.random(-7, 7)
	end
	ang = ang + oor
	
	return ori, ang, fov
	
end

