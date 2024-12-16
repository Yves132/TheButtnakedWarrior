extends Node2D
class_name COIN
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")#play idle coin animation

func _process(delta):
	for i in WorldData.world_dic["coins"].size():
		if $"." == WorldData.world_dic["coins"][i] and WorldData.world_dic["picked_up_coins"][i] == true:
			queue_free()


func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:#if player touched coin
		GameManager.gain_coins(1)#call gamemanager func to count coins
		queue_free()#delete coin
		for i in WorldData.world_dic["coins"].size():
			if $"."== WorldData.world_dic["coins"][i]:
				WorldData.world_dic["picked_up_coins"][i] = true
