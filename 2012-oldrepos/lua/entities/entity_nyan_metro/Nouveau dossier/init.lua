AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.iClass = CLASS_ROBOT
ENT.fMeleeDistance	= 100
ENT.fRangeDistance	= 4000
ENT.fFollowAttackDistance = 4000
ENT.fRangeDistanceBomb = 2000
ENT.m_fMaxYawSpeed = 10
ENT.fViewAngle = 320
ENT.possOffset = Vector(-100,0,550)

ENT.bExplodeOnDeath = true
ENT.iBloodType = false
ENT.bFlinchOnDamage = false
ENT.bIgnitable = false
ENT.idleChance = 22
ENT.sModel = "models/fallout/libertyprime.mdl"
ENT.tblIgnoreDamageTypes = {DMG_DISSOLVE}

ENT.tblAlertAct = {}
ENT.tblDeathActivities = {}
ENT.tblFlinchActivities = {}
ENT.tblCRelationships = {
	[D_NU] = {"monster_gman", "npc_seagull", "npc_antlion_grub", "npc_barnacle", "monster_cockroach", "npc_pigeon", "npc_crow"},
	[D_FR] = {"npc_strider","npc_combinegunship","npc_combinedropship", "npc_helicopter"},
	[D_HT] = {"obj_sentrygun", "npc_clawscanner", "npc_headcrab_poison", "npc_stalker"},
	[D_LI] = util.GetNPCClassAllies(CLASS_PLAYER_ALLY)
}

ENT.sSoundDir = "npc/libertyprime/"
ENT.tblSourceSounds = {
	["Attack"] = "genericrobot_attack[1-18].mp3",
	["LPDeath"] = "voc_robotlibertyprime_dlc03_01.mp3",
	["Pain"] = "genericrobot_hit[1-6].mp3"
}

function ENT:OnInit()
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()
	
	self:SetCollisionBounds(Vector(90, 90, 485), Vector(-90, -90, 0))

	self:CapabilitiesAdd(CAP_MOVE_GROUND | CAP_OPEN_DOORS)

	self:SetHealth(GetConVarNumber("sk_libertyprime_health"))
	
	self.nextAttackScream = 0
	self.nextBeam = 0
	self.nextThrow = 0
	self:SetSoundLevel(95)
	local cspIdle = CreateSound(self, self.sSoundDir .. "libertyprime_idle_lp.wav")
	cspIdle:SetSoundLevel(95)
	cspIdle:Play()
	self:StopSoundOnDeath(cspIdle)
end

function ENT:InitSandbox()
	if !self:GetSquad() then self:SetSquad(self:GetClass() .. "_sbsquad") end
	if #ents.FindByClass("npc_libertyprime") == 1 && math.random(1,10) == 1 then
		local cspSoundtrack = CreateSound(self, self.sSoundDir .. "soundtrack.mp3")
		cspSoundtrack:SetSoundLevel(0.2)
		cspSoundtrack:Play()
		self:StopSoundOnDeath(cspSoundtrack)
	end
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	if CurTime() >= self.nextBeam then self:FireBeam(); self.nextBeam = CurTime() +0.35 end
	fcDone(true)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:EmitSound(self.sSoundDir .. "libertyprime_bomb_equip.mp3", 100, 100)
	self:PlayActivity(ACT_ARM, false)
	self.bInSchedule = true
end

function ENT:_PossReload(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1, false, fcDone)
end

function ENT:_PossJump(entPossessor, fcDone)
	if CurTime() >= self.nextAttackScream then
		local sound = self:PlaySound("Attack")
		self.nextAttackScream = CurTime() +SoundDuration(sound)
	end
	fcDone(true)
end

function ENT:Interrupt()
	if self:IsPossessed() then self:_PossScheduleDone() end
	if self.bInSchedule then
		self.bInSchedule = false
	end
end

function ENT:DoDeath(dmginfo)
	self:SetNPCState(NPC_STATE_DEAD)
	self:SetState(NPC_STATE_DEAD)
	self:PlayActivity(ACT_IDLE);
	self:ScheduleFinished();
	self.nextExp = CurTime() +math.Rand(0,1)
	self.expEnd = CurTime() +math.Rand(4,8)
	self:PlaySound("LPDeath");
end

