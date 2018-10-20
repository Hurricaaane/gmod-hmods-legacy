--[[

Some parts of the code are PIECE OF SHIT that are tied to the SWEP object
while it shouldn't even be tied to it in the first place

]]--



-- Not Toybox
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

-- Toybox Stuffs
local GUNSTRU_WeaponClassname = ClassName or "weapon_gunstrumental"

-- Globalize this so that other scripts can read it
GUNSTRUMENTAL_NUM_VARS = 100

-- Gunstrumental object (hell yeah)
local GUNSTRU = {}
function GetGunstrumental()
	return GUNSTRU
	
end

GUNSTRU.NumVars 			= GUNSTRUMENTAL_NUM_VARS
GUNSTRU.NumPatterns 		= 2



//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//
//      THE CVARS
//
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
if CLIENT then
	GUNSTRU.CLI_DefaultPattern = [[A4..............A4A4A4A4A4..G4A4........A4A4A4A4A4..G4A4........A4A4A4A4A4f4f4f4f4f4f4f4f4f4f4..A4....f4........A4A4d5D5f5............f5..f5F5G5A5............A5A5A5G5F5G5..F5f5..........f5....D5D5f5F5..........f5D5..C5C5D5f5..........D5C5..c5c5d5e5..........g5....f5f4f4f4f4f4f4f4f4f4f4..A4....f4........A4A4d5D5f5............f5..f5F5G5A5................C6....c6....a5..........f5....F5................A5....a5....f5..........f5....F5................A5....a5....f5..........d5....D5................F5....f5....C5..........A4....c5c5d5e5..........g5....f5f4f4f4f4f4f4f4f4f4f4
d4..............d4d4d4d4c4..c4c4..........c4c4c4C4..C4C4........C4C4C4C4C4a3a3a3a3a3a3a3a3a3a3..d4....d4d4c4d4..d4d4f4g4G4..A4A4d5D5f5f5..G4A4c5C5..F4F4A4c5C5C5..C5c5A4C5..G4G4G4F4G4..G4G4F4G4F4..F4F4..F4A4....G4F4..f4..f4f4..f4G4....F4f4..e4....e4..f4g4..g4A4c5..a4a3a3a3a3a3a3a3a3a3a3..d4....d4d4c4d4..d4d4f4g4G4..A4A4d5D5f5f5..G4A4c5C5................e5....D5....c5..........a4....b4................C5....c5....a4..........a4....b4................C5....c5....a4..........a4....F4................b4....A4....f4..........C4....e4....e4..f4g4..g4A4c5..a4a3a3a3a3a3a3a3a3a3a3]]
	
	do
		-- Hardcoded default gunstrumental pattern (WTF)
		CreateClientConVar("gs_zzapat1", "A4..............A4A4A4A4A4..G4A4........A4A4A4A4A4..G4A4........A4A4A4A4A4f4f4f4f4f4f4f4f4f4f4..A4..", true, true)
		CreateClientConVar("gs_zzapat2", "..f4........A4A4d5D5f5............f5..f5F5G5A5............A5A5A5G5F5G5..F5f5..........f5....D5D5f5F5", true, true)
		CreateClientConVar("gs_zzapat3", "..........f5D5..C5C5D5f5..........D5C5..c5c5d5e5..........g5....f5f4f4f4f4f4f4f4f4f4f4..A4....f4....", true, true)
		CreateClientConVar("gs_zzapat4", "....A4A4d5D5f5............f5..f5F5G5A5................C6....c6....a5..........f5....F5..............", true, true)
		CreateClientConVar("gs_zzapat5", "..A5....a5....f5..........f5....F5................A5....a5....f5..........d5....D5................F5", true, true)
		CreateClientConVar("gs_zzapat6", "....f5....C5..........A4....c5c5d5e5..........g5....f5f4f4f4f4f4f4f4f4f4f4", true, true)
		CreateClientConVar("gs_zzapat7", "", true, true)
		CreateClientConVar("gs_zzbpat1", "d4..............d4d4d4d4c4..c4c4..........c4c4c4C4..C4C4........C4C4C4C4C4a3a3a3a3a3a3a3a3a3a3..d4..", true, true)
		CreateClientConVar("gs_zzbpat2", "..d4d4c4d4..d4d4f4g4G4..A4A4d5D5f5f5..G4A4c5C5..F4F4A4c5C5C5..C5c5A4C5..G4G4G4F4G4..G4G4F4G4F4..F4F4", true, true)
		CreateClientConVar("gs_zzbpat3", "..F4A4....G4F4..f4..f4f4..f4G4....F4f4..e4....e4..f4g4..g4A4c5..a4a3a3a3a3a3a3a3a3a3a3..d4....d4d4c4", true, true)
		CreateClientConVar("gs_zzbpat4", "d4..d4d4f4g4G4..A4A4d5D5f5f5..G4A4c5C5................e5....D5....c5..........a4....b4..............", true, true)
		CreateClientConVar("gs_zzbpat5", "..C5....c5....a4..........a4....b4................C5....c5....a4..........a4....F4................b4", true, true)
		CreateClientConVar("gs_zzbpat6", "....A4....f4..........C4....e4....e4..f4g4..g4A4c5..a4a3a3a3a3a3a3a3a3a3a3", true, true)
		CreateClientConVar("gs_zzbpat7", "", true, true)
		
		for n = 1, GUNSTRU.NumPatterns do
			local char = string.char( 97 - 1 + n )
			for i = 8, GUNSTRU.NumVars do
				CreateClientConVar("gs_zz" .. char .. "pat" .. i, "", true, true)
			end
			
		end
		
	end
	
	GUNSTRU.DefaultCvars = {
		{"gs_offsets",	0	},
		{"gs_volume",	50	},
		{"gs_tempo",	40	},
		
		{"gs_aoffset",	0	},
		{"gs_atrans",	0	},
		{"gs_asound",	"gunstrumental/gunstru__1.wav"	},
		
		{"gs_boffset",	-4	},
		{"gs_btrans",	0	},
		{"gs_bsound",	"gunstrumental/musicbox__2.wav"	},
		
		{"gs_rcdisplay",	32	},
		{"gs_rchold",		0	},
		{"gs_rcautoplay",	0	},
		{"gs_rcdebug",		0	},
	}
	
	for k,data in pairs( GUNSTRU.DefaultCvars ) do
		CreateClientConVar( data[1], tostring( data[2] ), true, true)
		
	end
	
	function GUNSTRU:CLI_ResetDefaults()
		for k,data in pairs( self.DefaultCvars ) do
			RunConsoleCommand( data[1], tostring( data[2] ) )
			
		end
		
	end
	
end


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//
//      THE SWEP
//
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

if CLIENT then
	SWEP.PrintName			= "The Gunstrumental"
	SWEP.Author				= "Hurricaaane (Ha3)"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 5
	SWEP.IconLetter			= "b"
	
	SWEP.LastCursorPos		= -1
	SWEP.LastCursorCurTime	= 0
	
	SWEP.CLI_ReloadTime = 0
	
end
-- Because of Singleplayer/Multiplayer LUA differences, CLIENT and SERVER might not be dinsjunctive.
-- Do NOT merge them into a dinsjunctive if then else end.
if SERVER then
	AddCSLuaFile( "shared.lua" ) // Useless in ToyBox
	
	SWEP.Cursor = 1
	SWEP.CursorBackingPos = 1
	SWEP.NeedsInit = true
	
end

SWEP.Category			= "Misc :: Ha3"

SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"
SWEP.HoldType			= "pistol"

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.DamageBase		= 15

SWEP.Secondary.ClipSize		= 0
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.DamageBase	= 5

SWEP.DamageMul = 2


SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true


function SWEP:GetPrimaryDelay()
	local tempo = GUNSTRU:RetreiveTempo( self.Owner )
	//return (tempo < 60) and 1 or (60 / tempo)
	//print( (6 / tempo) )
	return (tempo < 6) and 1 or (6 / tempo)
	
end

function SWEP:GetSecondaryDelay()
	return self:GetPrimaryDelay()
	
end

function SWEP:Deploy()
	return true
	
end

function SWEP:Initialize() 
	 if CLIENT then
		chat.AddText(Color(255, 255, 0), "The Gunstrumental", Color(255, 255, 255), " is a weapon that shoots music. ", Color(0, 255, 0), "Right click to open the menu ", Color(255, 255, 255), " and go ahead, load some music sheets! You can find music sheets in", Color(255, 255, 0), " The Gunstrukebox in the ToyBox for example." )
		
	 end
	 
end 

function SWEP:ShootEffects()
	---- Do not run since it shoots annoying shells out of the SMG.
	--- Used a Clientside CalcView override for the recoil as a replacement.
	-- self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	umsg.Start( "GUNSTRU_CouldShoot", self.Owner )
	umsg.End( "GUNSTRU_CouldShoot" )
	
