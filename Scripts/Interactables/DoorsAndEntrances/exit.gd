extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Area2D.overlaps_area(GameManager.player.HitBox):
		$Label.show()
		if Input.is_action_just_pressed("up"):
			get_tree().change_scene_to_file(WorldData.world_dic["last_level"])
			PlayerData.player_dic["positionx"] = PlayerData.player_dic["last_positionx"]
			PlayerData.player_dic["positiony"] = PlayerData.player_dic["last_positiony"]
	else:
		$Label.hide()
