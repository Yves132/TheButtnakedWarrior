extends CharacterBody2D

class_name Fireball
const EXPLOSION = preload("res://Scenes/Particles/explosion_fire.tscn")

@onready var audioplayer = $AudioStreamPlayer2D

const SPEED = 400
var direction = 1
var target_enemy
var exploded_on_wall = false
var exploded_when_stuck = false


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = SPEED * direction
	audioplayer.play()
	var pitch_mod = randf_range(-0.05,+0.05)
	audioplayer.pitch_scale = 1 + pitch_mod
	#add_child(explosion)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#if target_enemy!=null: #this is for homing fireballs
		##print("following")
		#look_at(target_enemy.global_position)
		#position = position.move_toward(target_enemy.global_position,100 * delta)
		if is_on_wall() and not exploded_on_wall:
			exploded_on_wall = true
			exploded_when_stuck = true
			var explosion = EXPLOSION.instantiate()
			explosion.position = position
			#explosion.scale = Vector2(4,4)
			get_parent().add_child(explosion)
			await get_tree().create_timer(0.2).timeout
			queue_free()
		if velocity.x == 0 and not exploded_when_stuck:
			exploded_when_stuck = true
			var explosion = EXPLOSION.instantiate()
			explosion.position = position
			#explosion.scale = Vector2(4,4)
			get_parent().add_child(explosion)
			await get_tree().create_timer(0.2).timeout
			queue_free()
		move_and_slide()



#func _on_homing_range_body_entered(body):#this is for homing fireballs
	#if body is Enemy:
		#target_enemy = body
		##print("enemy spotted")
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
