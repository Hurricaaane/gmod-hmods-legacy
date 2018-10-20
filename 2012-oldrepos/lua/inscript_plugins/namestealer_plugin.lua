PLUGIN.Name = "Name Stealer"
PLUGIN.DefaultOn = false
PLUGIN.Description = "Name Stealer."

function PLUGIN:LoadParameters()
end

function PLUGIN:Load()
	RunConsoleCommand("say","Enabled Inscript Name Stealer")
end

-- Functions that begin with a "_" are not automatically hooked.
function PLUGIN:_DiceNoRepeat( myMax, lastUsed )
	local dice = math.random(1, myMax - 1)
	if (dice >= lastUsed) then
		dice = dice + 1
	end
	
	return dice
end

-- This function is automatically hooked on Mount, and unhooked on Unmount.
function PLUGIN:Think()
	if (CurTime() > ((self.LastThink or 0) + 0.3)) then
		local allply = player.GetAll()
		if #allply <= 2 then
			self.NewName = "<none>"
			
		else
			repeat
				self.Dice = self:_DiceNoRepeat(#allply, self.Dice or 0)
			until allply[self.Dice] ~= LocalPlayer()
			self.NewName = allply[self.Dice]:Nick()
			
		end
		
		self.LastThink = CurTime()
	end
		
	RunConsoleCommand("setinfo", "name", (self.NewName or "") .. " " )
end

function PLUGIN:Unload()
	RunConsoleCommand("say","Disabled Inscript Name Stealer")
end