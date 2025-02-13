extends CanvasLayer

@onready var animation_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("logo_fade_in")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if (event is InputEventKey or event is InputEventMouseButton) and $BackGround/Label.visible == true:
		get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "logo_fade_in":
		animation_player.play("logo_fade_out")
	if anim_name == "logo_fade_out":
		animation_player.play("cutscene")
	if anim_name == "cutscene":
		get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
