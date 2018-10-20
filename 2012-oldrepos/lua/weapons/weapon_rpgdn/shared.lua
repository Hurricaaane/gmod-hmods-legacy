// NOTE :
//    Please forgive me if this SWEP is
//  against "external content" rule.
//    Since SWEPS like the Rick Roll SWEP went through,
//  I thought it wouldn't mind to showcase that concept.

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.PrintName       = "Duke Nukem 3D RPG"
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
SWEP.Instructions    = "Duke Nukem 3D RPG"
SWEP.ViewModel       = "models/weapons/v_rpg.mdl"
SWEP.WorldModel      = "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.ClipSize       = 10
SWEP.Primary.DefaultClip    = 10
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "dn_rpg"
SWEP.Primary.Delay          = 0.8

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.HoldType = "rpg"

SWEP.OwnerLastVelocity     = 0
SWEP.OwnerLastGroundEntity = nil

do
	SWEP.Sounds = {}
	SWEP.Sounds["deploy"]		= Sound("dn_wpnsel.wav")
	SWEP.Sounds["fire"]			= Sound("dn_rpgfire.wav")
	
end

if CLIENT then
	SWEP.Material				= Material( "dn_rpg" )
	SWEP.SurfaceID				= surface.GetTextureID("dn_rpg")
	
end

function SWEP:Initialize()
	
end

function SWEP:Deploy()
	self:EmitSound( self.Sounds.deploy )
	
	if SERVER then return end

end


function SWEP:Holster()
	if SERVER then return true end
	
	local vm = self.Owner:GetViewModel()
	if vm then
		vm:SetColor( 255, 255, 255, 255 )
		
	end
	
end

function SWEP:OnRemove()
	if not ValidEntity( self.Owner ) or not self.Owner.GetViewModel then return end 
	
	local vm = self.Owner:GetViewModel()
	if vm then
		vm:SetColor( 255, 255, 255, 255 )
		
	end
	
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return false end
	
	if SERVER then
		self:EmitSound( self.Sounds.fire )
		
		local ent = ents.Create( "dn_rpgmissile" )
		local ang = self.Owner:GetAimVector():Angle()
		ent:SetPos( self.Owner:GetShootPos() + ang:Right() * 6 + ang:Up() * -4 )
		ent:SetAngles( ang )
		ent:Spawn()
		
		ent:SetOwner( self.Owner )
		
	end
	
	self:ShootEffects()
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
    return true
    
end

function SWEP:SecondaryAttack()
    return false
    
end

function SWEP:ShouldDropOnDie()
    return false
	
end

function SWEP:ViewModelDrawn()
	local vm = self.Owner:GetViewModel()
	if not vm then return end
	
	vm:SetColor( 0, 0, 0, 1 )
	
	local attach = vm:GetAttachment( 1 )
	if not attach then return end
	
	local color = render.GetLightColor( LocalPlayer():GetShootPos() )
	local pos = (attach.Pos):ToScreen()
	--pos.x = pos.x / ScrW() - 0.5
	--pos.y = pos.y / ScrH() - 0.5
	
	/*
	surface.SetDrawColor( color )
	surface.SetTexture( self.SurfaceID )
	surface.DrawTexturedRectRotated( pos.x, pos.y, ScrH(), ScrH(), 0 )
	surface.DrawRect( pos.x - 16, pos.y - 16, 32, 32, 0 )
	*/
	
	local rat = math.Clamp( 1 - (self:GetNextPrimaryFire() - CurTime()) / self.Primary.Delay, 0, 1 ) * 32
	
	render.SetMaterial( self.Material )
	render.DrawSprite( attach.Pos + attach.Ang:Forward() * rat + attach.Ang:Up() * -16, ScrH() / 6, ScrH() / 6, color )
	
	return false
	
end

