extends CharacterBody2D

class_name Arrow
const SPEED = 200
var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = SPEED * direction
	$AnimatedSprite2D.play("Fly")
	$AudioStreamPlayer2D.play()
	var pitch_mod = randf_range(-0.5,+0.5)
	$AudioStreamPlayer2D.pitch_scale = 1.4 + pitch_mod

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide()
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	else :
		$AnimatedSprite2D.flip_h = true
	if velocity.x == 0:
		queue_free()


func _on_area_2d_body_entered(body):
	if body is Player:
		GameManager.lose_health(1)
		GameManager.player.Hurt(position.x)
		queue_free()
	if body is tile_map or body is tile_map_one_way:
		queue_free()


func _on_area_2d_2_area_entered(area):
	if area.get_parent() is Player:
		velocity.x = 5
		$AnimatedSprite2D.play("Break")
		



func _on_animated_sprite_2d_animation_finished():
	queue_free()
