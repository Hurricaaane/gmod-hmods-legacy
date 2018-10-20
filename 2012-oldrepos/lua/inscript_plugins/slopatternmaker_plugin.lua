PLUGIN.Name = "SLOW PATTERN MAKER"
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

--local DELAYBASE = 240
--local NODELAYFILTER = false 
local PATLIMIT = 200

function PLUGIN:ParseMIDI( text, sChannelToFilter )
	local pattern = ""
	local parts = string.Explode( "\n", text )
	
	do
		local asDelay, asChannel = "",""
		for k,part in pairs(parts) do
			local sDelay, sOn, sChannel, sNote, sVol      = string.match(part or "", "(%d*) (%a*) ch=(%d*) n=(%d*) v=(%d*)")
			if sDelay and sOn and sChannel and sNote and sVol then
				if (sOn == "On") and (sDelay == asDelay) and (sChannel == asChannel) then
					print( parts[k] )
					parts[k] = sDelay .. " " .. sOn .. " ch=" .. sChannel .. "00 n=" .. sNote .. " v=" .. (sVol or "")
					print( parts[k] )
					
					asDelay = sDelay
					asChannel = sChannel
				end
			end
			
		end
		
	end
	
	table.sort( parts, function( a, b )
		local asDelay, asOn, asChannel, asNote, asVol = string.match(a or "", "(%d*) (%a*) ch=(%d*) n=(%d*) v=(%d*)")
		local sDelay, sOn, sChannel, sNote, sVol      = string.match(b or "", "(%d*) (%a*) ch=(%d*) n=(%d*) v=(%d*)")
		if asDelay and asOn and asChannel and asNote and asVol then
			if sDelay and sOn and sChannel and sNote and sVol then
				return (tonumber(asDelay) == tonumber(sDelay)) and (tonumber(asChannel) < tonumber(sChannel)) or (tonumber(asDelay) < tonumber(sDelay))
				
			else
				return true
				
			end
			
		else
			return false
			
		end
		
	end)
	//PrintTable( parts )
	
	local first = true
	
	local lastID = -1
	local lastTime = 0
	local channelIsOn = false
	local sNoteoffs = ""
	local pauses = 0
	
	local DELAYBASE = GUNSTRUMENTAL_DELAYBASE or 240
	local NODELAYFILTER = GUNSTRUMENTAL_NODELAYFILTER or false
	
	for k,line in pairs( parts ) do
		local sDelay, sOn, sChannel, sNote, sVol = string.match(line, "(%d*) (%a*) ch=(%d*) n=(%d*) v=(%d*)")
		--print( sDelay, sOn, sChannel, sNote, sVol )
		
		if sDelay and sOn and sChannel and sNote and sVol then
			local sToFilter = ""
			local found = false
			if type(sChannelToFilter) == "table" then
				local search = 1
				while (not found) and (search <= #sChannelToFilter) do
					found = (sChannel == sChannelToFilter[search])
					if found then sToFilter = sChannelToFilter[search] end
					search = search + 1
					
				end
				
			else
				found = (sChannel == sChannelToFilter)
				sToFilter = sChannelToFilter
				
			end
			
			if found then
				--if sOn == "On" and not channelIsOn then
				local thisTime = tonumber( sDelay )
				if sOn == "On" and (first or ((thisTime ~= lastTime) and (NODELAYFILTER and (math.floor(thisTime / DELAYBASE) ~= lastID) or (thisTime % DELAYBASE == 0)))) /*and not channelIsOn*/ then
					--sNoteoffs = sNote
					local iNote = tonumber( sNote )
					local sNormalized = self:MIDI_IntegerToNote( iNote )
					
					lastID = math.floor(thisTime / DELAYBASE)
					
					--local matchTime = thisTime - thisTime % DELAYBASE
					thisTime = thisTime - thisTime % DELAYBASE
					
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
	local tab, tpause      = self:ParseMIDI( GUNSTRUMENTAL_TAB or "", GUNSTRUMENTAL_CH1 or "1" )
	local harmonics, hpause = self:ParseMIDI( GUNSTRUMENTAL_TAB or "", GUNSTRUMENTAL_CH2 or "2" )
	
	print( tab, harmonics )
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
	
	file.Write( "gunstruspm_out.txt", tab .. "\n" .. harmonics )
	
	if GetGunstrumental and GetGunstrumental() then
		GetGunstrumental():Gunstrumentalize( tab, harmonics )
		return
		
	end
	
	local size = 100
	local tabpos = 1
	local iPattern = 1
	while iPattern <= GUNSTRUMENTAL_NUM_VARS do
		if tabpos < tablen then
			timer.Simple(iPattern * 0.1 - 0.05, function(iPattern, tab, tabpos, size) chat.AddText( "setting "..iPattern) RunConsoleCommand("gs_zzapat"..iPattern, string.sub( tab, tabpos, tabpos + size - 1 ) ) end, iPattern, tab, tabpos, size)
			timer.Simple(iPattern * 0.1, function(iPattern, tab, tabpos, size) RunConsoleCommand("gs_zzbpat"..iPattern, string.sub( harmonics, tabpos, tabpos + size - 1 ) ) end, iPattern, tab, tabpos, size)
			tabpos = tabpos + size
			
		else
			timer.Simple(iPattern * 0.1 - 0.05, function(iPattern, tab, tabpos, size) chat.AddText( "emptying "..iPattern) RunConsoleCommand("gs_zzapat"..iPattern, "" ) end, iPattern, tab, tabpos, size)
			timer.Simple(iPattern * 0.1, function(iPattern, tab, tabpos, size) RunConsoleCommand("gs_zzbpat"..iPattern, "" ) end, iPattern, tab, tabpos, size)
			
		end
			
		iPattern = iPattern + 1
	end
	timer.Simple(iPattern * 0.1 + 0.05, function() chat.AddText("OK") end )
	
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
