PLUGIN.Name = "When I'm Scripted Debug"
PLUGIN.DefaultOn = false
PLUGIN.Description = "Apple!!"
PLUGIN.Trigger = false


function PLUGIN:LoadParameters()
	self:AddParameter("invert",    { Type = "checkbox" , Text = "Invert", Defaults = "0" } )
end

function PLUGIN:Load()
	self.materials = {}
	self.materials.Black = CreateMaterial( "B__Black", "UnlitGeneric", { [ "$basetexture" ] = "vgui/black" } )
	self.materials.White = CreateMaterial( "B__White", "UnlitGeneric", { [ "$basetexture" ] = "lights/white" } )
	self.materials.Object = CreateMaterial( "B__LOGS", "UnlitGeneric", { [ "$basetexture" ] = "console/gmod_logo" } )
	
end

function PLUGIN:Unload()
end
 
function PLUGIN.HOOK:PostDrawOpaqueRenderables()
	local invert = self:GetNumber("invert") > 0

	cam.Start3D( EyePos(), EyeAngles() )
	pcall(function()
	 
		render.ClearStencil()
		render.SetStencilEnable( true )
	 
		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
		
		render.SetStencilReferenceValue( 1 )
		
		for _, ent in pairs( player.GetAll() ) do
			ent:DrawModel()
		end
		for _, ent in pairs( ents.FindByClass( "prop_*" ) ) do
			ent:DrawModel()
		end
		for _, ent in pairs( ents.FindByClass( "npc_*" ) ) do
			ent:DrawModel()
		end
		
		--render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		
		--render.SetMaterial( invert and self.materials.Black or self.materials.White )
		--render.DrawScreenQuad()
		
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NOTEQUAL )
		
		render.SetMaterial( self.materials.Object )
		--render.DrawScreenQuad()
		render.DrawQuadEasy( EyePos() + EyeAngles():Forward() * 256,    --position of the rect
			EyeAngles():Forward() * -1,        --direction to face in
			64 + ((CurTime() * 2) % 1) * 32, 64 + ((CurTime() * 2) % 1) * 32,
			Color( 255, 255, 255, 255 - ((CurTime() * 2) % 1) * 128 ),  --color
			-4 + ((CurTime() * 2) % 1) * 10 + 180
		)
		
		render.SetMaterial( invert and self.materials.White or self.materials.Black )
		render.DrawScreenQuad()
	 
		render.SetStencilEnable( false )
	end)
	cam.End3D()
	
end
