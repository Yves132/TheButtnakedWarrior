extends Control

func _on_quit_pressed():
	GameManager.quit()


func _on_new_game_pressed():
	PlayerData.player_dic["health"] = PlayerData.max_health
	PlayerData.player_dic["mana"] = PlayerData.max_mana
	PlayerData.player_dic["dashes"] = PlayerData.max_dashes
	PlayerData.player_dic["Coins"] = PlayerData.coins
	SaveManager.save_game()
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/GoblinHills.tscn")
	



func _on_load_game_pressed():
	#InventoryManager.load_inventory()
	SaveManager.load_game()
	GameManager.loadgame()
