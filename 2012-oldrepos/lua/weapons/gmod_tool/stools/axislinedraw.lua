TOOL.Category = "Constraints"
TOOL.Name = "#axislinedraw"
TOOL.Command = nil
TOOL.ConfigName = nil

TOOL.ClientConVar[ "forcelimit" ] = 0
TOOL.ClientConVar[ "torquelimit" ] = 0
TOOL.ClientConVar[ "hingefriction" ] = 0
TOOL.ClientConVar[ "nocollide" ] = 0

cleanup.Register("AxisLinedraw")

if SERVER then
	TOOL._SoundValidate  = Sound( "buttons/button3.wav" )
	TOOL._SoundError     = Sound( "buttons/button2.wav" )
	TOOL._SoundAlert     = Sound( "buttons/button10.wav" )
end

if CLIENT then
	TOOL._Material_Laser = Material( "cable/new_cable_lit_back" )
	TOOL._Material_Spot  = Material( "sprites/grip" )

	language.Add("axislinedraw","Axis Linedraw" )
	language.Add("Tool_axislinedraw_name","Axis Linedraw")
	language.Add("Tool_axislinedraw_desc", "Draw two segments, then the axis will go though their middles." )
	language.Add("Tool_axislinedraw_0", "Left: Select the first prop.    Reload: Clear axis" )
	language.Add("Tool_axislinedraw_1", "Left: Select the second prop.    Right: Previous" )
	language.Add("Tool_axislinedraw_2", "Left: Draw the starting point of the 1st segment.    Right: Previous" )
	language.Add("Tool_axislinedraw_3", "Left: Draw the ending point of the 1st segment.    Right: Previous" )
	language.Add("Tool_axislinedraw_4", "Left: Draw the starting point of the 2nd segment.    Right: Previous" )
	language.Add("Tool_axislinedraw_5", "Left: Draw the ending point of the 2nd segment.    Right: Previous" )
	language.Add("Tool_axislinedraw_6", "Left: Validate.    Right: Previous" )
	
	language.Add("Tool_axislinedraw_force", "Force Limit" )
	language.Add("Tool_axislinedraw_torque", "Torque Limit" )
	language.Add("Tool_axislinedraw_friction", "Friction" )
	language.Add("Tool_axislinedraw_nocollide", "Nocollide" )
	
	language.Add("Undone_AxisLinedraw","Undone Axis Linedraw")
	
	language.Add("Cleanup_AxisLinedraw","Axis Linedraw")
	language.Add("Cleaned_AxisLinedraw","Cleaned up all Axis Linedraw")
end

