extends Control

func _ready():
	$VBoxContainer/HBoxContainer/NewGame.grab_focus()

func _on_quit_pressed():
	GameManager.quit()


func _on_new_game_pressed():
	GameManager.set_initial_data()
	DirAccess.remove_absolute("res://Saves/save1.tres")
	SaveManager.save_game()
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/GoblinHills.tscn")
	



func _on_load_game_pressed():
	SaveManager.load_game()
	GameManager.loadgame()
