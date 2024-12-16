extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	GameManager.health = GameManager.max_health
	GameManager.mana = GameManager.max_mana
	GameManager.dashes = GameManager.max_dashes
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/levelOne.tscn")
