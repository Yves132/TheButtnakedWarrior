extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.player.position.x > position.x and GameManager.player.position.x < position.x + size.x and GameManager.player.position.y > position.y:
		visible = false
		WorldData.world_dic["secret_found"] = true
	else:
		visible = true
