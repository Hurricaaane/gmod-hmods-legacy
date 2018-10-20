if CLIENT then
	SWEP.PrintName			= "Toho Base SWEP"			
	SWEP.Author				= "Hurricaaane (Ha3)"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 5
	SWEP.IconLetter			= "b"
	
end

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	
end

SWEP.Category			= "Touhou :: Ha3"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"
SWEP.HoldType			= "ar2"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true

SWEP.SpellcardSound = Sound("touhou/generic_spellcard.wav")
SWEP.AttackDelay = 0.5
SWEP.CooldownDelay = 1

SWEP._IsAttacking = false
SWEP._AttackTime  = 0

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return false end
	self._IsAttacking = true
	self._AttackTime = CurTime()
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.CooldownDelay )
	
	if self.ShouldShowSpellcardEffect and self:ShouldShowSpellcardEffect() then
		self:_Spellcard()
	end
	
	if self.DoSpellcard then
		self:DoSpellcard()
	end
	
	return true
end

function SWEP:ShouldShowSpellcardEffect()
	return true
end

function SWEP:_Spellcard()
	local effectData = EffectData()
	effectData:SetOrigin( self.Owner:GetShootPos() )
	effectData:SetNormal( self.Owner:GetAimVector() )
	self.Weapon:EmitSound( self.SpellcardSound )
	util.Effect("touhou_spellcard", effectData, true, true)
	if SERVER then
		util.ScreenShake( self.Owner:GetShootPos(), 3, 5, 0.5, 256 )
	end
end

function SWEP:Think()
	if self._IsAttacking and (CurTime() > (self._AttackTime + self.AttackDelay)) then
		self._IsAttacking = false
		self:Spell()
	end
end

function SWEP:Spell()
	
end
