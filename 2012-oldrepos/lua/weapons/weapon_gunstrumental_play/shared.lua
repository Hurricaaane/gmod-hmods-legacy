do return end

--[[
Some parts of the code are PIECE OF SHIT
that are tied to the SWEP object
while it shouldn't even be tied to it in the first place
]]--
local GUNSTRU = {}

-- Globalize this so that other scripts can read it
GUNSTRUMENTAL_NUM_VARS = 100
GUNSTRU.NUM_VARS = GUNSTRUMENTAL_NUM_VARS

SWEP.GUNSTRUMENTAL_NUM_VARS = GUNSTRUMENTAL_NUM_VARS //TOREMOVE

SWEP.NumPatterns = 2
SWEP.CachedPatterns = {}
SWEP.HitRatios = {}
SWEP.ReloadTime = 0

for n = 1, SWEP.NumPatterns do
	SWEP.CachedPatterns[n] = ""
	SWEP.HitRatios[n] = 0
	
	if CLIENT then
		local char = string.char( 97 - 1 + n )
		for i = 1, SWEP.GUNSTRUMENTAL_NUM_VARS do
			CreateClientConVar("gs_zz" .. char .. "pat" .. i, "", true, true)
		end
		
	end
	
end

if CLIENT then
	SWEP.PrintName			= "Gunstrumental Playa"
	SWEP.Author				= "Hurricaaane (Ha3)"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 5
	SWEP.IconLetter			= "b"
	
	SWEP.LastCursorPos = -1
	SWEP.LastCursorCurTime = 0
	
	SWEP.MenuOpened = false
	
	CreateClientConVar("gs_rcautoplay", "0", true, true)
	
	CreateClientConVar("gs_offsets", "0", true, true)
	CreateClientConVar("gs_volume", "50", true, true)
	CreateClientConVar("gs_tempo", "400", true, true)
	
	CreateClientConVar("gs_aoffset", "0", true, true)
	CreateClientConVar("gs_atrans", "0", true, true)
	CreateClientConVar("gs_asound", "gunstrumental1.wav", true, true)
	
	CreateClientConVar("gs_boffset", "-4", true, true)
	CreateClientConVar("gs_btrans", "3", true, true)
	CreateClientConVar("gs_bsound", "musicbox2.wav", true, true)
	
	CreateClientConVar("gs_rcdisplay", 32, true, true)
	CreateClientConVar("gs_rchold", 0, true, true)
	
end

if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.Cursor = 1
	SWEP.CursorBackingPos = 1
	SWEP.NeedsInit = true
	
end

SWEP.Category			= "Misc :: Ha3"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"
SWEP.HoldType			= "pistol"

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true

function SWEP:GetPrimaryDelay()
	//TODO : Tempo = 0
	local tempo = self.Owner:GetInfoNum("gs_tempo")
	return (tempo < 60) and 1 or (60 / tempo)
	
end

function SWEP:GetSecondaryDelay()
	return self:GetPrimaryDelay()
	
end

function SWEP:Deploy()
	return true
	
end

function SWEP:Initialize() 
	
end 

function SWEP:ShootEffects()
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
end

local DAMAGE_MUL = 2

function SWEP:FireA()
	local num_bullets = 1
	local damage = 15 * self:GetHitRatio( 1 ) * self:GetPrimaryDelay() * DAMAGE_MUL
	local aimcone = 0
	
	//print( "A:" .. damage )
	
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
	self.Weapon:ShootEffects()
	
end


function SWEP:FireB()
	local num_bullets = 1
	local damage = 5 * self:GetHitRatio( 1 ) * self:GetPrimaryDelay() * DAMAGE_MUL
	local aimcone = 0
	
	//print( "B:" .. damage )
	
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
	self.Weapon:ShootEffects()
	
end

