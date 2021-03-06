
if CLIENT then /// CLIENT

local MAPDECO = {}

MAPDECO.Mat = Material( "effects/yellowflare" )

MAPDECO.Harmonics = {}
MAPDECO.AngleDump = Angle(0,0,0)
MAPDECO.LastPhasis = 0

function MAPDECO.MakeHarmonics( origin, radius, color )
	local dataTable = {}
	
	-- Statics
	dataTable.NumPins = 12
	dataTable.CirclePrecision = 3
	dataTable.Thickness = 6
	
	
	dataTable.Origin = origin
	dataTable.Radius = radius
	dataTable.Color = color
	dataTable.BaseAlpha = color.a
	
	dataTable.Distance = radius
	
	dataTable.VD = {}
	for i = 1, 3 do
		table.insert(dataTable.VD, 0 )
		table.insert(dataTable.VD, ((math.random(0, 1) == 1) and 1 or -1) * math.Rand(0.7,3) )
	end
	
	dataTable.BaseCircle = {}
	for d = 0, 359, (360 / dataTable.CirclePrecision) do
		table.insert( dataTable.BaseCircle, Vector( math.cos( math.rad(d) ) * dataTable.Distance, math.sin( math.rad(d) ) * dataTable.Distance, 0) )
	end
	
	dataTable.SubSequents = {}
	for i=1,dataTable.NumPins do
		dataTable.SubSequents[i] = {}
		for k=1,dataTable.CirclePrecision do
			table.insert( dataTable.SubSequents[i], Vector(0,0,0) )
		end
	end
	
	table.insert( MAPDECO.Harmonics, dataTable )
	
end

function MAPDECO.CalculateAngle( iPhasis, dataTable, angleToModify )
	angleToModify.p = iPhasis * dataTable.VD[2]
	angleToModify.y = iPhasis * dataTable.VD[4]
	angleToModify.r = iPhasis * dataTable.VD[6]
end


local function HarmonicsPostDrawOpaqueRenderables()
	if #MAPDECO.Harmonics == 0 then return end

	local phasis = math.floor(CurTime() * 10)
	render.SetMaterial( MAPDECO.Mat )
	
	for _,dataTable in pairs(MAPDECO.Harmonics) do
		for i = 1, dataTable.NumPins do
			local delta = (dataTable.NumPins - i + 1) / dataTable.NumPins
			
			if phasis ~= MAPDECO.LastPhasis then
				MAPDECO.CalculateAngle( phasis - i, dataTable, MAPDECO.AngleDump )
				
				for k,_ in pairs( dataTable.SubSequents[i] ) do
					dataTable.SubSequents[i][k].x = dataTable.BaseCircle[k].x
					dataTable.SubSequents[i][k].y = dataTable.BaseCircle[k].y
					dataTable.SubSequents[i][k].z = 0
					
					-- Rotate modiffies the original vector
					dataTable.SubSequents[i][k]:Rotate( MAPDECO.AngleDump )
					dataTable.SubSequents[i][k] = dataTable.SubSequents[i][k] + dataTable.Origin
					
				end
			end
			
			for k,_ in pairs( dataTable.SubSequents[i] ) do
				dataTable.Color.a = dataTable.BaseAlpha * delta
				render.DrawBeam( dataTable.SubSequents[i][k], 		
								 dataTable.SubSequents[i][(k % dataTable.CirclePrecision) + 1],
								 dataTable.Thickness,					
								 0.5,					
								 0.5,				
								 dataTable.Color )
			end
			
		end
	end
	MAPDECO.LastPhasis = phasis
	
end
hook.Add("PostDrawOpaqueRenderables", "HarmonicsPostDrawOpaqueRenderables", HarmonicsPostDrawOpaqueRenderables)

local function HarmonicsMapDecoration( origin, extrema )
	local radius = (origin - extrema):Length()
	
	MAPDECO.MakeHarmonics( origin, radius, Color( 119, 199, 255, 164 ) )
	MAPDECO.MakeHarmonics( origin, radius, Color( 241, 197, 255, 164 ) )
	--MAPDECO.MakeHarmonics( origin, radius, Color( 197, 255, 231, 164 ) )
	
end





local function DecorationInfo( m )
	local origin  = m:ReadVector()
	local extrema = m:ReadVector()
	
	HarmonicsMapDecoration( origin, extrema )
end
usermessage.Hook( "DecorationInfo", DecorationInfo )



else /// SERVER

local function HarmonicsPlayerInitialSpawn( ply, id )
	if Decoration_Origin then
		umsg.Start("DecorationInfo", ply )
			umsg.Vector( Decoration_Origin )
			umsg.Vector( Decoration_Extrema )
		umsg.End()
	end
end

hook.Add("PlayerInitialSpawn", "HarmonicsPlayerInitialSpawn", HarmonicsPlayerInitialSpawn)

local function HarmonicsInitPostEntity( )
	-- Search for decoration
	local tOriginEnt = ents.FindByName("deco_center")
	local tExtremaEnt = ents.FindByName("deco_extrema")
	if #tOriginEnt > 0 and #tExtremaEnt > 0 then
		local origin  = tOriginEnt[1]
		local extrema = tExtremaEnt[1]
		Decoration_Origin  = origin:GetPos()
		Decoration_Extrema = extrema:GetPos()
	end
end
hook.Add("InitPostEntity", "HarmonicsInitPostEntity", HarmonicsInitPostEntity)

end ///

