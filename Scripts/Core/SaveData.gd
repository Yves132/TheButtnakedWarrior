extends Resource

class_name SaveData

@export var inventory_dic = {
		"quantity" : 0,
		"type" : null,
		"name" : null,
		"effect" : null,
		"texture" : null,
		"scene_path" : null
}


@export var player_dic = {
		"speed" = 0.0,
		"runspeed" = 0.0,
		"jump_height" = 0.0,
		"weapon_found" = false,
		"has_weapon" = false,
		"hat_found" = false,
		"has_hat" = false,
		"has_spell" = false,
		"dash_speed" = 0,
		"melee_dmg" = 0,
		"magic_dmg" = 0,
		"Max_Health" = 0,
		"Max_Dashes" = 0,
		"Max_Mana" = 0,
		"Current_Health" = 0,
		"Current_Dashes" = 0,
		"Current_Mana" = 0,
		"Coins" = 0,
		"inventory" = [],
		"inventory_hotbar_array" = [],
		"current_xp" = 0,
		"xp_required" = 0,
		"player_level" = 0,
		"last_positionx" = 0.0,
		"last_positiony" = 0.0,
		"positionx" = 0.0,
		"positiony" = 0.0,
		"skillpoints" = 0,
		"warrior_heart" = false,
		"sharp_mind" = false,
		"quick_step" = false,
		"dodge" = 5,
		"warrior_might" = false,
		"crit_chance" = 0,
		"flowing_water" = false,
		"deep_cuts" = false,
		"waterfall" = false,
		"focused_chi" = false,
		"deep_burn" = false
	}
	
@export var world_dic = {
			"actual_level" = null,
			"checkpoint_active" = false,
			"chest_opened" = false,
			"secret_found" = false,
			"enemies" = [],
			"first_boss_defeated" = false
	}
