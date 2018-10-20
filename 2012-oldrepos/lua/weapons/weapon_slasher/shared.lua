-- totally not a ripoff from call of duty's laser pointer code

local DONT_GIVE_A_SHIT = false

local SLASHER_WeaponClassname = ClassName or "weapon_slasher"

SWEP.PrintName		= "LaserPuncture"
SWEP.Slot			= 3
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= true
SWEP.DrawCrosshair	= true
SWEP.Weight			= 5
SWEP.AutoSwitchTo	= false
SWEP.AutoSwitchFrom	= false
SWEP.Author			= "BlackOps"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"

SWEP.Spawnable		= true
SWEP.AdminSpawnable	= DONT_GIVE_A_SHIT

SWEP.HoldType				= "pistol"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			="none"
SWEP.Primary.Delay			= 0.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay			= 0.5

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Reload()
end

function SWEP:Think()	
end

//SWEP.TargetedEntity = nil

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if IsFirstTimePredicted() then
		local ison = self.Weapon:GetNWBool( "IsTargetOn", false )
		
		if (!ison) then
			local eyePos = self.Owner:EyePos()
			local tEnts = ents.FindInCone( self.Owner:EyePos(), self.Owner:EyeAngles():Forward(), 512, 64 )
			local eSel = nil
			local eLen = 512
			for k,ent in pairs( tEnts ) do
				local dist = ent:GetPos():Distance(eyePos)
				if dist < eLen then
					eSel = ent
					eLen = dist
					self.Weapon:SetNWBool( "IsTargetOn", true )
					
				end
				
			end
			
			self:SetDTEntity(0, eSel)
			
		end
		
	end
	
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	
	if IsFirstTimePredicted() then
		
		
	end
	
end

function SWEP:ShouldDropOnDie()
	return false
	
end

if CLIENT then
	local LaserDot = Material( "Sprites/light_glow02_add" )
	local LaserBeam = Material( "trails/laser" )
	local LaserColor = Color(255, 255, 255, 255)

	local function GetTracerShootPos( ply, ent, attach )
		if !IsValid( ent ) then return false end
		if !ent:IsWeapon() then return false end
		
		local pos = false
		local me = LocalPlayer()

		if ent:IsCarriedByLocalPlayer() and GetViewEntity() == me then	
			local ViewModel = me:GetViewModel()
			if IsValid( ViewModel ) then
				local att = ViewModel:GetAttachment( attach )
				if att then
					pos = att.Pos
				end
				
			end
			
		else
			local att = ent:GetAttachment( attach )
			if att then
				pos = att.Pos
				
			end
			
		end

		return pos
	end

	hook.Add( "RenderScreenspaceEffects", "IMAFIRINMAHLAZOR.RenderScreenspaceEffects", function()
		/*for k,v in ipairs( player.GetAll() ) do
			local weap = v:GetActiveWeapon()
			
			if IsValid( weap ) and weap:GetNWBool( "IsLaserOn", false ) then
				cam.Start3D( EyePos(), EyeAngles() )
					local colornum = weap:GetNWInt( "LaserColorNum", 1 )
					local shootpos = v:GetShootPos()
					local ang = v:GetAimVector()
					
					local tr = {}
					tr.start = shootpos
					tr.endpos = shootpos + ( ang * 999999 )
					tr.filter = v
					tr.mask = MASK_SHOT
					
					local trace = util.TraceLine( tr )
					local Size = 4 + ( math.random() * 10 )
					local beamstartpos = GetTracerShootPos( v, weap, 1 )
					local beamendpos = trace.HitPos
					
					if beamstartpos then
						local Distance = beamstartpos:Distance( beamendpos )
						render.SetMaterial( LaserBeam )
						render.DrawBeam( beamstartpos, beamendpos, 4, 1, 0, beamcolors[ colornum ] )
					end
					
					render.SetMaterial( LaserDot )
					render.DrawQuadEasy( beamendpos + trace.HitNormal * 0.5, trace.HitNormal, Size, Size, lasercolors[ colornum ], 0 )
					render.DrawQuadEasy( beamendpos + trace.HitNormal * 0.5, trace.HitNormal * -1, Size, Size, lasercolors[ colornum ], 0 )
					
				cam.End3D()
				
			end
			
		end*/
		
		local ply = LocalPlayer()
		local wepon = ply:GetActiveWeapon()
		if (wepon:GetClass() != SLASHER_WeaponClassname) then return end
		
		local TargetedEnt = ply:GetDTEntity( 0 )
		if not ValidEntity( TargetedEnt ) then return end
			
		cam.Start3D( EyePos(), EyeAngles() )
			local dist = EyePos():Distance( TargetedEnt:GetPos() )
			
			render.SetMaterial( LaserDot )
			render.DrawSprite( TargetedEnt:GetPos(), 64, 64, LaserColor )
			render.DrawSprite( EyePos() + LocalPlayer():EyeAngles():Forward() * dist, 16, 16, LaserColor )
			
		cam.End3D()
		
	end )

elseif SERVER then

end