end

function SWEP:FireA()
	local num_bullets = 1
	local damage = self.Primary.DamageBase * self.DamageMul * GUNSTRU:GetHitRatio( self.Owner, 1 ) * self:GetPrimaryDelay()
	local aimcone = 0
	
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )
	bullet.Tracer	= 1
	bullet.TracerName = "ToolTracer"
	bullet.Force	= 1
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	
	self.Owner:FireBullets( bullet )
	
end


function SWEP:FireB()
	local num_bullets = 1
	local damage = self.Secondary.DamageBase * self.DamageMul * GUNSTRU:GetHitRatio( self.Owner, 1 ) * self:GetPrimaryDelay()
	local aimcone = 0
	
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )
	bullet.Tracer	= 1
	bullet.TracerName = "Tracer"
	bullet.Force	= 1
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	
	self.Owner:FireBullets( bullet )
	
end

function SWEP:PrimaryAttack()
	if CLIENT then return false end // TODO: CLI_SRV Interactions
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self:GetPrimaryDelay() )
	
	local could = false
	if self:PrimaryPattern( ) 		then self:FireA() could = true end
	if self:HarmonicsPattern( ) 	then self:FireB() could = true end
	if could					 	then self.Weapon:ShootEffects() end
	
	self:IncrementCursorPos( )
	
	return true
	
end

function SWEP:SecondaryAttack()
	//if SERVER then self.CursorBackingPos = self.Cursor end
	//
	self.Weapon:SetNextSecondaryFire( CurTime() + self:GetSecondaryDelay() )
	
	if GetConVarNumber("gs_rcautoplay") > 0 then return self:PrimaryAttack() end
	
	return false
end

function SWEP:Reload()
	if CLIENT then return false end
	
	self.Cursor = self.CursorBackingPos
	self:ApplyCursorPos( )
	
	local deltaTime = CurTime() - (self.Owner.GS and self.Owner.GS.ReloadTime or 0)
	if (deltaTime > 1) then
		GUNSTRU:RequirePatternUpdate( self.Owner ) -- This has to go first
		self.Owner.GS.ReloadTime = CurTime()
		
	end
	
	return false
	
end

function SWEP:Think()
	if CLIENT then
		if LocalPlayer():KeyPressed( IN_RELOAD ) then
			local deltaTime = CurTime() - self.CLI_ReloadTime
			if (deltaTime > 0.5) then
				self.CLI_ReloadTime = CurTime()
				GUNSTRU:RequirePatternUpdate( LocalPlayer() )
				
			end
			
		end
		
		if self.Owner:KeyPressed(IN_ATTACK2) then
			GUNSTRU:OpenMenu()
			
		end
		
		if (GetConVarNumber("gs_rchold") == 0) and self.Owner:KeyReleased(IN_ATTACK2) then
			GUNSTRU:CloseMenu()
		
		end
		
		if self.LastCursorPos == -1 then
			timer.Simple(1.5, function(self) if ValidEntity(self) then GUNSTRU:RequirePatternUpdate( LocalPlayer() ) end end, self )
			
		end
		
		local cursorPos = self:RetreiveCursorPos( )
		if cursorPos ~= self.LastCursorPos then
			self.LastCursorCurTime = CurTime()
			
		end
		self.LastCursorPos = cursorPos
		
	end
	
	if SERVER then
		if self.NeedsInit then
			self.NeedsInit = false
			timer.Simple(1.5, function(self) if ValidEntity(self) then GUNSTRU:RequirePatternUpdate( self.Owner ) end end, self )
			
		end
		
	end
	
end

function SWEP:ApplyCursorPos( )
	self:SetDTInt( 0, self.Cursor - 1 )
	
end

function SWEP:RetreiveCursorPos( )
	return self:GetDTInt( 0, self.Cursor ) + 1
	
end

function SWEP:IncrementCursorPos( )
	local sPattern = GUNSTRU:GetPattern( self.Owner, 1 )
	local sPatternLength = string.len( sPattern )
	
	self.Cursor = self.Cursor + 1
	
	if self.Cursor >= (1 + sPatternLength / 2) then
		self.Cursor = 1
		
	end
	self:ApplyCursorPos( )
	
end

function SWEP:PrimaryPattern( )
	return self:PatternPlay( self.Owner, 1, true )
	
end

function SWEP:HarmonicsPattern( )
	return self:PatternPlay( self.Owner, 2, true )
	
end

-- Tie to GUNSTRU Object ? -- No because of EmitSound
function SWEP:PatternPitch( ent, iPattern )
	local sPattern = GUNSTRU:GetPattern( ent, iPattern )
	local iOffs = GUNSTRU:RetreiveOffset( ent, iPattern ) + GUNSTRU:RetreiveGlobalOffsets( ent ) + GUNSTRU:RetreiveTrans( ent, iPattern )
	local sPatternLength = string.len( sPattern )

	-- Is sPattern valid ?
	if (sPatternLength < 2) or ((sPatternLength % 2) == 1) then return false end
	
	--- Compressed
	local sNote = string.sub( sPattern, self.Cursor * 2 - 1, self.Cursor * 2)
	
	return GUNSTRU:GetTonePitch( sNote, iOffs ), sNote, iOffs
	
end

function SWEP:PatternPlay( ent, iPattern, opt_bShouldAlert )
	local pitch, sNote, iOffs = self:PatternPitch( ent, iPattern )
	if pitch then
		if pitch <= 255 then
			self.Weapon:EmitSound( GUNSTRU:RetreiveSound( ent, iPattern ), 50, pitch )
			
		elseif opt_bShouldAlert then
			print( "Tried to play note ".. sNote .." which is, with offsets ".. iOffs .. " too high to be played (" .. math.floor(pitch) .. ") !")
			
		end
		
		return true
		
	else
		
		return false
	end
	
end

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//
//                                  DUE TO TOYBOX CODE BEING CONTAINED IN ONE SINGLE FILE
//     THIS BIG BLOCK IS SUPPOSED TO HELP SEEING THROUGH THE MESS OF CODE WHEN EDITING IT
//
// //  //  THE GUNSTRUMENTAL OBJECT
//
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

function GUNSTRU:UTIL_IntegerToAZCode( iNum )
	--string.char( 97 - 1 + iNum )
	return string.char( 96 + iNum )
	
end

function GUNSTRU:BuildGunstrumentalTable( ply )
	-- Don't create if there's already a Gunstru Table
	if not ValidEntity( ply ) or ply.GS then return false end
	
	ply.GS = {}
	ply.GS.CachedPatterns 	= {}
	ply.GS.HitRatios 		= {}
	ply.GS.ReloadTime = 0
	
	for n = 1, self.NumPatterns do
		ply.GS.CachedPatterns[n] = ""
		ply.GS.HitRatios[n] = 0
		
	end
	
	return true
	
end

function GUNSTRU:RequirePatternUpdate( ply )
	if not ValidEntity( ply ) then return end
	
	self:BuildGunstrumentalTable( ply )
	
	for n = 1, self.NumPatterns do
		ply.GS.CachedPatterns[ n ] = self:RetreivePattern( ply, n )
		
		local len = string.len( ply.GS.CachedPatterns[ n ] )
		if (len < 2) or ((len % 2) == 1) then
			ply.GS.CachedPatterns[ n ] = ""
			
		else
			ply.GS.HitRatios[ n ] = self:FindHitRatio( ply.GS.CachedPatterns[ n ] )
			
		end
		
	end
	
end

function GUNSTRU:FindHitRatio( sPattern )	
	local patternLength = string.len( sPattern )
	local hits = 0
	
	for i = 1, patternLength/2 do
		local sNote = string.sub( sPattern, i * 2 - 1, i * 2)
		local bIsValid = self:NoteToInteger( sNote, 0 ) and true or false
			
		if bIsValid then
			hits = hits + 1
			
		end
		
	end
	
	return (hits > 0) and (patternLength * 0.5 / hits) or 0
	
end


function GUNSTRU:GetHitRatio( ply, iNum )
	if not ValidEntity( ply ) or not ply.GS then return 0 end
	
	return ply.GS.HitRatios[ iNum ]
	
end

function GUNSTRU:RetreivePattern( ply, iNum )
	if not ValidEntity( ply ) or not ply.GS then return "" end
	
	local char = self:UTIL_IntegerToAZCode( iNum )
	local sPattern = ""
	for i = 1, self.NumVars do
		if SERVER then
			sPattern = sPattern .. ply:GetInfo( "gs_zz".. char .. "pat" .. i )
			
		else
			sPattern = sPattern .. GetConVarString( "gs_zz".. char .. "pat" .. i )
			
		end
		
	end
	
	return sPattern
	
end

function GUNSTRU:RetreiveTempo( ent )
	if not ValidEntity( ent ) then return 0 end
	
	return ent:GetInfoNum( "gs_tempo" ) or 0
	
end

