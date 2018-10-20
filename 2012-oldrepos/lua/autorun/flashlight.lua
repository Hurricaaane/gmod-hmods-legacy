if SERVER then
	function _FlashlightAttached( ply, bTrySwitchOn )
		/*if not ply._flashlightIsOn then
			ply._flashlightIsOn = true
			
		else
			ply._flashlightIsOn = not ply._flashlightIsOn
			
		end*/
		umsg.Start("_FlashlightSwitch")
			umsg.Entity( ply )
			umsg.Bool( ply._flashlightIsOn )
		umsg.End()
		--ply:EmitSound( "../../../../common/alien swarm/swarm/sound/weapons/3d/reloads/flashlighttoggle.wav", 100, 100 )

		/*if ply._flashlightIsOn then
			if not ValidEntity( ply._flashlight ) then 				
				ply._flashlight = ents.Create( "env_projectedtexture" )

				ply._flashlight:SetPos( ply:GetViewModel():GetPos() + ply:EyeAngles():Forward() * -32 )
				ply._flashlight:SetAngles( ply:EyeAngles() )
				ply._flashlight:SetParent( ply:GetViewModel() )

				ply._flashlight:SetKeyValue( "enableshadows", 1 )
				ply._flashlight:SetKeyValue( "farz", 2048 )
				ply._flashlight:SetKeyValue( "nearz", 8 )
				ply._flashlight:SetKeyValue( "lightfov", 50 )
				ply._flashlight:SetKeyValue( "lightcolor", "255 255 255" )
				ply._flashlight:Spawn()
				ply._flashlight:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" )
				
				ply._flashlight:Fire( "setparentattachmentmaintainoffset", "muzzle" , 0 )
				
			end
			
		else 
			if ValidEntity( ply._flashlight ) then
				ply._flashlight:Remove()
				ply._flashlight = nil
				
			end
			
		end
		
		return false*/
		return true
		
	end 
	hook.Add( "PlayerSwitchFlashlight", "_FlashlightAttached", _FlashlightAttached )
	
else
	local _FlashlightSwitch_GotAlienSwarm = file.Exists("../../../common/alien swarm/swarm/sound/weapons/3d/reloads/flashlighttoggle.wav", true)
	local _FlashlightSwitch_File =  _FlashlightSwitch_GotAlienSwarm and "../../../../common/alien swarm/swarm/sound/weapons/3d/reloads/flashlighttoggle.wav" or" items/flashlight1.wav"
	
	function _FlashlightSwitch( data )
		local ply = data:ReadEntity()
		local bTrySwitchOn = data:ReadBool()
		
		if ValidEntity( ply ) then
			ply:EmitSound( _FlashlightSwitch_File, 100, bTrySwitchOn and 120 or 100 )
			
		end
		
	end
	usermessage.Hook("_FlashlightSwitch", _FlashlightSwitch)
	
end