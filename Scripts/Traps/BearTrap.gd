extends Node2D





func _on_area_2d_body_entered(body):
	if body is Player:
		$AnimationPlayer.play("trap")#play trap animation
		GameManager.lose_health(1)#loses 1 health
		GameManager.player.Hurt(position.x)
