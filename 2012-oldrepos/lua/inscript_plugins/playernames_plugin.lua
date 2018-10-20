PLUGIN.Name = "Player Names"
PLUGIN.DefaultOn = false
PLUGIN.Description = 
[[Target Information - Plug.]]
PLUGIN.Trigger = false


function PLUGIN:LoadParameters()
	
end

function PLUGIN:Load()
end

function PLUGIN:Unload()
end

function PLUGIN:_StringNiceNameTransform( stringInput )
end

local pos
local ok = Color(255,255,255,255)
local bad = Color(255,64,64,255)
local blac = Color(0,0,0,255)

function PLUGIN.HOOK:HUDPaint()
	for k,entity in pairs( player.GetAll() ) do
		if ValidEntity( entity ) then
			
			pos = entity:GetPos():ToScreen()
			
			surface.SetDrawColor( 0, 0, 0, 255 )
			draw.SimpleText( entity:GetName(), "ScoreboardText", pos.x+1, pos.y+1 + 5, blac )
			
			if entity:IsPlayer() && entity:Alive() then
				draw.SimpleText( entity:GetName(), "ScoreboardText", pos.x, pos.y + 5, ok )
				
			else
				draw.SimpleText( entity:GetName(), "ScoreboardText", pos.x, pos.y + 5, bad )
				
			end
			
		end
	end
end

