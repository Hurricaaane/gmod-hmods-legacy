function _R.Player:DiveTo( deg, time, locktime )
	self._dive_deg = deg
	self._dive_time = time
	self._dive = true
	self._pitch = self:GetAngles( ).p	
	self.SideDive = true
	timer.Simple(0.6, function()
	self.SideDive = false
	end)
end

function _R.Player:SideDiveTo( deg, time, locktime )
	self._dive_deg = deg
	self._dive_time = time
	self._Sdive = true
	self._roll = 0
	self.SideDive = true
	timer.Simple(0.6, function()
	self.SideDive = false
	end)
end

local function umDiveTo( um )
	local a, b

	a = um:ReadFloat( )
	b = um:ReadFloat( )

	LocalPlayer():DiveTo( a, b)
end
usermessage.Hook( "DiveToMS", umDiveTo )

local function umSDiveTo( um )
	local a, b

	a = um:ReadFloat( )
	b = um:ReadFloat( )

	LocalPlayer():SideDiveTo( a, b)
end
usermessage.Hook( "SideDiveToMS", umSDiveTo )

local function DiveCView( pl, pos, ang, fov )
	local view
	
	if not pl._dive and not pl._Sdive then
		return
	end
	
	view = GAMEMODE:CalcView( pl, pos, ang, fov )
	
	if pl._dive then
	print("p")
	
	pl._pitch = math.Approach( pl._pitch, pl._dive_deg, FrameTime( ) * pl._dive_time * pl._dive_deg )
	
	if pl._pitch == pl._dive_deg then
		pl._dive = false
	end
	
	view.angles.p = pl._pitch
	
	end
	
	if pl._Sdive then
	print("r")
	
	pl._roll = math.Approach( pl._roll, pl._dive_deg, FrameTime( ) * pl._dive_time * pl._dive_deg )
	
	if pl._roll == pl._dive_deg then
		pl._Sdive = false
	end
	
	view.angles.r = pl._roll
	
	end
	
	return view
end

hook.Add( "CalcView", "DiveView.CalcView", DiveCView )

function SideDiveViewReset(UCMD)
if LocalPlayer().SideDive == true then
local ang=UCMD:GetViewAngles()
ang.p = 0
UCMD:SetViewAngles(ang)
end
end
hook.Add("CreateMove", "SideDiveCalcViewSet", SideDiveViewReset)