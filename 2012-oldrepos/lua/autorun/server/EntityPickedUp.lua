function PNY_GGGrab(ply, ent)
	ply:SetDTEntity(3, ent)
	
end
hook.Add("GravGunOnPickedUp", "PNY_GGGrab", PNY_GGGrab);


function PNY_GGDrop(ply, ent)
	ply:SetDTEntity(3, nil)
	
end
hook.Add("GravGunOnDropped", "PNY_GGDrop", PNY_GGDrop);


function PNY_Punt(ply, ent)
	ply:SetDTEntity(3, ent)
	timer.Simple( 0.2, function(ply, ent) if ValidEntity(ply) and ply:GetDTEntity(3) == ent then ply:SetDTEntity(3, nil) end end, ply, ent )
	
end
hook.Add("GravGunPunt", "PNY_Punt", PNY_Punt)