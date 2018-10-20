PLUGIN.Name = "Difftrack : Attachment"
PLUGIN.DefaultOn = false
PLUGIN.Description = [[]]
PLUGIN.Trigger = false


function PLUGIN:LoadParameters()
	self:AddParameter("active", { Type = "checkbox", Defaults = "0", Text = "Track mode" } )
	self:AddParameter("caplab", { Type = "label", Text = "Read the description for instructions." } )
	self:AddParameter("capturemode", { Type = "checkbox", Defaults = "0", Text = "Tracking Setup Mode (Replicated)" } )
	self:AddParameter("drawmode", { Type = "checkbox", Defaults = "0", Text = "Draw mode (Displays attachments)" } )
	self:AddParameter("attachment", { Type = "slider", Defaults = "0", Min = "0", Max = "20", Decimals = "0", Text = "Attachment ID" } )
	self:AddParameter("pa", { Type = "slider", Defaults = "0", Min = "-180", Max = "180", Decimals = "0", Text = "Pitchadd" } )
	self:AddParameter("ya", { Type = "slider", Defaults = "0", Min = "-180", Max = "180", Decimals = "0", Text = "Yawadd" } )
	self:AddParameter("ra", { Type = "slider", Defaults = "0", Min = "-180", Max = "180", Decimals = "0", Text = "Rolladd" } )

end

function PLUGIN:Load()
	self.GrabNow = false
	if not INSCRIPT_DIFFTRAT_EGLOBAL_SET then
		INSCRIPT_DIFFTRAT_EGLOBAL_TrackEnt  = nil
		INSCRIPT_DIFFTRAT_EGLOBAL_TrackLastWorldPos = Vector(0,0,0)
		INSCRIPT_DIFFTRAT_EGLOBAL_SET = true
	end
	
end

function PLUGIN.HOOK:HUDPaint()
	if not (self:GetNumber("drawmode") > 0) then return end
	
	//self:_CalcDistance( Vector(0,0,0) )
	local pos = INSCRIPT_DIFFTRAT_EGLOBAL_TrackLastWorldPos:ToScreen()
	draw.SimpleTextOutlined("x", "ScoreboardText", pos.x, pos.y, REDISH, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, WHITISH)
	
end

function PLUGIN:Unload()
	vgui.GetWorldPanel():MouseCapture( false )
end

function PLUGIN.HOOK:Think()
	if not (not (self:GetNumber("capturemode") > 0) or not self.GrabNow) then
		
		local trace = util.TraceLine( util.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetCursorAimVector() ) )
		if ValidEntity(trace.Entity) then	
			INSCRIPT_DIFFTRAT_EGLOBAL_TrackEnt = trace.Entity
			
			print("Now tracking entity ".. INSCRIPT_DIFFTRAT_EGLOBAL_TrackEnt:EntIndex() .. " :: " .. INSCRIPT_DIFFTRAT_EGLOBAL_TrackEnt:GetClass() )
			
		end
	
	end
	
	if (self:GetNumber("active") > 0) then
		local ang = (self:GetPos() - LocalPlayer():EyePos()):Angle()
		ang.p = ang.p + self:GetNumber("pa")
		ang.y = ang.y + self:GetNumber("ya")
		ang.r = ang.r + self:GetNumber("ra")
		LocalPlayer():SetEyeAngles(ang)
		
		
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


function PLUGIN:GetPos()
	if ValidEntity( INSCRIPT_DIFFTRAT_EGLOBAL_TrackEnt ) then
		local APB = INSCRIPT_DIFFTRAT_EGLOBAL_TrackEnt:GetAttachment( self:GetNumber("attachment") )
		if APB then
			INSCRIPT_DIFFTRAT_EGLOBAL_TrackLastWorldPos = APB.Pos
		end
		
	end
	
	return INSCRIPT_DIFFTRAT_EGLOBAL_TrackLastWorldPos
	
end
