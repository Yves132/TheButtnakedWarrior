extends CharacterBody2D

class_name Fireball
const SPEED = 400
var direction = 1
var target_enemy
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = SPEED * direction
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#if target_enemy!=null: #this is for homing fireballs
		##print("following")
		#look_at(target_enemy.global_position)
		#position = position.move_toward(target_enemy.global_position,100 * delta)
	$AnimationPlayer.play("Fireball")
	if is_on_wall():
		queue_free()
	if velocity.x == 0:
		queue_free()
	move_and_slide()
	if direction == 1:
		$Sprite2D.flip_h = false
	else :
		$Sprite2D.flip_h = true



#func _on_homing_range_body_entered(body):#this is for homing fireballs
	#if body is Enemy:
		#target_enemy = body
		##print("enemy spotted")


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
