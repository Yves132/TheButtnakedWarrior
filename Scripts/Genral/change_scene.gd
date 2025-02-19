extends Node2D

@export var destination :String
@export var txt :String

@onready var label = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if WorldData.world_dic["actual_level"] == "res://Scenes/WorldScenes/GoblinHills.tscn":
		if WorldData.world_dic["first_boss_defeated"] == false:
			label.text = txt
			label.show()
			return
	if body is Player:
		PlayerData.player_dic["positionx"] = PlayerData.positionx
		PlayerData.player_dic["positiony"] = PlayerData.positiony
		WorldData.world_dic["checkpoint_active"] = WorldData.checkpoint_active
		WorldData.world_dic["chest_opened"] = WorldData.chest_opened
		WorldData.world_dic["secret_found"] = WorldData.secret_found
		get_tree().change_scene_to_file(destination)


func _on_area_2d_body_exited(body):
	label.hide()
