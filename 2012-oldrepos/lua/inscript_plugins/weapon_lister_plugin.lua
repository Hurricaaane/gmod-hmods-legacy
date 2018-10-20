PLUGIN.Name = "Weapon Lister"
PLUGIN.DefaultOn = false
PLUGIN.Description = "Experimental plugin to test out RL Printouts."
PLUGIN.Trigger = false


function PLUGIN:LoadParameters()
	self:AddParameter("x_relpos",    { Type = "slider" , Text = "Grid X position", Defaults = "0", Min = "0", Max = "16", Decimals = "0" } )
	self:AddParameter("y_relpos",    { Type = "slider" , Text = "Grid Y position", Defaults = "0", Min = "0", Max = "16", Decimals = "0" } )
	self:AddParameter("padding",      { Type = "slider"   , Text = "Padding", Defaults = "4", Min = "0", Max = "8", Decimals = "0" } )
end

function PLUGIN:_Constitute()
	self.AT = {}
	self.col = Color(255,255,255)
end

function PLUGIN.HOOK:Think( )
	self.PPT = player.GetAll()
	for k,ply in pairs(self.PPT) do
		local str = ""
		local stw = 0
		if ValidEntity(ply:GetActiveWeapon()) then
			str = ply:GetActiveWeapon():GetClass()
			stw = ply:GetActiveWeapon():Clip1()
			
			str = str .. " ["..stw.."]"
		end
		self.AT[k] = {self.col, ply:Nick(), str, stw}
	end	
end

function PLUGIN:Load()
	self.CO_Main   =  Color( 0, 0, 0, 128 )
	self.CO_Text   =  Color( 255, 255, 255, 255 )
	self.CO_Achieving   =  Color( 255, 255, 255, 64 )
	self.BaseWidth = 280

	self:_Constitute()
	
end

function PLUGIN:Unload()
	
end

function PLUGIN.HOOK:HUDPaint()
	if not self.AT or #self.AT == 0 then return end

	local padding = self:GetNumber("padding")
	local X_Ref = 0
	local Y_Ref = 0
	
	local EXTRA = 5
	--local mins = math.min(7,#self.AT)
	local mins = #self.AT
	local heightnorm = mins * 17 + (mins - 1) * 3 + EXTRA
	
	X_Ref = padding + self:GetNumber("x_relpos") * ((ScrW() - 2 * padding - self.BaseWidth) / 16 )
	Y_Ref = padding + self:GetNumber("y_relpos") * ((ScrH() - 2 * padding - heightnorm) / 16 )
	
	surface.SetDrawColor( self.CO_Main.r , self.CO_Main.g, self.CO_Main.b, self.CO_Main.a )
	surface.DrawRect( X_Ref, Y_Ref, self.BaseWidth, heightnorm )
	
	surface.SetDrawColor( self.CO_Achieving.r , self.CO_Achieving.g, self.CO_Achieving.b, self.CO_Achieving.a )
	for i=1,mins do
		draw.SimpleText( #self.AT-mins+i, "DefaultSmall", X_Ref + self.BaseWidth - 5, Y_Ref + 12 + 20 * (i-1), self.CO_Achieving, TEXT_ALIGN_RIGHT )
		
		draw.SimpleText( self.AT[mins+1-i][2], "ScoreboardText", X_Ref + 5, Y_Ref + 20 * (i-1), self.AT[mins+1-i][1], TEXT_ALIGN_LEFT )
		draw.SimpleText( self.AT[mins+1-i][3], "DefaultSmall", X_Ref + 5 + 5, Y_Ref + 12 + 20 * (i-1), Color( 255, (self.AT[mins+1-i][4] % 2)*255, (self.AT[mins+1-i][4] % 2)*255) , TEXT_ALIGN_LEFT )
	end
	
end