function TOOL:LeftClick(trace)
	local curStage = self:GetStage()
	
	--local iNum = self:NumObjects()
	
	-- Don't allow us to choose the world as the first object
	if (curStage == 0 and not trace.Entity:IsValid()) then return false end
	
	-- Don't allow the first object to be the second
	if (curStage == 1 and trace.Entity:IsValid() and trace.Entity == self:GetEnt(1)) then return false end
	
	-- If there's no physics object then we can't constraint it!
	if ( SERVER and not util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local physObject = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( curStage + 1, trace.Entity, trace.HitPos, physObject, trace.PhysicsBone, trace.HitNormal )
	
	if ( curStage > 0 ) then
		local firstEntity = self:GetEnt( 1 )
		
		-- Something happened, the entity became invalid half way through
		-- Finish it.
		if ( not firstEntity:IsValid() ) then
		
			self:ClearObjects()
			return false
		
		end
		
	end
	
	if ( curStage > 1 ) then
		local secondEntity = self:GetEnt( 2 )
		
		-- Something happened, the entity became invalid half way through
		-- Finish it.
		if ( not secondEntity:IsValid() and not secondEntity:IsWorld() ) then
			self:ClearObjects()
			return false
		
		end
		
	end
	
	if ( curStage > 5 ) then
	
		-- Clientside can bail out
		if ( CLIENT ) then	
			self:ClearObjects()
			return true
		
		end
	
		-- Get client's CVars
		local forcelimit	= self:GetClientNumber( "forcelimit", 0 )
		local torquelimit 	= self:GetClientNumber( "torquelimit", 0 )
		local friction		= self:GetClientNumber( "hingefriction", 0 )
		local nocollide		= self:GetClientNumber( "nocollide", 0 )
		
		local Ent1,  Ent2  = self:GetEnt(1), self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1), self:GetBone(2)
		--local WPos1, WPos2 = self:GetPos(1), self:GetPos(2)
		--local LPos1, LPos2 = self:GetLocalPos(1), self:GetLocalPos(2)
		--local Norm1, Norm2 = self:GetNormal(1), self:GetNormal(2)
		local Phys1, Phys2 = self:GetPhys(1), self:GetPhys(2)
		local WPos3, WPos4 = self:GetPos(3), self:GetPos(4)
		local WPos5, WPos6 = self:GetPos(5), self:GetPos(6)
		
				
		-- Set the hinge Axis perpendicular to the trace hit surface
		local LPos1 = Phys1:WorldToLocal( WPos3 + (WPos4 - WPos3) * 0.5 )
		local LPos2 = Phys2:WorldToLocal( WPos5 + (WPos6 - WPos5) * 0.5 )
		
		if ( WPos3 + (WPos4 - WPos3) * 0.5 ) == ( WPos5 + ( WPos6 - WPos5) * 0.5 ) then
			self:ClearObjects()
			self:GetOwner():SendLua( "GAMEMODE:AddNotify('Error: The two middles are the same point. Do not undo!', NOTIFY_GENERIC,7);" )
			self.Weapon:EmitSound( self._SoundError )
			return true -- Return true to enable the toolgun to shoot
			
		end
		
		-- Create a constraint axis
		local constraint = constraint.Axis( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, friction, nocollide )

		undo.Create("AxisLinedraw")
		undo.AddEntity( constraint )
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		self:GetOwner():AddCleanup( "constraints", constraint )
		
		-- Clear the objects so we're ready to go again
		self:ClearObjects()
		
		self:GetOwner():SendLua( "GAMEMODE:AddNotify('Constraint completed successfully.', NOTIFY_GENERIC,7);" )
		self.Weapon:EmitSound( self._SoundValidate )
		self._Alerted = nil
		
	else
		self:SetStage( curStage + 1 )
		
	end
	
	return true
	
end

function TOOL:Holster( trace )
	--self:ClearObjects()
	if CLIENT then return end
	
	local curStage = self:GetStage()
	if curStage > 5 and not self._Alerted then
		self:GetOwner():SendLua( "GAMEMODE:AddNotify('Warning: Constraint was not applied because you did not validate! You can still switch back.', NOTIFY_GENERIC,7);" )
		self.Weapon:EmitSound( self._SoundAlert )
		self._Alerted = true
		
	end
	
end
		
function TOOL:RightClick( tr )	
	local curStage = self:GetStage()
	if curStage == 0 then return false end
	
	self:SetStage( curStage - 1 )
	self._Alerted = nil
	return true
	
end

function TOOL:Reload( trace )
	local curStage = self:GetStage()
	if curStage > 0 then
		self:ClearObjects()
		return true
		
	end	
	
	if ( not trace.Entity:IsValid() or trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local bool = constraint.RemoveConstraints( trace.Entity, "Axis" )
	return bool
	
end

function TOOL.BuildCPanel(panel)
	panel:AddControl("Header",{Text = "#Tool_axislinedraw_name", Description	= "#Tool_axislinedraw_desc"})
	panel:AddControl("Slider",{Label = "#Tool_axislinedraw_force",
								Description = "",
								Type = "Float",
								Min = 0,
								Max = 50000,
								Command = "axislinedraw_forcelimit" } )	
	panel:AddControl("Slider",{Label = "#Tool_axislinedraw_torque",
								Description = "",
								Type = "Float",
								Min = 0,
								Max = 50000,
								Command = "axislinedraw_torquelimit" } )	
	panel:AddControl("Slider",{Label = "#Tool_axislinedraw_friction",
								Description = "",
								Type = "Float",
								Min = 0,
								Max = 100,
								Command = "axislinedraw_hingefriction" } )	
	panel:AddControl("CheckBox",{Label = "#Tool_axislinedraw_nocollide", Description = "", Command = "nocollide"})
	
end
