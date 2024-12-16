extends Node

#inventory dictionary variables
@export var item_quantity = 0
@export var item_type = ""
@export var item_name = ""
@export var item_effect = ""
@export var item_texture = Texture
@export var item_scene_path = ""

#player dictionary variables
@export var speed = 200.0
@export var runspeed = speed * 1.3
@export var jump_height = -300.0
@export var has_weapon := false
@export var weapon_found := false
@export var has_hat := false
@export var hat_found := false
@export var has_spell := false
@export var dash_speed = 800
@export var melee_dmg := 2
@export var magic_dmg := 1
@export var coins := 0
@export var inventory : Array
@export var inventory_hotbar_array : Array
@export var max_health = 3
@export var health = max_health
@export var max_mana = 1
@export var mana = max_mana
@export var max_dashes = 1
@export var dashes = max_dashes
@export var current_xp = 0
@export var xp_required = 10
@export var player_level = 1
@export var last_positionx = 0.0
@export var last_positiony = 0.0
@export var positionx = 11.0
@export var positiony = 693.0
@export var skillpoints = 0
@export var warrior_heart = false
@export var sharp_mind = false
@export var quick_step = false
@export var dodge = 5
@export var warrior_might = false
@export var crit_chance = 0
@export var flowing_water = false
@export var deep_cuts = false
@export var waterfall = false
@export var focused_chi = false
@export var deep_burn = false

@export var inventory_dic = {
		"quantity" : item_quantity,
		"type" : item_type,
		"name" : item_name,
		"effect" : item_effect,
		"texture" : item_texture,
		"scene_path" : item_scene_path
}

@export var player_dic = {
		"speed" = speed,
		"runspeed" = runspeed,
		"jump_height" = jump_height,
		"weapon_found" = weapon_found,
		"has_weapon" = has_weapon,
		"hat_found" = hat_found,
		"has_hat" = has_hat,
		"has_spell" = has_spell,
		"dash_speed" = dash_speed,
		"melee_dmg" = melee_dmg,
		"magic_dmg" = magic_dmg,
		"max_health" = max_health,
		"max_dashes" = max_dashes,
		"max_mana" = max_mana,
		"health" = health,
		"dashes" = dashes,
		"mana" = mana,
		"Coins" = coins,
		"inventory" = inventory,
		"inventory_hotbar_array" = inventory_hotbar_array,
		"current_xp" = current_xp,
		"xp_required" = xp_required,
		"player_level" = player_level,
		"last_positionx" = last_positionx,
		"last_positiony" = last_positiony,
		"positionx" = positionx,
		"positiony" = positiony,
		"skillpoints" = skillpoints,
		"warrior_heart" = warrior_heart,
		"sharp_mind" = sharp_mind,
		"quick_step" = quick_step,
		"dodge" = dodge,
		"warrior_might" = warrior_might,
		"crit_chance" = crit_chance,
		"flowing_water" = flowing_water,
		"deep_cuts" = deep_cuts,
		"waterfall" = waterfall,
		"focused_chi" = focused_chi,
		"deep_burn" = deep_burn
	}