function GUNSTRU:RetreiveGlobalOffsets( ent )
	if not ValidEntity( ent ) then return 0 end
	
	return ent:GetInfoNum( "gs_offsets" ) or 0
	
end

function GUNSTRU:RetreiveOffset( ent, iNum )
	if not ValidEntity( ent ) then return 0 end
	
	return ent:GetInfoNum( "gs_".. self:UTIL_IntegerToAZCode( iNum ) .. "offset" ) or 0
	
end

function GUNSTRU:RetreiveTrans( ent, iNum )
	if not ValidEntity( ent ) then return 0 end
	
	return (ent:GetInfoNum( "gs_".. self:UTIL_IntegerToAZCode( iNum ) .. "trans" ) or 0) * 12
	
end

function GUNSTRU:RetreiveSound( ent, iNum )
	if not ValidEntity( ent ) then return "" end
	
	return ent:GetInfo( "gs_".. self:UTIL_IntegerToAZCode( iNum ) .. "sound" )
	
end

function GUNSTRU:GetPattern( ply, iNum )
	if not ValidEntity( ply ) or not ply.GS then return "" end
	
	return ply.GS.CachedPatterns[ iNum ]
	
end

local PBBASE = "aAbcCdDefFgG" -- 12 BASE
function GUNSTRU:IntegerToNote( a_four_base )
	local PBI = a_four_base % 12 + 1
	local PBI_L = string.sub( PBBASE, PBI, PBI )
	
	local OOC = 5 + math.floor( (a_four_base - 3) / 12 )
	
	return PBI_L .. OOC
	
end

function GUNSTRU:NoteToInteger( sNote, optiOffs )
	if string.len( tostring(sNote) ) ~= 2 then return end
	
	local PNI = string.sub( sNote, 1, 1 )
	local PNILOW = string.lower( PNI )
	if not ( ("a" <= PNILOW) and (PNILOW <= "g") ) then return end
	-- C D F G A filter
	-- Note : Don't check if it's B E, it's not as much of a matter as it wouldn't crash
	-- despite the false notation
	
	local OST = string.sub( sNote, 2, 2 )
	if not ( ("0" <= OST) and (OST <= "9") ) then return end --Assuming it could not be a number
	
	local ISOC = PNILOW ~= PNI
	OST = tonumber( OST )
	
	--local PUSE = ( string.byte(PNILOW) - string.byte("a") - 2 ) % 7
	--local PUSE = ( string.byte(PNILOW) - 97 - 2 ) % 7
	local PUSE = ( string.byte(PNILOW) - 99 ) % 7
	
	return -9 + ( 12 * ( OST - 4 ) ) + PUSE * 2 + ((PUSE >= 3) and -1 or 0) + (ISOC and 1 or 0) + (optiOffs or 0)
	
end

function GUNSTRU:GetTonePitch( sNote, optiOffs )
	local iNum = self:NoteToInteger( sNote, optiOffs )
	if not iNum then return end
	
	return 2 ^ ( iNum / 12 ) * 100
	
end

function GUNSTRU:Gunstrumentalize( tab, harmonics )
	local tablen = string.len( tab )
	local harmonicslen = string.len( harmonics )
	
	if tablen < harmonicslen then
		tab = tab .. string.rep(".", harmonicslen -  tablen)
		
	elseif harmonicslen < tablen then
		harmonics = harmonics .. string.rep(".", tablen -  harmonicslen)
		
	end
	
	local size = 100
	local tabpos = 1
	local iPattern = 1
	local delay = 0.02
	
	chat.AddText( Color(255, 255, 0), "Loading pattern into console variables..." )
	
	while iPattern <= GUNSTRUMENTAL_NUM_VARS do
		if tabpos < tablen then
			timer.Simple(iPattern * delay - delay/2,
			function(iPattern, contents)
				--chat.AddText( "setting "..iPattern)
				RunConsoleCommand("gs_zzapat"..iPattern, contents )
				
			end,
			iPattern, string.sub( tab, tabpos, tabpos + size - 1 )
			)
			timer.Simple(iPattern * delay,
			function(iPattern, contents)
				RunConsoleCommand("gs_zzbpat"..iPattern, contents )
				
			end,
			iPattern, string.sub( harmonics, tabpos, tabpos + size - 1 )
			)
			tabpos = tabpos + size
			
		else
			timer.Simple(iPattern * delay - delay/2,
			function(iPattern, tab, tabpos, size)
				--chat.AddText( "emptying "..iPattern)
				RunConsoleCommand("gs_zzapat"..iPattern, "" )
				
			end,
			iPattern)
			timer.Simple(iPattern * delay,
			function(iPattern, tab, tabpos, size)
				RunConsoleCommand("gs_zzbpat"..iPattern, "" )
				
			end,
			iPattern)
			
		end
		
		iPattern = iPattern + 1
		
	end
	timer.Simple(iPattern * delay, function() chat.AddText( Color(255, 255, 0), "Finished dumping..." ) end )
	timer.Simple(iPattern * delay + 2, function() chat.AddText( Color(0, 255, 0), "Done loading!", Color(255, 255, 255), " You should now ", Color(255, 255, 0), "reload your weapon by hitting your Reload key", Color(255, 255, 255), " (just as if you were reloading your SMG)." ) end )
	
end

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//
//                                  DUE TO TOYBOX CODE BEING CONTAINED IN ONE SINGLE FILE
//     THIS BIG BLOCK IS SUPPOSED TO HELP SEEING THROUGH THE MESS OF CODE WHEN EDITING IT
//
// //  //  THE HUD
//
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

if CLIENT then
	local PATTERN_COLPRE  = { Color( 164, 255, 64, 255 )	, Color( 64, 164, 255, 255 )		}
	local PATTERN_COLPASS = { Color( 255, 255, 0, 255 )	, Color( 255, 128, 0, 255 )		}
	local PATTERN_COLIMPOSSIBLE = { Color( 255, 0, 0, 255 ) }
	
	local PATTERN_COLORNONE = { Color( 0, 0, 0, 192 ) }
	
	local PATTERN_COLORDEBUG = { Color( 255, 255, 255, 255 ), Color( 255, 255, 255, 64 ) }
	
	local PATTERN_NOTE_TEXID = surface.GetTextureID("ha3mats/beacon_flare_add")
	
	function SWEP:DrawHUD()
		self:DrawPatterns()
		
	end
	
	function SWEP:DrawPatterns()
		local ply = LocalPlayer()
		
		local PATTERN_DEBUGMODE 		= GetConVarNumber("gs_rcdebug") > 0
		
		local PATTERN_VISRANGEPASS 	= GetConVarNumber("gs_rcdisplay")
		local PATTERN_VISRANGEPRE 		= PATTERN_VISRANGEPASS * 2
	
		local pos = self:RetreiveCursorPos()
		local offs = GUNSTRU:RetreiveGlobalOffsets( self.Owner )
		
		surface.SetTexture( PATTERN_NOTE_TEXID )
		
		local decreaser = 1 - (CurTime() - self.LastCursorCurTime) / self:GetPrimaryDelay()
		decreaser = (decreaser > 0) and decreaser or 0
		
		if PATTERN_DEBUGMODE then
			surface.SetDrawColor( PATTERN_COLORDEBUG[2] )
			surface.DrawTexturedRectRotated(
				ScrW() / 2,
				64,
				8,
				256,
				0
			)
			draw.SimpleText(
				self:RetreiveCursorPos(),
				"ConsoleText",
				ScrW() / 2+1,
				17,
				PATTERN_COLORNONE[1],
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_CENTER
			)
			draw.SimpleText(
				self:RetreiveCursorPos(),
				"ConsoleText",
				ScrW() / 2,
				16,
				PATTERN_COLORDEBUG[1],
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_CENTER
			)
			
		end
		
		for n = 1, GUNSTRU.NumPatterns do
			local pattern = GUNSTRU:GetPattern( ply, n )
			local patternLength = string.len( pattern )
			local patOffs = offs + GUNSTRU:RetreiveOffset( ply, n ) + GUNSTRU:RetreiveTrans( ply, n )
			
			if PATTERN_DEBUGMODE then
				local yImpossible = ScrH() * 0.17 - (16 - patOffs) * ScrH() / 192				
				surface.SetDrawColor( PATTERN_COLPRE[n] )
				surface.DrawTexturedRectRotated(
					ScrW() / 2,
					yImpossible,
					128,
					8,
					0
				)
				surface.SetDrawColor( PATTERN_COLIMPOSSIBLE[1] )
				surface.DrawTexturedRectRotated(
					ScrW() / 2,
					yImpossible,
					16,
					16,
					CurTime() * 30
				)
				
				
			end
			
			for i = math.max(1, pos - PATTERN_VISRANGEPASS), math.min(pos + PATTERN_VISRANGEPRE, patternLength/2 + 1) do
				local rel = pos - i
				local sNote = string.sub( pattern, i*2 - 1, i*2 )
				local high = GUNSTRU:NoteToInteger( sNote, 0 )
				if high then
					//print( ScrW() / 2 - rel * 4, 128 - high * 2 )
					/*draw.SimpleText(
						".",
						"ConsoleText",
						ScrW() / 2 - rel * 2,
						64 - high * 2,
						(rel <= 0) and PATTERN_COLPRE[n] or PATTERN_COLPASS[n],
						TEXT_ALIGN_CENTER,
						TEXT_ALIGN_CENTER
					)*/
					
					local isPre 	= rel <= 0
					local shrive 	= (isPre and (-rel / PATTERN_VISRANGEPRE) or (rel / PATTERN_VISRANGEPASS))^2
					local ashrive 	= 1 - shrive
					local add = (rel == 1) and decreaser or 0
					
					local isPossible = (high + patOffs) <= 16
					
					local xPos = ScrW() / 2 - (rel * math.floor(ScrW() / 320) - math.floor(decreaser * ScrW() / 320))
					local yPos = ScrH() * 0.17 - high * ScrH() / 192
					
					surface.SetDrawColor( isPossible and (isPre and PATTERN_COLPRE[n] or PATTERN_COLPASS[n]) or PATTERN_COLIMPOSSIBLE[1] )
					surface.DrawTexturedRectRotated(
						xPos,
						yPos,
						ScrH() / 64 * ((isPre and 2 or 1.5)*ashrive + add * 2),
						ScrH() / 64 * ((isPre and 2 or 1.5)*ashrive + add * 2),
						45 + add * 180
					)
					if PATTERN_DEBUGMODE then
						draw.SimpleText(
							sNote,
							"ConsoleText",
							xPos+1,
							yPos+9,
							PATTERN_COLORNONE,
							TEXT_ALIGN_CENTER,
							TEXT_ALIGN_CENTER
						)
						draw.SimpleText(
							sNote,
							"ConsoleText",
							xPos,
							yPos+8,
							isPossible and (isPre and PATTERN_COLPRE[n] or PATTERN_COLPASS[n]) or PATTERN_COLIMPOSSIBLE[1],
							TEXT_ALIGN_CENTER,
							TEXT_ALIGN_CENTER
						)
						
					end
					
				end
				
			end
			
		end
		
	end
	
	local CLI_LastSuccessShot = 0
	usermessage.Hook("GUNSTRU_CouldShoot", function()
		CLI_LastSuccessShot = CurTime()
	end)
	
	local RECOILTIME = 0.3
	function SWEP:GetViewModelPosition( pos, ang )
		local distTime = (CLI_LastSuccessShot - CurTime() + RECOILTIME)
		if distTime < 0 then return pos, ang end
		
		pos = pos + ang:Right() * 0
		pos = pos + ang:Forward() * -2 * (distTime / RECOILTIME) ^ 2
		pos = pos + ang:Up() * 0
		
		return pos, ang
		
	end
	
