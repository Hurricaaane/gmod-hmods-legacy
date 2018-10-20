PLUGIN.Name = "YouTube Stats"
PLUGIN.DefaultOn = false
PLUGIN.Description = "YouTube"
PLUGIN.Trigger = false


function PLUGIN:LoadParameters()
	self:AddParameter("username_label", { Type = "label"    , Text = "YouTube Username :" } )
	self:AddParameter("username",       { Type = "textentry", Defaults = "youtube", OnChange = function() self:_Query() end }, true )
	self:AddParameter("delay", { Type = "slider"   , Text = "Refresh delay", Defaults = "60", Min = "60", Max = "600", Decimals = "0" } )
	
	self:AddParameter("x_relpos",    { Type = "slider" , Text = "Grid X position", Defaults = "16", Min = "0", Max = "16", Decimals = "0" } )
	self:AddParameter("y_relpos",    { Type = "slider" , Text = "Grid Y position", Defaults = "1", Min = "0", Max = "16", Decimals = "0" } )
	self:AddParameter("padding",      { Type = "slider"   , Text = "Padding", Defaults = "4", Min = "0", Max = "8", Decimals = "0" } )
end

function PLUGIN:_Query()
	if self:HasChanged("username") then
		self.subfirst = nil
		self:FlushParameter("username")
	end

	local username = self:GetString("username")
	local url = "http://gdata.youtube.com/feeds/api/users/" .. username
	
	local function _Receive(contents, size)
		local uname = -1
		for v in string.gmatch(contents, "<yt:username>(%w+)</yt:username>") do
			uname = v
		end
		
		if uname == -1 then return end
		
		local scount = -1
		for v in string.gmatch(contents, "subscriberCount='(%w+)'") do
			scount = tonumber(v)
		end
		if not self.subfirst then self.subfirst = scount end
		
		self.TT_Text = uname .. " has " .. scount .. " subscriber" .. (scount > 1 and "s" or "") .. (((self.subfirst - scount) ~= 0) and ("(" .. string.format( "%+i", scount - self.subfirst ) .. " change)") or "")
	end
	
	http.Get(url, "", _Receive)
	timer.Adjust("ytstatsquery", self:GetNumber("delay"), 0, self._Query, self)
end

function PLUGIN:Load()
	self.CO_Main   =  Color( 0, 0, 0, 128 )
	self.CO_Text   =  Color( 255, 255, 255, 255 )
	self.CO_Memo   =  Color( 164, 164, 164, 255 )
	self.BaseWidth = 380
	
	self.TT_Text = "Querying YouTube..."

	self:_Query()

	timer.Create("ytstatsquery", self:GetNumber("delay"), 0, self._Query, self)
	
end

function PLUGIN:Unload()
	timer.Remove("ytstatsquery")
	
end

function PLUGIN:HUDPaint()	
	local padding = self:GetNumber("padding")
	local X_Ref = 0
	local Y_Ref = 0
	
	X_Ref = padding + self:GetNumber("x_relpos") * ((ScrW() - 2 * padding - self.BaseWidth) / 16 )
	Y_Ref = padding + self:GetNumber("y_relpos") * ((ScrH() - 2 * padding - 17 ) / 16 )
	
	surface.SetDrawColor( self.CO_Main.r , self.CO_Main.g, self.CO_Main.b, self.CO_Main.a )
	surface.DrawRect( X_Ref, Y_Ref, self.BaseWidth, 17 )
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	draw.SimpleText( self.TT_Text, "ScoreboardText", X_Ref + self.BaseWidth - 5, Y_Ref, self.CO_Text, TEXT_ALIGN_RIGHT )
	
end
