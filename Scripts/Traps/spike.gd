extends Node2D



func _on_area_2d_area_entered(area):
	if area.get_parent() is Player: #if player touched spike
		GameManager.lose_health(1)#loses 1 health
		GameManager.player.Hurt(position.x)
