/*
	YouTube Player by I_am_McLovin
	<mclovin1015@gmail.com>
	
	You are welcome to learn from 
	this and modify for personal use.
	Just don't re-upload this code
	or any modified versions of it.
*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

/* 
	Set this to nil or "" for no password,.
	But if you would like a password simply
	set it to what you would like.
	
	Example:
	local password = "password"
*/

local password = nil

local passwords = {}

function ENT:Initialize()

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( false )
	
end

function ENT:SpawnFunction( ply, trace )
	
	if #ents.FindByClass( "youtube_player" ) >= 1 then return end 
	
	if !file.IsDir( "youtube player" ) then file.CreateDir( "youtube player" ) end
	if !file.IsDir( "youtube player/videos" ) then file.CreateDir( "youtube player/videos" ) end
		
	if password then
		if passwords[ply] and passwords[ply].correct == true then
			umsg.Start( "youtube_player_spawnmenu", ply )
			umsg.End( )
		else
			umsg.Start( "youtube_player_password_request", ply )
				umsg.String( "youtube_player_spawnmenu" )
			umsg.End()
		end
	else
		umsg.Start( "youtube_player_spawnmenu", ply )
		umsg.End( )
	end
	
end

function ENT:Use( ply, caller )
	
	if !timer.IsTimer( "youtube_player_use_delay"..tostring( self.Entity:EntIndex() ) ) and self.Entity and self.Entity:IsValid() and ply and ply:IsValid() then
		local index = tostring( self.Entity:EntIndex() )
		
		umsg.Start( "youtube_player_use_menu", ply )
			if password then
				if passwords[ply] and passwords[ply].correct then
					umsg.Bool( true )
				else
					umsg.Bool( false )
				end
			else
				umsg.Bool( true )
			end
		umsg.End( )
		
		timer.Create( "youtube_player_use_delay" .. index, 2, 1, function( index )
			timer.Remove( "youtube_player_use_delay" .. index )
		end, index )
	end

end

concommand.Add( "youtube_player_spawn", function( ply, com, args )

	if ply and ply:IsValid() and ply:IsAdmin() then
		if Screen_List[args[1]] and ( !password or ( password and passwords[ply] and passwords[ply].correct ) ) then
			local trace = ply:GetEyeTrace()
	
			local ent = ents.Create( "youtube_player" )
				ent:SetModel( args[1] )
				ent:SetPos( trace.HitPos + trace.HitNormal * 80 )
				ent:DropToFloor()
				ent:PhysWake()
				ent:Spawn()
				ent:Activate()
			
			ply:AddCleanup( "props", ent )
			
			undo.Create( "YouTube_Player" )
				undo.AddEntity( ent )
				undo.SetPlayer( ply )
			undo.Finish()
		end
	end

end )

concommand.Add( "youtube_player_password", function( ply, com, args )
	
	if password then
		if passwords[ply] then 
			if !passwords[ply].correct then
				if passwords[ply].tries >= 10 then
					ply:PrintMessage( HUD_PRINTTALK, "You have made too many password attempts!" )
				else
					if args[1] == password then
						passwords[ply].correct = true
						if args[2] then
							umsg.Start( args[2], ply )
							umsg.End( )
						end
					else
						passwords[ply].tries = passwords[ply].tries + 1
						ply:PrintMessage( HUD_PRINTTALK, "Incorrect Password." )
					end
				end
			end
		else
			passwords[ply] = {
				correct = false, 
				tries = 0
			}
			if args[1] == password then
				passwords[ply].correct = true
				if args[2] then
					umsg.Start( args[2], ply )
					umsg.End( )
				end
			else
				passwords[ply].tries = passwords[ply].tries + 1
				ply:PrintMessage( HUD_PRINTTALK, "Incorrect Password." )
			end
		end
	end

end )

concommand.Add( "youtube_player_add_video", function( ply, com, args )

	if ply and ply:IsValid() and ply:IsAdmin() then
		if ( !password or ( password and passwords[ply] and passwords[ply].correct ) ) and file.IsDir( "youtube player" ) and file.IsDir( "youtube player/videos" ) then
			file.Write( "youtube player/videos/" .. args[1] .. ".txt", table.concat( { args[1], args[2] }, ";" ) )
		end
	end

end )

concommand.Add( "youtube_player_remove_video", function( ply, com, args )

	if ply and ply:IsValid() and ply:IsAdmin() then
		if ( !password or ( password and passwords[ply] and passwords[ply].correct ) ) and file.IsDir( "youtube player" ) and file.IsDir( "youtube player/videos" ) then
			if file.Exists( "youtube player/videos/" .. string.lower( args[1] ) .. ".txt" ) then
				file.Delete( "youtube player/videos/" .. string.lower( args[1] ) .. ".txt" )
			end
		end
	end

end )

concommand.Add( "youtube_player_start_populate", function( ply, com, args )

	if ply and ply:IsValid() and ply:IsAdmin() then
		if ( !password or ( password and passwords[ply] and passwords[ply].correct ) ) and file.IsDir( "youtube player" ) and file.IsDir( "youtube player/videos" ) then
			file.TFind( "data/youtube player/videos/*.txt", function( search, folders, files )				
				for k,v in pairs( files ) do
					local fl = file.Read( "youtube player/videos/" .. v )
					
					umsg.Start( "youtube_player_populate_video_list", ply )
					
					umsg.String( string.Explode( ";", fl )[1] )
					umsg.String( string.Explode( ";", fl )[2] )
					
					umsg.End()
				end
				
			end )
		end
	end

end )

concommand.Add( "youtube_player_url", function( ply, com, args )

	if ply and ply:IsValid() and ply:IsAdmin() then
		if password then
			if passwords[ply] then 
				if passwords[ply].correct then		
					umsg.Start( "youtube_player_start_video", RecipientFilter():AddAllPlayers() )
						umsg.String( args[1] )
					umsg.End( )
				else
					umsg.Start( "youtube_player_password_request", ply )
						umsg.String( "youtube_player_url" )
					umsg.End()
				end
			else
				umsg.Start( "youtube_player_password_request", ply )
					umsg.String( "youtube_player_url" )
				umsg.End()
			end
		else
			umsg.Start( "youtube_player_start_video", RecipientFilter():AddAllPlayers() )
				umsg.String( args[1] )
			umsg.End( )
		end
	end

end )
