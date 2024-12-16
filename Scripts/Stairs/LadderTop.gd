extends StaticBody2D

var above_ladder := false#is player above the ladder

func _physics_process(delta):
	if  Input.is_action_pressed("down") and above_ladder == true:#if above ladder and press down
		$CollisionShape2D.rotation_degrees = 180 #rotate one way collision shape
	else:
		$CollisionShape2D.rotation_degrees = 0#when passed through rotate again

func _on_check_above_body_entered(body):#signal for "player is on top of ladder"
	above_ladder = true


func _on_check_above_body_exited(body):#signal for "player is not on top of ladder"
	above_ladder = false
