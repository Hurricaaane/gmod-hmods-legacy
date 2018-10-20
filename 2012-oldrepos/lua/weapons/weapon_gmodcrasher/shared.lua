// Test joke weapon, entire source code taken from Jimbomcb's Cannister SWEP

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.PrintName            = "Garry's Mod Crasher"            
SWEP.Slot           = 3
SWEP.SlotPos        = 1
SWEP.DrawAmmo       = false
SWEP.DrawCrosshair  = true
SWEP.Weight         = 5
SWEP.AutoSwitchTo   = true
SWEP.AutoSwitchFrom = true
SWEP.Author         = "Jimbomcb" // I (Ha3) modified part of the code to add the crasher but it's main code is Jimbomcb's
SWEP.Contact        = ""
SWEP.Purpose        = ""
SWEP.Instructions   = "Left click to crash Garry's Mod at your target.\nRight click to spawn a pre-crashed Garry's Mod.\n\nRequires a path to the sky."
SWEP.ViewModel             = "models/weapons/v_357.mdl"
SWEP.WorldModel            = "models/weapons/w_357.mdl"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

local ShootSoundFire = Sound( "Airboat.FireGunHeavy" )
local ShootSoundFail = Sound( "WallHealth.Deny" )
local YawIncrement = 20
local PitchIncrement = 10

if CLIENT then
    language.Add ("Undone_CrashLaunch", "Debugged Garry's Mod.")
end
 
function SWEP:Initialize()
	self.Process = {}
	
end
 
function SWEP:PrimaryAttack(bSecondary)
    local tr = self.Owner:GetEyeTrace()
    self:ShootEffects(self)
    
    if (SERVER) then 
        local aBaseAngle = tr.HitNormal:Angle()
        local aBasePos = tr.HitPos
        local bScanning = true
        local iPitch = 10
        local iYaw = -180
        local iLoopLimit = 0
        local iProcessedTotal = 0
        local tValidHits = {} 

        while (bScanning == true && iLoopLimit < 500) do
            iYaw = iYaw + YawIncrement
            iProcessedTotal = iProcessedTotal + 1        
            if (iYaw >= 180) then
                iYaw = -180
                iPitch = iPitch - PitchIncrement
            end
            
            local tLoop = util.QuickTrace( aBasePos, (aBaseAngle+Angle(iPitch,iYaw,0)):Forward()*40000 )
            if (tLoop.HitSky || bSecondary) then 
                table.insert(tValidHits,tLoop) 
            end
                
            if (iPitch <= -80) then
                bScanning = false
            end
            iLoopLimit = iLoopLimit + 1
        end
        
        local iHits = table.Count(tValidHits)
        if (iHits > 0) then
            local iRand = math.random(1,iHits) 
            local tRand = tValidHits[iRand]        
            
            local ent = ents.Create( "env_headcrabcanister" )
            ent:SetPos( aBasePos )
            ent:SetAngles( (tRand.HitPos-tRand.StartPos):Angle() )
            ent:SetKeyValue( "HeadcrabType", 0 )
            ent:SetKeyValue( "HeadcrabCount", 0 )
            ent:SetKeyValue( "FlightSpeed", math.random(2500,6000) )
            ent:SetKeyValue( "FlightTime", math.random(2,5) )
            ent:SetKeyValue( "Damage", math.random(50,90) )
            ent:SetKeyValue( "DamageRadius", math.random(300,512) )
            ent:SetKeyValue( "SmokeLifetime", math.random(5,10) )
            ent:SetKeyValue( "StartingHeight",  1000 )
            local iSpawnFlags = 8192
            if (bSecondary) then iSpawnFlags = iSpawnFlags + 4096 end //If Secondary, spawn impacted.
            ent:SetKeyValue( "spawnflags", iSpawnFlags )
            
            ent:Spawn()
            
            ent:Input("FireCanister", self.Owner, self.Owner)

            undo.Create("CrashLaunch")
                undo.AddEntity( ent )
                undo.SetPlayer( self.Owner )
            undo.Finish()
            self:EmitSound( ShootSoundFire )
			
			table.insert( self.Process, ent )
			
			ent:SetColor( 0, 0, 0, 1 )

        else
            self:EmitSound( ShootSoundFail )
        end
        tLoop = nil
        tValidHits = nil
    end
	
end


function SWEP:Think()
	while #self.Process > 0 do
		local ent = self.Process[1]
		if ValidEntity( ent ) then
			local crasher = ents.Create( "ha3_gmodcrash" )
			crasher:SetPos( ent:GetPos() )
			crasher:SetAngles( ent:GetAngles() )
			crasher:Spawn()
			crasher:SetParent( ent )
			
		end
		
		table.remove( self.Process, 1 )
		
	end
	
end

function SWEP:SecondaryAttack() self:PrimaryAttack(true) end

function SWEP:ShouldDropOnDie()
    return false
end

do
	local ENT = {}
	ENT.Type = "anim"
	
	ENT.Model = Model( "models/props_junk/PopCan01a.mdl" )
	
	ENT.ModelScale = Vector(1, 1, 1)
	ENT.RB = Vector(1, 1, 1) * 128

	function ENT:Initialize()
		self.Entity:SetMoveType( MOVETYPE_NONE )
		self.Entity:SetSolid( SOLID_NONE )
		self.Entity:DrawShadow( false )
		
		self:SetModel( self.Model )
		
		if CLIENT then			
			local randomness = math.random(0, 100) / 100
			self.SubModels = {}
			self.SubModels[1] = {
				ClientsideModel("gamemodes/ascension/content/models/ascension/objects/crate_01.mdl", RENDERGROUP_OPAQUE),
				Vector(200 - math.random(0,1) - randomness * 32, 0, -48),
				Angle(0, 90 + math.random(-5, 5) * randomness, 45 + math.random(-10, 10) * randomness),
				Vector(0.02, 7, 7),
				Color( 255, 255, 255 ),
				nil,
				math.random(0,3)
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
				mdldata[1]:SetSkin( mdldata[7] )
				
			end
			self:SetPos( angsav )
			self:SetAngles( possav )
			
			self.SubModelsInit = false
			
			self:SetModelScale( self.ModelScale )
			self:SetRenderBoundsWS( self.RB, -1 * self.RB )
			
		end
		
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
	
	function ENT:Think()
		if not ValidEntity( self:GetParent() ) then return end
		
		self:SetPos( self:GetParent():GetPos() )
		self:SetAngles( self:GetParent():GetAngles() )
		
	end
	
	scripted_ents.Register(ENT, "ha3_gmodcrash", true)

end











