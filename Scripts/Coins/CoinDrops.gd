extends CharacterBody2D

var SPEED = 300
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var InitialPositionY = position.y
# Called when the node enters the scene tree for the first time.
func _ready():
	
	velocity.y = -SPEED/1.4
	var X = randi_range(-1,1)
	var DistanceX = randi() % 50
	velocity.x = (SPEED/2) * X + DistanceX
	$Sprite2D/AnimationPlayer.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_on_floor() and position.y < (InitialPositionY - 10):
		velocity.y += gravity * delta 
		velocity.x = move_toward(velocity.x, 0, gravity * delta)
	if is_on_floor():
		velocity.x =  0
	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		GameManager.gain_coins(1)#call gamemanager func to count coins
		queue_free()#delete coin


