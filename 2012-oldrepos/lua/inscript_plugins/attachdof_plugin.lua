PLUGIN.Name = "Super DoF : Attachment"
PLUGIN.DefaultOn = false
PLUGIN.Description = [[Allows you to use Super DoF in tracking mode while playing (Use with Source Recorder for Machinima purposes).

To use it, check the Tracking Setup Mode, and while this is checked, a GUI opened, click on any entity with your cursor. Note that the location you click at counts : Focus will be based on this point on the entity.

You can leave Tracking enabled, as long as you don't click with your cursor on an entity, it will not change focus.]]
PLUGIN.Trigger = false


function PLUGIN:LoadParameters()
	self:AddParameter("rendermode", { Type = "checkbox", Defaults = "0", Text = "Render Mode" } )
	self:AddParameter("blursize", { Type = "slider", Defaults = "5", Min = "0", Max = "10", Decimals = "3", Text = "Blur Size" } )
	self:AddParameter("caplab", { Type = "label", Text = "Read the description for instructions." } )
	self:AddParameter("capturemode", { Type = "checkbox", Defaults = "0", Text = "Tracking Setup Mode (Replicated)" } )
	self:AddParameter("drawmode", { Type = "checkbox", Defaults = "0", Text = "Draw mode (Displays attachments)" } )
	self:AddParameter("attachment", { Type = "slider", Defaults = "0", Min = "0", Max = "20", Decimals = "0", Text = "Attachment ID" } )

	self:AddParameter("rm_radial", { Type = "slider", Defaults = "16", Min = "16", Max = "32", Decimals = "0", Text = "Render Mode : Radial Steps" } )
	self:AddParameter("rm_passes", { Type = "slider", Defaults = "6", Min = "6", Max = "12", Decimals = "0", Text = "Render Mode : Passes" } )
end

function PLUGIN:Load()
	self.texFSB = render.GetSuperFPTex()
	self.matFSB = Material( "pp/motionblur" )
	self.matFB	 = Material( "pp/fb" )
	
	self.GrabNow = false
	-- Don't reset it. It is saved through sessions.
	if not INSCRIPT_ATDDOF_EGLOBAL_SET then
		INSCRIPT_ATDDOF_EGLOBAL_TrackEnt  = nil
		INSCRIPT_ATDDOF_EGLOBAL_TrackScan = 0
		//INSCRIPT_ATDDOF_EGLOBAL_TrackRelativePos  = Vector(0,0,0)
		INSCRIPT_ATDDOF_EGLOBAL_TrackLastWorldPos = Vector(0,0,0)
		INSCRIPT_ATDDOF_EGLOBAL_SET = true
	end
	
end

local REDISH  = Color(255,0,0,255)
local WHITISH = Color(255,255,255,255)

function PLUGIN.HOOK:HUDPaint()
	if not (self:GetNumber("drawmode") > 0) then return end
	
	self:_CalcDistance( Vector(0,0,0) )
	local pos = INSCRIPT_ATDDOF_EGLOBAL_TrackLastWorldPos:ToScreen()
	draw.SimpleTextOutlined("x", "ScoreboardText", pos.x, pos.y, REDISH, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, WHITISH)
	
end

function PLUGIN:Unload()
	vgui.GetWorldPanel():MouseCapture( false )
end

function PLUGIN:_CalcDistance( origin )
	if ValidEntity( INSCRIPT_ATDDOF_EGLOBAL_TrackEnt ) then
		//INSCRIPT_ATDDOF_EGLOBAL_TrackLastWorldPos = INSCRIPT_ATDDOF_EGLOBAL_TrackEnt:LocalToWorld( INSCRIPT_ATDDOF_EGLOBAL_TrackRelativePos )
		local APB = INSCRIPT_ATDDOF_EGLOBAL_TrackEnt:GetAttachment( self:GetNumber("attachment") )
		if APB then
			//INSCRIPT_ATDDOF_EGLOBAL_TrackLastWorldPos = INSCRIPT_ATDDOF_EGLOBAL_TrackEnt:LocalToWorld(APB.Pos)
			INSCRIPT_ATDDOF_EGLOBAL_TrackLastWorldPos = APB.Pos
		end
		
	end
	
	return (origin - INSCRIPT_ATDDOF_EGLOBAL_TrackLastWorldPos):Length()
end

function PLUGIN.HOOK:Think()
	if not (self:GetNumber("capturemode") > 0) or not self.GrabNow then return end

	local trace = util.TraceLine( util.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetCursorAimVector() ) )
	if ValidEntity(trace.Entity) then	
		INSCRIPT_ATDDOF_EGLOBAL_TrackEnt = trace.Entity
		//INSCRIPT_ATDDOF_EGLOBAL_TrackRelativePos = INSCRIPT_ATDDOF_EGLOBAL_TrackEnt:WorldToLocal(trace.HitPos)
		//INSCRIPT_ATDDOF_EGLOBAL_TrackLastWorldPos = trace.HitPos
		
		print("Now tracking entity ".. INSCRIPT_ATDDOF_EGLOBAL_TrackEnt:EntIndex() .. " :: " .. INSCRIPT_ATDDOF_EGLOBAL_TrackEnt:GetClass() )
		
	end
end

function PLUGIN.HOOK:GUIMousePressed()
	if not (self:GetNumber("capturemode") > 0) then return end

	vgui.GetWorldPanel():MouseCapture( true )
	self.GrabNow = true
end

function PLUGIN.HOOK:GUIMouseReleased()
	if not (self:GetNumber("capturemode") > 0) then return end
	
	vgui.GetWorldPanel():MouseCapture( false )
	self.GrabNow = false
end

function PLUGIN:_RenderDoF( vOrigin, vAngle, vFocus, fAngleSize, radial_steps, passes, drawhud, bSpin )

	local OldRT 	= render.GetRenderTarget();
	local view 		= {  x = 0, y = 0, w = ScrW(), h = ScrH(), drawhud = drawhud }
	local fDistance = vOrigin:Distance( vFocus )
	
	fAngleSize = fAngleSize * math.Clamp( 256/fDistance, 0.1, 1 ) * 0.5
	
	view.origin = vOrigin
	view.angles = vAngle
	
	// Straight render (to act as a canvas)
	render.RenderView( view )
	render.UpdateScreenEffectTexture()
	
	render.SetRenderTarget( self.texFSB )
			self.matFB:SetMaterialFloat( "$alpha", 1  )
			render.SetMaterial( self.matFB )
			render.DrawScreenQuad()	
	
	local Radials = (math.pi*2) / radial_steps
	
	for mul=(1 / passes), 1, (1 / passes) do
	
		for i=0,(math.pi*2), Radials do
		
			local VA = vAngle * 1 // hack - this makes it copy the angles instead of the reference
			
			// Rotate around the focus point
			VA:RotateAroundAxis( vAngle:Right(), 	math.sin( i + (mul) ) * fAngleSize * mul )
			VA:RotateAroundAxis( vAngle:Up(), 		math.cos( i + (mul) ) * fAngleSize * mul )
			
			ViewOrigin = vFocus - VA:Forward() * fDistance
			
			view.origin = ViewOrigin
			view.angles = VA
			
			// Render to the front buffer
			render.SetRenderTarget( OldRT )
			render.Clear( 0, 0, 0, 255, true )
			render.RenderView( view )
			render.UpdateScreenEffectTexture()
			
			// Copy it to our floating point buffer at a reduced alpha
			render.SetRenderTarget( self.texFSB )
			local alpha = (Radials/(math.pi*2)) 		// Divide alpha by number of radials
			alpha = alpha * (1-mul)					// Reduce alpha the further away from center we are
			self.matFB:SetMaterialFloat( "$alpha", alpha  )
			

				render.SetMaterial( self.matFB )
				render.DrawScreenQuad()

			// We have to SPIN here to stop the Source engine running out of render queue space.
			if ( bSpin ) then
			
				// Restore RT
				render.SetRenderTarget( OldRT )
	
				// Render our result buffer to the screen
				self.matFSB:SetMaterialFloat( "$alpha", 1 )
				self.matFSB:SetMaterialTexture( "$basetexture", self.texFSB )
		
				render.SetMaterial( self.matFSB )
				render.DrawScreenQuad()
			
				render.Spin()
				
			end
		
		end
		
	end
	
	// Restore RT
	render.SetRenderTarget( OldRT )
	
	// Render our result buffer to the screen
	--self.matFSB:SetMaterialFloat( "$alpha", 1 )
	--self.matFSB:SetMaterialTexture( "$basetexture", self.texFSB )
		
	--render.SetMaterial( self.matFSB )
	--render.DrawScreenQuad()

end

function PLUGIN:_RenderSuperDoF( ViewOrigin, ViewAngles )

	local FocusPoint = ViewOrigin + ViewAngles:Forward() * self:_CalcDistance( ViewOrigin )
	local userender = self:GetNumber("rendermode") > 0

	self:_RenderDoF( ViewOrigin, ViewAngles, FocusPoint, self:GetNumber("blursize"), userender and self:GetNumber("rm_radial") or 2, userender and self:GetNumber("rm_passes") or 4, 1, userender )
	
	self.matFSB:SetMaterialFloat( "$alpha", 1 )
	self.matFSB:SetMaterialTexture( "$basetexture", self.texFSB )
	render.SetMaterial( self.matFSB )
	render.DrawScreenQuad()
	
end

function PLUGIN.HOOK:RenderScene( ViewOrigin, ViewAngles )
	--do return end
	if (self:GetNumber("drawmode") > 0) then return end
	if ( FrameTime() == 0 ) then return end -- If console is up, don't render
	
	self:_RenderSuperDoF( ViewOrigin, ViewAngles )
	return true

end
