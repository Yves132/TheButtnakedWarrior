extends Node2D



@onready var text = $Path2D/PathFollow2D/AnimatedSprite2D/Label
@onready var area = $Path2D/PathFollow2D/Area2D

var hello = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Path2D/PathFollow2D.progress_ratio = 0


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
		$Path2D/PathFollow2D.progress_ratio += delta
		if GameManager.cutscene == true:
			$Path2D/PathFollow2D/AnimatedSprite2D.play("Walk")
		if $Path2D/PathFollow2D.progress_ratio >= 1 and not hello:
			$Path2D/PathFollow2D/AnimatedSprite2D.play("Idle")
			await get_tree().create_timer(2).timeout
			GameManager.cutscene = false
		if GameManager.cutscene == false and hello == false:
			$Path2D/PathFollow2D/AnimatedSprite2D.play("Idle")
	else:
		hide()
	
	#position = $Path2D/PathFollow2D.progress_ratio
	#orientation()
	
func orientation():#handles sprite orientation based on player's
	if GameManager.player.Playerposx > $Path2D/PathFollow2D/Area2D.position.x:
		$Path2D/PathFollow2D/AnimatedSprite2D.flip_h = false#swap sprite 2d for animated sprite2d when you make animations
	elif GameManager.player.Playerposx < $Path2D/PathFollow2D/Area2D.position.x:
		$Path2D/PathFollow2D/AnimatedSprite2D.flip_h = true

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		text.text = str(ConfigFileHandler.config.get_value("Keybinding","interact"))+" to interact"
		text.show()


func _on_area_2d_area_exited(area):
	if area.get_parent() is Player:
		text.hide()


func _on_hello_area_body_entered(body):
	if body is Player:
		hello = true
		$Path2D/PathFollow2D/AnimatedSprite2D.play("Hello")


func _on_animated_sprite_2d_animation_finished():
	hello = false