function SWEP:PrimaryAttack()
	if CLIENT then return false end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self:GetPrimaryDelay() )
	
	if self:PrimaryPattern( ) 		then self:FireA() end
	if self:HarmonicsPattern( ) 	then self:FireB() end
	
	self:IncrementPattern( )
	
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
	//print(CLIENT, "LOLZ")
	if SERVER then
		self.Cursor = self.CursorBackingPos
		self:ApplyCursorPos( )
		
	end
	
	local deltaTime = CurTime() - self.ReloadTime
	if (SERVER and (deltaTime > 1)) or (CLIENT and (deltaTime > 0.5)) then
		self.ReloadTime = CurTime()
		self:RequirePatternUpdate()
		
	end
	
	return false
end

function SWEP:Think()
	if CLIENT then
		if LocalPlayer():KeyPressed( IN_RELOAD ) then
			//print("aaa")
			local deltaTime = CurTime() - self.ReloadTime
			if (deltaTime > 0.5) then
				self.ReloadTime = CurTime()
				self:RequirePatternUpdate()
				//print("bbb")
				
			end
			
		end
		
		if self.Owner:KeyPressed(IN_ATTACK2) then
			self:OpenMenu()
			
		end
		
		if (GetConVarNumber("gs_rchold") == 0) and self.Owner:KeyReleased(IN_ATTACK2) then
			self:CloseMenu()
		
		end
		
		if self.LastCursorPos == -1 then
			timer.Simple(1.5, function(self) if ValidEntity(self) then self:RequirePatternUpdate() end end, self )
			
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
			timer.Simple(1.5, function(self) if ValidEntity(self) then self:RequirePatternUpdate() end end, self )
			
		end
		
	end
	
end

function SWEP:RequirePatternUpdate()
	for n = 1, self.NumPatterns do
		self.CachedPatterns[ n ] = self:RetreivePattern( n )
		
		local len = string.len( self.CachedPatterns[ n ] )
		if (len < 2) or ((len % 2) == 1) then
			self.CachedPatterns[ n ] = ""
			
		else
			self.HitRatios[ n ] = self:FindHitRatio( self.CachedPatterns[ n ] )
			
		end
		
	end
	
end

function SWEP:FindHitRatio( sPattern )
	local patternLength = string.len( sPattern )
	local hits = 0
	
	for i = 1, patternLength/2 do
		local sNote = string.sub( sPattern, i * 2 - 1, i * 2)
		local bIsValid = self:GetToneNumber( sNote, 0 ) and true or false
		//print( sNote )
			
		if bIsValid then
			hits = hits + 1
			
		end
		
	end
	
	return (hits > 0) and (patternLength * 0.5 / hits) or 0
	
end


function SWEP:GetHitRatio( iNum )
	return self.HitRatios[ iNum ]
	
end

function SWEP:ApplyCursorPos( )
	self:SetDTInt( 0, self.Cursor - 1 )
	
end

function SWEP:RetreiveCursorPos( )
	return self:GetDTInt( 0, self.Cursor ) + 1
	
end

function SWEP:RetreivePattern( iNum )
	local char = string.char( 97 - 1 + iNum )
	local sPattern = ""
	for i = 1, self.GUNSTRUMENTAL_NUM_VARS do
		if SERVER then
			sPattern = sPattern .. self.Owner:GetInfo( "gs_zz".. char .. "pat" .. i )
			
		else
			sPattern = sPattern .. GetConVarString( "gs_zz".. char .. "pat" .. i )
			
		end
		
	end
	
	return sPattern
	
end


function SWEP:RetreiveOffset( iNum )
	local char = string.char( 97 - 1 + iNum )
	
	return self.Owner:GetInfo( "gs_".. char .. "offset" )
	
end

function SWEP:RetreiveTrans( iNum )
	local char = string.char( 97 - 1 + iNum )
	
	return self.Owner:GetInfo( "gs_".. char .. "trans" ) * 12
	
end

