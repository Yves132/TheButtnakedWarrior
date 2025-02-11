extends Control

const mouse_speed = 600

func _ready():
	$VBoxContainer/HBoxContainer/NewGame.grab_focus()
	if not FileAccess.file_exists(SaveManager.savepath+SaveManager.savename):
		$VBoxContainer/HBoxContainer2/LoadGame.disabled = true

func _process(delta):
	var right_stick_vector = Input.get_vector("Cursor left", "Cursor right", "Cursor up", "Cursor down")
	get_viewport().warp_mouse(round(get_global_mouse_position() + right_stick_vector * mouse_speed * delta))
	if Input.is_action_just_pressed("PauseMenu") and $InputSettings.visible == true:
		$InputSettings.hide()
	

func _on_quit_pressed():
	GameManager.quit()


func _on_new_game_pressed():
	GameManager.set_initial_data()
	DirAccess.remove_absolute("user://save1.tres")
	SaveManager.save_game()
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/GoblinHills.tscn")
	



func _on_load_game_pressed():
	SaveManager.load_game()
	GameManager.loadgame()


func _on_new_game_mouse_entered():
	$VBoxContainer/HBoxContainer/NewGame.grab_focus()

func _on_load_game_mouse_entered():
	$VBoxContainer/HBoxContainer2/LoadGame.grab_focus()

func _on_quit_mouse_entered():
	$VBoxContainer/HBoxContainer3/Quit.grab_focus()

func _on_settings_pressed():
	$InputSettings.show()
