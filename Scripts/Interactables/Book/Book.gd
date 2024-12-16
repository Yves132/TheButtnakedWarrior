extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_book_area_entered(area):
		if area.get_parent() is Player:#if player touched book
			PlayerData.player_dic["has_spell"] = true#player now has spell
			queue_free()#delete book
