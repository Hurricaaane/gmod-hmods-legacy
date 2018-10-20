ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName		= "Touhou Projector"

local shd_oDelay = CreateConVar("gm_sv_thprojo_delay", "8.72", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )

do
	ENT.Spawnable = false
	ENT.AdminSpawnable = true
	
end

local shd_MyClassName = ClassName or "gmod_badlamp"

local shd_modelProp = Model( "models/hunter/plates/plate1x1.mdl" )
local STATIC_DefaultTexture = "TODO"
local STATIC_Sequencer = 
{
	"BadAppleVertexAnim/badapple1",
	"BadAppleVertexAnim/badapple2",
	"BadAppleVertexAnim/badapple3",
	"BadAppleVertexAnim/badapple4",
	"BadAppleVertexAnim/badapple5",
	"BadAppleVertexAnim/badapple6",
	"BadAppleVertexAnim/badapple7",
	"BadAppleVertexAnim/badapple8",
	"BadAppleVertexAnim/badapple9",
	"BadAppleVertexAnim/badapple10",
	"BadAppleVertexAnim/badapple11",
	"BadAppleVertexAnim/badapple12",
	"BadAppleVertexAnim/badapple13",
	"BadAppleVertexAnim/badapple14",
	"BadAppleVertexAnim/badapple15",
	"BadAppleVertexAnim/badapple16",
	"BadAppleVertexAnim/badapple17",
	"BadAppleVertexAnim/badapple18",
	"BadAppleVertexAnim/badapple19",
	"BadAppleVertexAnim/badapple20",
	"BadAppleVertexAnim/badapple21",
	"BadAppleVertexAnim/badapple22",
	"BadAppleVertexAnim/badapple23",
	"BadAppleVertexAnim/badapple24",
	"BadAppleVertexAnim/badapple25"
}

if CLIENT then
	STATIC_DefaultTexture = Material( STATIC_DefaultTexture ) // TODO
	
	for i=1,#STATIC_Sequencer do
		STATIC_Sequencer[i] = Material( STATIC_Sequencer[i] )
		
	end
	
end

///

function ENT:Initialize()
	if SERVER then
		self:SetModel( shd_modelProp )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
		self.iNextSequenceUpdate = 0
		self.iCurrentSequence = 0
		self.bIsOn = false
		
		self:SetOn( true )
		
	end
	
end

function ENT:SpawnFunction( ply, tr )
	if not tr.Hit then return end

	local vSpawnPos = tr.HitPos + tr.HitNormal * 32

	local ent = ents.Create( shd_MyClassName )
	if not ValidEntity( ent ) then return end
	
	ent:SetPos( vSpawnPos )
	ent:Spawn()
	ent:Activate()
	
	local physObj = ent:GetPhysicsObject()
	if physObj:IsValid() then
		physObj:Wake()
		
	end

	return ent

end

///

function ENT:SetOn( _in_ )
	if _in_ and not self.bIsOn then
		local fUpdateTime = CurTime() + 8.72 - CurTime() % 8.72
		self:SetDTInt( 0, fUpdateTime )
		self.bIsOn = true
		self.iNextSequenceUpdate = fUpdateTime
		self.iCurrentSequence = 0
		//self:UpdateEvent()
		
	elseif not _in_ and self.bIsOn then
		self:SetDTInt( 0, 0 )
		self.bIsOn = false
		self.iNextSequenceUpdate = 0
		self.iCurrentSequence = 0
		self:UpdateEvent()
		
	end
	
end

function ENT:GetTime()
	return self:GetDTInt( 0 )
	
end

function ENT:GetOn()
	return self:GetDTInt( 0 ) ~= 0
	
end

function ENT:SetLightColor( r, g, b )
	self:SetVar( "lightr", r )
	self:SetVar( "lightg", g )
	self:SetVar( "lightb", b )
	
	self:SetColor( r, g, b, 255 )
	
	self.m_strLightColor = Format( "%i %i %i", r, g, b )
	
	/*if ( self.flashlight ) then
		self.flashlight:SetKeyValue( "lightcolor", self.m_strLightColor )
		
	end*/
	
end

function ENT:SetFlashlightTexture( tex )
	self:SetMaterial( tex )
	/*if ( self.flashlight ) then
		self.flashlight:Input( "SpotlightTexture", NULL, NULL, tex )
		
	end*/
	
end

function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
	
end

function ENT:Use( activator, caller )
	
end

function ENT:UpdateEvent( iSequence )
	if not self.bIsOn then
		/*if self.flashlight then
			SafeRemoveEntity( self.flashlight )
			self.flashlight = nil
			
		end*/
		return
		
	end
	
	-- exclusive-implies if self.bIsOn then do the following:
	/*if not self.flashlight then
		local angForward = self:GetAngles() + Angle( 90, 0, 0 )
		self.flashlight = ents.Create( "env_projectedtexture" )
		
			self.flashlight:SetParent( self.Entity )
			
			-- The local positions are the offsets from parent..
			self.flashlight:SetLocalPos( Vector( 0, 0, 0 ) )
			self.flashlight:SetLocalAngles( Angle(90,90,90) )
			
			-- Looks like only one flashlight can have shadows enabled!
			self.flashlight:SetKeyValue( "enableshadows", 1 )
			self.flashlight:SetKeyValue( "farz", 2048 )
			self.flashlight:SetKeyValue( "nearz", 8 )
			
			-- Todo: Make this tweakable?
			self.flashlight:SetKeyValue( "lightfov", 50 )
			
			-- Color.. Bright pink if none defined to alert us to error
			self.flashlight:SetKeyValue( "lightcolor", self.m_strLightColor or "255 0 255" )
			
			
		self.flashlight:Spawn()
		
	end*/
	
	if iSequence and not (iSequence < 1 or iSequence > #STATIC_Sequencer) then
		self:SetFlashlightTexture( STATIC_Sequencer[iSequence] )
		
	else
		self.iCurrentSequence = 1
		self:UpdateEvent( self.iCurrentSequence )
		//self:SetFlashlightTexture( STATIC_DefaultTexture ) // TODO
		
	end
	
end

function ENT:Think()
	if not self.bIsOn then return end
	
	if CurTime() > self.iNextSequenceUpdate then
		self.iCurrentSequence = self.iCurrentSequence + 1
		self:UpdateEvent( self.iCurrentSequence )
		
		self.iNextSequenceUpdate = self.iNextSequenceUpdate + shd_oDelay:GetFloat() // TODO : Check 8.8
		
	end
	
	
	
end

/// CLI
if CLIENT then
	ENT.RenderGroup 	= RENDERGROUP_BOTH
	
	//local cli_matLight = Material( "sprites/light_ignorez" )
	
	function ENT:Draw()
		//self.BaseClass.Draw( self )
		self:DrawModel()
		
	end
	
	function ENT:DrawTranslucent()
		self:Draw()
		
	end
	
	/*function ENT:GetOverlayText()
		return self:GetPlayerName()
		
	end*/
	
end