local PBBASE = "aAbcCdDefFgG" -- 12 BASE
function SWEP:IntegerToNote( a_four_base )
	local PBI = a_four_base % 12 + 1
	local PBI_L = string.sub( PBBASE, PBI, PBI )
	
	local OOC = 5 + math.floor( (a_four_base - 3) / 12 )
	
	return PBI_L .. OOC
	
end

function SWEP:RetreiveSound( iNum )
	local char = string.char( 97 - 1 + iNum )
	
	return self.Owner:GetInfo( "gs_".. char .. "sound" )
	
end

function SWEP:GetPattern( iNum )
	--return self.CachedPatterns[ string.byte( sName ) - 97 + 1 ]
	return self.CachedPatterns[ iNum ]
	
end

function SWEP:IncrementPattern( )
	local sPattern = self:GetPattern( 1 )
	local sPatternLength = string.len( sPattern )
	
	self.Cursor = self.Cursor + 1
	
	if self.Cursor >= (1 + sPatternLength / 2) then
		self.Cursor = 1
		
	end
	self:ApplyCursorPos( )
	
end

function SWEP:PrimaryPattern( )
	local sPattern = self:GetPattern( 1 )
	local iOffs = self.Owner:GetInfoNum("gs_aoffset") + self.Owner:GetInfoNum("gs_offsets") + self:RetreiveTrans( 1 )
	local sPatternLength = string.len( sPattern )
	
	-- Is sPattern valid ?
	if (sPatternLength < 2) or ((sPatternLength % 2) == 1) then return false end
	
	--- Compressed
	local sNote = string.sub( sPattern, self.Cursor * 2 - 1, self.Cursor * 2)
	local pitch = self:GetTonePitch( sNote, iOffs )
	--local pitch = self:GetTonePitch( string.sub( sPattern, self.Cursor * 2 - 1, self.Cursor * 2), iOffs )
	
	if pitch then
		if pitch <= 255 then
			self.Weapon:EmitSound( self.Owner:GetInfo("gs_asound"), self.Owner:GetInfoNum("gs_volume"), pitch )
			
		else
			print( "Tried to play note ".. sNote .." which is, with offsets ".. iOffs .. " too high to be played (" .. math.floor(pitch) .. ") !")
			
		end
		
	end
	
	return pitch ~= nil
	
end

function SWEP:HarmonicsPattern( )
	local sPattern = self:GetPattern( 2 )
	local iOffs = self.Owner:GetInfoNum("gs_boffset") + self.Owner:GetInfoNum("gs_offsets") + self:RetreiveTrans( 2 )
	local sPatternLength = string.len( sPattern )

	-- Is sPattern valid ?
	if (sPatternLength < 2) or ((sPatternLength % 2) == 1) then return false end
	
	local pitch = self:GetTonePitch( string.sub( sPattern, self.Cursor * 2 - 1, self.Cursor * 2), iOffs )
	
	if pitch then
		self.Weapon:EmitSound( self.Owner:GetInfo("gs_bsound"), self.Owner:GetInfoNum("gs_volume"), pitch )
	end
	
	return pitch ~= nil
	
end

function SWEP:GetToneNumber( sNote, optiOffs )
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

function SWEP:GetTonePitch( sNote, optiOffs )	
	local iNum = self:GetToneNumber( sNote, optiOffs )
	if not iNum then return end
	
	return 2 ^ ( iNum / 12 ) * 100
	
end

