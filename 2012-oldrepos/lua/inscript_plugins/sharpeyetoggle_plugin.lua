//  Filename must end with the suffix "_plugin.lua" .

PLUGIN.Name = "SharpeYe_toggle command"
PLUGIN.DefaultOn = false
PLUGIN.Description = ""
PLUGIN.Trigger = false


function PLUGIN:LoadParameters()
end

function PLUGIN:DoToggle()
	if sharpeye and sharpeye.IsEnabled then
		if sharpeye:IsEnabled() then
			RunConsoleCommand("sharpeye_core_enable", 0)
			
		else
			RunConsoleCommand("sharpeye_core_enable", 1)
		
		end
		
		
		
	end
	
end

function PLUGIN:Load()
	concommand.Add("sharpeye_toggle", function() self:DoToggle() end)
end

function PLUGIN:Unload()
	concommand.Remove("sharpeye_toggle")
	
end

