extends CharacterBody2D


const SPEED = 300.0
@onready var InitialPositionY = position.y 

func _ready():#this makes the drop go in an arc before hitting the floor
	velocity.y = -SPEED/1.4 #sets vertical speed
	var X = randi_range(-1,1)#gives the drop chance to go right or left
	var DistanceX = randi() % 50#determines random left/right distance
	velocity.x = (SPEED/2) * X + DistanceX#determines horizontal speed

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and position.y < (InitialPositionY - 50):#this makes the drop approach the floor when spawned
		velocity.y += get_gravity() * delta 
		velocity.x = move_toward(velocity.x, 0, delta*2)
	if is_on_floor():
		velocity.x =  0#stops the drop from gliding
	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		queue_free()