if CLIENT then
	local PATTERN_COLPRE  = { Color( 164, 255, 64, 255)	, Color( 64, 164, 255, 255)			}
	local PATTERN_COLPASS = { Color( 255, 255, 0, 255)	, Color( 255, 128, 0, 255) 	}
	local PATTERN_COLIMPOSSIBLE = { Color( 255, 0, 0, 255 ) }
	//local PATTERN_VISRANGEPRE 		= 32*2
	//local PATTERN_VISRANGEPASS 	= 16*2
	local PATTERN_NOTE_TEXID = surface.GetTextureID("ha3mats/beacon_flare_add")
	
	function SWEP:DrawHUD()
		self:DrawPatterns()
		
	end
	
	function SWEP:DrawPatterns()
		local PATTERN_VISRANGEPRE 		= GetConVarNumber("gs_rcdisplay") * 2
		local PATTERN_VISRANGEPASS 	= GetConVarNumber("gs_rcdisplay") // * 2 / 2
	
		local pos = self:RetreiveCursorPos()
		local offs = self.Owner:GetInfoNum("gs_offsets")
		
		surface.SetTexture( PATTERN_NOTE_TEXID )
		
		local decreaser = 1 - (CurTime() - self.LastCursorCurTime) / self:GetPrimaryDelay()
		decreaser = (decreaser > 0) and decreaser or 0
		
		for n = 1, self.NumPatterns do
			local pattern = self:GetPattern( n )
			local patternLength = string.len( pattern )
			local patOffs = offs + self:RetreiveOffset( n ) + self:RetreiveTrans( n )
			//print( patternLength )
			
			for i = math.max(1, pos - PATTERN_VISRANGEPASS), math.min(pos + PATTERN_VISRANGEPRE, patternLength/2 + 1) do
				local rel = pos - i
				local sNote = string.sub( pattern, i*2 - 1, i*2 )
				//print( sNote )
				local high = self:GetToneNumber( sNote, 0 )
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
					
					//local ped = rel / (PATTERN_VISRANGEPRE + PATTERN_VISRANGEPASS)
					
					local isPossible = (high + patOffs) <= 16
					
					surface.SetDrawColor( isPossible and (isPre and PATTERN_COLPRE[n] or PATTERN_COLPASS[n]) or PATTERN_COLIMPOSSIBLE[1] )
					surface.DrawTexturedRectRotated(
						//ScrW() / 2 - rel * ScrW() / 320,
						//ScrH() / 8 - high * ScrH() / 512,
						--ScrW() / 2 - (rel * math.floor(ScrW() / 320) - math.floor(decreaser * ScrW() / 320)),
						ScrW() / 2 - (rel * math.floor(ScrW() / 320) - math.floor(decreaser * ScrW() / 320)),
						//ScrW() / 2 - math.floor(ped * math.floor(ScrW() / 3) - math.floor(decreaser * ScrW() / 3 * 1 / (PATTERN_VISRANGEPRE + PATTERN_VISRANGEPASS))),
						ScrH() * 0.17 - high * ScrH() / 192,
						ScrH() / 64 * ((isPre and 2 or 1.5)*ashrive + add * 2),
						ScrH() / 64 * ((isPre and 2 or 1.5)*ashrive + add * 2),
						45 + add * 180
					)
					
				end
				
			end
			
		end
		
	end
	
	
end

function SWEP:Gunstrumentalize( tab, harmonics )
	
	local tablen = string.len( tab )
	local harmonicslen = string.len( harmonics )
	
	if tablen < harmonicslen then
		tab = tab .. string.rep(".", harmonicslen -  tablen)
		
	elseif harmonicslen < tablen then
		harmonics = harmonics .. string.rep(".", tablen -  harmonicslen)
	
	end
	
	local tabpos = 1
	local iPattern = 1
	while iPattern <= self.GUNSTRUMENTAL_NUM_VARS do
		if tabpos < tablen then
			RunConsoleCommand("gs_zzapat"..iPattern, string.sub( tab, tabpos, tabpos + 99 ) )
			RunConsoleCommand("gs_zzbpat"..iPattern, string.sub( harmonics, tabpos, tabpos + 99 ) )
			tabpos = tabpos + 100
			
		else
			RunConsoleCommand("gs_zzapat"..iPattern, "" )
			RunConsoleCommand("gs_zzbpat"..iPattern, "" )
			
		end
			
		iPattern = iPattern + 1
	end
	
end

function SWEP:Remove()
	if CLIENT then
		self:RemoveMenu()
		
	end
	
end

