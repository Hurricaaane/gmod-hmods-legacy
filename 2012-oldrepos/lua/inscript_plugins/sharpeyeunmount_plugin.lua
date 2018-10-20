//  Filename must end with the suffix "_plugin.lua" .

PLUGIN.Name = "Unmount SharpeYe"
PLUGIN.DefaultOn = false
PLUGIN.Description = "Unmounts SharpeYe."
PLUGIN.Trigger = true


function PLUGIN:LoadParameters()
end

function PLUGIN:Load()
	if sharpeye then sharpeye.Unmount() end
end

function PLUGIN:Unload()
end

