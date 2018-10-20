PLUGIN.Name = "Display players"
PLUGIN.DefaultOn = false
PLUGIN.Description = "YESH"

function PLUGIN:LoadParameters()
	
end

function PLUGIN:Load()
	self.GrabEntity = nil
	self.DiscoverTime = 0
	self.LostTime = 0
	self.GotEntity = false
	
	self.WarmTime = 0.2
	self.CoolTime = 1
	self.LastParticle = 1
	self.ParticleTime = 1
	
end


local MaterialBlurX = Material( "pp/blurx" )
local MaterialBlurY = Material( "pp/blury" )
local MaterialWhite = CreateMaterial( "WhiteMaterial", "VertexLitGeneric", {
    ["$basetexture"] = "color/white",
    ["$vertexalpha"] = "1",
    ["$model"] = "1",
} )
local MaterialComposite = CreateMaterial( "CompositeMaterial", "UnlitGeneric", {
    ["$basetexture"] = "_rt_FullFrameFB",
    ["$additive"] = "1",
} )

local RT1 = GetRenderTarget( "L4D1" )
local RT2 = GetRenderTarget( "L4D2" )

function PLUGIN:Unload()
	
	
end
 
function PLUGIN:RenderToStencil( entities )
	render.SetStencilEnable( true )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilWriteMask( 1 )
	render.SetStencilReferenceValue( 1 )
	
	cam.IgnoreZ( true )
		render.SetBlend( 0 )
		SetMaterialOverride( MaterialWhite )
			for k,entity in pairs( entities ) do
				if ValidEntity( entity ) then
					entity:DrawModel()
					
				end
				
			end
		SetMaterialOverride()
		render.SetBlend( 1 )
	cam.IgnoreZ( false )
	
	render.SetStencilEnable( false )
	
end
 
function PLUGIN:RenderToGlowTexture( entities )	
	local w, h = ScrW(), ScrH()

	local oldRT = render.GetRenderTarget()
	render.SetRenderTarget( RT1 )
		render.SetViewPort( 0, 0, 512, 512 )
		cam.IgnoreZ( true )
			render.SuppressEngineLighting( true )
			local alpha = math.Clamp( self.GotEntity
			and ((CurTime() - self.DiscoverTime) / self.WarmTime)
			or (1 - ((CurTime() - self.LostTime) / self.CoolTime)), 0 , 1 )
			render.SetBlend( alpha )
				SetMaterialOverride( MaterialWhite )
				for k,entity in pairs( entities ) do
					if ValidEntity( entity ) then
						if entity:IsPlayer() && entity:Alive() then
							render.SetColorModulation( 1, 0.6, 0.6 )
							
						else
							render.SetColorModulation( 0.6, 0.6, 1 )
							
						end
						
						entity:DrawModel()
						
					end
					
				end
				SetMaterialOverride()
			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 1 )
			render.SuppressEngineLighting( false )
		cam.IgnoreZ( false )
		render.SetViewPort( 0, 0, w, h )
	render.SetRenderTarget( oldRT )
	
end

function PLUGIN.HOOK:RenderScene( Origin, Angles )
	local oldRT = render.GetRenderTarget()
	render.SetRenderTarget( RT1 )
	render.Clear( 0, 0, 0, 255, true )
	render.SetRenderTarget( oldRT )
	
end
 

function PLUGIN.HOOK:RenderScreenspaceEffects( )
	MaterialBlurX:SetMaterialTexture( "$basetexture", RT1 )
	MaterialBlurY:SetMaterialTexture( "$basetexture", RT2 )
	MaterialBlurX:SetMaterialFloat( "$size", 6 )
	MaterialBlurY:SetMaterialFloat( "$size", 6 )
	
	local oldRT = render.GetRenderTarget()
	
	render.SetRenderTarget( RT2 )
	render.SetMaterial( MaterialBlurX )
	render.DrawScreenQuad()

	render.SetRenderTarget( RT1 )
	render.SetMaterial( MaterialBlurY )
	render.DrawScreenQuad()
	render.SetRenderTarget( oldRT )
	
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilTestMask( 1 )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	
	MaterialComposite:SetMaterialTexture( "$basetexture", RT1 )
	render.SetMaterial( MaterialComposite )
	render.SetBlend( 0.1 )
	render.DrawScreenQuad()
	render.SetBlend( 1 )
	
	render.SetStencilEnable( false )
	
end

function PLUGIN.HOOK:PostDrawTranslucentRenderables( )
	local entities = player.GetAll()
	
	if( OUTLINING_ENTITY ) then return end
	OUTLINING_ENTITY = true
	
	self:RenderToStencil( entities )
	self:RenderToGlowTexture( entities )
	
	OUTLINING_ENTITY = false
	
end
