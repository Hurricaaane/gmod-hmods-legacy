if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "melee"
end

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "ZA WARUDO"
SWEP.Category				= "Devenger's Sillies"

SWEP.Author					= "Devenger"
SWEP.Contact				= "devenger@gmail.com"
SWEP.Instructions			= "Put crosshair on enemy, fire, then maintain crosshair on target until attack is complete"

SWEP.Slot					= 0

SWEP.ViewModel				= "models/weapons/v_knife_t.mdl"
SWEP.WorldModel				= "models/weapons/w_knife_t.mdl"
SWEP.ViewModelAimPos		= Vector (2.5364, -1.8409, 1.745)

SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 52

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

--actual SWEP

SWEP.MakesItsHolderAwesomelyUnkillable = true --love awesome variable names

SWEP.Sound = Sound ("za_warudo/fulltrack.mp3")

SWEP.DroppedObject = "models/combine_apc_wheelcollision.mdl"

local function MakeKnives ()
	local pl = wpn.Owner
	local basepos = pl:GetShootPos() + pl:GetAimVector() * 20
	local ang = pl:EyeAngles()
	for i=1, 4 do
		local knife = ents.Create ("zawarudo_proj_knife")
		local pos = basepos + ang:Right() * (math.random() - 0.5) * 30 + ang:Up() * (math.random() - 0.5) * 30 + ang:Forward() * (math.random() - 0.5) * 30
		knife:SetPos (pos)
		knife:SetAngles (ang)
		knife:SetOwner (pl)
		knife:Spawn()
	end
	wpn:SendWeaponAnim (ACT_VM_HITCENTER)
	wpn.Owner:SetAnimation (PLAYER_ATTACK1)
end

SWEP.FireActions = {
	{
	delay = 2.1,
	func = function ()
		wpn:SendBlackout()
		wpn:FreezeNPCsStageOne()
	end
	},
	{
	delay = 2.7,
	func = function ()
		wpn:FreezeEverything()
	end
	},
	{
	delay = 3.2,
	func = function ()
		wpn:SendInversion()
	end
	},
	{
	delay = 5.2,
	func = function ()
		wpn:EquipKnife()
	end
	},
	{
	delay = 5.9,
	func = MakeKnives
	},
	{
	delay = 6.2,
	func = MakeKnives
	},
	{
	delay = 6.5,
	func = MakeKnives
	},
	{
	delay = 9,
	func = function ()
		wpn:UnfreezePhysics()
	end
	},
	{
	delay = 11.3,
	func = function ()
		print (wpn.PlaceToDropSomething)
		if wpn.PlaceToDropSomething then
			local trc = util.TraceLine ({start = wpn.PlaceToDropSomething, endpos = wpn.PlaceToDropSomething + Vector (0,0,400), mask = MASK_NPCWORLDSTATIC})			
			local veh = ents.Create ("prop_vehicle_airboat")
			if !ValidEntity (veh) then return end
			veh:SetModel ("models/airboat.mdl")
			veh:SetKeyValue ("vehiclescript", "scripts/vehicles/airboat.txt")
			veh:SetPos (trc.HitPos - Vector (0,0,100))
			veh:SetAngles (Angle (0,wpn.Owner:GetAngles().y,0))
			veh:Spawn()
			veh:Activate()
			veh:GetPhysicsObject():SetVelocity (Vector (0,0,-1000))
			timer.Create ("crush"..CurTime(), 0.05, 30, function (veh)
				if ValidEntity(veh) then
					veh:GetPhysicsObject():SetVelocity (Vector (0,0,-1000))
				end
			end, veh)
			wpn.Owner:EnterVehicle (veh)
		end
	end
	},
}

function SWEP:Initialize()
	self:SetKnifeInCamera (false)
	if SERVER then
		self:SetWeaponHoldType (self.HoldType)
	end
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire (CurTime() + 9999)
	if SERVER then
		self.Owner:EmitSound (self.Sound)
		self.FireTime = CurTime()
		self.Action = 1
		local trc = util.QuickTrace (self.Owner:GetShootPos(), self.Owner:GetAimVector() * 4096, self.Owner)
		local ent = trc.Entity
		if ent:IsNPC() or ent:IsPlayer() then
			self.Target = ent
		else
			self.PlaceToDropSomething = trc.HitPos - self.Owner:GetAimVector() * 32
		end
	end
	self.Owner:SetAnimation (PLAYER_ATTACK1)
	self.Weapon:SendWeaponAnim (ACT_VM_HITCENTER)
