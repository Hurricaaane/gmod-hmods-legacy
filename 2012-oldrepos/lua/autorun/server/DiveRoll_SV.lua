function DiveRoll_KeyPress( ply, key )
if ply.RollForward and CurTime() < ply.RollForward then return false end
if ply.RollBack and CurTime() < ply.RollBack then return false end
if ply.RollLeft and CurTime() < ply.RollLeft then return false end
if ply.RollRight and CurTime() < ply.RollRight then return false end
if ply.DiveCoolDown and CurTime() < ply.DiveCoolDown then return false end
if not ply.CanDiveRoll then return false end
if ply:KeyDown(IN_FORWARD) and ply:KeyDown(IN_USE) and key == IN_JUMP then
ply.DiveCoolDown = CurTime() + 3
if ply:GetVelocity():Length() <= 300 then
ply:SetVelocity(ply:GetForward()*350)
end
ply:ConCommand("+duck")
ply.RollForward = CurTime() + 1.5
elseif ply:KeyDown(IN_BACK) and ply:KeyDown(IN_USE) and key == IN_JUMP then
ply.DiveCoolDown = CurTime() + 3
if ply:GetVelocity():Length() <= 300 then
ply:SetVelocity(ply:GetForward()*-350)
end
ply:ConCommand("+duck")
ply.RollBack = CurTime() + 1.5
elseif ply:KeyDown(IN_MOVELEFT) and ply:KeyDown(IN_USE) and key == IN_JUMP then
ply.DiveCoolDown = CurTime() + 3
if ply:GetVelocity():Length() <= 300 then
ply:SetVelocity(ply:GetRight()*-350)
end
ply:ConCommand("+duck")
ply.RollLeft = CurTime() + 1.5
elseif ply:KeyDown(IN_MOVERIGHT) and ply:KeyDown(IN_USE) and key == IN_JUMP then
ply.DiveCoolDown = CurTime() + 3
if ply:GetVelocity():Length() <= 300 then
ply:SetVelocity(ply:GetRight()*350)
end
ply:ConCommand("+duck")
ply.RollRight = CurTime() + 1.5
end
if key == IN_JUMP and ply.CanDiveRoll == true then
ply.CanDiveRoll = false
end
end
hook.Add("KeyPress","DiveRoll_KP",DiveRoll_KeyPress)

local FUCKOFFWEAPONS = {
"weapon_physgun",
"weapon_physcannon",
"weapon_pistol",
"weapon_crowbar",
"weapon_slam",
"weapon_357",
"weapon_smg1",
"weapon_ar2",
"weapon_crossbow",
"weapon_shotgun",
"weapon_frag",
"weapon_stunstick",
"weapon_rpg",
"gmod_camera",
"gmod_toolgun"}

	local GlobalGrabSound = {
	Sound("physics/flesh/flesh_impact_hard3.wav"),
	Sound("physics/flesh/flesh_impact_hard4.wav"),
	Sound("physics/flesh/flesh_impact_hard6.wav"),
	Sound("physics/cardboard/cardboard_box_break3.wav") }

function HideWepz(ply)
ply:EmitSound(GlobalGrabSound[math.random(#GlobalGrabSound)], 75, math.random(82, 90))
if ply:GetActiveWeapon():IsValid() and ply:IsValid() then
ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_RELOAD)
timer.Simple(0.04,function()
if ply:Alive() then
ply:GetViewModel():SetNoDraw(true)
end
end)
ply:GetActiveWeapon():SetNextPrimaryFire(CurTime() + 0.8)
ply:GetActiveWeapon():SetNextSecondaryFire(CurTime() + 0.8)
ply:GetActiveWeapon().Reloadaftershoot = CurTime() + 0.8
timer.Simple(0.6, function()
if ply:GetActiveWeapon():IsValid() and ply:IsValid() then
if table.HasValue(FUCKOFFWEAPONS,ply:GetActiveWeapon():GetClass()) then
ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW)
else
ply:GetActiveWeapon():Deploy()
end
ply:GetViewModel():SetNoDraw(false)
end
end)
end
end

function DiveRoll_Ground(ply)
ply.CanDiveRoll = true
if ply.RollForward and CurTime() >= ply.RollForward then
ply.RollForward = nil
ply:ConCommand("-duck")
elseif ply.RollBack and CurTime() >= ply.RollBack then
ply.RollBack = nil
ply:ConCommand("-duck")
elseif ply.RollLeft and CurTime() >= ply.RollLeft then
ply.RollLeft = nil
ply:ConCommand("-duck")
elseif ply.RollRight and CurTime() >= ply.RollRight then
ply.RollRight = nil
ply:ConCommand("-duck")
end
if ply.RollForward and CurTime() < ply.RollForward then
HideWepz(ply)
ply.RollForward = nil
ply.ForceForward = CurTime() + 0.8
timer.Simple(0.5,function()
ply:ConCommand("-duck")
end)
umsg.Start("DiveToMS",ply)
umsg.Float(360)
umsg.Float(1.3)
umsg.End()
elseif ply.RollBack and CurTime() < ply.RollBack then
HideWepz(ply)
ply.RollBack = nil
ply.ForceBack = CurTime() + 0.8
timer.Simple(0.5,function()
ply:ConCommand("-duck")
end)
umsg.Start("DiveToMS",ply)
umsg.Float(-360)
umsg.Float(1.3)
umsg.End()
elseif ply.RollLeft and CurTime() < ply.RollLeft then
HideWepz(ply)
ply.RollLeft = nil
ply.ForceLeft = CurTime() + 0.8
timer.Simple(0.5,function()
ply:ConCommand("-duck")
end)
umsg.Start("SideDiveToMS",ply)
umsg.Float(-360)
umsg.Float(1.3)
umsg.End()
elseif ply.RollRight and CurTime() < ply.RollRight then
HideWepz(ply)
ply.RollRight = nil
ply.ForceRight = CurTime() + 0.8
timer.Simple(0.5,function()
ply:ConCommand("-duck")
end)
umsg.Start("SideDiveToMS",ply)
umsg.Float(360)
umsg.Float(1.3)
umsg.End()
end
end
hook.Add("OnPlayerHitGround","DROLLGROUND",DiveRoll_Ground)

function DiveRoll_Think()
for k,v in pairs (player.GetAll()) do
if v.ForceForward and CurTime() <= v.ForceForward then
v:SetLocalVelocity(v:GetForward()*250)
elseif v.ForceBack and CurTime() <= v.ForceBack then
v:SetLocalVelocity(v:GetForward()*-250)
elseif v.ForceLeft and CurTime() <= v.ForceLeft then
v:SetLocalVelocity(v:GetRight()*-250)
elseif v.ForceRight and CurTime() <= v.ForceRight then
v:SetLocalVelocity(v:GetRight()*250)
end
end
end
hook.Add("Think","DiveRollTHINK",DiveRoll_Think)