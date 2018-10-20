if CLIENT then
	SWEP.PrintName			= "Master Spark (SWR)"			
	SWEP.Author				= "Hurricaaane (Ha3)"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 5
	SWEP.IconLetter			= "b"
	
	killicon.AddFont( "weapon_toho_spark", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
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
SWEP.CooldownDelay = 3.0

SWEP.SparkSound = Sound("touhou/marisa_spark1.wav")

function SWEP:DoSpellcard()
	return
end

function SWEP:Spell()
	self:_Spark()
end

function SWEP:_Spark()
	local effectData = EffectData()
	effectData:SetOrigin( self.Owner:GetShootPos() )
	effectData:SetNormal( self.Owner:GetAimVector() )
	self.Weapon:EmitSound( self.SparkSound )
	util.Effect("touhou_masterspark_swr", effectData, true, true)
	
	if SERVER then
		util.ScreenShake( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 256, 5, 5, 2.7, 1024 )
		util.ScreenShake( self.Owner:GetShootPos(), 10, 10, 2.7, 128 )
	end
end
