SWEP.Category			= "BP :: Ha3"
SWEP.Author				= "Hurricaaane (Ha3)"
--SWEP.Contact			= ...
--SWEP.Purpose			= ...

if CLIENT then
	SWEP.PrintName			= "Rocket-Launcher (BP)"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 5
	SWEP.IconLetter			= "b"
	
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	
end

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "rpg"
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	--SWEP.Weight			= ...
	
end

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/v_bprpg.mdl"
SWEP.WorldModel			= "models/weapons/w_bprpg.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.TakeAmmo		= 1
SWEP.Primary.Sound			= nil
SWEP.Primary.Delay			= 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.TakeAmmo		= 1
SWEP.Secondary.Sound		= nil
SWEP.Secondary.Delay		= 0

function SWEP:Initialize() 
	--util.PrecacheSound( self.Primary.Sound )
	--util.PrecacheSound( self.Secondary.Sound )
	
	if ( SERVER ) then 
		self:SetWeaponHoldType( self.HoldType ) 
	end
	
end 


function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return false end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self:TakePrimaryAmmo( self.Primary.TakeAmmo )
	
	return true
end

function SWEP:SecondaryAttack()
	return false
	
end
