extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Area2D.overlaps_area(GameManager.player.HitBox):
		$Label.show()
		if Input.is_action_just_pressed("up"):
			WorldData.world_dic["last_level"] = WorldData.world_dic["actual_level"]
			get_tree().change_scene_to_file("res://Scenes/WorldScenes/goblin_hills_cave.tscn")
			#WorldData.world_dic["actual_level"] = "res://Scenes/WorldScenes/goblin_hills_cave.tscn"
			PlayerData.player_dic["last_positionx"] = GameManager.player.position.x
			PlayerData.player_dic["last_positiony"] = GameManager.player.position.y
			PlayerData.player_dic["positionx"] = PlayerData.positionx
			PlayerData.player_dic["positiony"] = PlayerData.positiony
			#print("actual: " + WorldData.world_dic["actual_level"])
			#print("last: " + WorldData.world_dic["last_level"])
	else :
		$Label.hide()
