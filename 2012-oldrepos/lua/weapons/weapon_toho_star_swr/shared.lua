if CLIENT then
	SWEP.PrintName			= "Stars (SWR)"			
	SWEP.Author				= "Hurricaaane (Ha3)"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 5
	SWEP.IconLetter			= "b"
	
end

if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end


SWEP.Base				= "weapon_toho_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

do
	SWEP.ViewModel			= "models/weapons/v_crowbar.mdl"
	SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"
	SWEP.HoldType			= "ar2"

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
end

do
	SWEP.Primary.ClipSize		= 100
	SWEP.Primary.DefaultClip	= 100
	SWEP.Primary.Automatic		= true
	SWEP.Primary.Ammo			= "spark"

	--SWEP.Secondary.Automatic	= false
	--SWEP.Secondary.Ammo		= "none"
end

SWEP.AttackDelay = 0.8
SWEP.CooldownDelay = 0.8

SWEP.AttackSound = Sound("touhou/marisa_staremit1.wav")

function SWEP:DoSpellcard()
	return
end

function SWEP:Spell()
	self:_Stars()
end

function SWEP:_Stars()
	local effectData = EffectData()
	effectData:SetOrigin( self.Owner:GetShootPos() )
	effectData:SetNormal( self.Owner:GetAimVector() )
	self.Weapon:EmitSound( self.AttackSound )
	util.Effect("touhou_star_swr", effectData, true, true)
	
	if SERVER then
		util.ScreenShake( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 256, 5, 5, 2.7, 1024 )
		util.ScreenShake( self.Owner:GetShootPos(), 10, 10, 2.7, 128 )
	end
end