end

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//
//                                  DUE TO TOYBOX CODE BEING CONTAINED IN ONE SINGLE FILE
//     THIS BIG BLOCK IS SUPPOSED TO HELP SEEING THROUGH THE MESS OF CODE WHEN EDITING IT
//
// //  //  THE GUNSTRUMENTAL MENU
//
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

if CLIENT then
	--[[	
	local function GS_HGetFocus( panel )
		if not ValidPanel( GS_MENU ) then return end
		if panel:HasParent( GS_MENU ) then
			GS_MENU:StartKeyFocus()
		end
		
	end
	
	local function GS_HLoseFocus( panel )
		if not ValidPanel( GS_MENU ) then return end
		if panel:HasParent( GS_MENU ) then
			GS_MENU:EndKeyFocus()
		end
		
	end

	hook.Remove( "OnTextEntryGetFocus", "GS_HGetFocus" )
	hook.Remove( "OnTextEntryLoseFocus", "GS_HLoseFocus" )

	hook.Add( "OnTextEntryGetFocus", "GS_HGetFocus", GS_HGetFocus )
	hook.Add( "OnTextEntryLoseFocus", "GS_HLoseFocus", GS_HLoseFocus )
	]]--
	
	local GS_MENU = nil
	
	function GUNSTRU:OpenMenu()
		self:MakeMenu()
		self:GetMenu():Open()
		
	end
	
	function GUNSTRU:CloseMenu()
		if not self:HasMenu() then return end
		
		self:GetMenu():Close()
		
	end
	
	function GUNSTRU:HasMenu()
		return ValidPanel( GS_MENU )
		
	end
	
	function GUNSTRU:GetMenu()
		return GS_MENU or self:BuildMenu()
		
	end
	
	function GUNSTRU:BuildMenu( )
		if self:HasMenu() then return end
			
		self.HangMenu = vgui.Create( "GS_MENU" )
		GS_MENU = self.HangMenu
		
		return self.HangMenu
		
	end
	
	function GUNSTRU:MakeMenu( )
		if not self:GetMenu():GetContents() then
			self:GetMenu():SetContents( self:BuildContents() )
			self:GetMenu():UpdateContents()
			
		end
		
	end
	
	function GUNSTRU:BuildContents()
		//////////////////////////////////////////////////////
		//
		//      PREPARE FOR A THOUSAND LINES OF SHIT CODE
		//
		//////////////////////////////////////////////////////
		
		self.HangMenu:SetSize( ScrW() * 0.35, ScrH() * 0.7 )
		self.HangMenu:SetPos( (ScrW() - self.HangMenu:GetWide()) / 2, (ScrH() - self.HangMenu:GetTall()) / 2 )
		GS_MENU.DEF_TALL = self.HangMenu:GetTall()
		self.HangMenu.Paint = function (self)
			surface.SetDrawColor( 0, 0, 0, 96 )
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
		end
		
		local mainPanel = vgui.Create( "DPanel" )
		mainPanel.Paint = function (self)
			surface.SetDrawColor( 0, 0, 0, 96 )
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
		end
		
		local header = vgui.Create( "DPanel", mainPanel )
		header.CTS = {}
		do
			local item = "title"
			header.CTS[item] = vgui.Create("DLabel", header)
			header.CTS[item]:SetMouseInputEnabled( true )
			header.CTS[item]:SetText("Gunstrumental")
			header.CTS[item]:SetFont("DefaultBold")
			header.CTS[item]:SetContentAlignment( 5 )
			header.CTS[item].Paint = function (self)
				surface.SetDrawColor( 0, 0, 0, 96 )
				surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
			end
			header.CTS[item].OnMousePressed = function( self )
				self.mx, self.my = self:CursorPos()
				self._moving = true
				self:MouseCapture( true )
				
			end
			header.CTS[item].OnMouseReleased = function( self )
				self._moving = false
				self:MouseCapture( false )
				
			end
			header.CTS[item].Think = function( self )
				if not self._moving then return end
				
				local rx, ry = gui.MousePos()
				local realx, realy = rx - self.mx, ry - self.my
				local w, h = GS_MENU:GetWide(), GS_MENU:GetTall()
				
				if realx < 0 then
					realx = 0
					realy = 0
					GS_MENU:SetTall( ScrH() )
					GS_MENU._largemode = true
					
				elseif (realx + w) > ScrW() then
					realx = ScrW() - w
					realy = 0
					GS_MENU:SetTall( ScrH() )
					GS_MENU._largemode = true
					
				else
					if GS_MENU._largemode then
						GS_MENU._largemode = false
						GS_MENU:SetTall( GS_MENU.DEF_TALL )
						
					end
					
					if realy < 0 then realy = 0 end
					if (realy + h) > ScrH() then realy = ScrH() - h end
					
				end
				
				GS_MENU:SetPos( realx, realy )
				
			end
			
		end
		do
			local item = "closebox"
			header.CTS[item] = vgui.Create("DSysButton", header)
			header.CTS[item]:SetType( "close" )
			header.CTS[item].DoClick = function ( self ) GUNSTRU:CloseMenu() end
		end
		header.PerformLayout = function( self )
			self.CTS["title"]:StretchToParent(0, 0, 0, 0)
			self.CTS["closebox"]:SetSize( self:GetTall() * 0.9, self:GetTall() * 0.9 )
			self.CTS["closebox"]:CenterVertical( )
			self.CTS["closebox"]:AlignRight( self:GetTall() * 0.1 )
			
		end
		
		local tabMaster = vgui.Create( "DPropertySheet", mainPanel )
		do
			local form = vgui.Create( "DPanelList" )
			form:EnableVerticalScrollbar( true )
			tabMaster._p_general = form
			form.CTS = {}
			do
				local item = "rchold"
				form.CTS[item] = vgui.Create("DCheckBoxLabel", form)
				form.CTS[item]:SetText("Hold menu open after right-clicking")
				form.CTS[item]:SetConVar( "gs_rchold" )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "rcautoplay"
				form.CTS[item] = vgui.Create("DCheckBoxLabel", form)
				form.CTS[item]:SetText("Play the Gunstrumental when holding right-click")
				form.CTS[item]:SetConVar( "gs_rcautoplay" )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "rcdebug"
				form.CTS[item] = vgui.Create("DCheckBoxLabel", form)
				form.CTS[item]:SetText("Enable Debug Mode to show me the notes!")
				form.CTS[item]:SetConVar( "gs_rcdebug" )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "tempo"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item]:SetText("Tempo")
				form.CTS[item]:SetMin( 10 )
				form.CTS[item]:SetMax( 360 )
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar( "gs_tempo" )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "offsets"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item]:SetText("Global Transposition (Octave)")
				form.CTS[item]:SetMin( -20 )
				form.CTS[item]:SetMax( 20 )
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar( "gs_offsets" )
				form:AddItem( form.CTS[item] )
				
			end	
			do
				local item = "helpme"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item].step = 1
				form.CTS[item]:SetText("HELP ME! My weapon doesn't shoot anything!")
				form.CTS[item].Texts = {
					"HELP ME! My weapon doesn't shoot anything!",
					"READ THIS: Clicking this again will reset your settings.",
					"DONE. Do you also want to reset your music sheet?",
					"DONE."
				}
				form.CTS[item].OnMousePressed = function( self )
					self:ExecStep()
					self:StepText()
					
				end
				form.CTS[item].ExecStep = function(self)
					local step = self.step
					if step == 2 then
						GUNSTRU:CLI_ResetDefaults()
						
					elseif step == 3 then
						GUNSTRU:Gunstrumentalize("A4..............A4A4A4A4A4..G4A4........A4A4A4A4A4..G4A4........A4A4A4A4A4f4f4f4f4f4f4f4f4f4f4..A4....f4........A4A4d5D5f5............f5..f5F5G5A5............A5A5A5G5F5G5..F5f5..........f5....D5D5f5F5..........f5D5..C5C5D5f5..........D5C5..c5c5d5e5..........g5....f5f4f4f4f4f4f4f4f4f4f4..A4....f4........A4A4d5D5f5............f5..f5F5G5A5................C6....c6....a5..........f5....F5................A5....a5....f5..........f5....F5................A5....a5....f5..........d5....D5................F5....f5....C5..........A4....c5c5d5e5..........g5....f5f4f4f4f4f4f4f4f4f4f4","d4..............d4d4d4d4c4..c4c4..........c4c4c4C4..C4C4........C4C4C4C4C4a3a3a3a3a3a3a3a3a3a3..d4....d4d4c4d4..d4d4f4g4G4..A4A4d5D5f5f5..G4A4c5C5..F4F4A4c5C5C5..C5c5A4C5..G4G4G4F4G4..G4G4F4G4F4..F4F4..F4A4....G4F4..f4..f4f4..f4G4....F4f4..e4....e4..f4g4..g4A4c5..a4a3a3a3a3a3a3a3a3a3a3..d4....d4d4c4d4..d4d4f4g4G4..A4A4d5D5f5f5..G4A4c5C5................e5....D5....c5..........a4....b4................C5....c5....a4..........a4....b4................C5....c5....a4..........a4....F4................b4....A4....f4..........C4....e4....e4..f4g4..g4A4c5..a4a3a3a3a3a3a3a3a3a3a3")
						
					end
					
					
					
					// After the modulus, put the number of available steps
					self.step = self.step % 4 + 1
					
				end
				form.CTS[item].StepText = function(self)
					self:SetText( self.Texts[ self.step ] )
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "advance"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Advance")
				form.CTS[item].OnMousePressed = function( self )
					RunConsoleCommand("+attack")
					self:MouseCapture( true )
					
				end
				form.CTS[item].OnMouseReleased = function( self )
					RunConsoleCommand("-attack")
					self:MouseCapture( false )
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "reload"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Reload weapon (Do it after loading music sheets!)")
				form.CTS[item].OnMousePressed = function( self )
					RunConsoleCommand("+reload")
					self:MouseCapture( true )
					
				end
				form.CTS[item].OnMouseReleased = function( self )
					RunConsoleCommand("-reload")
					self:MouseCapture( false )
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "help"
				form.CTS[item] = vgui.Create("DLabel", form)
				form.CTS[item]:SetText( "By aiming at an entity that contains Gunstrumental music (For example, the Gunstrukebox in the Toybox), you'll be able to load them up from here!" )
				form.CTS[item]:SetWrap( true )
				form.CTS[item]:SetAutoStretchVertical( true )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "help"
				form.CTS[item] = vgui.Create("DLabel", form)
				form.CTS[item].form = form
				form.CTS[item].Announce = false
				form.CTS[item].Think = function (self)
					if not self.Announce and self.form.CTS["downloaded"].LastEnt then
						self.Announce = true
						self:SetText("Some music sheets were found!")
						
					end
					local tone = (math.sin(3*CurTime()) + 1) * 127
					self:SetTextColor( Color(tone, 255, 0) )
					
				end
				form.CTS[item]:SetText( "" )
				form.CTS[item]:SetWrap( true )
				form.CTS[item]:SetAutoStretchVertical( true )
				form:AddItem( form.CTS[item] )
				
			end
			
			do
				local item = "downloaded"
				form.CTS[item] = vgui.Create( "DPanelList" )
				form.CTS[item]:EnableVerticalScrollbar( false )
				form.CTS[item].LastEnt = nil
				form.CTS[item].Think = function( self )
					local ent = util.TraceLine( util.GetPlayerTrace( LocalPlayer() ) ).Entity
					if ValidEntity( ent ) and (ent ~= self.LastEnt) and ent.GetGunstrumental and (type(ent.GetGunstrumental) == "function") then
						self.LastEnt = ent
						self:Clear()
						local gunstruData = ent:GetGunstrumental()
						if (type(gunstruData) == "table") then
							for k,data in ipairs( gunstruData ) do
								local button = vgui.Create("DButton", self )
								button.gunstru = tostring( data[1] or "" )
								button.mylist = self
								button:SetText( data[2] or "#" .. tostring(k) .. " music with no name" )
								button.DoClick = function( self )
									local edit = string.Explode("\n", self.gunstru)
									GUNSTRU:Gunstrumentalize(edit[1] or "", edit[2] or "")
									
								end
								self:AddItem(button)
								
							end
							
						end
						self:Rebuild()
						self:InvalidateParent()
						self:SizeToContents()
						
					end
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			
		end
		do
			local form = vgui.Create( "DPanelList" )
			form:EnableVerticalScrollbar( true )
			tabMaster._p_instruments = form
			form.CTS = {}
			do
				local item = "condition"
				form.CTS[item] = vgui.Create("DLabel", form)
				form.CTS[item]:SetText( "Instruments sets:" )
				form.CTS[item]:SetWrap( true )
				form.CTS[item]:SetAutoStretchVertical( true )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local sets = {}
				table.insert( sets,
					{ "Gunstrumental",
						"gunstrumental/gunstru__1.wav", 0,
						"gunstrumental/musicbox__2.wav", -4
					} )
				table.insert( sets,
					{ "Gunstrumental (Higher 2,2)",
						"gunstrumental/gunstru__1o880.wav", 0,
						"gunstrumental/musicbox__2o880.wav", -4
					} )
				table.insert( sets,
					{ "Gunstrumental (Higher 3,2)",
						"gunstrumental/gunstru__1o1760.wav", 0,
						"gunstrumental/musicbox__2o880.wav", -4
					} )
				table.insert( sets,
					{ "Piano",
						"gunstrumental/piano_f3__1.wav", 0,
						"gunstrumental/piano_f3__2.wav", 0
					} )
				table.insert( sets,
					{ "Piano (Higher 2,2)",
						"gunstrumental/piano_f3__1o880.wav", 0,
						"gunstrumental/piano_f3__2o880.wav", 0
					} )
				table.insert( sets,
					{ "Piano (Higher 3,3)",
						"gunstrumental/piano_f3__1o1760.wav", 0,
						"gunstrumental/piano_f3__2o1760.wav", 0
					} )
				table.insert( sets,
					{ "Bonk",
						"vo/scout_specialcompleted03.wav"	, 0,
						"vo/scout_specialcompleted02.wav"	, -1
					} )
				table.insert( sets,
					{ "Music Box",
						"gunstrumental/musicbox__1.wav", 0,
						"gunstrumental/musicbox__2.wav", 0
					} )
				table.insert( sets,
					{ "Music Box (Higher 2,2)",
						"gunstrumental/musicbox__1o880.wav", 0,
						"gunstrumental/musicbox__2o880.wav", 0
					} )
				table.insert( sets,
					{ "SMG / AR2",
						"weapons/smg1/smg1_fire1.wav"	, 0,
						"weapons/ar2/fire1.wav"	, 0
					} )
				table.insert( sets,
					{ "TF2 Bat / SMG",
						"weapons/bat_hit.wav"	, 0,
						"weapons/smg_shoot.wav"	, 0
					} )
				table.insert( sets,
					{ "Triangle waves",
						"gunstrumental/gs_tri_03s__1.wav", 0,
						"gunstrumental/gs_tri_03s__2.wav", 0
					} )
				table.insert( sets,
					{ "DTMF Phone dial",
						"gunstrumental/dtmf1__1.wav", 0,
						"gunstrumental/dtmf1__2.wav", 0
					} )
				table.insert( sets,
					{ "NES Set #1 (DH/BASS)",
						"gunstrumental/nes_test_1__1.wav", 0,
						"gunstrumental/nes_test_2__2.wav", 0
					} )
				table.insert( sets,
					{ "NES Set #2 (DH/DH)",
						"gunstrumental/nes_test_1__1.wav", 0,
						"gunstrumental/nes_test_1__2.wav", 0
					} )
				table.insert( sets,
					{ "Vibraphone",
						"gunstrumental/vibraphone__1.wav", 0,
						"gunstrumental/vibraphone__2.wav", 0
					} )
				table.insert( sets,
					{ "Vibraphone (Higher 2,2)",
						"gunstrumental/vibraphone__1o880.wav", 0,
						"gunstrumental/vibraphone__2o880.wav", 0
					} )
				table.insert( sets,
					{ "Vibraphone (Higher 3,3)",
						"gunstrumental/vibraphone__1o1760.wav", 0,
						"gunstrumental/vibraphone__2o1760.wav", 0
					} )
				table.insert( sets,
					{ "Music Box/Vibraphone (Higher 2,2)",
						"gunstrumental/musicbox__1o880.wav", 0,
						"gunstrumental/vibraphone__2o880.wav", 1
					} )
				table.insert( sets,
					{ "Vibraphone/Music Box (Higher 2,2)",
						"gunstrumental/vibraphone__1o880.wav", 1,
						"gunstrumental/musicbox__2o880.wav", 0
					} )
				local item = "instrument_sets"
				form.CTS[item] = vgui.Create( "DMultiChoice" )
				for k,v in pairs( sets ) do
					form.CTS[item]:AddChoice( v[1] )
					
				end
				
				form.CTS[item].OnSelect = function(index, value, data)
					RunConsoleCommand( "gs_asound" , sets[value][2] )
					RunConsoleCommand( "gs_aoffset", sets[value][3] )
					RunConsoleCommand( "gs_bsound" , sets[value][4] )
					RunConsoleCommand( "gs_boffset", sets[value][5] )
					
				end
				form.CTS[item]:PerformLayout()
				form.CTS[item]:SizeToContents()
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "help"
				form.CTS[item] = vgui.Create("DLabel", form)
				form.CTS[item]:SetText( "(These instrument sets can be changed via console variables; gs_asound, gs_bsound)" )
				form.CTS[item]:SetWrap( true )
				form.CTS[item]:SetAutoStretchVertical( true )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "atrans"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item]:SetText("Primary Pattern transposition")
				form.CTS[item]:SetMin( -5 )
				form.CTS[item]:SetMax( 5 )
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar( "gs_atrans" )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "btrans"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item]:SetText("Secondary Pattern transposition")
				form.CTS[item]:SetMin( -5 )
				form.CTS[item]:SetMax( 5 )
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar( "gs_btrans" )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "aoffset"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item]:SetText("Primary Pattern height adjustment (Octave)")
				form.CTS[item]:SetMin( -11 )
				form.CTS[item]:SetMax( 11 )
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar( "gs_aoffset" )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "boffset"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item]:SetText("Secondary Pattern height adjustment (Octave)")
				form.CTS[item]:SetMin( -11 )
				form.CTS[item]:SetMax( 11 )
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar( "gs_boffset" )
				form:AddItem( form.CTS[item] )
				
			end
			
			
			
		end
		do
			local form = vgui.Create( "DPanelList" )
			form:EnableVerticalScrollbar( true )
			form.MAX = 0
			tabMaster._p_maker = form
			form.CTS = {}
			form.Think = function( self )
				form.MAX = math.floor( string.len( GUNSTRU:GetPattern( LocalPlayer(), 1 ) ) / 2 )
				
			end
			do
				local item = "curpos"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Current cursor position (about to be played)")
				form.CTS[item]:SetMin( 1 )
				form.CTS[item].Think = function( self )
					if not ValidEntity( LocalPlayer() ) then return end
					
					local found = ValidEntity(self.GunstrumentalObject)
					if not found then
						local tWeapons = LocalPlayer():GetWeapons()
						local iSearch = 1
						while not found and (iSearch <= #tWeapons) do
							if tWeapons[iSearch]:GetClass() == GUNSTRU_WeaponClassname then
								found = ValidEntity( self.GunstrumentalObject )
								self.GunstrumentalObject = tWeapons[iSearch]
								
							end
							
							iSearch = iSearch + 1
							
						end
						
					end
					if not found then return end
					
					form.CTS[item]:SetMax( form.CTS[item].form.MAX )
					form.CTS[item]:SetValue( self.GunstrumentalObject:RetreiveCursorPos() )
					
				
				end
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "advance"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Advance")
				form.CTS[item].OnMousePressed = function( self )
					RunConsoleCommand("+attack")
					self:MouseCapture( true )
					
				end
				form.CTS[item].OnMouseReleased = function( self )
					RunConsoleCommand("-attack")
					self:MouseCapture( false )
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "reload"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Reload weapon")
				form.CTS[item].OnMousePressed = function( self )
					RunConsoleCommand("+reload")
					self:MouseCapture( true )
					
				end
				form.CTS[item].OnMouseReleased = function( self )
					RunConsoleCommand("-reload")
					self:MouseCapture( false )
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "edit"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item].form = form
				form.CTS[item]:SetTall( 300 )
				form.CTS[item]:SetMultiline(true)
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "copy"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Copy to clipboard")
				form.CTS[item].DoClick = function( self )
					SetClipboardText( self.form.CTS["edit"]:GetValue() ) 
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "try"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Gunstrumentalize! (Remember to reload your weapon)")
				form.CTS[item].DoClick = function( self )
					local edit = string.Explode("\n", self.form.CTS["edit"]:GetValue())
					GUNSTRU:Gunstrumentalize(edit[1] or "", edit[2] or "")
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "help"
				form.CTS[item] = vgui.Create("DLabel", form)
				form.CTS[item]:SetText(
[[Create your own music here! (You should be using a text editor at the same time to perform safe saves)
The notation goes as this: c2d2e2f2g2a2b2c3d3e3f3....C3D3F3G3A3 where:
a4 (lowercase note) is denoted in real music sheets as A4
A4 (uppercase note) is denoted in real music sheets as A#4
.. (double dot) denotes a pause.

This is a valid Gunstrumental sheet for example: a3A3b3c4C4d4D4

These notes are valid:
(Gunstrumental  <-  Real music sheets)

... (any previously 1, 2)
a2  <-  A2
A2  <-  A#2
b2  <-  B2
c3  <-  C3
C3  <-  C#3
d3  <-  D3
D3  <-  D#3
e3  <-  E3
f3  <-  F3
F3  <-  F#3
g3  <-  G3
G3  <-  G#3

a3  <-  A3
A3  <-  A#3
b3  <-  B3
c4  <-  C4
C4  <-  C#4
... (and so on, 4, 5, 6...)

To create the second line of music (Blue notes), you can write it as the second line. If there are less notes in the second line than in the first tine, the sheet will be trimmed. In this case, use pauses .. for the music to substain.\nPlease note that if your pattern is short, loading your weapon may take less time, therefore your can reload your weapon earlier.]] )
				form.CTS[item]:SetWrap( true )
				form.CTS[item]:SetAutoStretchVertical( true )
				form:AddItem( form.CTS[item] )
				
			end
			
		end
		do
			local form = vgui.Create( "DPanelList" )
			form:EnableVerticalScrollbar( true )
			tabMaster._p_downloader = form
			form.CTS = {}
			do
				local item = "advance"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Advance")
				form.CTS[item].OnMousePressed = function( self )
					RunConsoleCommand("+attack")
					self:MouseCapture( true )
					
				end
				form.CTS[item].OnMouseReleased = function( self )
					RunConsoleCommand("-attack")
					self:MouseCapture( false )
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "reload"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Reload weapon")
				form.CTS[item].OnMousePressed = function( self )
					RunConsoleCommand("+reload")
					self:MouseCapture( true )
					
				end
				form.CTS[item].OnMouseReleased = function( self )
					RunConsoleCommand("-reload")
					self:MouseCapture( false )
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "edit"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item]:SetTall( 100 )
				form.CTS[item]:SetMultiline(true)
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "url"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				//form.CTS[item]:SetConVar("")
				form.CTS[item]:SetValue("http://pastebin.com/download.php?i=6pwchMF3")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "copy"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Load once")
				form.CTS[item].DoClick = function( self )
					http.Get(self.form.CTS["url"]:GetValue(), "", self.form.HttpCallBack, self) 
					
				end
				form.HttpCallBack = function (selfa, contents , size)
						selfa[1].form.CTS["edit"]:SetValue( contents )
						
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "copy"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Copy to clipboard")
				form.CTS[item].DoClick = function( self )
					SetClipboardText( self.form.CTS["edit"]:GetValue() ) 
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "try"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Gunstrumentalize! (Remember to reload your weapon)")
				form.CTS[item].DoClick = function( self )
					local edit = string.Explode("\n", self.form.CTS["edit"]:GetValue())
					GUNSTRU:Gunstrumentalize(edit[1] or "", edit[2] or "")
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "help"
				form.CTS[item] = vgui.Create("DLabel", form)
				form.CTS[item]:SetText( "Want to load a pattern from the web? Make sure the pattern is enclosed in some sort of text file (that is, there is no other web contents), like in Pastebin. Then, paste the link here and press Load once. It will try to load the contents of the page." )
				form.CTS[item]:SetWrap( true )
				form.CTS[item]:SetAutoStretchVertical( true )
				form:AddItem( form.CTS[item] )
				
			end
			
		end
		do
			local form = vgui.Create( "DPanelList" )
			form:EnableVerticalScrollbar( true )
			form.SWEPENT = self
			form.MAX = 0
			tabMaster._p_trimmer = form
			form.CTS = {}
			form.Think = function( self )
				form.MAX = math.floor( string.len( GUNSTRU:GetPattern( LocalPlayer(), 1 ) ) / 2 )
				
			end
			do
				local item = "curpos"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Current cursor position (about to be played)")
				form.CTS[item]:SetMin( 1 )
				form.CTS[item].Think = function( self )
					if not ValidEntity( LocalPlayer() ) then return end
					
					local found = ValidEntity(self.GunstrumentalObject)
					if not found then
						local tWeapons = LocalPlayer():GetWeapons()
						local iSearch = 1
						while not found and (iSearch <= #tWeapons) do
							if tWeapons[iSearch]:GetClass() == GUNSTRU_WeaponClassname then
								found = ValidEntity( self.GunstrumentalObject )
								self.GunstrumentalObject = tWeapons[iSearch]
								
							end
							
							iSearch = iSearch + 1
							
						end
						
					end
					if not found then return end
					
					form.CTS[item]:SetMax( form.CTS[item].form.MAX )
					form.CTS[item]:SetValue( self.GunstrumentalObject:RetreiveCursorPos() )
					
				
				end
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "advance"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Advance")
				form.CTS[item].OnMousePressed = function( self )
					RunConsoleCommand("+attack")
					self:MouseCapture( true )
					
				end
				form.CTS[item].OnMouseReleased = function( self )
					RunConsoleCommand("-attack")
					self:MouseCapture( false )
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "trimstart"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Trimmer Start")
				form.CTS[item]:SetMin( 1 )
				form.CTS[item]:SetValue( 1 )
				form.CTS[item].Think = function( self )
					form.CTS[item]:SetMax( form.CTS[item].form.MAX )
					
				end
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "trimend"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Trimmer End")
				form.CTS[item]:SetMin( 1 )
				form.CTS[item]:SetValue( 1 )
				form.CTS[item].Think = function( self )
					form.CTS[item]:SetMax( form.CTS[item].form.MAX )
					
				end
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "edit"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item].form = form
				form.CTS[item]:SetTall(100)
				form.CTS[item]:SetMultiline(true)
				form.CTS[item].Think = function( self )
					form.CTS[item]:SetValue(
						string.sub( GUNSTRU:GetPattern( LocalPlayer(), 1 ), self.form.CTS["trimstart"]:GetValue()*2-1, self.form.CTS["trimend"]:GetValue()*2 ) .. "\n" .. string.sub( GUNSTRU:GetPattern( LocalPlayer(), 2 ), self.form.CTS["trimstart"]:GetValue()*2-1, self.form.CTS["trimend"]:GetValue()*2 )
					)
					
				end
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "diff"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item].form = form
				form.CTS[item].Think = function( self )
					form.CTS[item]:SetValue(
						(self.form.CTS["trimend"]:GetValue() - self.form.CTS["trimstart"]:GetValue() + 1) * 2
					)
					
				end
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "copy"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Copy to clipboard")
				form.CTS[item].DoClick = function( self )
					SetClipboardText( self.form.CTS["edit"]:GetValue() ) 
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			
		end
		do
			local form = vgui.Create( "DPanelList" )
			form:EnableVerticalScrollbar( true )
			form.MAX = 0
			tabMaster._p_merger = form
			form.CTS = {}
			do
				local item = "first"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item].form = form
				form.CTS[item]:SetTall(50)
				form.CTS[item]:SetMultiline(true)
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "addpause"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Pause time between patterns")
				form.CTS[item]:SetMin( 0 )
				form.CTS[item]:SetMax( 100 )
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "second"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item].form = form
				form.CTS[item]:SetTall(50)
				form.CTS[item]:SetMultiline(true)
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "edit"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item].form = form
				form.CTS[item]:SetTall(100)
				form.CTS[item]:SetMultiline(true)
				form.CTS[item].Think = function( self )
					local first = string.Explode("\n", self.form.CTS["first"]:GetValue())
					local second = string.Explode("\n", self.form.CTS["second"]:GetValue())
					local rep = string.rep("..", self.form.CTS["addpause"]:GetValue() )
					form.CTS[item]:SetValue(
						(first[1] or "") .. rep .. (second[1] or "") .. "\n" ..
						(first[2] or "") .. rep .. (second[2] or "")
					)
					
				end
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "diff"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item].form = form
				form.CTS[item].Think = function( self )
					local alen = string.len( self.form.CTS["first"]:GetValue() ) / 2 - 1
					local blen = string.len( self.form.CTS["second"]:GetValue() ) / 2 - 1
					local diff = alen - blen
					form.CTS[item]:SetValue(
						alen .. " - ".. blen .. " = " .. diff
					)
					
				end
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "copy"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Copy to clipboard")
				form.CTS[item].DoClick = function( self )
					SetClipboardText( self.form.CTS["edit"]:GetValue() ) 
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "try"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Gunstrumentalize!")
				form.CTS[item].DoClick = function( self )
					local edit = string.Explode("\n", self.form.CTS["edit"]:GetValue())
					GUNSTRU:Gunstrumentalize(edit[1] or "", edit[2] or "")
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			
		end
		do
			local form = vgui.Create( "DPanelList" )
			form:EnableVerticalScrollbar( true )
			tabMaster._p_transposer = form
			form.CTS = {}
			do
				local item = "input"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item].form = form
				form.CTS[item]:SetTall(50)
				form.CTS[item]:SetMultiline(true)
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "distance"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Transpose")
				form.CTS[item]:SetMin( -5 )
				form.CTS[item]:SetMax( 5 )
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "smalldist"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Transpose (Octave)")
				form.CTS[item]:SetMin( -11 )
				form.CTS[item]:SetMax( 11 )
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "edit"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item].form = form
				form.CTS[item]:SetTall(100)
				form.CTS[item]:SetMultiline(true)
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "transpose"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Transpose now!")
				form.CTS[item].DoClick = function( self )
					local edit = string.Explode("\n", self.form.CTS["input"]:GetValue())
					local newa = ""
					local newb = ""
					if edit[1] then
						for i=1,(string.len( edit[1] ) / 2) do
							local str = string.sub( edit[1], i*2-1, i*2 )
							local inte = GUNSTRU:NoteToInteger(str, self.form.CTS["distance"]:GetValue()*12 + self.form.CTS["smalldist"]:GetValue() )
							newa = newa .. ( inte and GUNSTRU:IntegerToNote( inte ) or ".." )
							
						end
						
					end
					if edit[2] then
						for i=1,(string.len( edit[2] ) / 2) do
							local str = string.sub( edit[2], i*2-1, i*2 )
							local inte = GUNSTRU:NoteToInteger(str, self.form.CTS["distance"]:GetValue()*12 + self.form.CTS["smalldist"]:GetValue() )
							newb = newb .. ( inte and GUNSTRU:IntegerToNote( inte ) or ".." )
							
						end
						
					end
					self.form.CTS["edit"]:SetValue( newa .. "\n" .. newb )
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "copy"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Copy to clipboard")
				form.CTS[item].DoClick = function( self )
					SetClipboardText( self.form.CTS["edit"]:GetValue() ) 
					
				end
				form:AddItem( form.CTS[item] )
				
			end
		end
		do
			local form = vgui.Create( "DPanelList" )
			form:EnableVerticalScrollbar( true )
			tabMaster._p_portalizer = form
			form.CTS = {}
			do
				local item = "input"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item].form = form
				form.CTS[item]:SetTall(50)
				form.CTS[item]:SetMultiline(true)
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "edit"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item].form = form
				form.CTS[item]:SetTall(100)
				form.CTS[item]:SetMultiline(true)
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "portalize"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Portalize now!")
				form.CTS[item].DoClick = function( self )
					local edit = string.Explode("\n", self.form.CTS["input"]:GetValue())
					local newa = ""
					local newb = ""
					if edit[1] then
						local memory = ".."
						for i=1,(string.len( edit[1] ) / 2) do
							local str = string.sub( edit[1], i*2-1, i*2 )
							if str ~= ".." then 
								memory = str
							end
							newa = newa .. memory
							
						end
						
					end
					if edit[2] then
						local memory = ".."
						for i=1,(string.len( edit[2] ) / 2) do
							local str = string.sub( edit[2], i*2-1, i*2 )
							if str ~= ".." then 
								memory = str
							end
							newb = newb .. memory
							
						end
						
					end
					self.form.CTS["edit"]:SetValue( newa .. "\n" .. newb )
					
				end
				form:AddItem( form.CTS[item] )
				
				end
				do
				local item = "copy"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Copy to clipboard")
				form.CTS[item].DoClick = function( self )
					SetClipboardText( self.form.CTS["edit"]:GetValue() ) 
					
				end
				form:AddItem( form.CTS[item] )
				
			end
		end
		do
			local form = vgui.Create( "DPanelList" )
			form:EnableVerticalScrollbar( true )
			tabMaster._p_dilate = form
			form.CTS = {}
			do
				local item = "input"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item].form = form
				form.CTS[item]:SetTall(50)
				form.CTS[item]:SetMultiline(true)
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "edit"
				form.CTS[item] = vgui.Create("DTextEntry", form)
				form.CTS[item].form = form
				form.CTS[item]:SetTall(100)
				form.CTS[item]:SetMultiline(true)
				form.CTS[item]:SetConVar("")
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "dilate"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Dilate now!")
				form.CTS[item].DoClick = function( self )
					local edit = string.Explode("\n", self.form.CTS["input"]:GetValue())
					local newa = ""
					local newb = ""
					if edit[1] then
						for i=1,(string.len( edit[1] ) / 2) do
							local str = string.sub( edit[1], i*2-1, i*2 )
							newa = newa .. str .. ".."
							
						end
						
					end
					if edit[2] then
						for i=1,(string.len( edit[2] ) / 2) do
							local str = string.sub( edit[2], i*2-1, i*2 )
							newb = newb .. str .. ".."
							
						end
						
					end
					self.form.CTS["edit"]:SetValue( newa .. "\n" .. newb )
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "halve"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Halve now!")
				form.CTS[item].DoClick = function( self )
					local edit = string.Explode("\n", self.form.CTS["input"]:GetValue())
					local newa = ""
					local newb = ""
					if edit[1] then
						for i=1,(string.len( edit[1] ) / 2),2 do
							local str = string.sub( edit[1], i*2-1, i*2 )
							newa = newa .. str
							
						end
						
					end
					if edit[2] then
						for i=1,(string.len( edit[2] ) / 2),2 do
							local str = string.sub( edit[2], i*2-1, i*2 )
							newb = newb .. str
							
						end
						
					end
					self.form.CTS["edit"]:SetValue( newa .. "\n" .. newb )
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "copy"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Copy to clipboard")
				form.CTS[item].DoClick = function( self )
					SetClipboardText( self.form.CTS["edit"]:GetValue() ) 
					
				end
				form:AddItem( form.CTS[item] )
				
			end
		end
		
		tabMaster:AddSheet( "General", tabMaster._p_general, "gui/silkicons/application_view_detail", false, false, "General options." )
		tabMaster:AddSheet( "Instruments", tabMaster._p_instruments, "gui/silkicons/application_view_detail", false, false, "Tweak the way instruments sound like." )
		tabMaster:AddSheet( "Text downloader", tabMaster._p_downloader, "gui/silkicons/application_view_detail", false, false, "Get music from URLs here!" )
		tabMaster:AddSheet( "Maker", tabMaster._p_maker, "gui/silkicons/application_view_detail", false, false, "Make your own music here!" )
		tabMaster:AddSheet( "Trimmer", tabMaster._p_trimmer, "gui/silkicons/application_view_detail", false, false, "If you're experienced, use this tool to create mashups by trimming them!" )
		tabMaster:AddSheet( "Merger", tabMaster._p_merger, "gui/silkicons/application_view_detail", false, false, "Merge patterns together using this tool and try them!" )
		tabMaster:AddSheet( "Transposer", tabMaster._p_transposer, "gui/silkicons/application_view_detail", false, false, "You can transpose patterns here!" )
		tabMaster:AddSheet( "Portalizer", tabMaster._p_portalizer, "gui/silkicons/application_view_detail", false, false, "Make notes repeat, filling out .. spaces." )
		tabMaster:AddSheet( "Dilate/Halve", tabMaster._p_dilate, "gui/silkicons/application_view_detail", false, false, "Double the number of notes or halve it." )
		
		mainPanel._p_header = header
		mainPanel._p_tabMaster = tabMaster
		mainPanel._n_Spacing = 4
		
		mainPanel.PerformLayout = function( self )
			self:GetParent():StretchToParent( 1, 1, 1, 1 )
			self:StretchToParent( self._n_Spacing, self._n_Spacing, self._n_Spacing, self._n_Spacing )
			self._p_tabMaster:PerformLayout()
			self._p_tabMaster:Dock( FILL )
			self._p_header:Dock( TOP )
			
		end
		
		return mainPanel
		
	end

