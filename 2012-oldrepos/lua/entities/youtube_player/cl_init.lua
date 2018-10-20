/*
	YouTube Player by I_am_McLovin
	<mclovin1015@gmail.com>
	
	You are welcome to learn from 
	this and modify for personal use.
	Just don't re-upload this code
	or any modified versions of it.
*/

include( "shared.lua" )  

ENT.RenderGroup = RENDERGROUP_OPAQUE
 
ENT.Base = "base_anim"
ENT.Type = "anim"

local _self, video_list, yt_mfps, yt_on

local start_html = [[
<html>
	<head>
		<style type="text/css">
			body, html{
				padding:0px 0px 0px 0px;
				margin:0px 0px 0px 0px;
				text-align: center;
				vertical-align:100%;
				height:100%;			
			}
		</style>
	</head>
	<body scroll="no"; bgcolor="black">
	</body>
</html> 
]]

local function Create_Browser( self )
	
	local offsets = Screen_Offsets[self.Entity:GetModel()]

	self.BW = offsets.w
	self.BH = offsets.h
	
	self.Scale = offsets.scale
	
	self.Browser = vgui.Create( "HTML" )
		self.Browser:SetSize( self.BW, self.BH )
		self.Browser:SetPaintedManually( true )
		self.Browser:SetVerticalScrollbarEnabled( false )
		self.Browser:SetHTML( start_html )
		self.Browser:StartAnimate( 1000 / yt_mfps )

end

local function send_password( pass, _umsg )
	if pass and string.len( pass ) <= 150 then
		if _umsg and _umsg != "" then
			RunConsoleCommand( "youtube_player_password", pass, _umsg )
		else
			RunConsoleCommand( "youtube_player_password", pass )
		end
		return true
	else
		LocalPlayer():PrintMessage( HUD_PRINTTALK, "Invalid Password." )
		return false
	end
end

function ENT:Initialize()
	
	if !file.IsDir( "youtube player" ) then file.CreateDir( "youtube player" ) end
	if !file.IsDir( "youtube player/settings" ) then file.CreateDir( "youtube player/settings" ) end
	if !file.Exists( "youtube player/settings/settings.txt" ) then file.Write( "youtube player/settings/settings.txt", "20;1" ) end

	local fl = file.Read( "youtube player/settings/settings.txt" )
	
	yt_mfps = tonumber( string.Explode( ";", fl )[1] )
	yt_on = tonumber( string.Explode( ";", fl )[2] )
	
	_self = self
	
	self:DrawShadow( false )
	
	if yt_on == 1 then Create_Browser( self ) end
	
	if self:GetModel() == "models/props/cs_office/projector.mdl" then
		self:SetRenderBounds( Vector( -55000, -55000, -55000 ), Vector( 55000, 55000, 55000 ) )
	end

end
 
function ENT:Draw() 

	self.Entity:DrawModel() 
	
	if !self.Browser or !self.Browser:IsValid() then 
		if yt_on == 1 then
			Create_Browser( _self )
		end
		return
	end
	
	local pos, ang, _draw
	local scale = self.Scale
	
	if self.Entity:GetModel() != "models/props/cs_office/projector.mdl" then
		local offsets = Screen_Offsets[self.Entity:GetModel()]
		
		local obbmax, obbmin = self:OBBMaxs(), self:OBBMins()
		
		obbmax.x = obbmax.x - offsets.x
		obbmax.y = obbmin.y + offsets.y
		obbmax.z = obbmax.z - offsets.z
		
		pos = self:LocalToWorld( obbmax )
		
		ang = self:GetAngles()
		ang:RotateAroundAxis( ang:Right(), -90 )  
		ang:RotateAroundAxis( ang:Up(), 90 )
	else
		local start = self.Entity:LocalToWorld( self.Entity:OBBCenter() )
		
		local excludes = player.GetAll()
		table.insert( excludes, self.Entity )
		
		//increase the multiplier for a greater max distance and max size
		local trace = util.QuickTrace( start, self.Entity:GetRight() * 2000, excludes )
		
		_draw = trace.Hit
		
		if _draw then
			scale = ( ( self.Scale ) * start:Distance( trace.HitPos ) )
		
			ang = trace.HitNormal:Angle()
			ang:RotateAroundAxis( ang:Forward(), 90 ) 
			ang:RotateAroundAxis( ang:Right(), -90 )
			
			pos = trace.HitPos + ( trace.HitNormal * 3 ) - ang:Right() * ( ( self.BH * scale ) / 2 ) - ang:Forward() * ( ( self.BW * scale ) / 2 )
		end
		
	end
	
	if self.Browser and self.Browser:IsValid() and ( self.Entity:GetModel() != "models/props/cs_office/projector.mdl" or ( self.Entity:GetModel() == "models/props/cs_office/projector.mdl" and _draw ) ) then
		self.Browser:SetPaintedManually( false )
		
		render.SuppressEngineLighting( true )
		
		cam.Start3D2D( pos, ang, scale )
			self.Browser:PaintManual()
			
			surface.SetDrawColor( 0, 0, 0, 255 )
			if self.Entity:GetModel() == "models/props/cs_office/tv_plasma.mdl" then
				surface.DrawRect( 0, -90, self.BW, 91 )
			elseif self.Entity:GetModel() == "models/props/cs_assault/billboard.mdl" then
				surface.DrawRect( 0, -30, self.BW, 31 )
			end
		cam.End3D2D()

		render.SuppressEngineLighting( false )
		
		self.Browser:SetPaintedManually( true )
	end
	