end

local function OnNPCKilled (npc, killer, weapon)
	print (npc, killer, weapon)
	if not ValidEntity(killer) then return end
	if weapon:GetClass() == "zawarudo_proj_knife" and ValidEntity (killer:GetActiveWeapon()) and killer:GetActiveWeapon().MakesItsHolderAwesomelyUnkillable then
		--we have the npc?
		print ("Got target from knife: ", npc)
		killer:GetActiveWeapon().Target = npc
	end
end

hook.Add ("OnNPCKilled", "ZW_NPCKilled", OnNPCKilled)

local function PlayerShouldTakeDamage (pl)
	if ValidEntity (pl:GetActiveWeapon()) and pl:GetActiveWeapon().MakesItsHolderAwesomelyUnkillable then return false end
end

hook.Add ("PlayerShouldTakeDamage", "ZW_ShouldTakeDamage", PlayerShouldTakeDamage)

function SWEP:Think()
	if self.FireTime then
		if ValidEntity(self.Target) and self.Target:GetMoveType() != 0 then
			--print (self.Target)
			self.PlaceToDropSomething = self.Target:GetPos()
			--Oh really
		else
			local pos = self.PlaceToDropSomething
			if ValidEntity(self.Target) then
				pos = self.Target:GetPos()
			end
			--hunt for ragdolls where we last saw 'em
			if pos then
				for _,ent in pairs (ents.FindInSphere(pos, 250)) do
					print (ent, "?")
					if not ent.WeKnowOfThis and ent:GetModel() and util.IsValidRagdoll(ent:GetModel()) then
						self.Target = ent
					end
					ent.WeKnowOfThis = true
				end
			end
		end
		if self.Action then
			local action = self.FireActions[self.Action]
			if self.FireTime + action.delay < CurTime() then
				wpn = self
				action.func()
				if not self.Action then return end
				if self.FireActions[self.Action + 1] then
					self.Action = self.Action + 1
				else
					self.FireTime = false
					self.Action = nil
					self.Weapon:SetNextPrimaryFire (CurTime() + 1)
				end
			end
		end
	end
end

function SWEP:Holster()
	if SERVER then
		self.FireTime = false
		self.Action = nil
		self:UnfreezeEverything()
		self:SendEffectsEnd()
		self.PlaceToDropSomething = false
		self.Target = false
	else
		self:SetKnifeInCamera (false)
	end
	return true
end

function SWEP:FreezeNPCsStageOne()
	for _,npc in pairs (ents.FindByClass("npc_*")) do
		npc:SetPlaybackRate (0)
	end
end

function SWEP:FreezeEverything()
	RunConsoleCommand ("phys_timescale", "0")
	RunConsoleCommand ("ai_disabled", "1")
	for _,pl in pairs (player.GetAll()) do
		pl:Freeze (true)
	end
end

function SWEP:UnfreezePhysics()
	RunConsoleCommand ("phys_timescale", "1")
end

function SWEP:UnfreezeEverything()
	RunConsoleCommand ("phys_timescale", "1")
	RunConsoleCommand ("ai_disabled", "0")
	for _,npc in pairs (ents.FindByClass("npc_*")) do
		npc:SetPlaybackRate (1)
		if npc:IsValid() and npc:IsNPC() then
			npc:ClearEnemyMemory (true)
		end
	end
	for _,pl in pairs (player.GetAll()) do
		pl:Freeze (false)
	end
end

function SWEP:SendBlackout()
	umsg.Start ("zw_blackout")
	umsg.End ()
end

function SWEP:SendInversion()
	umsg.Start ("zw_inversion")
	umsg.End ()
end

function SWEP:SendEffectsEnd()
	umsg.Start ("zw_endeffects")
	umsg.End ()
end

function SWEP:EquipKnife()
	umsg.Start ("zw_knife", self.Owner)
	umsg.End ()
end

function SWEP:UnequipKnife()
	umsg.Start ("zw_unknife", self.Owner)
	umsg.End ()
end

function SWEP:SetKnifeInCamera (bool)
	if not CLIENT then return end
	if bool then
		self.ViewModelPos = Vector (0,0,0)
		self.ViewModelAng = Vector (0,0,0)
	else
		self.ViewModelPos = Vector (5.3449, 0, -0.1317)
		self.ViewModelAng = Vector (0, 0, 57.3041)
	end
