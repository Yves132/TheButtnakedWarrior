extends CharacterBody2D

class_name GoblinMeat


const SPEED = 300.0
@onready var InitialPositionY = position.y


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	velocity.y = -SPEED/1.4
	var X = randi_range(-1,1)
	var DistanceX = randi() % 50
	velocity.x = (SPEED/2) * X + DistanceX

func _physics_process(delta):
	if not is_on_floor() and position.y < (InitialPositionY - 50):
		velocity.y += gravity * delta 
		velocity.x = move_toward(velocity.x, 0, delta*2)
	if is_on_floor():
		velocity.x =  0
	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		queue_free()
