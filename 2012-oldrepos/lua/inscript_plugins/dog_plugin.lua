//  Filename must end with the suffix "_plugin.lua" .

PLUGIN.Name = "D0G"
PLUGIN.DefaultOn = false
PLUGIN.Description = "Does stuff."
PLUGIN.Trigger = false


function PLUGIN:LoadParameters()
end

function PLUGIN:Load()
	--sharpeye_focus = {}
	--sharpeye_focus.IsEnabled = function() return true end
	--sharpeye_focus.AppendCalcView = function( view ) return self.CalcViewIntermed( view ) end
	self.DidOverride = false
	self.FoundEnt = false
	
	timer.Simple( 0, self.HookIt, self )
	
end

function PLUGIN:HookIt()
	if sharpeye and not self.DidOverride then
		self.DidOverride = true
		
		self.OriginalComp = sharpeye.ProcessCompatibleCalcView
		sharpeye.ProcessCompatibleCalcView = function( ... ) self:CalcViewIntermed( ... ) end
		self.OriginalMeasure = sharpeye.GetMeasureEntity
		sharpeye.GetMeasureEntity = function( ... ) return self:Measure( ... ) end
	end
	
end

function PLUGIN:UnhookIt()
	if sharpeye and self.DidOverride then
		self.DidOverride = false
		
		sharpeye.ProcessCompatibleCalcView = self.OriginalComp
		sharpeye.GetMeasureEntity = self.OriginalMeasure
		
	end
	
end

function PLUGIN:Unload()
	--sharpeye_focus = nil
	self:UnhookIt()
end

function PLUGIN:CalcViewIntermed( ply, origin, angles, fov, player_view_med )
	if not self.FoundEnt or not ValidEntity( self.FoundEnt ) then
		local found = ents.FindByClass("npc_dog")
		if #found > 0 then
			self.FoundEnt = found[1]
		else
			return false
		end
	end
	
	local attachment = self.FoundEnt:GetAttachment( 1 )
	
	player_view_med.origin = attachment.Pos - attachment.Ang:Forward() * 3
	player_view_med.angles = attachment.Ang
	
	return true
end

function PLUGIN:Measure( )
	return self.FoundEnt ~= nil and self.FoundEnt or LocalPlayer()
end
