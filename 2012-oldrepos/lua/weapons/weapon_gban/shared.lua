
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.PrintName       = "garry BAN SIMULATOR"
SWEP.Author          = "Hurricaaane (Ha3)"           
SWEP.Slot            = 5
SWEP.SlotPos         = 10
SWEP.DrawAmmo        = false
SWEP.DrawCrosshair   = true
SWEP.Weight          = 5
SWEP.AutoSwitchTo    = false
SWEP.AutoSwitchFrom  = false
SWEP.Author          = ""
SWEP.Contact         = ""
SWEP.Purpose         = ""
SWEP.Instructions    = "Shoot to ban stuff for 15 seconds."
SWEP.ViewModel       = "models/weapons/v_hands.mdl"
SWEP.WorldModel      = ""

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.HoldType = "normal"

SWEP.OwnerLastVelocity     = 0
SWEP.OwnerLastGroundEntity = nil

do
	SWEP.Sounds = {}
	SWEP.Sounds["fire"]			= Sound("buttons/button4.wav")
	
end


function SWEP:Initialize()
	
end

function SWEP:PrimaryAttack()
    return false
    
end

function SWEP:SecondaryAttack()
    return false
    
end

function SWEP:ShouldDropOnDie()
    return false
	
end

function SWEP:Think()
	if CLIENT then
		if self.Owner:KeyPressed(IN_ATTACK2) then
			self:OpenMenu()
		
		elseif self.Owner:KeyReleased(IN_ATTACK2) then
			self:CloseMenu()
		
		end
		
	end
	
end

SWEP.ShitNamePrefixes = 
{
"i",
"THE",
"super",
"dump",
"winner",
"ddt",
"douche",
"what",
"wtf"
}

SWEP.ShitNameSuffixes = 
{
"naruto",
"cirno",
"pro",
"admin",
"solid",
"wtf"
}