end

function ENT:IsTranslucent() 
 
	return true

end

function ENT:OnRemove() 
	
	if self.Browser and self.Browser:IsValid() then
		self.Browser:Remove()
	end
	
end 

usermessage.Hook( "youtube_player_spawnmenu", function( um )

	local frame = vgui.Create( "DFrame" )
		frame:SetTitle( "Youtube URL" )
		frame:SetSize( 211, 130 )
		frame:SetSizable( false )
		frame:Center()
		frame:MakePopup()
		
	local panel = vgui.Create( "DPanel", frame )
		panel:SetSize( frame:GetWide() - 10, frame:GetTall() - 30 )
		panel:SetPos( 5, 25 )
		function panel.Paint() 
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() )
		end
		
	local text = vgui.Create( "DLabel", frame )
		text:SetText( "Please choose a screen." )
		text:SizeToContents()
		text:SetPos( ((frame:GetWide() / 2) - (text:GetWide() / 2 )), 28 )
		text:SetColor( Color( 255, 255, 255, 175 ) )
	
	local spawn_menu = vgui.Create( "DPanelList", frame )
		spawn_menu:EnableVerticalScrollbar( false ) 
		spawn_menu:EnableHorizontal( true )
		spawn_menu:SetPadding( 5 )
		spawn_menu:SetPos( 5, 45 )
		spawn_menu:SetSize( 201, 75 )
	
	for screen,_ in pairs( Screen_List ) do
		local icon = vgui.Create( "SpawnIcon", spawn_menu )
			icon:SetModel( screen )
			icon.model = screen
			function icon.DoClick( )
				surface.PlaySound( "ui/buttonclickrelease.wav" )
				RunConsoleCommand( "youtube_player_spawn", icon.model )
				frame:Close()
			end
			
		spawn_menu:AddItem( icon )
	end

end )

usermessage.Hook( "youtube_player_populate_video_list", function( um )

	if video_list and video_list:IsValid() then
		video_list:AddLine( um:ReadString(), um:ReadString() )
	end	
	
	video_list:SortByColumn( 1 )

end )

