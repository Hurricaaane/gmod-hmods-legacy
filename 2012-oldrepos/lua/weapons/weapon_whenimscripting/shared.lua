require"glon"

-- http://lua-users.org/wiki/SimpleLuaClasses
local function class(base, init)
   local c = {}    -- a new class instance
   if not init and type(base) == 'function' then
	  init = base
	  base = nil
   elseif type(base) == 'table' then
	-- our new class is a shallow copy of the base class!
	  for i,v in pairs(base) do
		 c[i] = v
	  end
	  c._base = base
   end
   -- the class will be the metatable for all its objects,
   -- and they will look up their methods in it.
   c.__index = c

   -- expose a constructor which can be called by <classname>(<args>)
   local mt = {}
   mt.__call = function(class_tbl, ...)
   local obj = {}
   setmetatable(obj,c)
   if init then
	  init(obj,...)
   else 
	  -- make sure that any stuff from the base class is initialized!
	  if base and base.init then
	  base.init(obj, ...)
	  end
   end
   return obj
   end
   c.init = init
   c.is_a = function(self, klass)
	  local m = getmetatable(self)
	  while m do 
		 if m == klass then return true end
		 m = m._base
	  end
	  return false
   end
   setmetatable(c, mt)
   return c
end




-- Declared classes
local Scene = nil
local CompositedScenes = nil
local PanningScene = nil
local SceneSequence = nil
local WhenImScrolling = nil


do --class Scene
	Scene = class(Scene, function(this)
		this._CLASS       = "Scene"
		this._duration    = 1.0
		this._effects     = {}
	end)
	
	function PanningScene:GetClass()
		return this._CLASS
		
	end
	
	function PanningScene:SetDuration(fDuration)
		self._duration = fDuration
		
	end
	
	function PanningScene:GetDuration()
		return self._duration
		
	end
	
end


do --class PanningScene
	-- TODO: Implement ease
	PanningScene = class(Scene, function(this)
		this._CLASS       = "PanningScene"
		this._camPosBegin = Vector(0,0,0)
		this._camPosEnd   = Vector(0,0,0)
		this._camAngBegin = Angle(0,0,0)
		this._camAngEnd   = Angle(0,0,0)
		this._camFovBegin = nil
		this._camFovEnd   = nil
		this._camTransmit = {}
		this._camTransmit.pos = Vector(0,0,0)
		this._camTransmit.ang = Angle(0,0,0)
		this._camTransmit.fov = nil
		this._ease        = 0
		this._duration    = 1.0
		this._effects     = {}
	end)
	
	function PanningScene:SetCameraPosBegin(posPosition)
		self._camPosBegin = posPosition
		
	end
	
	function PanningScene:SetCameraPosEnd(posPosition)
		self._camPosEnd = posPosition
		
	end
	
	function PanningScene:SetCameraAngBegin(angAngle)
		self._camAngBegin = angAngle
		
	end
	
	function PanningScene:SetCameraAngEnd(angAngle)
		self._camAngEnd = angAngle
		
	end
	
	function PanningScene:SetCameraFovBegin(fFov)
		self._camFovBegin = fFov
		
		if self._camFovEnd == nil then
			self._camFovEnd = fFov
			
		end
		
	end
	
	function PanningScene:SetCameraFovEnd(fFov)
		self._camFovEnd = fFov
		
		if self._camFovBegin == nil then
			self._camFovBegin = fFov
			
		end
		
	end
	
	function PanningScene:SetCameraFovReset()
		self._camFovBegin = nil
		self._camFovEnd   = nil
		
	end	
	
	function PanningScene:SetCameraBegin(posPosition, angAngle)
		self:SetCameraPosBegin(posPosition)
		self:SetCameraAngBegin(angAngle)
		
	end
	
	function PanningScene:SetCameraEnd(posPosition, angAngle)
		self:SetCameraPosEnd(posPosition)
		self:SetCameraAngEnd(angAngle)
		
	end
	
	function PanningScene:EmulateCamera(fTime)
		if     (fTime > 1) then fTime = 1
		elseif (fTime < 0) then fTime = 0 end
		
		self._camTransmit.pos = self._camPosBegin + (self._camPosEnd - self._camPosBegin) * fTime
		
		self._camTransmit.ang.p = self._camAngBegin.p + math.AngleDifference(self._camAngBegin.p, self._camAngEnd.p) * fTime
		self._camTransmit.ang.y = self._camAngBegin.y + math.AngleDifference(self._camAngBegin.y, self._camAngEnd.y) * fTime
		self._camTransmit.ang.r = self._camAngBegin.r + math.AngleDifference(self._camAngBegin.r, self._camAngEnd.r) * fTime
		
		if (self._camFovBegin ~= nil and self._camFovEnd ~= nil) then
			self._camTransmit.fov = self._camFovBegin + (self._camFovEnd - self._camFovBegin) * fTime
			
		else
			self._camTransmit.fov = nil
			
		end
		
		for k,effect in pairs(self._effects) do
			effect:AlterateCamera(self._camTransmit)
			
		end
		
		return self._camTransmit
		
	end
	
	function PanningScene:GLON_Serialize()
		return glon.encode(self)
		
	end
	
	function PanningScene:GLON_Assimilmate(glonEncoded)
		local tVars = glon.decode(glonEncoded)
		for k,v in pairs(tVars) do
			self[k] = v
			
		end
		
	end
	
