extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("Loading")
	#print(WorldData.world_dic["actual_level"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	PlayerData.player_dic["health"] = PlayerData.player_dic["max_health"]
	PlayerData.player_dic["mana"] = PlayerData.player_dic["max_mana"]
	PlayerData.player_dic["dashes"] = PlayerData.player_dic["max_dashes"]
	GameManager.loadgame()
	SaveManager.load_game()
	
