extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not PlayerData.player_dic["hat_found"]:
		if overlaps_area(GameManager.player.HitBox):
			$"../Label".text = str(ConfigFileHandler.config.get_value("Keybinding","interact"))+" to interact"
			$"../Label".show()
			if Input.is_action_pressed("interact"):
				PlayerData.player_dic["hat_found"] = true
				PlayerData.player_dic["has_hat"] = true
				$"..".queue_free()
		else:
			$"../Label".hide()
	else:
		$"..".queue_free()
		
