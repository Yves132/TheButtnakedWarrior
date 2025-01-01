extends Node2D



@onready var text = $Label
@onready var area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if area.overlaps_body(GameManager.player):#openshop
		if Input.is_action_just_pressed("interact"):
			GameManager.uimanager.shop.populate_inventory()#each time the shop is open it updates the player inventory
			GameManager.uimanager.shop.show()
			GameManager.uimanager.shopopen = true
			GameManager.pause_play()
		if GameManager.uimanager.shopopen == false:
			GameManager.uimanager.shop.hide()
	if WorldData.world_dic["first_boss_defeated"]:#the shop is shown only after defeating the first boss
		show()
	else:
		hide()
	orientation()
	
func orientation():#handles sprite orientation based on player's
	if GameManager.player.Playerposx > position.x:
		$Sprite2D.flip_h = false#swap sprite 2d for animated sprite2d when you make animations
	elif GameManager.player.Playerposx < position.x:
		$Sprite2D.flip_h = true

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		text.show()


func _on_area_2d_area_exited(area):
	if area.get_parent() is Player:
		text.hide()