function SWEP:GenerateShitName( ent )
	local basename = ent:GetClass()
	local failname = self.ShitNamePrefixes[ math.random(1,#self.ShitNamePrefixes) ] .. basename .. self.ShitNameSuffixes[ math.random(1,#self.ShitNameSuffixes) ] .. math.random(1,100)
	
	return failname
	
end

function SWEP:GenerateShitPost( ent )
	return self.ShitPosts[ math.random(1,#self.ShitPosts) ]
	
end

function SWEP:CreatePosts()
	self.Ents = ents.GetAll()
	
	local i = 1
	while #self.Ents >= i do
		local ent = self.Ents[ i ]
		
		if ValidEntity( ent ) and ( ent:IsNPC() or ent:IsPlayer() or string.find( ent:GetClass(), "prop" ) ) then
			ent.__GBAN_SHITNAME = ent.__GBAN_SHITNAME or self:GenerateShitName( ent )
			ent.__GBAN_SHITPOST = ent.__GBAN_SHITPOST or self:GenerateShitPost( ent )
			
			i = i + 1
		
		else
			table.remove( self.Ents, i )
			
		end
		
	end
	
end



function SWEP:Remove()

	if CLIENT then
		self:RemoveMenu()
		
	end
	
end

function SWEP:Holster()
	
	if CLIENT then
		self:RemoveMenu()
		
	end
	
end

function SWEP:ReceiveBanRequest()
	//
end

function SWEP:PerformBan( ent, ... )
	ent:TakeDamage( ... )
	
	self:CreateBanEffects( ent )

end

function SWEP:RemoveMenu()
	if self.HangMenu then
		self.HangMenu:Remove()
		
	end
	self.HangMenu = nil
	
end

function SWEP:OpenMenu()
	self:GetMenu().Contents = self:UpdateContents()
	
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
		
	self.HangMenu = vgui.Create( "GBAN_Menu" )
	self.HangMenu.LIFE = self
	
	return self.HangMenu
	
end


function SWEP:UpdateContents()
	self:CreatePosts()
	
	if self.HangMenu.Contents then
		self.HangMenu.Contents:Remove()
		self.HangMenu.Contents = nil
	
	end
	
	return self:BuildContents()

end

SWEP.ShitPosts = {
"first",
"second",
"i cant use garrysmod.org it doesnt want my steam acount",
"garry if u dunt want gmod to be stolen then make it free",
"capsadmin and irzilla is butthurt",
"gmod sucks since garry makes money",
"(User was banned for this post (Predicting banana))"
}

function SWEP:BuildContents()
	local form = vgui.Create( "DForm", self.HangMenu )
	form:SetSize( 350, 50 )
	form:SetSpacing( 4 )
	form:SetName( "" )
	form.Paint = function( self )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
		
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
		
	end
	
	for i=1,1 do
		local cpanel = vgui.Create( "DForm" )
		cpanel:SetSize( 50, 50 )
		cpanel:SetSpacing( 4 )
		cpanel:SetName( "CREATE SOME NPCS OR PROPS TO UPDATE" )
		cpanel.Paint = function( self )
			surface.SetDrawColor( 240, 240, 240, 255 )
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
			
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
			
		end
		
		do
			local label = vgui.Create( "DLabel" )
			label:SetText( self.ShitPosts[ math.random(1,#self.ShitPosts) ] )
			label:SetTextColor( Color(0, 0, 0) )
			label:SetFont( "Default" )
			cpanel:AddItem( label )
		
		end
		
		do
			local label = vgui.Create( "DLabel" )
			label.Think = function ( self )
				if ((CurTime() % 2) > 1) then
					if not self.IsBanned then
						self.IsBanned = true
						label:SetText( "(User was banned for this post)" )
						label:SetTextColor( Color(255, 0, 0) )
						label:SetFont( "DefaultBold" )
						
					end
					
				elseif self.IsBanned then
					self.IsBanned = false
					label:SetText( "Click here to ban this user." )
					label:SetTextColor( Color(0, 0, 255) )
					label:SetFont( "DefaultUnderline" )
					
				end
				
			end
			cpanel:AddItem( label )
		
		end
		cpanel:SizeToContents()
		form:AddItem( cpanel )
		
	end
	
	for k,ent in pairs( self.Ents ) do
		local cpanel = vgui.Create( "DPanel" )
		cpanel:SetSize( 50, 50 )
		--cpanel:SetSpacing( 4 )
		--cpanel:SetName( ent.__GBAN_SHITNAME )
		cpanel.Paint = function( self )
			surface.SetDrawColor( 240, 240, 240, 255 )
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
			
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
			
		end
		cpanel.OBJ = {}
		
		do
			local icon = vgui.Create( "DModelPanel", cpanel )
			icon:SetModel( ent:GetModel() or "" )
			 
			icon:SetSize( 64, 64 )
			icon:SetCamPos( Vector( 75, 0, ent:OBBCenter().z ) )
			icon:SetLookAt( Vector( 0, 0, ent:OBBCenter().z) )
			--cpanel:AddItem( icon )
			
			cpanel.OBJ["avatar"] = icon
			
		end
		
		do
			local label = vgui.Create( "DLabel", cpanel )
			label:SetText( ent.__GBAN_SHITNAME )
			label.Think = function ( self ) 
				if not cpanel.IsBanned then
					self:SetTextColor( Color(0, 0, 0) )
					self:SetFont( "Default" )
					
				else
				
					self:SetTextColor( Color(255, 0, 0) )
					self:SetFont( "DefaultBold" )
					
				end
				
			end
			
			cpanel.OBJ["name"] = label
		
		end
		
		do
			local label = vgui.Create( "DLabel", cpanel )
			label:SetText( ent.__GBAN_SHITPOST )
			label:SetTextColor( Color(0, 0, 0) )
			label:SetFont( "Default" )
			--cpanel:AddItem( label )
			
			cpanel.OBJ["post"] = label
		
		end
		
		do
			local label = vgui.Create( "DLabel", cpanel )
			label.BOOT = true
			label.Think = function ( self )
				if ((CurTime() % 2) > 1) then
					if not cpanel.IsBanned or self.BOOT then
						cpanel.IsBanned = true
						label:SetText( "(User was banned for this post)" )
						label:SetTextColor( Color(255, 0, 0) )
						label:SetFont( "DefaultBold" )
						
					end
					
				elseif cpanel.IsBanned  or self.BOOT then
					cpanel.IsBanned = false
					label:SetText( "Click here to ban ".. ent.__GBAN_SHITNAME .. "." )
					label:SetTextColor( Color(0, 0, 255) )
					label:SetFont( "DefaultUnderline" )
					
				end
				self.BOOT = false
				
			end
			--cpanel:AddItem( label )
			
			cpanel.OBJ["message"] = label
		
		end
		cpanel.PerformLayout = function ( self )
			self.OBJ.post:SizeToContents()
			self.OBJ.message:SizeToContents()
			self.OBJ.name:SizeToContents()
			
			self.OBJ.post:SetWide( self:GetWide() )
			self.OBJ.message:SetWide( self:GetWide() )
			self.OBJ.name:SetWide( self:GetWide() )
			
			
			self.OBJ.name:AlignTop( 5 )
			self.OBJ.name:AlignLeft( 5 )
			
			self.OBJ.avatar:MoveBelow( self.OBJ.name, 5 )
			self.OBJ.avatar:AlignLeft( 5 )
			
			self.OBJ.post:MoveBelow( self.OBJ.name, 5 )
			self.OBJ.post:MoveRightOf( self.OBJ.avatar, 5 )
			
			self.OBJ.message:MoveBelow( self.OBJ.post, 5 )
			self.OBJ.message:MoveRightOf( self.OBJ.avatar, 5 )
			self:SetTall( 80 )
			
		end
		cpanel:SizeToContents()
		form:AddItem( cpanel )
		
	end
	
	return form

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
	
	function PANEL:Open()
		self:SetHangOpen( false )
		
		if ( self:IsVisible() ) then return end
		
		//CloseDermaMenus()
		
		self:MakePopup()
		self:SetVisible( true )
		self:SetKeyboardInputEnabled( false )
		self:SetMouseInputEnabled( true )
		
		RestoreCursorPosition()
		
		// Set up the active panel..
		if ( self.Contents ) then
			self.OldParent = self.Contents:GetParent()
			self.OldPosX, self.OldPosY = self.Contents:GetPos()
			self.Contents:SetParent( self )
			self.Canvas:Clear()
			self.Canvas:AddItem( self.Contents )
			self.Canvas:Rebuild()
			
		end
		
		self.animOut:Stop()
		self.animIn:Stop()
		
		self:InvalidateLayout( true )
		
		self.animIn:Start( 0.1, { TargetY = self.y } )

	end

	function PANEL:Close( bSkipAnim )

		if ( self:GetHangOpen() ) then 
			self:SetHangOpen( false )
			return
		end
		
		RememberCursorPosition()
		
		//CloseDermaMenus()

		self:SetKeyboardInputEnabled( false )
		self:SetMouseInputEnabled( false )
		
		self.animIn:Stop()
		
		if ( bSkipAnim ) then
		
			self:SetAlpha( 255 )
			self:SetVisible( false )
			self:RestoreControlPanel()
			
		else
		
			self.animOut:Start( 0.1, { StartY = self.y } )
			
		end

	end
	
	function PANEL:Think()
		////////
		if not ValidEntity( self.LIFE ) then self:Remove() return end
		
		self.animIn:Run()
		self.animOut:Run()

	end
	
	function PANEL:PerformLayout()
		
		if ( self.Contents ) then
		
			self.Contents:InvalidateLayout( true )
			
			local Tall = self.Contents:GetTall() + 10
			local MaxTall = ScrH() * 0.8
			if ( Tall > MaxTall ) then Tall = MaxTall end
			
			self:SetTall( Tall )
			self.x = (ScrW() - self:GetWide()) / 2
		
		end

		self:SetWide( ScrW() * 0.6 )

		--self:SetPos( ScrW() - self:GetWide() - 50, self.y )
		self:SetPos( self.x , ScrH() - 50 - self:GetTall() )
		
		self.Canvas:StretchToParent( 0, 0, 0, 0 )
		self.Canvas:InvalidateLayout( true )
		
		self.animIn:Run()
		self.animOut:Run()

	end

	function PANEL:StartKeyFocus( pPanel )

		self:SetKeyboardInputEnabled( true )
		self:SetHangOpen( true )
		
	end

	function PANEL:EndKeyFocus( pPanel )

		self:SetKeyboardInputEnabled( false )

	end

	function PANEL:RestoreControlPanel()

		// Restore the active panel
		if ( !self.Contents ) then return end
		if ( !self.OldParent ) then return end
		
		self.Contents:SetParent( self.OldParent )
		self.Contents:SetPos( self.OldPosX, self.OldPosY )
		
		self.OldParent = nil

	end

	function PANEL:OpenAnim( anim, delta, data )
		
		if ( anim.Started ) then
			
		end
		
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
		
			self:SetVisible( false )
			self:RestoreControlPanel()
			return
			
		end
		
		--local Distance = ScrW() - data.StartX
		local Distance = ScrH() - data.StartY
		
		self.y = data.StartY + Distance * ( delta ^ 2 )

	end


	vgui.Register( "GBAN_Menu", PANEL, "EditablePanel" )

end

