PLUGIN.Name = "CCV NOW"
PLUGIN.DefaultOn = false
PLUGIN.Description = ""
PLUGIN.Trigger = true

function PLUGIN:Load()
	for n = 1, 2 do
		local char = string.char( 97 - 1 + n )
		for i = 1, GUNSTRUMENTAL_NUM_VARS do
			print("CreateClientConVar(\"gs_zz" .. char .. "pat" .. i .. "\", \"" .. GetConVarString("gs_zz" .. char .. "pat" .. i) .. "\", true, true)")
		end
		
	end
	
end