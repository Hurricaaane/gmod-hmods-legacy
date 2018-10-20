ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Marino: Plaque de file d'attente"

do
	ENT.Spawnable = false
	ENT.AdminSpawnable = true
	
end

local shd_MyClassName = ClassName or "marino_fileattente"
local shd_modelProp = Model( "models/hunter/plates/plate1x1.mdl" )

if CLIENT then
	ENT.RenderGroup 	= RENDERGROUP_BOTH
	
	function ENT:Draw()
		self:DrawModel()
		
	end
	
	function ENT:DrawTranslucent()
		self:Draw()
		
	end
	
end

do
	ENT.Sounds = {}
	ENT.Sounds.Validate = "marinosthread/beepclear.wav"
	ENT.Sounds.Timer = "marinosthread/ticktock.wav"
	ENT.Sounds.Call = "marinosthread/ding.wav"
	ENT.Sounds.Free = "marinosthread/ding.wav"
	ENT.Sounds.Begin = "marinosthread/calibrating1.wav"
	ENT.Sounds.End = "marinosthread/novariances.wav"
	
	
end

function ENT:SpawnFunction( ply, tr )
	if not tr.Hit then return end

	local vSpawnPos = tr.HitPos + tr.HitNormal * 32

	local ent = ents.Create( shd_MyClassName )
	if not ValidEntity( ent ) then return end
	
	ent:SetPos( vSpawnPos )
	ent:Spawn()
	ent:Activate()
	
	local physObj = ent:GetPhysicsObject()
	if physObj:IsValid() then
		physObj:Wake()
		
	end

	return ent

end

function ENT:Initialize()
	if SERVER then
		self:SetModel( shd_modelProp )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
		self:SetMaterial( "models/debug/debugwhite" )
		self:SetColor( 255, 164, 128, 255 )
		
		self.tThread = {}
		//self.tInService = {} --Used to keep track of customers that were served so they don't get back in line
		
		self.fLastTime = 0
		self.fWaitTime = 1
		
		self.fNextCustomerTime = 0
		self.fMinFindDelay = 1
		self.fMaxFindDelay = 12
		
		self.fEndWorkTime = 0
		self.fMinWorkDuration = 3.5
		self.fMaxWorkDuration = 7
		
		self.fEndIdleTime = 0
		self.fMinIdleDuration = 0.2
		self.fMaxIdleDuration = 2
		
		self.eCustomer = nil
		self.eExit = nil
		
	end
	
end

////////////////

function ENT:CanCallCustomer()
	if #self.tThread == 0 then return false end
	if not ValidEntity( self.tThread[1] ) then return false end
	
	return true
	
end

function ENT:CallCustomer( fDelay )
	if self.eCustomer ~= nil then return end
	if not self:CanCallCustomer() then return end
	
	self.eCustomer = table.remove( self.tThread, 1 )
	if fDelay then
		timer.Simple( fDelay, self.MoveCustomer, self )
		
	else
		self:MoveCustomer()
		
	end
	
	--table.insert( self.tInService, self.eCustomer )
	
	self:ReorganizeEveryone()
	self:SetColor( 255, 164, 128, 255 )
	
end

function ENT:MoveCustomer()
	if not ValidEntity( self.eCustomer ) then return end
	
	self.eCustomer:SetLastPosition( self:GetPos() )
	self.eCustomer:SetSchedule( SCHED_FORCED_GO_RUN )
	self.eCustomer:UseActBusyBehavior()
	
end


function ENT:DiscardCustomer()
	if self.eCustomer == nil then return end
	
	if ValidEntity( self.eCustomer ) then
		local vExit = nil
		if ValidEntity( self.eExit ) then
			vExit = self.eExit:GetPos() + Angle( 0, math.random(0, 359), 0 ):Forward() * math.Rand(1, 2) * 86
			
		else
			vExit = self:GetPos() + self:GetAngles():Forward() * -256
			
		end
		
		self.eCustomer:SetLastPosition( vExit )
		self.eCustomer:SetSchedule( SCHED_FORCED_GO_RUN )
		self.eCustomer:UseNoBehavior()
		
	end
	
	self.eCustomer = nil
	self:SetColor( 128, 164, 255, 255 )
	
end

function ENT:HasActiveCustomer()
	return self.eCustomer ~= nil
	
end

function ENT:GetCustomer()
	return self.eCustomer
	
end

function ENT:ToggleCustomer()
	if not self:HasActiveCustomer() then self:CallCustomer() else self:DiscardCustomer() end
	
end

function ENT:OnTakeDamage( dmginfo )
	--self:TakePhysicsDamage( dmginfo )
	--self:ToggleCustomer()
	self:PerformFindCustomers()
	
end

function ENT:Use( activator, caller )
	--self:ToggleCustomer()
	self:PerformFindCustomers()
	
end

function ENT:CheckTablesForErrors()
	self:CheckTable( self.tThread )
	//self:CheckTable( self.tInService )
	
end