do
	local ENT = {}
	ENT.Type = "anim"
	
	ENT.Model = Model( "models/Weapons/W_missile_launch.mdl" )
	
	ENT.Sounds = {}
	ENT.Sounds["explode"]		= Sound("dn_explode.wav")
	ENT.Sounds["squish"]		= Sound("dn_squish.wav")
	
	ENT.ModelScale = Vector(1, 0.7, 0.7)

	function ENT:Initialize()
		self.Entity:PhysicsInit( SOLID_OBB )
		self.Entity:SetMoveType( MOVETYPE_FLY )
		self.Entity:SetSolid( SOLID_OBB )
        self.Entity:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self.Entity:DrawShadow( false )
		
		self:SetModel( self.Model )
		
		-- util.Effect()
		
		self:SetVelocity( self:GetAngles():Forward() * 768 )
		
		if CLIENT then			
			self.SubModels = {}
			self.SubModels[1] = {
				ClientsideModel("models/props_c17/playgroundTick-tack-toe_block01a.mdl", RENDERGROUP_OPAQUE),
				Vector(-3, 0, 0),
				Angle(90, 180, 0),
				Vector(1, 0.1, 1) * 0.4,
				Color( 255, 0, 0 ),
				Material( "lights/white" )
			}
			self.SubModels[2] = {
				ClientsideModel("models/props_c17/playgroundTick-tack-toe_block01a.mdl", RENDERGROUP_OPAQUE),
				Vector(-3, 0, 0),
				Angle(0, 90, -90),
				Vector(1, 0.1, 1) * 0.4,
				Color( 255, 0, 0 ),
				Material( "lights/white" )
			}
			self.SubModels[3] = {
				ClientsideModel("models/Weapons/AR2_grenade.mdl" , RENDERGROUP_OPAQUE),
				Vector(-6, 0, 0),
				Angle(0, 0, 0),
				Vector(1.4, 2, 2) * 0.7,
				Color( 255, 240, 48 ),
				Material( "lights/white" )
			}
			self.SubModels[4] = {
				ClientsideModel("models/Weapons/AR2_grenade.mdl" , RENDERGROUP_OPAQUE),
				Vector(-5, 0, 0),
				Angle(0, 0, 0),
				Vector(1.2, 2.5, 2.5) * 0.7,
				Color( 255, 255, 255 ),
				Material( "models/props_pipes/pipeset_metal02" )
			}
			
			-- This is hacky
			local angsav = self:GetAngles()
			local possav = self:GetPos()
			self:SetPos( Vector(0) )
			self:SetAngles( Angle(0) )
			for k,mdldata in pairs( self.SubModels ) do
				mdldata[1]:SetPos( mdldata[2] )
				mdldata[1]:SetAngles( mdldata[3])
				mdldata[1]:SetParent( self )
							
				mdldata[1]:SetModelScale( mdldata[4] )
				mdldata[1]:DrawShadow( false )
				mdldata[1]:SetColor( mdldata[5] )
				
			end
			self:SetPos( angsav )
			self:SetAngles( possav )
			
			self.SubModelsInit = false
			
			self:SetModelScale( self.ModelScale )
			
		end
		
	end
	
	function ENT:Touch( ent )
		util.BlastDamage( self, self:GetOwner(), self:GetPos(), 256, 128 ) -- Last 2 : rad, dmg
		for k,ent in pairs( ents.FindInSphere( self:GetPos(), 128 ) ) do
			if ent:IsNPC() or ent:IsPlayer() then
				ent:EmitSound( self.Sounds.squish )
				
			end
			
		end
		
		local effect = EffectData()
		effect:SetOrigin( self:GetPos() )
		util.Effect( "HelicopterMegaBomb", effect )
		
		self:EmitSound( self.Sounds.explode )
		self:Remove()
		
	end
	
	function ENT:Draw()
		if not self.SubModels then return end
		
		if not self.SubModelsInit then
			for k,mdldata in pairs( self.SubModels ) do
				mdldata[5].r = mdldata[5].r / 255
				mdldata[5].g = mdldata[5].g / 255
				mdldata[5].b = mdldata[5].b / 255
				
			end
			self.SubModelsInit = true
			
		end
		
		render.SetBlend( 1 )
		for k,mdldata in pairs( self.SubModels ) do		
			render.SetColorModulation( mdldata[5].r, mdldata[5].g, mdldata[5].b )
			if mdldata[6] then SetMaterialOverride( mdldata[6] ) end
			mdldata[1]:DrawModel()
			SetMaterialOverride( 0 )
			render.SetColorModulation( 1, 1, 1 )
			
		end
		
		self:DrawModel()
		return true
		
	end
	
	scripted_ents.Register(ENT, "dn_rpgmissile", true)

end

if SERVER and false then
	hook.Remove("OnDamagedByExplosion", "DN_EXPLO")
	hook.Add("OnDamagedByExplosion", "DN_EXPLO", function (ent, dmginfo)
		if dmginfo:GetInflictor():GetClass() == "dn_rpgmissile" and dmginfo:GetDamage() > 64 
			and ( ent:IsNPC() or ent:IsPlayer() ) then
			WorldSound( self.Sounds.squish, ent:GetPos() )
			
		end
	 
	end)

end