usermessage.Hook( "youtube_player_use_menu", function( um )

	local frame = vgui.Create( "DFrame" )
		frame:SetTitle( "Options Panel" )
		frame:SetSize( 250, 130 )
		frame:SetSizable( false )
		frame:Center()
		frame:MakePopup()
		
	local menu_tab = vgui.Create( "DPropertySheet", frame )
		menu_tab:SetSize( frame:GetWide() - 10, frame:GetTall() - 30 )
		menu_tab:SetPos( 5, 25 )
	
	local options_tab = vgui.Create( "DPanel" )
		options_tab:SetSize( menu_tab:GetWide() - 10, menu_tab:GetTall() - 10 )
		options_tab:SetPos( 5, 5 )
		function options_tab.Paint() 
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( 0, 0, options_tab:GetWide(), options_tab:GetTall() )
		end
		
	local fps_bar = vgui.Create( "DNumSlider", options_tab )
		fps_bar:SetSize( options_tab:GetWide() - 10, 100 )
		fps_bar:SetPos( 5, 5 )
		fps_bar:SetText( "Max FPS" )
		fps_bar:SetMin( 1 )
		fps_bar:SetMax( 50 )
		fps_bar:SetDecimals( 0 )
		fps_bar:SetValue( yt_mfps )
		function fps_bar.Think()
			if fps_bar:GetValue() != yt_mfps then
				yt_mfps = fps_bar:GetValue()
				file.Write( "youtube player/settings/settings.txt", table.concat( { yt_mfps, yt_on }, ";" ) )
				if _self.Browser then
					_self.Browser:StopAnimate()
					_self.Browser:StartAnimate( 1000 / yt_mfps ) 
				end
			end
		end
		
	local stop_video = vgui.Create( "DButton", options_tab )
		stop_video:SetSize( (options_tab:GetWide() - 10) / 2, 20 )
		stop_video:SetPos( 5, 45 )
		stop_video:SetText( "Stop Video" )
		function stop_video.DoClick()
			if _self.Browser then
				_self.Browser:SetHTML( start_html )
			end
		end	
		
	local on_off = vgui.Create( "DCheckBoxLabel", options_tab )
		on_off:SetPos( ( ( options_tab:GetWide() - 10 ) / 2 ) + 20, 47 )
		on_off:SetText( "Player On" )
		on_off:SetValue( yt_on )
		on_off:SizeToContents()
		function on_off.Think()
			local val
			if on_off:GetChecked( true ) then
				val = 1
			else
				val = 0
			end
			if val != yt_on then
				yt_on = val
				file.Write( "youtube player/settings/settings.txt", table.concat( { yt_mfps, yt_on }, ";" ) )
				if yt_on == 1 then
					Create_Browser( _self )
				else
					if _self.Browser then 
						_self.Browser:Remove() 
						_self.Browser = nil
					end
				end
			end
		end
		
	menu_tab:AddSheet( "Player Options", options_tab, "gui/silkicons/wrench", false, false, "Youtube Player Options" )
	
	if LocalPlayer():IsAdmin() then
		if um:ReadBool() then
			local video_tab = vgui.Create( "DPanel" )
				video_tab:SetSize( menu_tab:GetWide() - 10, menu_tab:GetTall() - 10 )
				video_tab:SetPos( 5, 5 )
				function video_tab.Paint() 
					surface.SetDrawColor( 0, 0, 0, 235 )
					surface.DrawRect( 0, 0, video_tab:GetWide(), video_tab:GetTall() )
				end
				
			local video_options = vgui.Create( "DLabel", video_tab )
				video_options:SetText( "Video Options" )
				video_options:SizeToContents()
				video_options:SetPos( ( ( video_tab:GetWide() / 2 ) - ( video_options:GetWide() / 2 ) ), 3 )
				video_options:SetColor( Color( 255, 255, 255, 175 ) )
				
			local url_window_btn = vgui.Create( "DButton", video_tab )
				url_window_btn:SetText( "Enter a URL" )
				url_window_btn:SetSize( video_tab:GetWide() - 10, 20 )
				url_window_btn:SetPos( 5, 20 )
				function url_window_btn.DoClick()
					frame:Close()
					
					frame = vgui.Create( "DFrame" )
						frame:SetTitle( "URL Entry" )
						frame:SetSize( 250, 95 )
						frame:SetSizable( false )
						frame:Center()
						frame:MakePopup()
						
					local panel = vgui.Create( "DPanel", frame )
						panel:SetSize( frame:GetWide() - 10, frame:GetTall() - 30 )
						panel:SetPos( 5, 25 )
						function panel.Paint() 
							surface.SetDrawColor( 0, 0, 0, 235 )
							surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() )
						end
						
					local text = vgui.Create( "DLabel", frame )
						text:SetText( "Please enter a Youtube URL" )
						text:SizeToContents()
						text:SetPos( ((frame:GetWide() / 2) - (text:GetWide() / 2 )), 28 )
						text:SetColor( Color( 255, 255, 255, 175 ) )
						
					local textbox = vgui.Create( "DTextEntry", frame )
						textbox:SetSize( 236, 20 )
						textbox:SetPos( 7, 45 )
						function textbox.OnEnter()
							RunConsoleCommand( "youtube_player_url", textbox:GetValue() )
							frame:Close()
						end
						
					local sendurl = vgui.Create( "DButton", frame )
						sendurl:SetText( "Load Video" )
						sendurl:SetSize( 236, 20 )
						sendurl:SetPos( 7, 67 )
						function sendurl.DoClick()
							RunConsoleCommand( "youtube_player_url", textbox:GetValue() )
							frame:Close()
						end
				end
			
			local video_list_btn = vgui.Create( "DButton", video_tab )
				video_list_btn:SetText( "Load Video List" )
				video_list_btn:SetSize( video_tab:GetWide() - 10, 20 )
				video_list_btn:SetPos( 5, 45 )
				function video_list_btn.DoClick()
					frame:Close()
					
					local selected = nil
					
					frame = vgui.Create( "DFrame" )
						frame:SetTitle( "Video List" )
						frame:SetSize( 250, 165 )
						frame:SetSizable( false )
						frame:Center()
						frame:MakePopup()
						
					local panel = vgui.Create( "DPanel", frame )
						panel:SetSize( frame:GetWide() - 10, frame:GetTall() - 30 )
						panel:SetPos( 5, 25 )
						function panel.Paint() 
							surface.SetDrawColor( 0, 0, 0, 235 )
							surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() )
						end
						
					video_list = vgui.Create( "DListView", panel )
						video_list:SetSize( panel:GetWide() - 10, 100 )
						video_list:SetPos( 5, 5 )
						video_list:SetMultiSelect( false )
						video_list:AddColumn( "Name" )
						video_list:AddColumn( "URL" )
						function video_list.OnRowSelected( parent, row )
							local dlist = DermaMenu()
							
							dlist:AddOption( "Load Video", function()
								RunConsoleCommand( "youtube_player_url", video_list:GetLine(row):GetValue(2) )
								frame:Close()
							end )
							
							dlist:AddOption( "Remove Video", function()
								RunConsoleCommand( "youtube_player_remove_video", video_list:GetLine(row):GetValue(1) )
								video_list:RemoveLine( row )
							end )
							
							dlist:Open()
							
							selected = row
						end
						
					local add_video = vgui.Create( "DButton", panel )
						add_video:SetText( "Add Video" )
						add_video:SetSize( panel:GetWide() - 13, 20 )
						add_video:SetPos( 7, 110 )
						function add_video.DoClick()
							frame:Close()
							
							frame = vgui.Create( "DFrame" )
								frame:SetTitle( "Add Video" )
								frame:SetSize( 210, 145 )
								frame:SetSizable( false )
								frame:Center()
								frame:MakePopup()
							
							local panel = vgui.Create( "DPanel", frame )
								panel:SetSize( frame:GetWide() - 10, frame:GetTall() - 30 )
								panel:SetPos( 5, 25 )
								function panel.Paint() 
									surface.SetDrawColor( 0, 0, 0, 235 )
									surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() )
								end
								
							local name_label = vgui.Create( "DLabel", frame )
								name_label:SetText( "Name" )
								name_label:SizeToContents()
								name_label:SetPos( ( ( frame:GetWide() / 2 ) - ( name_label:GetWide() / 2 ) ), 28 )
								name_label:SetColor( Color( 255, 255, 255, 175 ) )
								
							local namebox = vgui.Create( "DTextEntry", frame )
								namebox:SetSize( 190, 20 )
								namebox:SetPos( 10, 45 )
								
							local URL_label = vgui.Create( "DLabel", frame )
								URL_label:SetText( "URL" )
								URL_label:SizeToContents()
								URL_label:SetPos( ( ( frame:GetWide() / 2 ) - ( URL_label:GetWide() / 2 ) ), 70 )
								URL_label:SetColor( Color( 255, 255, 255, 175 ) )
								
							local URL_box = vgui.Create( "DTextEntry", frame )
								URL_box:SetSize( 190, 20 )
								URL_box:SetPos( 10, 90 )
								
							local add_video = vgui.Create( "DButton", frame )
								add_video:SetText( "Add Video" )
								add_video:SetSize( 190, 20 )
								add_video:SetPos( 10, 115 )
								function add_video.DoClick()
									if namebox:GetValue() and namebox:GetValue() != "" and string.len( namebox:GetValue() ) <= 50 and URL_box:GetValue() and URL_box:GetValue() != "" and string.len( URL_box:GetValue() ) <= 100 then
										RunConsoleCommand( "youtube_player_add_video", namebox:GetValue(), URL_box:GetValue() )
										frame:Close()
									end
								end
						end
						
					RunConsoleCommand( "youtube_player_start_populate" )
				end
				
			menu_tab:AddSheet( "Video Options", video_tab, "gui/silkicons/user", false, false, "Youtube Player Video Options" )
		else
			local video_tab = vgui.Create( "DPanel" )
				video_tab:SetSize( menu_tab:GetWide() - 10, menu_tab:GetTall() - 10 )
				video_tab:SetPos( 5, 5 )
				function video_tab.Paint() 
					surface.SetDrawColor( 0, 0, 0, 235 )
					surface.DrawRect( 0, 0, video_tab:GetWide(), video_tab:GetTall() )
				end
				
			local pass_text = vgui.Create( "DLabel", video_tab )
				pass_text:SetText( "Please enter the password." )
				pass_text:SizeToContents()
				pass_text:SetPos( ( ( video_tab:GetWide() / 2 ) - ( pass_text:GetWide() / 2 ) ), 5 )
				pass_text:SetColor( Color( 255, 255, 255, 175 ) )
			
			local pass_box = vgui.Create( "DTextEntry", video_tab )
				pass_box:SetSize( video_tab:GetWide() - 10, 20 )
				pass_box:SetPos( 5, 20 )
				function pass_box.OnEnter()
					if send_password( pass_box:GetValue() ) then frame:Close() end
				end
				
			local send_pass = vgui.Create( "DButton", video_tab )
				send_pass:SetText( "Submit" )
				send_pass:SetSize( video_tab:GetWide() - 10, 20 )
				send_pass:SetPos( 5, 45 )
				function send_pass.DoClick()
					if send_password( pass_box:GetValue() ) then frame:Close() end
				end
			
			menu_tab:AddSheet( "Video Options", video_tab, "gui/silkicons/user", false, false, "Youtube Player Video Options" )
		end
	end