end

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//
//                                  DUE TO TOYBOX CODE BEING CONTAINED IN ONE SINGLE FILE
//     THIS BIG BLOCK IS SUPPOSED TO HELP SEEING THROUGH THE MESS OF CODE WHEN EDITING IT
//
// //  //  THE HANG PANEL
//
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

if CLIENT then
	local PANEL = {}
	
	AccessorFunc( PANEL, "m_bHangOpen", 	"HangOpen" )
	
	function PANEL:Init()		
		self.Canvas = vgui.Create( "DPanelList", self )
	   
		self.m_bHangOpen = false
	   
		self.Canvas:EnableVerticalScrollbar( true )
		self.Canvas:SetSpacing( 0 )
		self.Canvas:SetPadding( 5 )
		self.Canvas:SetDrawBackground( false )
		
		self:Close( )
		
	end
	
	function PANEL:GetCanvas( )
		return self.Canvas
		
	end
	
	function PANEL:SetContents( objPanel, obtb_NoUpdate )
		if not ValidPanel( objPanel ) then return end
		
		local oldContents = self._Contents
		if ValidPanel( oldContents ) then
			oldContents:SetParent( mil )
			
		end
		
		objPanel:SetParent( self )
		self._Contents = objPanel
		
		if not obtb_NoUpdate then
			self:UpdateContents()
			
		end
		
		return oldContents
		
	end
	
	function PANEL:GetContents()
		return self._Contents
		
	end
	
	function PANEL:UpdateContents()
		if not ValidPanel( self._Contents ) then return end
		
		self.Canvas:Clear()
		self.Canvas:AddItem( self._Contents )
		self.Canvas:Rebuild()
		
		self.Canvas:InvalidateLayout( true )
		self:InvalidateLayout( true )
		
	end
	
	function PANEL:Open( )
		self:SetHangOpen( false )
		
		if self:IsVisible() then return end
		
		RestoreCursorPosition()
		
		self:SetKeyboardInputEnabled( false )
		self:SetMouseInputEnabled( true )
		
		self:MakePopup()
		self:SetVisible( true )
		self:InvalidateLayout( true )
		
	end
	
	function PANEL:Close( )
		if ( self:GetHangOpen() ) then
			self:SetHangOpen( false )
			return
		end
		
		RememberCursorPosition()
		
		self:SetKeyboardInputEnabled( false )
		self:SetMouseInputEnabled( false )
		
		
		self:SetAlpha( 255 )
		self:SetVisible( false )
		
	end
	
	function PANEL:StartKeyFocus( pPanel )
		self:SetKeyboardInputEnabled( true )
		self:SetHangOpen( true )
		   
	end
	 
	function PANEL:EndKeyFocus( pPanel )
		self:SetKeyboardInputEnabled( false )
		
	end
	
	function PANEL:PerformLayout()
		if ( self.Contents ) then
			self.Contents:InvalidateLayout( true )
		
		end
		
		self.Canvas:StretchToParent( 0, 0, 0, 0 )
		self.Canvas:InvalidateLayout( true )
		
	end
	
	vgui.Register( "GS_MENU", PANEL, "EditablePanel" )
	
end
