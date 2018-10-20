/*
	YouTube Player by I_am_McLovin
	<mclovin1015@gmail.com>
	
	You are welcome to learn from 
	this and modify for personal use.
	Just don't re-upload this code
	or any modified versions of it.
*/

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "YouTube Player"
ENT.Author = "I am McLovin"

ENT.Spawnable = false
ENT.AdminSpawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

/*
	If you decide to add your own screen
	just put the screen dir in Screen_List here like 
	I did with the others, then you can define your 
	own offsets in Screen_Offsets. It should
	be pretty straight forward. If I get enough requests I 
	might release a tutorial on how to modify/add screens.
	Keep checking my channel for updates! (McLoves1001)
	
	NOTE: 
	Keep the width and height the same. Sometimes
	it will give you purple and black shit and if you raise the 
	resolution it will start to lag.
*/

Screen_List = { 
	["models/props/cs_office/tv_plasma.mdl"] = true,
	["models/props/cs_assault/billboard.mdl"] = true, 
	["models/props/cs_office/projector.mdl"] = true 
}

Screen_Offsets = { 
	["models/props/cs_office/tv_plasma.mdl"] = {
		["scale"] = 0.0555,
		["w"] = 1025,
		["h"] = 513,
		["x"] = 0.79,
		["y"] = 1.9,
		["z"] = 8
	},
	["models/props/cs_assault/billboard.mdl"] = {
		["scale"] = 0.219,
		["w"] = 1025,
		["h"] = 513,
		["x"] = 52,
		["y"] = 7.8,
		["z"] = 17.8
	},
	["models/props/cs_office/projector.mdl"] = {
		["scale"] = 0.001,
		["w"] = 1025,
		["h"] = 513
	}
}
