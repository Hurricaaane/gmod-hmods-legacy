if CLIENT then
	SWEP.PrintName			= "Dispell (IaMP)"			
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

SWEP.DispellSound = Sound( "touhou/generic_dispell.wav" )

function SWEP:ShouldShowSpellcardEffect()
	return false
end

function SWEP:DoSpellcard()
	self:_Dispell()
	return
end

function SWEP:Spell()
	--self:_Spark()
end

function SWEP:_Dispell()
	local shootPos = self.Owner:GetShootPos()

	local effectData = EffectData()
	effectData:SetOrigin( shootPos )
	effectData:SetNormal( self.Owner:GetAimVector() )
	self.Weapon:EmitSound( self.DispellSound )
	util.Effect("touhou_dispell_iamp", effectData, true, true)
	
	if SERVER then
		util.ScreenShake( shootPos + self.Owner:GetAimVector() * 256, 5, 5, 2.7, 1024 )
		util.ScreenShake( shootPos, 10, 10, 2.7, 128 )
		
		for _,ent in pairs( ents.FindInSphere( self.Owner:GetShootPos() , 256 ) ) do
			local physobj = ent:GetPhysicsObject()
			if physobj:IsValid() then
				physobj:ApplyForceCenter( (ent:LocalToWorld(physobj:GetMassCenter()) - shootPos):Normalize() * physobj:GetMass() * 800 )
			end
		end
	end
end