function ENT:CheckTable( teArbitrary )
	local k = 1
	while k <= #teArbitrary do
		if not ValidEntity( teArbitrary[k] ) then table.remove( teArbitrary, k )
		else k = k + 1
		end
		
	end
	
end


function ENT:IsCustomer( ent )
	if ent:IsNPC() and table.HasValue( self.tThread, ent ) and ent ~= self.eCustomer then return true end
	return false
	
end

function ENT:AddCustomer( ent )
	if ent:IsNPC() and not table.HasValue( self.tThread, ent ) then
		table.insert( self.tThread, ent )
		self:ReorganizeEveryone() 
		
	end
	
end

function ENT:Touch( ent )
	if ent ~= self.eExit and ent:GetClass() == "prop_physics" then
		if ValidEntity( self.eExit ) then
			self.eExit:EmitSound( self.Sounds.Validate )
			
		end
		self.eExit = ent
		self.eExit:EmitSound( self.Sounds.Validate )
		
	end
	
end


function ENT:Think()
	if CLIENT then return end
	self:DoFindCustomersRoutine()
	self:DoThreadRoutine()
	
end

function ENT:DoFindCustomersRoutine()
	if not ValidEntity( self.eExit ) then return end
	if CurTime() < (self.fLastTime + self.fWaitTime) then return end
	
	self:PerformFindCustomers( true )
	
	self.fLastTime = CurTime()
	
end

function ENT:PerformFindCustomers( bUseTime )
	if not ValidEntity( self.eExit ) then return end
	self:CheckTablesForErrors()
	
	if not bUseTime or (CurTime() > self.fNextCustomerTime) then
		local teProximity = ents.FindInSphere( self.eExit:GetPos(), 256 )
		
		local foundTarget = false
		local k = 1
		
		while not foundTarget and #teProximity ~= 0 do
			local ent = table.remove( teProximity, math.random( 1, #teProximity ) )
			if ent:IsNPC() and not self:IsCustomer( ent ) then
				self:AddCustomer( ent )
				self.fNextCustomerTime = CurTime() + math.Rand( self.fMinFindDelay, self.fMaxFindDelay )
				foundTarget = true
				
			end
			
		end
		
	end
	
	self:ReorganizeEveryone() --DEBUG
	
end

function ENT:DoThreadRoutine()
	/*
		self.fNextCustomerTime = 0
		self.fMinFindDelay = 2
		self.fMaxFindDelay = 14
		
		self.fEndWorkTime = 0
		self.fMinWorkDuration = 3
		self.fMaxWorkDuration = 7
		
		self.fEndIdleTime = 0
		self.fMinIdleDuration = 0.2
		self.fMaxIdleDuration = 2
	*/
	
	
	if (CurTime() > self.fEndIdleTime) and not self:HasActiveCustomer() and self:CanCallCustomer() then
		self:EmitSound( self.Sounds.Call )
		self:CallCustomer( 0.6 )
		self.fEndWorkTime = nil
		
	elseif self:HasActiveCustomer() and self.fEndWorkTime == nil then
		self.fEndWorkTime = CurTime()  + math.Rand( self.fMinWorkDuration, self.fMaxWorkDuration )
		timer.Simple( 1.5, self.GLADOS_SayWeight, self )
		timer.Create( tostring(self) .. "_makeclock", 1.5, 1, self.GLADOS_MakeClock, self )
		
	elseif self:HasActiveCustomer() and (CurTime() > self.fEndWorkTime) then
		timer.Simple( 0.3, self.GLADOS_SayWeightResults, self )
		timer.Destroy( tostring(self) .. "_makeclock" )
		timer.Destroy( tostring(self) .. "_ticktock" )
		self:EmitSound( self.Sounds.Free )
		self:DiscardCustomer() 
		self.fEndIdleTime = CurTime()  + math.Rand( self.fMinIdleDuration, self.fMaxIdleDuration )
		
	end
	
end

function ENT:GLADOS_MakeClock()
	timer.Create( tostring(self) .. "_ticktock", 1, 0, self.GLADOS_TickTock, self )
end

function ENT:GLADOS_TickTock()
	if self:HasActiveCustomer() and self.fEndWorkTime ~= nil and (CurTime() < self.fEndWorkTime) then
		self:EmitSound( self.Sounds.Timer )
		
		--timer.Simple( 1, self.GLADOS_TickTock, self )
		
	end
	
end

function ENT:GLADOS_SayWeight()
	self:EmitSound( self.Sounds.Begin )
	
end

function ENT:GLADOS_SayWeightResults()
	self:EmitSound( self.Sounds.End )
	
end

function ENT:ReorganizeEveryone()
	for k,ent in pairs( self.tThread ) do
		local centerPos = self:GetPos() + self:GetAngles():Forward() * ( k + 1 ) * 35
		if (ent:GetPos() - centerPos):Length() > 24 then
			ent:SetLastPosition( centerPos + Angle(0, 0, math.random(0, 360)):Forward() * math.random(0,22) )
			ent:SetSchedule( SCHED_FORCED_GO )
			
		end
		
		ent:UseActBusyBehavior()
		
	end
	
end

