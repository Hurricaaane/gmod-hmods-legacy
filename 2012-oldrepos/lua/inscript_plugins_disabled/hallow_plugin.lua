//  Filename must end with the suffix "_plugin.lua" .

PLUGIN.Name = "Hallow"
PLUGIN.DefaultOn = false
PLUGIN.Description = "Does stuff."
PLUGIN.Trigger = false


function PLUGIN:LoadParameters()
	--self:AddParameter("arrange",    { Type = "checkbox" , Text = "Arrange stuff constantly", Defaults = "0" } )
	--self:AddParameter("name_label", { Type = "label"    , Text = "Stuff name :" } )
	--self:AddParameter("name",       { Type = "textentry", Defaults = "Default contents." } )
	--self:AddParameter("max",        { Type = "slider"   , Text = "Maximum stuff allowed.", Defaults = "30", Min = "1", Max = "60", Decimals = "0" } )
	--self:AddParameter("doarrange",  { Type = "button"   , Text = "Rearrange Stuff now", DoClick = function() self:_Rearrange() end } )
end

function PLUGIN:Load()
	self.Mat = Material( "effects/yellowflare" )
	
	self.materials = {}
	self.materials.Black = CreateMaterial( "B__Black", "UnlitGeneric", { [ "$basetexture" ] = "vgui/black" } )
	self.materials.White = CreateMaterial( "B__White", "UnlitGeneric", { [ "$basetexture" ] = "lights/white" } )
	
	self._scale = Vector(1.1, 1.1, 1.1)
	self._normal = Vector(1, 1, 1)
	
end

function PLUGIN:Unload()
end

function PLUGIN:BlackAndWhite( fAmount )
	local tColorData = {} 
	
 	tColorData["$pp_colour_brightness"] = 0
 	tColorData["$pp_colour_contrast"] 	= 1
 	tColorData["$pp_colour_colour"] 	= 0
 	tColorData["$pp_colour_mulr"] 		= 0
 	tColorData["$pp_colour_mulg"] 		= 0
 	tColorData["$pp_colour_mulb"] 		= 0
 	tColorData["$pp_colour_addr"] 		= 0
 	tColorData["$pp_colour_addg"] 		= 0
 	tColorData["$pp_colour_addb"] 		= 0
 	 
 	DrawColorModify( tColorData )
	
end

function PLUGIN:RenderScreenspaceEffects()
	self:BlackAndWhite()
	
end
 
function PLUGIN.HOOK:PostDrawOpaqueRenderables()
	cam.Start3D( EyePos(), EyeAngles() )
 
	render.SetMaterial( self.Mat )
	// First we clear the stencil and enable the stencil buffer
	render.ClearStencil()
	render.SetStencilEnable( true )
 
	// First we set every pixel with the prop + outline to 1
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilReferenceValue( 1 )
	
	self._players = player.GetAll()
	for _, ent in pairs( self._players ) do
		if ValidEntity( ent ) and ent:Alive() then
			ent:DrawModel()
		end
		
	end
	--render.ClearBuffersObeyStencil()
	render.SetStencilReferenceValue( 0 )
	
	/*for _, ent in pairs( self._players ) do
		if ValidEntity( ent ) then
			render.DrawSprite( ent:GetPos() + Vector(0,0,32), 64, 64, Color(255, 0, 0, 255) )
		end
		
	end*/
	
	// Now we only draw the pixels with a value of 1 black, which are the pixels with only the outline
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	
	render.SetMaterial( self.materials.White )
	render.DrawScreenQuad()
 
	// Disable the stencil buffer again
	render.SetStencilEnable( false )
	
	cam.End3D()
	
end