function ENT:OnThink()
	if(self.bDead) then
		if(CurTime() >= self.expEnd) then
			local exps = {}
			for i = 0, self:GetBoneCount() -1 do
				local bonepos, boneang = self:GetBonePosition(i)
				local flDistMin = math.huge
				for k, v in pairs(exps) do
					if i != k then
						local flDist = bonepos:Distance(self:GetBonePosition(k))
						if flDist < flDistMin then flDistMin = flDist end
					end
				end
				if flDistMin > 80 then
					util.CreateExplosion(bonepos,nil,nil,self);
					exps[i] = bonepos
				end
			end
			self:Remove()
		elseif(CurTime() >= self.nextExp) then
			local pos = self:GetBonePosition(math.random(0,self:GetBoneCount() -1));
			util.CreateExplosion(pos,nil,nil,self);
			local tm = math.Rand(0.3,1.75) *math.Min(((self.expEnd -CurTime()) /6),0.25)
			self.nextExp = CurTime() +tm;
		end
		return
	end
	self:UpdateLastEnemyPositions()
	local pp_pitch = self:GetPoseParameter("aim_pitch")
	local pitch = 0
	if ValidEntity(self.entEnemy) then
		local att = self:GetAttachment(self:LookupAttachment("eye"))
		local fDist = self:OBBDistance(self.entEnemy)
		local bPos = att.Pos

		local _ang = att.Ang
		local ang = (self.entEnemy:GetCenter() -bPos):Angle() -_ang
		pitch = pp_pitch +math.NormalizeAngle(ang.p)
		
		if CurTime() >= self.nextAttackScream then
			if math.random(1,2) == 1 then
				local sound = self:PlaySound("Attack")
				self.nextAttackScream = CurTime() +SoundDuration(sound) +math.Rand(3,8)
			else self.nextAttackScream = CurTime() +math.Rand(3,8) end
		end
		
		if CurTime() >= self.nextBeam then
			self.nextBeam = CurTime() +0.35
			if !self.bInAttack && !self.bInSchedule && fDist <= self.fRangeDistance && fDist > 380 && self:Visible(self.entEnemy) then
				local ang = self:GetAngleToPos(self.entEnemy:GetPos())
				if (ang.y <= 45 || ang.y >= 315) && (ang.p <= 45 || ang.p >= 315) && !self:GunTraceBlocked() then
					self:FireBeam()
				end
			end
		end
	elseif self:IsPossessed() then
		local att = self:GetAttachment(self:LookupAttachment("eye"))
		local bPos = att.Pos
		local tr = self:GetPossessor():GetPossessionEyeTrace()
		
		local _ang = att.Ang
		local ang = (tr.HitPos -bPos):Angle() -_ang
		pitch = pp_pitch +math.NormalizeAngle(ang.p)
	end
	pp_pitch = math.ApproachAngle(pp_pitch, pitch, 3)
	self:SetPoseParameter("aim_pitch", pp_pitch)
	
	self:NextThink(CurTime())
	return true
end

function ENT:GunTraceBlocked()
	local tracedata = {}
	tracedata.start = self:GetAttachment(self:LookupAttachment("eye")).Pos
	tracedata.endpos = self.entEnemy:GetHeadPos()
	tracedata.filter = self
	local tr = util.TraceLine(tracedata)
	return tr.Entity:IsValid() && tr.Entity != self.entEnemy
end

function ENT:EventHandle(sEvent)
	if string.find(sEvent, "foot") then
		local trans = string.find(sEvent, "trans")
		if !self:OnGround() && !trans then return end
		local left = string.find(sEvent, "lfoot")
		local iAtt = self:LookupAttachment(left && "lfoot" || "rfoot")
		local att = self:GetAttachment(iAtt)
		if trans then
			WorldSound(self.sSoundDir .. "foot/libertyprime_foot_" .. (left && "l" || "r") .. "_trans.mp3", att.Pos, 100, 100)
			return
		end
		WorldSound(self.sSoundDir .. "foot/libertyprime_foot_" .. (left && "l" || "r") .. "_near.mp3", att.Pos, 100, 100)
		util.ScreenShake(att.Pos, 100, 100, 0.5, 1500)
		
		self:DoMeleeDamage(80,200,Angle(0,0,0),iAtt,nil,true,false)
		local tr = util.TraceLine({start = att.Pos +Vector(0,0,20), endpos = att.Pos -Vector(0,0,30), filter = self})
		if tr.MatType == 68 || tr.MatType == 78 then
			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetScale(460)
			util.Effect("ThumperDust", effectdata) 
		end
		return
	end
	if string.find(sEvent, "mattack") then
		local iAtt = self:LookupAttachment("rfoot")
		local att = self:GetAttachment(iAtt)
		WorldSound(self.sSoundDir .. "foot/libertyprime_foot_r_near.mp3", att.Pos, 100, 100)
		util.ScreenShake(att.Pos, 100, 100, 0.5, 1500)
		
		self:DoMeleeDamage(280,200,Angle(0,0,0),iAtt,nil,true,false)
		local tr = util.TraceLine({start = att.Pos +Vector(0,0,20), endpos = att.Pos -Vector(0,0,30), filter = self})
		if tr.MatType == 68 || tr.MatType == 78 then
			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetScale(460)
			util.Effect("ThumperDust", effectdata) 
		end
		return
	end
	if string.find(sEvent, "range") then
		self:PlayActivity(ACT_RANGE_ATTACK1, true, nil, true)
		return
	end
	if string.find(sEvent, "throw") then
		local pos = self:GetBonePosition(self:LookupBone("Bip01 R Hand"))
		local posTarget
		if self:IsPossessed() then
			local tr = self:GetPossessor():GetPossessionEyeTrace()
			local _pos = tr.HitPos
			if pos:Distance(tr.HitPos) > 1800 then _pos = pos +(tr.HitPos -pos):GetNormal() *1800 end
			posTarget = _pos
		else posTarget = ValidEntity(self.entEnemy) && self.entEnemy:GetCenter() || self:GetLastEnemyPosition() || self:GetPos() +self:GetForward() *1000 end
		local att = self:GetAttachment(self:LookupAttachment("bomb"))
		local pos = att.Pos -self:GetForward() *300 +self:GetUp() *140 +self:GetRight() *220
		local entNuke = ents.Create("obj_prime_mininuke")
		entNuke:SetEntityOwner(self)
		entNuke:Spawn()
		entNuke:Activate()
		entNuke:SetPos(pos)
		entNuke:SetAngles(self:GetAngles() +Angle(30,0,0))
		local phys = entNuke:GetPhysicsObject()
		if ValidEntity(phys) then
			local distZ = pos.z -posTarget.z
			pos.z = 0
			posTarget.z = 0
			local dist = pos:Distance(posTarget)
			
			phys:SetVelocity(self:GetForward() *3000 -self:GetUp() *(2000 -dist *1.2 +distZ *1.3) -self:GetRight() *((2000 -dist) *0.65))
		end
		return
	end
	if string.find(sEvent, "takebomb") then
		self:SetBodygroup(2,1)
		return
	end
	if string.find(sEvent, "unequipped") then
		self.nextThrow = CurTime() +math.Rand(6,12)
		self:SetBodygroup(2,0)
		self.bInSchedule = false
		return
	end
	if string.find(sEvent, "unequip") then
		self:PlayActivity(ACT_DISARM, true, self:IsPossessed() && self._PossScheduleDone || nil, true)
		return
	end
