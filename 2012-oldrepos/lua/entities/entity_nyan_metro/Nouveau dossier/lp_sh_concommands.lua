local ConVars = {}
// LIBERTY PRIME
ConVars["sk_libertyprime_health"] = 40000
ConVars["sk_libertyprime_dmg_laser"] = 88
ConVars["sk_libertyprime_dmg_bomb"] = 10000

for k, v in pairs(ConVars) do
	CreateConVar(k, v, {})
end