end


do
	SceneSequence = class(function(this)
		this._scenes    = {}
		this._durations = {}
		this._duration  = 0
		
	end)
	
	function SceneSequence:AddScenes(tScenes)
		for k,scene in pairs(tScenes) do
			self:AddScene( scene )
			
		end
		
	end
	
	function SceneSequence:Clear()
		self._scenes    = {}
		self._durations = {}
		self._duration  = 0
		
	end
	
	function SceneSequence:AddScene(scene)
		table.insert( self._scenes, scene )
		
	end
	
	function SceneSequence:RefreshDurations(scene)
		self._durations = {}
		
		local total = 0.0
		for k,scene in pairs(self._scenes) do
			local duration = scene:GetDuration()
			table.insert( self._durations, duration)
			total = total + duration
			
		end
		self._duration = total
		
	end
	
	function SceneSequence:Emulate(fTime)
		if (#self._scenes == 0) then return nil end
		
		local scene = 1
		local acc = 0
		local found = false
		while (not found and scene <= #self._scenes) do
			if (fTime < (acc + self._durations[scene])) then
				found = true
				
			else
				acc = acc + self._durations[scene]
				scene = scene + 1
				
			end
			
		end
		
		if not found then
			return nil
			
		end
		
		local sceneObj = self._scenes[scene]
		return sceneObj:EmulateCamera((fTime - acc) / sceneObj:GetDuration())
		
	end
	
end

do
	WhenImScrolling = class(function(this, camPos, camAng)
		this._camPos    = camPos or Vector(0,0,0)
		this._camAngle  = camAng or Angle(0,0,0)
		this._camFov    = 75
		--this._swiftAng  = Angle(0,90,0)
		this._swiftDist = 100
		
	end)
	
	function WhenImScrolling:GenerateScene()
		local set = {}
		set[1] = Scene()
		set[2] = Scene()
		set[3] = Scene()
		self:RebuildScene(set)
		
		return set
		
	end
	
	function WhenImScrolling:GetSet(i)
		return set[i]
		
	end
	
	function WhenImScrolling:RebuildScene(set)
		if set == nil then return end
		
		set[1]:SetCameraPosBegin(self._camPos + self._camAngle:Right() * self._swiftDist)
		set[1]:SetCameraPosEnd(self._camPos)
		set[1]:SetCameraAngBegin(self._camAngle)
		set[1]:SetCameraAngEnd(self._camAngle)
		set[1]:SetCameraFovBegin(self._camFov)
		set[1]:SetCameraFovEnd(self._camFov)
		set[1]:SetDuration(0.15)
		
		set[2]:SetCameraPosBegin(self._camPos)
		set[2]:SetCameraPosEnd(self._camPos)
		set[2]:SetCameraAngBegin(self._camAngle)
		set[2]:SetCameraAngEnd(self._camAngle)
		set[2]:SetCameraFovBegin(self._camFov)
		set[2]:SetCameraFovEnd(self._camFov)
		set[2]:SetDuration(0.2)
		
		set[3]:SetCameraPosBegin(self._camPos)
		set[3]:SetCameraPosEnd(self._camPos - self._camAngle:Right() * self._swiftDist)
		set[3]:SetCameraAngBegin(self._camAngle)
		set[3]:SetCameraAngEnd(self._camAngle)
		set[3]:SetCameraFovBegin(self._camFov)
		set[3]:SetCameraFovEnd(self._camFov)
		set[3]:SetDuration(0.15)
		
	end
	
	function Scene:GLON_Serialize()
		return glon.encode(self)
		
	end
	
	function Scene:GLON_Assimilmate(glonEncoded)
		local tVars = glon.decode(glonEncoded)
		for k,v in pairs(tVars) do
			self[k] = v
			
		end
		
	end
	
end

do
	SWEP.Spawnable			= true
	SWEP.AdminSpawnable		= false

	SWEP.PrintName       = "When I'm Scripted"
	SWEP.Slot            = 3
	SWEP.SlotPos         = 10
	SWEP.DrawAmmo        = false
	SWEP.DrawCrosshair   = true
	SWEP.Weight          = 5
	SWEP.AutoSwitchTo    = false
	SWEP.AutoSwitchFrom  = false
	SWEP.Author          = ""
	SWEP.Contact         = ""
	SWEP.Purpose         = ""
	SWEP.Instructions    = ""
	SWEP.ViewModel       = "models/weapons/v_hands.mdl"
	SWEP.WorldModel      = ""

	SWEP.Primary.ClipSize       = -1
	SWEP.Primary.DefaultClip    = -1
	SWEP.Primary.Automatic      = false
	SWEP.Primary.Ammo           = "none"
	SWEP.Primary.Delay          = 0.75

	SWEP.Secondary.ClipSize     = -1
	SWEP.Secondary.DefaultClip  = -1
	SWEP.Secondary.Automatic    = false
	SWEP.Secondary.Ammo         = "none"

	SWEP.HoldType = "ar2"

	function SWEP:Initialize()
		if SERVER then return end
		
		self._sequence = SceneSequence()
		self._startTime = 0
		self._playing = false
		self._parts = 0
		self._sounds = { "ha3weapons/whenimscripted/a.wav", "ha3weapons/whenimscripted/b.wav", "ha3weapons/whenimscripted/c.wav", "ha3weapons/whenimscripted/d.wav" }
		
	end
	
	function SWEP:Deploy()
	end

	function SWEP:Reload()
	end

	function SWEP:Think()
		if CLIENT then
			if not self._wait and LocalPlayer():KeyPressed( IN_ATTACK ) then
				self._sequence:AddScenes( WhenImScrolling(EyePos(), EyeAngles()):GenerateScene() )
				self._sequence:RefreshDurations()
				
				self._parts = self._parts + 1
				self.Owner:EmitSound( self._sounds[ (self._parts - 1) % 4 + 1 ] )
				self._wait = true
				
			end
			
			if not self._wait and LocalPlayer():KeyPressed( IN_ATTACK2 ) then	
				self.Owner:EmitSound( "ha3weapons/whenimscripted/whenim.wav" )
				
				if not self._playing then
					self._startTime = CurTime()
					self._playing = true
					
				else
					self._playing = false
					
				end
				
				self._wait = true
				
			end
			
			if not self._wait and LocalPlayer():KeyPressed( IN_RELOAD ) then
				self._sequence:Clear()
				self._parts = 0
				self._playing = false
				
				self._wait = true
				
			end
			
			if LocalPlayer():KeyPressed( IN_USE ) then
				self._wait = false
				
			end
			
			
			
		end
	
	end

	function SWEP:PrimaryAttack()
		return true
		
	end

	function SWEP:SecondaryAttack()
		return true
		
	end

	function SWEP:ShouldDropOnDie()
		return false
		
	end

	function SWEP:CalcView( ply, origin, ang, fov )
		if self._playing then
			local packer = self._sequence:Emulate(CurTime() - self._startTime)
			
			if packer == nil then return origin, ang, fov end
			
			return packer.pos, packer.ang, packer.fov
			
		end
		
		return origin, ang, fov
		
	end
	
end