end

function ENT:FireBeam()
	local att = self:GetAttachment(self:LookupAttachment("eye"))
	local posTgt = self:IsPossessed() && self:GetPossessor():GetPossessionEyeTrace().HitPos || self.entEnemy:GetHeadPos()
	local dir = self:GetConstrictedDirection(att.Pos, 45, 45, posTgt) +Vector(math.Rand(-0.014,0.014),math.Rand(-0.014,0.014),math.Rand(-0.012,0.012))
	local tr = util.TraceLine({start = att.Pos, endpos = att.Pos +dir *32768, filter = self})
	util.BlastDamage(self, self, tr.HitPos, 20, GetConVarNumber("sk_libertyprime_dmg_laser"))
	self:EmitSound(self.sSoundDir .. "libertyprime_laser_fire.mp3", 100, 100)
	
	local entBeam = ents.Create("obj_beam_laser_prime")
	entBeam:SetDestination(tr.HitPos)
	entBeam:SetOwner(self)
	entBeam:Spawn()
	entBeam:Activate()
	
	self:RestartGesture(ACT_GESTURE_RANGE_ATTACK1)
end

function ENT:SelectScheduleHandle(fDist,fDistPredicted,iDisposition)
	if iDisposition == 1 then
		if self:CanSee(self.entEnemy) then
			local bThrow = CurTime() >= self.nextThrow && fDist <= self.fRangeDistanceBomb && fDist >= 350
			if bThrow then
				local ang = self:GetAngleToPos(self.entEnemy:GetPos())
				if (ang.y <= 45 || ang.y >= 315) && (ang.p <= 45 || ang.p >= 315) then
					self.nextThrow = CurTime() +math.Rand(6,12)
					local numEnemies = self:GetEnemyCount();
					local r = math.Max(30 -(numEnemies *2),20)
					if(self.entEnemy:Health() >= 500) then r = r -10 end;
					if math.random(1,r) <= 10 then
						self:EmitSound(self.sSoundDir .. "libertyprime_bomb_equip.mp3", 100, 100)
						self:PlayActivity(ACT_ARM, true)
						self.bInSchedule = true
						return
					end
				end
			end
			local bMelee = fDist <= self.fMeleeDistance
			if bMelee then
				self:PlayActivity(ACT_MELEE_ATTACK1, true)
				self.bInAttack = true
				return
			elseif self.bInAttack then self.bInAttack = false end
			if fDist <= 1000 && fDist > 380 then
				local ang = self:GetAngleToPos(self.entEnemy:GetPos())
				if (ang.y <= 45 || ang.y >= 315) && (ang.p <= 45 || ang.p >= 315) && !self:GunTraceBlocked() && self:Visible(self.entEnemy) then
					return
				end
			end
		end
		self:ChaseEnemy()
	elseif iDisposition == 2 then
		self:Hide()
	end
end
