PLUGIN.Name = "FLASH"
PLUGIN.DefaultOn = false
PLUGIN.Description = ""
PLUGIN.Trigger = false

function PLUGIN:LoadParameters()	
end

function PLUGIN:Load()	
	self.StartTime = CurTime()
end

function PLUGIN.HOOK:HUDPaint()
	//local i = ((math.floor(CurTime() * 10) % 2) == 0) and 255 or 0
	local i = ((math.sin( CurTime() * 3.14 * 8) + 1) / 2)^2 * 255
	surface.SetDrawColor( i,i,i, 255 )
	
	if (CurTime() - self.StartTime) < 5 then
		surface.SetDrawColor( 0,0,0, 255 )
	end
	
	surface.DrawRect( 0, 0, ScrW(), ScrH() )
	
end