function SWEP:Holster()
	if CLIENT then
		self:CloseMenu()
		
	end
	return true
	
end

function SWEP:RemoveMenu()
	if self.HangMenu then
		self.HangMenu:Remove()
		
	end
	self.HangMenu = nil
	
end

if CLIENT then
	local PATTERN_MENU = nil
	
	local function GS_HGetFocus( panel )
		print("test")
		if not ValidPanel( PATTERN_MENU ) then return end
		if panel:HasParent( PATTERN_MENU ) then
			PATTERN_MENU:StartKeyFocus()
		end
		
	end
	
	local function GS_HLoseFocus( panel )
		if not ValidPanel( PATTERN_MENU ) then return end
		if panel:HasParent( PATTERN_MENU ) then
			PATTERN_MENU:EndKeyFocus()
		end
		
	end

	hook.Remove( "OnTextEntryGetFocus", "GS_HGetFocus" )
	hook.Remove( "OnTextEntryLoseFocus", "GS_HLoseFocus" )

	hook.Add( "OnTextEntryGetFocus", "GS_HGetFocus", GS_HGetFocus )
	hook.Add( "OnTextEntryLoseFocus", "GS_HLoseFocus", GS_HLoseFocus )
	
	function SWEP:OpenMenu()
		self:MakeMenu()
		self:GetMenu():Open()
		
	end
	
	function SWEP:CloseMenu()
		self:GetMenu():Close()
		
	end
	
	function SWEP:GetMenu()
		return self.HangMenu or self:BuildMenu()
		
	end
	
	function SWEP:BuildMenu()
		if self.HangMenu then
			self:RemoveMenu()
			
		end
			
		self.HangMenu = vgui.Create( "GS_MENU" )
		self.HangMenu.LIFE = self
		PATTERN_MENU = self.HangMenu
		
		return self.HangMenu
		
	end
	
	function SWEP:MakeMenu( )
		if not self:GetMenu():GetContents() then
			self:GetMenu():SetContents( self:BuildContents() )
			self:GetMenu():UpdateContents()
		end
		
	end
	
	function SWEP:BuildContents()
		self.HangMenu:SetSize( 480, ScrH() / 2 - 64 )
		self.HangMenu:SetPos( (ScrW() - self.HangMenu:GetWide()) / 2, ScrH() - self.HangMenu:GetTall() - 32 )
		self.HangMenu.Paint = function (self)
			surface.SetDrawColor( 0, 0, 0, 96 )
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
		end
		
		local mainPanel = vgui.Create( "DPanel" )
		mainPanel.Paint = function (self)
			surface.SetDrawColor( 0, 0, 0, 96 )
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
		end
		
		local tabMaster = vgui.Create( "DPropertySheet", mainPanel )
		
		do
			local form = vgui.Create( "DPanelList" )
			form:EnableVerticalScrollbar( true )
			tabMaster._p_general = form
			form.CTS = {}
			do
				local item = "closer"
				form.CTS[item] = vgui.Create("DButton", form)
				form.CTS[item].SWEPENT = self
				form.CTS[item].form = form
				form.CTS[item]:SetText("Close")
				form.CTS[item].DoClick = function( self )
					self.SWEPENT:CloseMenu()
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "rcautoplay"
				form.CTS[item] = vgui.Create("DCheckBoxLabel", form)
				form.CTS[item]:SetText("Hold menu open after right-clicking")
				form.CTS[item]:SetConVar( "gs_rchold" )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "rcautoplay"
				form.CTS[item] = vgui.Create("DCheckBoxLabel", form)
				form.CTS[item]:SetText("Autoplay when this menu is displayed")
				form.CTS[item]:SetConVar( "gs_rcautoplay" )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "tempo"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item]:SetText("Tempo")
				form.CTS[item]:SetMin( 100 )
				form.CTS[item]:SetMax( 2600 )
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar( "gs_tempo" )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "offsets"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item]:SetText("Global Transposition")
				form.CTS[item]:SetMin( -20 )
				form.CTS[item]:SetMax( 20 )
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar( "gs_offsets" )
				form:AddItem( form.CTS[item] )
				
			end
			
		end
		do
			local form = vgui.Create( "DPanelList" )
			form:EnableVerticalScrollbar( true )
			tabMaster._p_instruments = form
			form.CTS = {}
			do
				local sets = {}
				table.insert( sets,
					{ "Gunstrumental",
						"gunstrumental1.wav"	, 0,
						"musicbox2.wav"			, -4
					} )
				table.insert( sets,
					{ "Piano",
						"piano_f3.wav"	, 0,
						"piano_f3_2.wav"			, 0
					} )
				table.insert( sets,
					{ "Bonk",
						"vo/scout_specialcompleted03.wav"	, 0,
						"vo/scout_specialcompleted02.wav"	, -1
					} )
				table.insert( sets,
					{ "Music Box",
						"musicbox1.wav"	, 0,
						"musicbox2.wav"			, 0
					} )
				table.insert( sets,
					{ "SMG / AR2",
						"weapons/smg1/smg1_fire1.wav"	, 0,
						"weapons/ar2/fire1.wav"	, 0
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
				form.CTS[item]:SetText("Primary Pattern height adjustment")
				form.CTS[item]:SetMin( -11 )
				form.CTS[item]:SetMax( 11 )
				form.CTS[item]:SetDecimals( 0 )
				form.CTS[item]:SetConVar( "gs_aoffset" )
				form:AddItem( form.CTS[item] )
				
			end
			do
				local item = "boffset"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item]:SetText("Secondary Pattern height adjustment")
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
			form.SWEPENT = self
			form.MAX = 0
			tabMaster._p_trimmer = form
			form.CTS = {}
			form.Think = function( self )
				form.MAX = string.len( self.SWEPENT:GetPattern( 1 ) )
				
			end
			do
				local item = "curpos"
				form.CTS[item] = vgui.Create("DNumSlider", form)
				form.CTS[item].form = form
				form.CTS[item]:SetText("Current cursor position (about to be played)")
				form.CTS[item]:SetMin( 1 )
				form.CTS[item].Think = function( self )
					form.CTS[item]:SetMax( form.CTS[item].form.MAX )
					form.CTS[item]:SetValue( form.CTS[item].form.SWEPENT:RetreiveCursorPos() )
					
				
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
					
				end
				form.CTS[item].OnMouseReleased = function( self )
					RunConsoleCommand("-attack")
					
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
						string.sub( self.form.SWEPENT:GetPattern(1), self.form.CTS["trimstart"]:GetValue()*2-1, self.form.CTS["trimend"]:GetValue()*2 ) .. "\n" .. string.sub( self.form.SWEPENT:GetPattern(2), self.form.CTS["trimstart"]:GetValue()*2-1, self.form.CTS["trimend"]:GetValue()*2 )
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
			form.SWEPENT = self
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
					self.form.SWEPENT:Gunstrumentalize(edit[1] or "", edit[2] or "")
					
				end
				form:AddItem( form.CTS[item] )
				
			end
			
		end
		do
			local form = vgui.Create( "DPanelList" )
			form:EnableVerticalScrollbar( true )
			form.SWEPENT = self
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
				form.CTS[item]:SetText("Transpose now")
				form.CTS[item].DoClick = function( self )
					local edit = string.Explode("\n", self.form.CTS["input"]:GetValue())
					local newa = ""
					local newb = ""
					if edit[1] then
						for i=1,(string.len( edit[1] ) / 2) do
							local str = string.sub( edit[1], i*2-1, i*2 )
							local inte = self.form.SWEPENT:GetToneNumber(str, self.form.CTS["distance"]:GetValue()*12 )
							newa = newa .. ( inte and self.form.SWEPENT:IntegerToNote( inte ) or ".." )
							
						end
						
					end
					if edit[2] then
						for i=1,(string.len( edit[2] ) / 2) do
							local str = string.sub( edit[2], i*2-1, i*2 )
							local inte = self.form.SWEPENT:GetToneNumber(str, self.form.CTS["distance"]:GetValue()*12 )
							newb = newb .. ( inte and self.form.SWEPENT:IntegerToNote( inte ) or ".." )
							
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
		tabMaster:AddSheet( "Trimmer", tabMaster._p_trimmer, "gui/silkicons/application_view_detail", false, false, "If you're experienced, use this tool to create mashups by trimming them!" )
		tabMaster:AddSheet( "Merger", tabMaster._p_merger, "gui/silkicons/application_view_detail", false, false, "Merge patterns together using this tool and try them!" )
		tabMaster:AddSheet( "Transposer", tabMaster._p_transposer, "gui/silkicons/application_view_detail", false, false, "You can transpose patterns here!" )
		
		mainPanel._p_tabMaster = tabMaster
		mainPanel._n_Spacing = 4
		
		mainPanel.PerformLayout = function( self )
			self:GetParent():StretchToParent( 1, 1, 1, 1 )
			self:StretchToParent( self._n_Spacing, self._n_Spacing, self._n_Spacing, self._n_Spacing )
			self._p_tabMaster:PerformLayout()
			self._p_tabMaster:Dock( FILL )
			
		end
		
		return mainPanel
		
	end

end

if CLIENT then
	local PANEL = {}

	AccessorFunc( PANEL, "m_bHangOpen", 	"HangOpen" )

	function PANEL:Init()
		self.animIn = Derma_Anim( "OpenAnim", self, self.OpenAnim )
		self.animOut = Derma_Anim( "CloseAnim", self, self.CloseAnim )
		
		self.Canvas = vgui.Create( "DPanelList", self )
	   
		self.m_bHangOpen = false
	   
		self.Canvas:EnableVerticalScrollbar( true )
		self.Canvas:SetSpacing( 0 )
		self.Canvas:SetPadding( 5 )
		self.Canvas:SetDrawBackground( false )
		
		// LOL ADDED.
		self:Close( true )
		
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
		
		/*self.animOut:Stop()
		self.animIn:Stop()
		
		self.animIn:Start( 0.1, { TargetY = self.y } )*/

	end

	function PANEL:Close( bSkipAnim )
		debug.Trace()
		print("try")
		if ( self:GetHangOpen() ) then
			print("skip")
			self:SetHangOpen( false )
			return
		end
		
		RememberCursorPosition()

		self:SetKeyboardInputEnabled( false )
		self:SetMouseInputEnabled( false )
		
		self.animIn:Stop()
		
		//if ( bSkipAnim ) then
		
			self:SetAlpha( 255 )
			self:SetVisible( false )
			
		/*else
		
			self.animOut:Start( 0.1, { StartY = self.y } )
			
		end*/

	end
	
	function PANEL:Think()
		////////
		if not ValidEntity( self.LIFE ) then self:Remove() return end
		
		//self.animIn:Run()
		//self.animOut:Run()
		
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
		
		//self.animIn:Run()
		//self.animOut:Run()

	end

	function PANEL:OpenAnim( anim, delta, data )
		
		if ( anim.Finished ) then
			self.y = data.TargetY
			return
			
		end
		
		--local Distance = ScrW() - data.TargetX
		local Distance = ScrH() - data.TargetY
		
		self.y = data.TargetY + Distance - Distance * ( delta ^ 0.1 )

	end

	function PANEL:CloseAnim( anim, delta, data )
		
		if ( anim.Finished ) then
			self.y = data.StartY
			self:SetVisible( false )
			return
			
		end
		
		--local Distance = ScrW() - data.StartX
		local Distance = ScrH() - data.StartY
		
		self.y = data.StartY + Distance * ( delta ^ 2 )

	end


	vgui.Register( "GS_MENU", PANEL, "EditablePanel" )

end

