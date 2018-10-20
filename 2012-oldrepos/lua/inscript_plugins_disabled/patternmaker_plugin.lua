PLUGIN.Name = "PATTERN MAKER"
PLUGIN.DefaultOn = false
PLUGIN.Description = ""
PLUGIN.Trigger = true

function PLUGIN:LoadParameters()
	inscript.RegisterPanelConstructor( "multitext__pmaker" , function( sFullConvarName, stData )	
		local myPanel = vgui.Create("DTextEntry")
		myPanel:SetMultiline( true )
		myPanel:SetConVar(sFullConvarName)
		myPanel:SetUpdateOnType( stData.UpdateOnType and true or false )
		myPanel.OnValueChange = function( ... )
			if inscript.Data_IsMounted( stData ) and stData.OnChange then
				stData.OnChange( myPanel, ... )
			end
		end
		myPanel.OnEnter = function( ... )
			if inscript.Data_IsMounted( stData ) and stData.OnEnter then
				stData.OnEnter( myPanel, ... )
			end
		end
		return myPanel 
	end , "noconvars" )
	
	self:AddParameter("arrange",    {
		Type = "multitext__pmaker" ,
		Defaults = "",
		OnChange = function( panel )
			local value = panel:GetValue()
			print( value )
			
			
		end
	} )
	
end

local DELAYBASE = 240
local NODELAYFILTER = false 
local PATLIMIT = 50

function PLUGIN:ParseMIDI( text, sChannelToFilter )
	local pattern = ""
	local parts = string.Explode( "\n", text )
	
	local first = true
	
	local lastTime = 0
	local channelIsOn = false
	local sNoteoffs = ""
	local pauses = 0
	for k,line in pairs( parts ) do
		local sDelay, sOn, sChannel, sNote, sVol = string.match(line, "(%d*) (%a*) ch=(%d*) n=(%d*) v=(%d*)")
		--print( sDelay, sOn, sChannel, sNote, sVol )
		
		if sDelay and sOn and sChannel and sNote and sVol then
			if sChannel == sChannelToFilter then
				--if sOn == "On" and not channelIsOn then
				local thisTime = tonumber( sDelay )
				if sOn == "On" and (first or ((thisTime ~= lastTime) and (NODELAYFILTER or(thisTime % DELAYBASE == 0)))) /*and not channelIsOn*/ then
					--sNoteoffs = sNote
					local iNote = tonumber( sNote )
					local sNormalized = self:MIDI_IntegerToNote( iNote )
					
					--if not first then
						for dt = 1, ( math.floor((thisTime - lastTime) / DELAYBASE) - 1 ) do
							pattern = pattern .. ".."
							
						end
					--end
					if first then pauses = ( math.floor(thisTime / DELAYBASE) ) end
					
					pattern = pattern .. sNormalized
					
					--print( (thisTime - lastTime) )
					
					lastTime = thisTime
					first = false
					--channelIsOn = true
					
				--elseif sOn == "Off" /*and channelIsOn and sNoteoffs == sNote*/ then
				--	--delayAccumulator = delayAccumulator + tonumber( sDelay )
				--	channelIsOn = false
					
				end
				
			/*else
				delayAccumulator = delayAccumulator + tonumber( sDelay )*/
				
			end
			
		end
		
	end
	
	return pattern, pauses
end

function PLUGIN:Load()
	local tab, tpause      = self:ParseMIDI( GUNSTRUMENTAL_TAB or "", "1" )
	local harmonics, hpause = self:ParseMIDI( GUNSTRUMENTAL_TAB or "", "2" )
	
	print( tab, tpause )
	local tablen = string.len( tab )
	local harmonicslen = string.len( harmonics )
	
	local minpause = math.Min( tpause, hpause )
	
	--tab = string.sub( tab, 1 + minpause * 2, tablen )
	--harmonics = string.sub( harmonics, 1 + minpause * 2, harmonicslen )
	
	if tablen < harmonicslen then
		tab = tab .. string.rep(".", harmonicslen -  tablen)
		
	elseif harmonicslen < tablen then
		harmonics = harmonics .. string.rep(".", tablen -  harmonicslen)
	
	end
	
	local tabpos = 1
	local iPattern = 1
	while iPattern <= PATLIMIT do
		if tabpos < tablen then
			RunConsoleCommand("ha3_gunstrumental_pattern"..iPattern, string.sub( tab, tabpos, tabpos + 99 ) )
			RunConsoleCommand("ha3_gunstrumental_harmonics"..iPattern, string.sub( harmonics, tabpos, tabpos + 99 ) /*string.rep("cirn9",20)*/ )
			tabpos = tabpos + 100
		else
			RunConsoleCommand("ha3_gunstrumental_pattern"..iPattern, "" )
			RunConsoleCommand("ha3_gunstrumental_harmonics"..iPattern, "" )
		end
			
		iPattern = iPattern + 1
	end
	
end

function PLUGIN:Unload()
end

local PBBASE = "aAbcCdDefFgG" -- 12 BASE
function PLUGIN:MIDI_IntegerToNote( iNote )
	local a_four_base = iNote - 69 -- MIDI A440 is n = i + 69
	local PBI = a_four_base % 12 + 1
	local PBI_L = string.sub( PBBASE, PBI, PBI )
	
	local OOC = 5 + math.floor( (a_four_base - 3) / 12 )
	
	return PBI_L .. OOC
	
end
