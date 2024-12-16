extends AnimatedSprite2D

class_name Dust_Wall_Slide
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction == 1:
		$".".flip_h = false
	else :
		$".".flip_h = true
	$AnimationPlayer.play("DustWallSlide")

func _on_animation_finished():
	queue_free()