end

function SWEP:GetViewModelPosition (pos, ang, inv, mul)
	--this is always applied
	local DefPos = self.ViewModelPos
	local DefAng = self.ViewModelAng
	
	if DefAng then
		ang = ang * 1
		ang:RotateAroundAxis (ang:Right(), 		DefAng.x)
		ang:RotateAroundAxis (ang:Up(), 		DefAng.y)
		ang:RotateAroundAxis (ang:Forward(), 	DefAng.z)
	end

	if DefPos then
		local Right 	= ang:Right()
		local Up 		= ang:Up()
		local Forward 	= ang:Forward()
	
		pos = pos + DefPos.x * Right
		pos = pos + DefPos.y * Forward
		pos = pos + DefPos.z * Up
	end
	
	return pos, ang
end

local function RecvBlackout (umsg)
	blackoutTime = CurTime()
	inversionTime = false
end

usermessage.Hook ("zw_blackout", RecvBlackout)

local function RecvInversion (umsg)
	inversionTime = CurTime()
	blackoutTime = false
end

usermessage.Hook ("zw_inversion", RecvInversion)

local function RecvEndEffects (umsg)
	if inversionTime or blackoutTime then
		inversionEndTime = CurTime()
	end
	inversionTime = false
	blackoutTime = false
end

usermessage.Hook ("zw_endeffects", RecvEndEffects)

local function RecvKnife (umsg)
	print ("KNIFE!!!! awesum")
	local wpn = LocalPlayer():GetActiveWeapon()
	if wpn then
		wpn:SetKnifeInCamera (true)
	end
end

usermessage.Hook ("zw_knife", RecvKnife)

local function RecvUnKnife (umsg)
	print ("KNIFE!!!! awesum")
	local wpn = LocalPlayer():GetActiveWeapon()
	if wpn then
		wpn:SetKnifeInCamera (false)
	end
end

usermessage.Hook ("zw_unknife", RecvUnKnife)

local function DrawBlackout (prog)
	local tab = {} 
 	 
 	tab[ "$pp_colour_addr" ] 		= 0
 	tab[ "$pp_colour_addg" ] 		= 0
 	tab[ "$pp_colour_addb" ] 		= 0
 	tab[ "$pp_colour_brightness" ] 	= 0 - prog
 	tab[ "$pp_colour_contrast" ] 	= 1 + prog * 3
 	tab[ "$pp_colour_colour" ] 		= 1 - prog
 	tab[ "$pp_colour_mulr" ] 		= 0
 	tab[ "$pp_colour_mulg" ] 		= 0
 	tab[ "$pp_colour_mulb" ] 		= 0
 	 
 	DrawColorModify (tab)
end

local function DrawInversion (prog)
	local tab = {} 
 	 
 	tab[ "$pp_colour_addr" ] 		= 0
 	tab[ "$pp_colour_addg" ] 		= 0
 	tab[ "$pp_colour_addb" ] 		= 0
 	tab[ "$pp_colour_brightness" ] 	= 0
 	tab[ "$pp_colour_contrast" ] 	= 1
 	tab[ "$pp_colour_colour" ] 		= 1 - prog
 	tab[ "$pp_colour_mulr" ] 		= 0
 	tab[ "$pp_colour_mulg" ] 		= 0
 	tab[ "$pp_colour_mulb" ] 		= 0
 	 
 	DrawColorModify (tab)
	
	--DrawSharpen (2,2)
end

local DrawHUD = true

local function DrawZaWarudoEffects()
	DrawHUD = false
	if blackoutTime then
		if blackoutTime + 5 > CurTime() then
			DrawBlackout (math.Clamp ((CurTime() - blackoutTime) * 3, 0, 1))
		else
			blackoutTime = nil --failure
		end
		return
 	elseif inversionTime then
		if inversionTime + 25 > CurTime() then
			DrawInversion (1)
		else
			inversionTime = nil --failure
		end
		return
	elseif inversionEndTime and inversionEndTime + 1 > CurTime() then
		DrawInversion (inversionEndTime + 1 - CurTime())
		return
	end
	DrawHUD = true
end
   
hook.Add ("RenderScreenspaceEffects", "DrawZaWarudoEffects", DrawZaWarudoEffects)

local function HUDShouldDraw()
	if not DrawHUD then return false end
end

hook.Add ("HUDShouldDraw", "ZaWarudoHUDDisabler", HUDShouldDraw)