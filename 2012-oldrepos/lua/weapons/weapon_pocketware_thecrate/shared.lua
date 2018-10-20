if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	
end

SWEP.Category			= "Misc :: Ha3"
SWEP.PrintName			= "PocketWare: Crate Size!"
SWEP.Author				= "Hurricaaane (Ha3)"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/v_IRifle.mdl"
SWEP.WorldModel			= "models/weapons/w_IRifle.mdl"
SWEP.HoldType			= "pistol"

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true

SWEP.Sounds = {}
SWEP.Sounds["pocketware_everyonelose"] 	= "pocketware_stings/everyone_lose2.wav"
SWEP.Sounds["pocketware_everyonewon"] 	= "pocketware_stings/everyone_won3.wav"
SWEP.Sounds["pocketware_new"] 			= { "pocketware_stings/exp_game_new_1.mp3",
											"pocketware_stings/exp_game_new_2.mp3",
											"pocketware_stings/exp_game_new_3.mp3",
											"pocketware_stings/exp_game_new_4.mp3",
											"pocketware_stings/exp_game_new_5.mp3", }
SWEP.Sounds["pocketware_win"] 			= { "pocketware_stings/exp_game_win_1.mp3",
											"pocketware_stings/exp_game_win_2.mp3",
											"pocketware_stings/exp_game_win_3.mp3" }
SWEP.Sounds["pocketware_lose"] 			= { "pocketware_stings/exp_game_lose_1.mp3",
											"pocketware_stings/exp_game_lose_2.mp3",
											"pocketware_stings/exp_game_lose_3.mp3" }
SWEP.Sounds["pocketware_music"] 		= "pocketware_stings/exp_loop_2.wav"
SWEP.Sounds["pocketware_begin"] 		= "pocketware_stings/game_begin.wav"
SWEP.Sounds["pocketware_localwin"] 		= { "pocketware_stings/local_exo_won1.wav",
											"pocketware_stings/local_exo_won2.wav" }
SWEP.Sounds["pocketware_locallose"] 	= { "pocketware_stings/local_lose2.wav",
											"pocketware_stings/local_lose3.wav",
											"pocketware_stings/local_lose4.wav" }

											
SWEP.Sounds["blaster_fire"]	= "weapons/Irifle/irifle_fire2.wav"
SWEP.Sounds["flare_fire"]	= "weapons/flaregun/fire.wav"

function SWEP:PrecacheSounds( tObjString )
	for k,obj in pairs( tObjString ) do
		if type( obj ) == "table" then
			self:PrecacheSounds( obj )
			
		elseif type( obj ) == "string" then
			Sound( obj )
			
		end
		
	end
	
end