end )

usermessage.Hook( "youtube_player_password_request", function( um )
	
	local _umsg = um:ReadString()
	
	local frame = vgui.Create( "DFrame" )
		frame:SetTitle( "Password Entry" )
		frame:SetSize( 250, 95 )
		frame:SetSizable( false )
		frame:Center()
		frame:MakePopup()
		
	local panel = vgui.Create( "DPanel", frame )
		panel:SetSize( frame:GetWide() - 10, frame:GetTall() - 30 )
		panel:SetPos( 5, 25 )
		function panel.Paint() 
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() )
		end
		
	local pass_text = vgui.Create( "DLabel", frame )
		pass_text:SetText( "Please enter the password." )
		pass_text:SizeToContents()
		pass_text:SetPos( ( ( frame:GetWide() / 2 ) - ( pass_text:GetWide() / 2 ) ), 28 )
		pass_text:SetColor( Color( 255, 255, 255, 175 ) )
		
	local pass_box = vgui.Create( "DTextEntry", frame )
		pass_box:SetSize( 236, 20 )
		pass_box:SetPos( 7, 45 )
		function pass_box.OnEnter()
			if send_password( pass_box:GetValue(), _umsg ) then frame:Close() end
		end
		
	local send_pass = vgui.Create( "DButton", frame )
		send_pass:SetText( "Submit" )
		send_pass:SetSize( 236, 20 )
		send_pass:SetPos( 7, 67 )
		function send_pass.DoClick()
			if send_password( pass_box:GetValue(), _umsg ) then frame:Close() end
		end

end )

usermessage.Hook( "youtube_player_start_video", function( um )
	
	local self = _self
	
	if !self or !self:IsValid() or !self.Browser then return end
	
	local url = um:ReadString()
	
	print( "(CLIENT) Loading Video...\n" .. url .. "\n" )
	
	/* Patdaman was here :D */
	local load_html = [[
	<html>
		<body bgcolor="black">
			<script type='text/javascript'>
				<!--
					var youurl=']] .. url .. [[';
					var newurl=youurl.split('v=');
					var convertedurl = newurl[1]
					
					document.write("<object width='100%' height='100%'><param name='movie' value='http://www.youtube.com/v/"+ convertedurl +"&hl=en&fs=1&autoplay=1'></param><param name='allowFullScreen' value='true'><param name='autoplay' value='true'></param></param><param name='allowscriptaccess' value='always'></param><embed src='http://www.youtube.com/v/"+ convertedurl + "&hl=en&fs=1&autoplay=1' type='application/x-shockwave-flash' allowscriptaccess='always' allowfullscreen='true' width='100%' height='100%'></embed></object>"); 
				// -->
			</script>
		</body>
	</html>
	]]
	
	self.Browser:SetHTML( load_html )
	
end )
