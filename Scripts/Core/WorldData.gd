extends Node

@export var checkpoint_active = false
@export var chest_opened = false
@export var secret_found = false
@export var enemies = []
@export var dead_enemies:Array[bool] = []
@export var first_boss_defeated = false

@export var world_dic = {
		"actual_level" = null,
		"checkpoint_active" = checkpoint_active,
		"chest_opened" = chest_opened,
		"secret_found" = secret_found,
		"enemies" = enemies,
		"first_boss_defeated" = first_boss_defeated
	}
	
#func generate_level(level):
	#if level not in world_dic:
		#world_dic[level] = {
			#"actual_level" = null,
			#"checkpoint_active" = checkpoint_active,
			#"chest_opened" = chest_opened,
			#"secret_found" = secret_found
		#}