function SWEP:SoundToString( tObjString )
	if type( tObjString ) == "table" then
		return self:SoundToString( tObjString[ math.random( 1, #tObjString ) ] )
	
	elseif type( tObjString ) == "string" then
		return tObjString
	
	end
	
	return ""
	
end

local SWEPLOC = SWEP //WTF
local function GetSound( sIdentifier )
	return SWEPLOC:GetSound( sIdentifier )
	
end

function SWEP:GetSound( sIdentifier )
	return self:SoundToString( self.Sounds[sIdentifier] )
	
end

function SWEP:Initialize() 
	if CLIENT then self:PrecacheSounds( self.Sounds ) end
	
end 

function SWEP:ShootEffects()
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

end

function SWEP:GetPrimaryDelay()
	return 0.85
end

function SWEP:PrimaryAttack()
	if SERVER then
		//GetWareEngine():SetAchieved( self.Owner, true )
		//GetWareEngine():ApplyLock( self.Owner )
		
		self:EmitSound( self:GetSound("blaster_fire") )
		self:EmitSound( self:GetSound("flare_fire") )
		self.Weapon:SetNextPrimaryFire( CurTime() + self:GetPrimaryDelay() )
		
		local bullet = {}
		bullet.Num 		= 1
		bullet.Src 		= self.Owner:GetShootPos()
		bullet.Dir 		= self.Owner:GetAimVector()
		bullet.Spread 	= Vector( 0, 0, 0 )
		bullet.Tracer	= 1
		bullet.TracerName = "AirboatGunHeavyTracer"
		bullet.Force	= 1500
		bullet.Damage	= 200
		bullet.AmmoType = "Pistol"
	 
		self.Owner:FireBullets( bullet )
		self.Weapon:ShootEffects()
	end
	
	return true
end

function SWEP:SecondaryAttack()
	return false
	
end

do
	local WARE_RULES = {}
	SWEP.WARE_RULES = WARE_RULES
	
	local WARE_TEMP = {}
	SWEP.WARE_TEMP = WARE_TEMP
	
	local WARE = {}
	WARE_RULES.HOOKS = WARE
	
	function WARE:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )
		if (ent:GetClass() == "pocketware_sizablebox") and (amount > ent:Health()) then
			if ent.Winner then
				GetWareEngine():SetAchieved( killer, true )
				GetWareEngine():ApplyLock( killer )
				ent:GetPhysicsObject():ApplyForceCenter( Vector(0, 0, 150)*100 )
				ent:GetPhysicsObject():AddAngleVelocity(Angle(math.random(-600,600),math.random(-600,600),math.random(-600,600))) 
				ent:SetColor( 255, 255, 0, 255 )
				
			else
				GetWareEngine():SetAchieved( killer, false )
				GetWareEngine():ApplyLock( killer )
				
				ent:GetPhysicsObject():ApplyForceCenter( Vector(0, 0, 100)*50 )
				ent:GetPhysicsObject():AddAngleVelocity(Angle(math.random(-600,600),math.random(-600,600),math.random(-600,600))) 
				ent:SetColor( 255, 0, 0, 255 )
				
				GetWareTemp().Winner:GetPhysicsObject():ApplyForceCenter( Vector(0, 0, 150)*100 )
				GetWareTemp().Winner:GetPhysicsObject():AddAngleVelocity(Angle(math.random(-600,600),math.random(-600,600),math.random(-600,600))) 
				GetWareTemp().Winner:SetColor( 255, 255, 0, 255 )
				
			end
			
		end
		
		return true
		
	end
	
end


function SWEP:Reload()
	return false
	
end

function SWEP:Deploy()
	if SERVER then	
		GetWareEngine():Prepare( )
		local WARE_TEMP = GetWareTemp()
		
		local tracedata = {}
		tracedata.start = self.Owner:GetPos() + Vector(0,0,32)
		tracedata.filter = self.Owner
		
		local iter = 0
		local canBegin = false
		local foundMax = false
		local up = Vector(0, 0, 1)
		
		local minToFind = 5
		local maxToFind = 20
		local tryToFind = math.random( minToFind, maxToFind )
		
		local savedPos = {}
		
		repeat
			tracedata.endpos = tracedata.start + Angle( math.random(5, 10), self.Owner:GetAngles().y + math.random(-50, 50), 0 ):Forward() * 1024
			local traceres = util.TraceLine( tracedata )
			if traceres.HitWorld and traceres.HitNormal:DotProduct( up ) > 0.2 then
				local mindist = 1024
				for k,pos in pairs( savedPos ) do
					mindist = math.min( traceres.HitPos:Distance( pos ), mindist )
					
				end
				
				if mindist > 72 then
					table.insert( savedPos, traceres.HitPos )
					
				end
				
				if #savedPos >= minToFind then
					canBegin = true
				
				end
				if #savedPos == tryToFind then
					foundMax = true
					
				end
				
			end
			iter = iter + 1
			
		until (foundMax or iter > 100)
		
		if canBegin then
			local WareEngine = GetWareEngine()
			WareEngine:Begin( self.Owner, self.WARE_RULES )
			WARE_TEMP.UseMax = math.random(0, 1) > 0
			
			local sizes = {}
			local initSize = math.random(16, 32)
			table.insert( sizes, initSize )
			
			for i = 2,#savedPos do
				table.insert( sizes, sizes[#sizes] + math.random(4,6) )
				
			end
			
			for k,pos in pairs( savedPos ) do
				local ent = ents.Create( "pocketware_sizablebox" )
				WareEngine:AppendEntToBin( ent )
				ent:SetDTInt( 3, sizes[k] )
				ent:SetPos( pos + Vector(0, 0, 0.5) * sizes[k] )
				ent:SetAngles( Angle(0, math.random(0, 360), 0) )
				ent:Spawn()
				
				if not WARE_TEMP.UseMax and k == 1 then
					ent.Winner = true
					WARE_TEMP.Winner = ent
					
				elseif WARE_TEMP.UseMax and k == #savedPos then
					ent.Winner = true
					WARE_TEMP.Winner = ent
					
				else
					ent.Winner = false
					
				end
				
			end
			WareEngine:HookRules( )
			if not WARE_TEMP.UseMax then
				WareEngine:DrawInstructions( "Blast the smallest crate!" )
				
			else
				WareEngine:DrawInstructions( "Blast the biggest crate!" )
			
			end
			
		end
		
	end
	
	return true
	
end

function SWEP:Holster()
	if SERVER then
		GetWareEngine():End( self.Owner )
		
	end
	
	return true
	
end

do
	local ENT = {}
	
	ENT.Type			="anim"
	ENT.Base			= "base_anim"
	ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT
	
	//ENT.Health = 50
	
	function ENT:Initialize()
		local dts = self:GetDTInt( 3 )
		dts = (dts >= 2) and dts or 2
		local halfcuboid = Vector(1,1,1) * dts * 0.5
		
		if SERVER then
			local cfactor = 1.1 + (dts/40)^2*5 - 12/40
			self.Entity:SetModel( "models/props_junk/wood_crate001a.mdl" )
			self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
			self.Entity:SetSolid( SOLID_VPHYSICS )
			self.Entity:PhysicsInitBox( -1 * halfcuboid, halfcuboid, "wood" )
			self.Entity:SetCollisionBounds( -1 * halfcuboid * cfactor, halfcuboid * cfactor)
			//self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
			//self.Entity:SetSolid( SOLID_VPHYSICS )
			self.Entity:GetPhysicsObject():SetMass( 50 )
			self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
			
		end
		-- Same shit, CLI/SRV Disjunction on Singleplayer ambiguities
		if CLIENT then
			self.Entity:SetModelScale( 2 * halfcuboid / 40 )
			self.Entity:SetRenderBounds( -1 * halfcuboid, halfcuboid )
			
		end
		//self:SetHealth( 50 )
		
	end
	
	/*function ENT:Think( )
		if self:Health() <= 0 then
			self:Break()
			
		end
		
	end*/
	
	/*function ENT:Break( )
		self.Entity:GibBreakClient( Vector(0, 0, 64) )
		self.Entity:Remove()
		
	end*/
	
	scripted_ents.Register(ENT, "pocketware_sizablebox", true)
	
end

if SERVER then
	local WARE_ENGINE = {}
	local WARE_TEMP = {}
	WARE_ENGINE.HasBegun		= false
	WARE_ENGINE.HasAchieved		= false
	WARE_ENGINE.HasLocked		= false
	WARE_ENGINE.Rules = nil
	
	WARE_ENGINE.Bin = nil
	
	function GetWareEngine()
		return WARE_ENGINE
		
	end
	
	function GetWareTemp()
		return WARE_TEMP
		
	end
	
	function WARE_ENGINE:AppendEntToBin( ent )
		if not self.Bin then return end
		if ent:IsPlayer() then return end
		
		table.insert( self.Bin, ent )
		
	end
	
	function WARE_ENGINE:EmptyBin( )
		if not self.Bin then return end
		
		for k,ent in pairs( self.Bin ) do
			if ValidEntity( ent ) then
				ent:Remove()
				
			end
			
		end
		
	end
	
	function WARE_ENGINE:DrawInstructions( sInstructions , optColorPointer , optTextColorPointer , optrpFilter )
		local rp = optrpFilter or nil
				
		umsg.Start( "gw_instructions", rp )
		umsg.String( sInstructions )
		-- If there is no color, no chars about the color are passed.
		umsg.Bool( optColorPointer ~= nil )
		if (optColorPointer ~= nil) then
			-- If there is a background color, a bool stating about the presence
			-- of a text color must be passed, even if there is no text color !
			umsg.Bool( optTextColorPointer ~= nil )

			umsg.Char( optColorPointer.r - 128 )
			umsg.Char( optColorPointer.g - 128 )
			umsg.Char( optColorPointer.b - 128 )
			umsg.Char( optColorPointer.a - 128 )
			
			if (optTextColorPointer ~= nil) then
				umsg.Char( optTextColorPointer.r - 128 )
				umsg.Char( optTextColorPointer.g - 128 )
				umsg.Char( optTextColorPointer.b - 128 )
				umsg.Char( optTextColorPointer.a - 128 )
			end
		end
		umsg.End()
		
	end
	
	function WARE_ENGINE:SendStatus( ply, bAchieved, bEveryone )
		umsg.Start("gw_yourstatus", ply)
			umsg.Bool(bAchieved or false)
			umsg.Bool(bEveryone or false)
		umsg.End()
		
	end
	
	function WARE_ENGINE:Prepare( )
		WARE_TEMP = {}
	
	end
	function WARE_ENGINE:Begin( ply, objRules )
		if self.HasBegun then return end
		self.Bin = {}
		self.HasBegun = true
		self.HasAchieved		= false
		self.HasLocked		= false
		self.Rules = objRules
		
		umsg.Start("gw_beginware", ply )
		umsg.End()
		
	end
	
	
	function WARE_ENGINE:HookRules( )
		if not self.HasBegun then return end
		if not self.Rules or not self.Rules.HOOKS then return end
		
		for name,fct in pairs( self.Rules.HOOKS ) do
			hook.Add( name, "POCKETWARE_" .. name, function(...) fct(WARE_TEMP, ...) end )
			
		end
		
	end
	
	
	function WARE_ENGINE:UnhookRules( )
		if not self.Rules or not self.Rules.HOOKS then return end
		
		for name,fct in pairs( self.Rules.HOOKS ) do
			hook.Remove( name, "POCKETWARE_" .. name )
			
		end
		
	end
	
	function WARE_ENGINE:End( ply )
		if not self.HasBegun then return end
		
		self:SetAchieved( ply, false )
		self:ApplyLock( ply )
		
		self:UnhookRules( )
		self.Rules = nil
		
		self:EmptyBin( )
		self.Bin = nil
		self.HasBegun = false
		

		umsg.Start("gw_endware", ply )
			umsg.Bool( self.HasAchieved )
		umsg.End()
		
	end
	
	function WARE_ENGINE:SetAchieved( ply, bStatus )
		if self.HasLocked then return end
		self.HasAchieved = bStatus and true or false
	
	end
	
	function WARE_ENGINE:ApplyLock( ply )
		if self.HasLocked then return end
		self.HasLocked = true
		
		self:SendStatus( ply, self.HasAchieved )
		
	end
	
end


if CLIENT then
	surface.CreateFont("Trebuchet MS", 36, 0   , 0, false, "garryware_instructions" )
	
	////////////////////////////////////////////////
	// // GarryWare Gold                          //
	// by Hurricaaane (Ha3)                       //
	//  and Kilburn_                              //
	// http://www.youtube.com/user/Hurricaaane    //
	//--------------------------------------------//
	// FILEOVERRIDE Skin                          //
	////////////////////////////////////////////////

	local surface = surface
	local draw = draw
	local Color = Color

	local SKIN = {}

	SKIN.PrintName 		= ""
	SKIN.Author 		= ""
	SKIN.DermaVersion	= 1

	SKIN.bg_color 					= Color( 100, 100, 100, 255 )
	SKIN.bg_color_sleep 			= Color( 70, 70, 70, 255 )
	SKIN.bg_color_dark				= Color( 50, 50, 50, 255 )
	SKIN.bg_color_bright			= Color( 220, 220, 220, 255 )

	SKIN.fontFrame					= "Default"

	SKIN.control_color 				= Color( 180, 180, 180, 255 )
	SKIN.control_color_highlight	= Color( 220, 220, 220, 255 )
	SKIN.control_color_active 		= Color( 110, 150, 255, 255 )
	SKIN.control_color_bright 		= Color( 255, 200, 100, 255 )
	SKIN.control_color_dark 		= Color( 100, 100, 100, 255 )

	SKIN.bg_alt1 					= Color( 50, 50, 50, 255 )
	SKIN.bg_alt2 					= Color( 55, 55, 55, 255 )

	SKIN.listview_hover				= Color( 70, 70, 70, 255 )
	SKIN.listview_selected			= Color( 100, 170, 220, 255 )

	SKIN.text_bright				= Color( 255, 255, 255, 255 )
	SKIN.text_normal				= Color( 180, 180, 180, 255 )
	SKIN.text_dark					= Color( 20, 20, 20, 255 )
	SKIN.text_highlight				= Color( 255, 20, 20, 255 )

	SKIN.texGradientUp				= Material( "gui/gradient_up" )
	SKIN.texGradientDown			= Material( "gui/gradient_down" )

	SKIN.combobox_selected			= SKIN.listview_selected

	SKIN.panel_transback			= Color( 255, 255, 255, 50 )
	SKIN.tooltip					= Color( 255, 245, 175, 255 )

	SKIN.colPropertySheet 			= Color( 170, 170, 170, 255 )
	SKIN.colTab			 			= SKIN.colPropertySheet
	SKIN.colTabInactive				= Color( 170, 170, 170, 155 )
	SKIN.colTabShadow				= Color( 60, 60, 60, 255 )
	SKIN.colTabText		 			= Color( 255, 255, 255, 255 )
	SKIN.colTabTextInactive			= Color( 0, 0, 0, 155 )
	SKIN.fontTab					= "Default"

	SKIN.colCollapsibleCategory		= Color( 255, 255, 255, 20 )

	SKIN.colCategoryText			= Color( 255, 255, 255, 255 )
	SKIN.colCategoryTextInactive	= Color( 200, 200, 200, 255 )
	SKIN.fontCategoryHeader			= "TabLarge"

	SKIN.colNumberWangBG			= Color( 255, 240, 150, 255 )
	SKIN.colTextEntryBG				= Color( 240, 240, 240, 255 )
	SKIN.colTextEntryBorder			= Color( 20, 20, 20, 255 )
	SKIN.colTextEntryText			= Color( 20, 20, 20, 255 )
	SKIN.colTextEntryTextHighlight	= Color( 20, 200, 250, 255 )
	SKIN.colTextEntryTextHighlight	= Color( 20, 200, 250, 255 )

	SKIN.colMenuBG					= Color( 255, 255, 255, 200 )
	SKIN.colMenuBorder				= Color( 0, 0, 0, 200 )

	SKIN.colButtonText				= Color( 0, 0, 0, 250 )
	SKIN.colButtonTextDisabled		= Color( 0, 0, 0, 100 )
	SKIN.colButtonBorder			= Color( 20, 20, 20, 255 )
	SKIN.colButtonBorderHighlight	= Color( 255, 255, 255, 50 )
	SKIN.colButtonBorderShadow		= Color( 0, 0, 0, 100 )
	SKIN.fontButton					= "Default"

	-- enum for draw order
	DM_ORDER_LATESTATTOP = 1
	DM_ORDER_LATESTATBOTTOM = 2

	-- basic deathmsg appearance settings
	SKIN.deathMessageBackgroundCol			= Color( 46, 43, 42, 220 )
	SKIN.deathMessageBackgroundLocal		= Color( 75, 75, 75, 200 ) -- this is the colour that the background is when the local player is involved in the deathmsg, so it stands out.
	SKIN.deathMessageActionColor			= Color( 200, 200, 200 )

	local matBlurScreen = Material( "pp/blurscreen" )


	/*---------------------------------------------------------
	   DrawGenericBackground
	---------------------------------------------------------*/
	function SKIN:DrawGenericBackground( x, y, w, h, color )

		draw.RoundedBox( 4, x, y, w, h, color )

	end

	/*---------------------------------------------------------
	   DrawLinedButtonBorder
	---------------------------------------------------------*/
	function SKIN:DrawLinedButtonBorder( x, y, w, h, depressed )

		surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
		surface.DrawOutlinedRect( x+1, y+1, w-2, h-2 )

	end

	/*---------------------------------------------------------
		Button
	---------------------------------------------------------*/
	function SKIN:PaintCancelButton( panel )

		local w, h = panel:GetSize()

		if ( panel.m_bBackground ) then
		
			local col = self.control_color
			
			if ( panel:GetDisabled() ) then
				col = self.control_color_dark
			elseif ( panel.Depressed or panel:GetSelected() ) then
				col = self.control_color_active
			elseif ( panel.Hovered ) then
				col = self.control_color_highlight
			end
			
			if ( panel.m_colBackground ) then
			
				col = table.Copy( panel.m_colBackground )
				
				if ( panel:GetDisabled() ) then
					col.r = math.Clamp( col.r * 0.7, 0, 255 )
					col.g = math.Clamp( col.g * 0.7, 0, 255 )
					col.b = math.Clamp( col.b * 0.7, 0, 255 )
					col.a = 20
				elseif ( panel.Depressed or panel:GetSelected() ) then
					col.r = math.Clamp( col.r + 100, 0, 255 )
					col.g = math.Clamp( col.g + 100, 0, 255 )
					col.b = math.Clamp( col.b + 100, 0, 255 )
				elseif ( panel.Hovered ) then
					col.r = math.Clamp( col.r + 30, 0, 255 )
					col.g = math.Clamp( col.g + 30, 0, 255 )
					col.b = math.Clamp( col.b + 30, 0, 255 )
				end
			end
			
			surface.SetDrawColor( col.r, col.g, col.b, col.a )
			panel:DrawFilledRect()
		
		end

	end

	SKIN.PaintSelectButton = SKIN.PaintCancelButton

	function SKIN:PaintOverCancelButton( panel )

		local w, h = panel:GetSize()
		
		if ( panel.m_bBorder ) then
			self:DrawLinedButtonBorder( 0, 0, w, h, panel.Depressed or panel:GetSelected() )
		end

	end

	SKIN.PaintOverSelectButton = SKIN.PaintOverCancelButton

	function SKIN:SchemeCancelButton( panel )

		panel:SetFont( "FRETTA_SMALL" )
		
		if ( panel:GetDisabled() ) then
			panel:SetTextColor( self.colButtonTextDisabled )
		else
			panel:SetTextColor( self.colButtonText )
		end
		
		DLabel.ApplySchemeSettings( panel )

	end

	function SKIN:SchemeSelectButton( panel )

		panel:SetFont( "FRETTA_SMALL" )
		
		if ( panel:GetDisabled() ) then
			panel:SetTextColor( self.colButtonTextDisabled )
		else
			panel:SetTextColor( self.colButtonText )
		end
		
		DLabel.ApplySchemeSettings( panel )

	end

	/*---------------------------------------------------------
		ListViewLine
	---------------------------------------------------------*/
	function SKIN:PaintListViewLine( panel )


	end

	/*---------------------------------------------------------
		ListViewLine
	---------------------------------------------------------*/
	function SKIN:PaintListView( panel )


	end

	/*---------------------------------------------------------
		ListViewLabel
	---------------------------------------------------------*/
	function SKIN:PaintScorePanelHeader( panel )

		--surface.SetDrawColor( panel.cTeamColor )	
		--panel:DrawFilledRect()
		
	end

	/*---------------------------------------------------------
		ListViewLabel
	---------------------------------------------------------*/
	function SKIN:PaintScorePanelLine( panel )

		local Tall = panel:GetTall()
		local BoxHeight = 21
		
		if ( not IsValid( panel.pPlayer ) or !panel.pPlayer:Alive() ) then
			draw.RoundedBox( 4, 0, Tall*0.5 - BoxHeight*0.5, panel:GetWide(), BoxHeight, Color( 60, 60, 60, 255 ) )
			return
		end

		if ( panel.pPlayer == LocalPlayer() ) then
			draw.RoundedBox( 4, 0, Tall*0.5 - BoxHeight*0.5, panel:GetWide(), BoxHeight, Color( 90, 90, 90, 255 ) )
			return
		end

		draw.RoundedBox( 4, 0, Tall*0.5 - BoxHeight*0.5, panel:GetWide(), BoxHeight, Color( 70, 70, 70, 255 ) )
			
	end

	/*---------------------------------------------------------
		PaintScorePanel
	---------------------------------------------------------*/
	function SKIN:PaintScorePanel( panel )

		surface.SetMaterial( matBlurScreen )	
		surface.SetDrawColor( 255, 255, 255, 255 )
			
		local x, y = panel:LocalToScreen( 0, 0 )
		
		matBlurScreen:SetMaterialFloat( "$blur", 5 )
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( x*-1, y*-1, ScrW(), ScrH() )
		
		--matBlurScreen:SetMaterialFloat( "$blur", 3 )
		--render.UpdateScreenEffectTexture()
		--surface.DrawTexturedRect( x*-1, y*-1, ScrW(), ScrH() )
			
		draw.RoundedBox( 8, 8, 16, panel:GetWide()-16, panel:GetTall()-8-16, Color( 200, 200, 200, 170 ) )
		draw.RoundedBox( 8, 0, 0, panel:GetWide(), panel:GetTall()  , Color( 255, 255, 255, 128 ) )
		
	end


	/*---------------------------------------------------------
		LayoutTeamScoreboardHeader
	---------------------------------------------------------*/
	function SKIN:LayoutTeamScoreboardHeader( panel )

		panel.TeamName:StretchToParent( 0, 0, 0, 0 )
		panel.TeamName:SetTextInset( 8 )
		panel.TeamName:SetColor( Color( 0, 0, 0, 220 ) )
		panel.TeamName:SetFont( "FRETTA_MEDIUM" )
		
		panel.TeamScore:StretchToParent( 0, 0, 0, 0 )
		panel.TeamScore:SetContentAlignment( 6 )
		panel.TeamScore:SetTextInset( 8 )
		panel.TeamScore:SetColor( Color( 0, 0, 0, 250 ) )
		panel.TeamScore:SetFont( "FRETTA_MEDIUM" )

	end

	function SKIN:PaintTeamScoreboardHeader( panel )

		local Color = team.GetColor( panel.iTeamID )
		draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall()*2, Color )

	end

	function SKIN:SchemeScorePanelLabel( panel )

		panel:SetTextColor( GAMEMODE:GetTeamColor( panel.pPlayer ) )
		panel:SetFont( "FRETTA_MEDIUM_SHADOW" )

	end

	function SKIN:PaintScorePanelLabel( panel )

		if ( not IsValid( panel.pPlayer ) or !panel.pPlayer:Alive() ) then
			panel:SetAlpha( 125 )
		else
			panel:SetAlpha( 255 )
		end
			
	end

	function SKIN:SchemeScorePanelHeaderLabel( panel )

		panel:SetTextColor( Color( 70, 70, 70, 255 ) )
		panel:SetFont( "HudSelectionText" )
			
	end

	function SKIN:SchemeSpectatorInfo( panel )

		panel:SetTextColor( Color( 255, 255, 255, 255 ) )
		panel:SetFont( "FRETTA_SMALL" )
			
	end

	/*---------------------------------------------------------
		ScoreHeader
	---------------------------------------------------------*/
	function SKIN:PaintScoreHeader( panel )

		draw.RoundedBox( 8, 8, 8, panel:GetWide()-16, panel:GetTall() + 8, Color( 255, 64, 64 ) )
		
		--draw.RoundedBox( 8, 0, 0, panel:GetWide(), panel:GetTall()+8 , Color( 255, 255, 255, 128 ) )
			
	end

	function SKIN:LayoutScoreHeader( panel )
		
		panel.GamemodeName:SetPos( 0, 0 )
		panel.GamemodeName:SizeToContents()
		panel.GamemodeName:CenterHorizontal()
		
		panel.HostName:SizeToContents()
		panel.HostName:SetPos( 0, 90 )
		panel.HostName:CenterHorizontal()
		
		panel:SetTall( 108 ) 
			
	end

	function SKIN:SchemeScoreHeader( panel )

		panel.HostName:SetTextColor( Color( 255, 255, 255, 255 ) )
		panel.HostName:SetFont( "FRETTA_MEDIUM_SHADOW" )
		
		--panel.GamemodeName:SetTextColor( Color( 255, 255, 255, 255 ) )
		--panel.GamemodeName:SetFont( "FRETTA_MEDIUM_SHADOW" )
			
	end

	/*---------------------------------------------------------
		DeathMessages
	---------------------------------------------------------*/
	function SKIN:PaintGameNotice( panel )

		if ( panel.m_bHighlight ) then
			draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall(), Color( 90, 90, 90, 200 ) )
			return
		end

		draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall(), Color( 20, 20, 20, 190 ) )
		
	end

	function SKIN:SchemeGameNoticeLabel( panel )

		panel:SetFont( "FRETTA_NOTIFY" )
		DLabel.ApplySchemeSettings( panel )
		
	end

	/*---------------------------------------------------------
		GamemodeButton
	---------------------------------------------------------*/
	function SKIN:PaintGamemodeButton( panel )

		local w, h = panel:GetSize()
		
		local col = Color( 255, 255, 255, 10 )
		
		if ( panel:GetDisabled() ) then
			col = Color( 0, 0, 0, 10 )
		elseif ( panel.Depressed or panel:GetSelected() ) then
			col = Color( 255, 255, 255, 50 )
		elseif ( panel.Hovered ) then
			col = Color( 255, 255, 255, 20 )
		end
		
		if ( panel.bgColor ~= nil ) then col = panel.bgColor end

		draw.RoundedBox( 4, 0, 0, w, h, col )

	end

	function SKIN:SchemeGamemodeButton( panel )

		panel:SetTextColor( color_white )
		panel:SetFont( "FRETTA_MEDIUM_SHADOW" )
		panel:SetContentAlignment( 4 )
		panel:SetTextInset( 8 )

	end


	/*---------------------------------------------------------
		PanelButton
	---------------------------------------------------------*/
	function SKIN:PaintPanelButton( panel )

		local w, h = panel:GetSize()
		
		local col = Color( 160, 160, 160, 255 )
		
		if ( panel:GetDisabled() ) then
			col = Color( 100, 100, 100, 255 )
		elseif ( panel.Depressed or panel:GetSelected() ) then
			col = Color( 150, 210, 255, 255 )
		elseif ( panel.Hovered ) then
			col = Color( 200, 200, 200, 255 )
		end
			
		if ( panel.bgColor ~= nil ) then col = panel.bgColor end

		surface.SetDrawColor( col )
		panel:DrawFilledRect()

	end

	function SKIN:PaintOverPanelButton( panel )

		local w, h = panel:GetSize()
		self:DrawLinedButtonBorder( 0, 0, w, h, panel.Depressed or panel:GetSelected() )

	end

	derma.DefineSkin( "pocketware", "", SKIN )
	
end

if CLIENT then
	local PANEL = {}

	function PANEL:Init()
		self:SetPaintBackground( false )

		self.INS_DefFore   =  Color(255, 255, 255, 255)
		self.INS_DefBack   =  Color(128, 170, 128, 192)
		
		self.DYN_INS_Foreground   =  Color( 255, 0, 0, 128 )
		self.DYN_INS_Background   =  Color( 255, 0, 0, 128 )
		self.DYN_INS_Border       =  Color( 255, 255, 255, 128 )
		self.INS_BorderAlpha = 220
		
		self.INS_Time = 0
		self.INS_Text = ""
		
		self.__INS_AppearDuration = 0.16
		self.INS_RemainDuration = 5.0
		self.INS_RemainDurationDefault = 5.0
		--self.__INS_Y = 12/16
		
		self.__INS_BaseHeight  = 38
		self.__INS_ExtraBorder = 4
		self.__INS_Expand      = 2
		
		self._INS_Xc = 0
		self._INS_Yc = 0
		self._INS_Wc = 0
		self._INS_Hc = 0
		
		self._INS_Xb = 0
		self._INS_Yb = 0
		self._INS_Wb = 0
		self._INS_Hb = 0
		
		self._INS_Xt = 0
		self._INS_Yt = 0
		
		self:InvalidateLayout()
		
	end

	function PANEL:PrepareDrawData(sText, cFore, cBack, oftfRemainOverride)
		self:MakeDrawData(sText or "", cFore or self.INS_DefFore, cBack or self.INS_DefBack, oftfRemainOverride or self.INS_RemainDurationDefault)
		
	end

	function PANEL:MakeDrawData(sText, cFore, cBack, fRemainDuration)
		self.INS_RemainDuration = fRemainDuration
		self.INS_Time = CurTime()
		self.INS_Text = sText

		surface.SetFont( "garryware_instructions" )
		local wB, hB = surface.GetTextSize( self.INS_Text )
		
		self._INS_Wc = wB + self.__INS_BaseHeight
		self._INS_Hc = self.__INS_BaseHeight --cst
		self._INS_Xc = self.__INS_ExtraBorder * ( 1 + self.__INS_Expand )
		self._INS_Yc = self.__INS_ExtraBorder * ( 1 + self.__INS_Expand ) --cst
		
		self._INS_Wb = self._INS_Wc + self.__INS_ExtraBorder * 2
		self._INS_Hb = self._INS_Hc + self.__INS_ExtraBorder * 2 --cst
		self._INS_Xb = self.__INS_ExtraBorder * self.__INS_Expand
		self._INS_Yb = self.__INS_ExtraBorder * self.__INS_Expand --cst
		
		self._INS_Xt = (2 * self._INS_Xc + self._INS_Wc) / 2
		self._INS_Yt = (2 * self._INS_Yc + self._INS_Hc) / 2 --cst
		
		self.DYN_INS_Foreground.r = cFore.r
		self.DYN_INS_Foreground.g = cFore.g
		self.DYN_INS_Foreground.b = cFore.b
		
		self.DYN_INS_Background.r = cBack.r
		self.DYN_INS_Background.g = cBack.g
		self.DYN_INS_Background.b = cBack.b
		
		self:SetVisible( true )
		self:InvalidateLayout()
		
	end

	function PANEL:Think()
		if self:IsVisible() and (CurTime() - self.INS_Time) > self.INS_RemainDuration then
			self:SetVisible( false )
		end 
		
	end

	function PANEL:PerformLayout()
		self:SetWidth(  self._INS_Wb + self.__INS_ExtraBorder * ( 1 + self.__INS_Expand ) * 2 )
		self:SetHeight( self._INS_Hb + self.__INS_ExtraBorder * ( 1 + self.__INS_Expand ) * 2 )
		
	end


	function PANEL:Paint()
		if (CurTime() - self.INS_Time) > self.INS_RemainDuration then return false end -- Compensated by think
		
		local delta = CurTime() - self.INS_Time
		local visRate = (delta > self.__INS_AppearDuration) and (1 - (delta / self.INS_RemainDuration) ^ 3) or (delta / self.__INS_AppearDuration)
		local specialSize = (delta > self.__INS_AppearDuration) and 0 or ((1 - delta / self.__INS_AppearDuration) * self.__INS_ExtraBorder * self.__INS_Expand)
		self.DYN_INS_Border.a     = self.INS_BorderAlpha * visRate
		self.DYN_INS_Foreground.a = 255 * ((delta > self.__INS_AppearDuration) and visRate or 1)
		self.DYN_INS_Background.a = 255 * visRate

		
		draw.RoundedBox(self.__INS_ExtraBorder, self._INS_Xb - specialSize, self._INS_Yb - specialSize, self._INS_Wb + specialSize * self.__INS_Expand, self._INS_Hb + specialSize * self.__INS_Expand, self.DYN_INS_Border)
		draw.RoundedBox(self.__INS_ExtraBorder, self._INS_Xc - specialSize, self._INS_Yc - specialSize, self._INS_Wc + specialSize * self.__INS_Expand, self._INS_Hc + specialSize * self.__INS_Expand, self.DYN_INS_Background)
		
		draw.SimpleText(self.INS_Text, "garryware_instructions", self._INS_Xt, self._INS_Yt, self.DYN_INS_Foreground, 1, 1 ) -- 1 and 1 are alignment
		
		return true
		
	end

	vgui.Register( "GWMessage", PANEL, "DPanel" )
end

local G_GWI_SKIN = "pocketware"
if CLIENT then
	local PANEL = {}

	function PANEL:Init()
		self:SetSkin( G_GWI_SKIN )
		self:SetPaintBackground( true )
		self:SetVisible( true )
		
	end

	function PANEL:PerformLayout()
		self:SetWidth(  self._INS_Wb + self.__INS_ExtraBorder * ( 1 + self.__INS_Expand ) * 2 )
		self:SetHeight( self._INS_Hb + self.__INS_ExtraBorder * ( 1 + self.__INS_Expand ) * 2 )
		self:SetPos( (ScrW() - self:GetWide()) * 0.5, ScrH() * 10 / 16.0 - self:GetTall() * 0.5 )
		
	end

	--Derma_Hook( PANEL, "Paint", "Paint", "GWInstructions" )
	vgui.Register( "GWStatus", PANEL, "GWMessage" )
	
end

if CLIENT then
	local PANEL = {}

	function PANEL:Init()
		self:SetSkin( G_GWI_SKIN )
		self:SetPaintBackground( true )
		self:SetVisible( true )
		
	end

	function PANEL:PerformLayout()
		self:SetWidth(  self._INS_Wb + self.__INS_ExtraBorder * ( 1 + self.__INS_Expand ) * 2 )
		self:SetHeight( self._INS_Hb + self.__INS_ExtraBorder * ( 1 + self.__INS_Expand ) * 2 )
		self:SetPos( (ScrW() - self:GetWide()) * 0.5, ScrH() * 12 / 16.0 - self:GetTall() * 0.5 )
		
	end

	--Derma_Hook( PANEL, "Paint", "Paint", "GWInstructions" )
	vgui.Register( "GWInstructions", PANEL, "GWMessage" )
end


if CLIENT then
	pocketware_InstructionsVGUI	= pocketware_InstructionsVGUI or vgui.Create( "GWInstructions" )
	pocketware_StatusVGUI		= pocketware_StatusVGUI or vgui.Create( "GWStatus" )
	
	pocketware_Music = nil
	local pocketware_MusicIsPlaying = false
	local pocketware_Iteration = 0
	
	local cStatusBackWinColorSet  = Color(0, 164, 237,192)
	local cStatusBackLoseColorSet = Color(255,  87,  87,192)
	local cStatusTextColorSet = Color(255,255,255,255)
	
	local function ReceiveStatuses( usrmsg )	
		local sText = ""
		
		local yourStatus = usrmsg:ReadBool() or false
		local isServerGlobal = usrmsg:ReadBool() or false
		
		if not isServerGlobal then
			sText = ((yourStatus and "Success!") or "Failure!") -- MaxOfS2D you fail
			if yourStatus then
				//LocalPlayer():EmitSound( GetSound("pocketware_win" ), 100, GAMEMODE:GetSpeedPercent() )
				LocalPlayer():EmitSound( GetSound("pocketware_localwin" ), 100, 100 )
				
			else
				LocalPlayer():EmitSound( GetSound("pocketware_locallose"), 100, 100 )
				
			end
			
		else
			sText = ((yourStatus and "Everyone won!") or "Everyone failed!")
			
		end

		local colorSelect = yourStatus and cStatusBackWinColorSet or cStatusBackLoseColorSet

		pocketware_StatusVGUI:PrepareDrawData( sText, nil, colorSelect, 3.0 )
	end
	usermessage.Hook( "gw_yourstatus", ReceiveStatuses )
	
	local function ReceiveInstructions( usrmsg )
		local sText = usrmsg:ReadString()
		local bUseCustomBG  = usrmsg:ReadBool()
		
		local cFG_Builder = nil
		local cBG_Builder = nil
		
		if bUseCustomBG then
			local bUseCustomFG = usrmsg:ReadBool()
			
			cBG_Builder = Color(usrmsg:ReadChar() + 128, usrmsg:ReadChar() + 128, usrmsg:ReadChar() + 128, usrmsg:ReadChar() + 128)
			
			if bUseCustomFG then
				cFG_Builder = Color( usrmsg:ReadChar() + 128, usrmsg:ReadChar() + 128, usrmsg:ReadChar() + 128, usrmsg:ReadChar() + 128)
				
			end
		
		end
		pocketware_InstructionsVGUI:PrepareDrawData( sText, cFG_Builder, cBG_Builder )
		
	end
	usermessage.Hook( "gw_instructions", ReceiveInstructions )
	
	local function RaiseMusic( iter )
		if (not pocketware_MusicIsPlaying) or (pocketware_Iteration ~= iter) then return end
		
		pocketware_Music:ChangeVolume( 0.7 )
		
	end
	
	local function BeginWare( usrmsg )
		pocketware_Iteration = pocketware_Iteration + 1
		
		LocalPlayer():EmitSound( GetSound("pocketware_new"), 100, 100 )
		
		pocketware_MusicIsPlaying = true
		pocketware_Music = pocketware_Music or CreateSound( LocalPlayer(), GetSound( "pocketware_music" ) )
		pocketware_Music:Play()
		pocketware_Music:ChangeVolume( 0.1 )
		timer.Simple( 2.50 * 0.7 , RaiseMusic, pocketware_Iteration )
		
	end
	usermessage.Hook( "gw_beginware", BeginWare )
	

	local function EndWare( usrmsg )
		local won  = usrmsg:ReadBool()
		if won then
			LocalPlayer():EmitSound( GetSound("pocketware_win"), 100, 100 )
			
		else
			LocalPlayer():EmitSound( GetSound("pocketware_lose"), 100, 100 )
			
		end
		
		pocketware_MusicIsPlaying = false
		pocketware_Music:Stop()
		//LocalPlayer():EmitSound( GetSound("pocketware_begin"), 100, 100 )
		
	end
	usermessage.Hook( "gw_endware", EndWare )
	
	/*local function BeginPocketWare( usrmsg )
		//LocalPlayer():EmitSound( GetSound("pocketware_begin"), 100, 100 )
		
	end
	usermessage.Hook( "gw_begin", BeginPocketWare )*/
	
end
