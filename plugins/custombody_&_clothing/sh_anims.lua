--------------------------
--[[ ANIMATION TABLES ]]--
--------------------------
nut.anim.forp_Male = {
	normal = {
		idle 					=	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, ACT_COVER_LOW},
		walk 					=	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					=	{"run_all", ACT_RUN_AIM_RIFLE_STIMULATED},

		idle_panicked 			=	{"crouchIdle_panicked4", "Crouch_Idle_RPG"},
		run_panicked 			=	{"crouchRUNALL1", "crouchRUNHOLDINGALL1"},
		walk_panicked 			=	{"walk_panicked_all", "walk_panicked_all"},
		walk_panicked_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	=	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			=	{"LineIdle02", ACT_IDLE_ANGRY_SMG1},
		run_depressed 			=	{"run_all", ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			=	{"pace_all", ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, ACT_COVER_LOW}

	},
	pistol = {
		idle 					= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_panicked_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	ar2 = {
		idle 					= 	{ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_RPG},
		idle_crouch 			= 	{ACT_COVER_LOW_RPG,  "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK_RPG,  ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, "Crouch_walk_aiming_all"},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_SNIPER_RIFLE,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_panicked_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	smg = {
		idle 					= 	{ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	shotgun = {
		idle 					= 	{ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_SHOTGUN,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	grenade = {
		idle 					= 	{ACT_IDLE, ACT_IDLE_MANNEDGUN},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK, ACT_WALK_AIM_RIFLE},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_RANGE_ATTACK_THROW,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	melee = {
		idle 					= 	{ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK, ACT_WALK_AIM_RIFLE},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		run 					= 	{ACT_RUN, ACT_RUN},
		attack 					= 	ACT_MELEE_ATTACK_SWING,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_panicked_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	glide = ACT_GLIDE,
	vehicle = {
		["prop_vehicle_prisoner_pod"] = {"podpose", Vector(-3, 0, 0)},
		["prop_vehicle_jeep"] = {ACT_BUSY_SIT_CHAIR, Vector(14, 0, -14)},
		["prop_vehicle_airboat"] = {ACT_BUSY_SIT_CHAIR, Vector(8, 0, -20)},
		chair = {ACT_BUSY_SIT_CHAIR, Vector(1, 0, -23)}
	},
}

nut.anim.forp_Female = {
	normal = {
		idle 					=	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, ACT_COVER_LOW},
		walk 					=	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					=	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},

		idle_panicked 			=	{"crouch_panicked", "Crouch_Idle_RPG"},
		run_panicked 			=	{"run_panicked3__all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			=	{"Crouch_walk_all", "Crouch_walk_all"},
		walk_panicked_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	=	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			=	{"LineIdle01", ACT_IDLE_ANGRY_SMG1},
		run_depressed 			=	{"run_all", ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			=	{"walk_all_Moderate", ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, ACT_COVER_LOW}
	},
	pistol = {
		idle 					= 	{"Pistol_idle", "Pistol_idle_aim"},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK, ACT_WALK_AIM_PISTOL},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_PISTOL},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_PISTOL},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"idlepackage", "Pistol_idle_aim"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_holding_package_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{"Pistol_idle", "Pistol_idle_aim"},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{"walk_all", ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	smg = {
		idle 					=	{ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					=	{ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					=	ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload 					=	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouch_panicked", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	ar2 = {
		idle 					= 	{ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_RPG},
		idle_crouch 			= 	{ACT_COVER_LOW_RPG,  "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK_RPG,  ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, "Crouch_walk_aiming_all"},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_SNIPER_RIFLE,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_panicked_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	shotgun = {
		idle 					=	{ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					=	{ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					=	{ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					=	ACT_GESTURE_RANGE_ATTACK_SHOTGUN,

		idle_panicked 			= 	{"crouch_panicked", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	grenade = {
		idle 					=	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					=	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					=	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					=	ACT_RANGE_ATTACK_THROW,

		idle_panicked 			= 	{"crouch_panicked", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	melee = {
		idle 					=	{ACT_IDLE, ACT_IDLE_MANNEDGUN},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					=	{ACT_WALK, ACT_WALK_AIM_RIFLE},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		run 					=	{ACT_RUN, ACT_RUN},
		attack 					=	ACT_MELEE_ATTACK_SWING,

		idle_panicked 			= 	{"crouch_panicked", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	glide = ACT_GLIDE,
	vehicle = nut.anim.citizen_male.vehicle
}

local animClasses = {
	["models/lazarusroleplay/heads/female_african.mdl"] = "forp_Female",
	["models/lazarusroleplay/heads/female_asian.mdl"] = "forp_Female",
	["models/lazarusroleplay/heads/female_caucasian.mdl"] = "forp_Female",
	["models/lazarusroleplay/heads/female_hispanic.mdl"] = "forp_Female",
	["models/lazarusroleplay/heads/male_african.mdl"] = "forp_Male",
	["models/lazarusroleplay/heads/male_asian.mdl"] = "forp_Male",
	["models/lazarusroleplay/heads/male_caucasian.mdl"] = "forp_Male",
	["models/lazarusroleplay/heads/male_hispanic.mdl"] = "forp_Male"
}

-----------------------
--[[ HOLD TYPES ]]--
-----------------------
local holdTypes = {
	weapon_physgun = "smg",
	weapon_physcannon = "smg",
	weapon_stunstick = "melee",
	weapon_crowbar = "melee",
	weapon_stunstick = "melee",
	weapon_357 = "pistol",
	weapon_pistol = "pistol",
	weapon_smg1 = "smg",
	weapon_ar2 = "smg",
	weapon_crossbow = "smg",
	weapon_shotgun = "shotgun",
	weapon_frag = "grenade",
	weapon_slam = "grenade",
	weapon_rpg = "shotgun",
	weapon_bugbait = "melee",
	weapon_annabelle = "shotgun",
	gmod_tool = "pistol"
}

-- We don't want to make a table for all of the holdtypes, so just alias them.
local translateHoldType = {
	melee2 = "melee",
	fist = "melee",
	knife = "melee",
	physgun = "smg",
	crossbow = "ar2",
	slam = "grenade",
	passive = "normal",
	rpg = "shotgun"
}

local normalHoldtypes = {
	normal = true,
	fist = true,
	melee = true,
	revolver = true,
	pistol = true,
	slam = true,
	knife = true,
	grenade = true
}

local function getHoldType(weapon)
	local holdType = holdTypes[weapon:GetClass()]

	if (holdType) then
		return holdType
	elseif (weapon.HoldType) then
		return translateHoldType[weapon.HoldType] or weapon.HoldType
	else
		return "normal"
	end
end

---------------------------
--[[ DISPLAY ANIMATIONS ]]--
----------------------------
local WEAPON_LOWERED = 1
local WEAPON_RAISED = 2
local math_NormalizeAngle = math.NormalizeAngle
local string_find = string.find
local string_lower = string.lower
local getAnimClass = nut.anim.getModelClass
local config_get = nut.config.get
local length2D = FindMetaTable("Vector").Length2D

function PLUGIN:CalcMainActivity(ply, vel)
	if ( not self:HaveFalloutModel(ply) ) then return end

	local model = ply:GetModel()
	local wep = ply:GetActiveWeapon()
	local holdType = "normal"
	local state = WEAPON_LOWERED
	local action = "idle"
	local len = length2D(vel)

	if ( len >= config_get("runSpeed") - 10 ) then
		action = "run"
	elseif ( len >= 5 ) then
		action = "walk"
	end

	if ( IsValid(wep) ) then
		holdType = getHoldType(wep)

		if ( wep.IsAlwaysRaised or ALWAYS_RAISED[wep:GetClass()] ) then
			state = WEAPON_RAISED
		end
	end

	if ( ply:isWepRaised() ) then
		state = WEAPON_RAISED
	end
	
	local class = animClasses[model]

	if ( ply:getChar() and ply:Alive() ) then
		ply.CalcSeqOverride = -1

		if ( ply:Crouching() ) then
			action = action.."_crouch"
		end
		
		local animClass = nut.anim[class]

		if ( not animClass) then
			class = "citizen_male"
        end
        
		if ( not animClass[holdType] ) then
			holdType = "normal"
        end
        
		if ( not animClass[holdType][action] ) then
			action = "idle"
		end

		local animation = animClass[holdType][action]
		local value = ACT_IDLE

		if ( not ply:OnGround() ) then
			ply.CalcIdeal = animClass.glide or ACT_GLIDE
		elseif ( ply:InVehicle() ) then
			ply.CalcIdeal = animClass.normal.idle_crouch[1]
		elseif ( animation ) then
			value = animation[state]

			if (type(value) == "string") then
				ply.CalcSeqOverride = ply:LookupSequence(value)
			else
				ply.CalcIdeal = value
			end
		end

		local override = ply:getNetVar("seq")

		if ( override ) then
			ply.CalcSeqOverride = ply:LookupSequence(override)
		end

		if (CLIENT) then
			ply:SetIK(false)
		end

		local eyeAngles = ply:EyeAngles()
		local yaw = vel:Angle().yaw
		local normalized = math_NormalizeAngle(yaw - eyeAngles.y)

		ply:SetPoseParameter("move_yaw", normalized)
		
		if ( ply.nutForceSeq ) then
			return ply.CalcIdeal, ply.nutForceSeq or ACT_IDLE, ply.CalcSeqOverride or -1
		end

		return ply.CalcIdeal or ACT_IDLE, ply.CalcSeqOverride or -1
	end
end