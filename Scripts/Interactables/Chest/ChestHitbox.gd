extends Area2D

const BOOK = preload("res://Scenes/Interactables/book.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready():
	if WorldData.world_dic["chest_opened"]:
		$"../AnimatedSprite2D".play("already open")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if overlaps_area(GameManager.player.HitBox) and not WorldData.world_dic["chest_opened"]:
		$"../Label".text = str(ConfigFileHandler.config.get_value("Keybinding","interact"))+" to interact"
		$"../Label".show()
		if Input.is_action_pressed("interact") and not WorldData.world_dic["chest_opened"]:
			$"../AnimatedSprite2D".play("Open")
			$"../open".play()
			WorldData.world_dic["chest_opened"]= true
	else:
		$"../Label".hide()
		
		
	

func _on_animated_sprite_2d_animation_finished():
	var book = BOOK.instantiate()
	get_parent().add_child(book)
	book.position.x = position.x
	book.position.y = position.y + -200
	book.scale.x = 0.5
	book.scale.y = 0.5
