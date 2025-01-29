extends Node
#we have put this in autoload so it runs all the game
signal collected_coins(int)#declaration of signal



var paused := false
var cutscene := false#used to determine if we are in a cutscene
var BossBattleStart = false#used to determine when the boss battle has started (for animation purposes)
#var BossDefeated = false#used to determine boss relative behavior
var CurrentCheckpoint : Checkpoint #Var CurrentCheckpoint is node Checkpoint (we gave it this name)
var player : Player #Var player is node Player (we gave it this name)
var uimanager : UiManager
var crit = false
var joypaddetected = false
var keyboarddetected = false

func _input(event):
	#if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		#joypaddetected = true
		#keyboarddetected = false
		#print("joypaddetected")
	if event is InputEventKey or event is InputEventMouseButton:
		joypaddetected = false
		keyboarddetected = true
		#print("keyboarddetected")

func set_initial_data():
	#uimanager.input_settings._on_reset_button_pressed()
	PlayerData.player_dic["positionx"] = PlayerData.positionx
	PlayerData.player_dic["positiony"] = PlayerData.positiony
	PlayerData.player_dic["health"] = PlayerData.max_health
	PlayerData.player_dic["mana"] = PlayerData.max_mana
	PlayerData.player_dic["dashes"] = PlayerData.max_dashes
	PlayerData.player_dic["weapon_found"] = PlayerData.weapon_found
	PlayerData.player_dic["has_weapon"] = PlayerData.has_weapon
	PlayerData.player_dic["hat_found"] = PlayerData.hat_found
	PlayerData.player_dic["has_hat"] = PlayerData.has_hat
	PlayerData.player_dic["has_spell"] = PlayerData.has_spell
	PlayerData.player_dic["Coins"] = PlayerData.coins
	PlayerData.player_dic["current_xp"] = PlayerData.current_xp
	PlayerData.player_dic["inventory"] = PlayerData.inventory
	PlayerData.player_dic["warrior_heart"] = PlayerData.warrior_heart
	PlayerData.player_dic["sharp_mind"] = PlayerData.sharp_mind
	PlayerData.player_dic["quick_step"] = PlayerData.quick_step
	PlayerData.player_dic["dodge"] = PlayerData.dodge
	PlayerData.player_dic["warrior_might"] = PlayerData.warrior_might
	PlayerData.player_dic["crit_chance"] = PlayerData.crit_chance
	PlayerData.player_dic["flowing_water"] = PlayerData.flowing_water
	PlayerData.player_dic["deep_cuts"] = PlayerData.deep_cuts
	PlayerData.player_dic["waterfall"] = PlayerData.waterfall
	PlayerData.player_dic["focused_chi"] = PlayerData.focused_chi
	PlayerData.player_dic["deep_burn"] = PlayerData.deep_burn
	PlayerData.player_dic["xp_required"] = PlayerData.xp_required
	PlayerData.player_dic["player_level"] = PlayerData.player_level
	PlayerData.player_dic["skillpoints"] = PlayerData.skillpoints
	WorldData.world_dic["first_boss_defeated"] = WorldData.first_boss_defeated
	WorldData.world_dic["checkpoint_active"] = WorldData.checkpoint_active
	WorldData.world_dic["chest_opened"] = WorldData.chest_opened

func Respawn_Player():#respawns player
	player.dead = false
	player.fell = false
	if CurrentCheckpoint != null:#if there is a Checkpoint
		player.position = CurrentCheckpoint.global_position#Player gets respawned on the Checkpoint
		
func gain_coins(coins_gained):#func to count gained coins
	PlayerData.player_dic["Coins"] += coins_gained #coins = coins + coins_gained
	emit_signal("collected_coins", coins_gained)#emits signal, we use this to update ui of coins

func lose_health(lost:int) :#player loses health on hit
	
	if randi() %100 +1 > PlayerData.player_dic["dodge"]:
		PlayerData.player_dic["health"] -= lost
		uimanager.Update_health()#updates ui health
		if player.fell == false:
			player.Hit=true
			player.hurtTimer.start()
		if PlayerData.player_dic["health"] == 0:#if health is 0 player dies
			player.Die()
	else:
		player.dodge.show()
		player.dodgetimer.start()
		player.dodged = true

func deathscreen():
	uimanager.get_tree().paused = true
	uimanager.deathscreen.show()
	
func gain_xp(xp):
	PlayerData.player_dic["current_xp"] += xp
	if PlayerData.player_dic["current_xp"] >= PlayerData.player_dic["xp_required"]:
		PlayerData.player_dic["current_xp"] = PlayerData.player_dic["current_xp"] - PlayerData.player_dic["xp_required"]
		level_up()
	uimanager.Update_playerxp()
	
func level_up():
	player.levelup.show()
	player.leveluptimer.start()
	PlayerData.player_dic["skillpoints"] += 1
	PlayerData.player_dic["player_level"] += 1
	PlayerData.player_dic["xp_required"] = PlayerData.player_dic["xp_required"] * 1.5
	uimanager.Update_playerlevel()
	
func pause_play():
	if uimanager.pausemenuOpen == true:
		uimanager.pausemenuOpen = false
		paused = not paused
		uimanager.pausemenu.visible = paused
		uimanager.get_tree().paused = paused
	if uimanager.inventoryopen == true:
		uimanager.inventoryopen = false
		paused = not paused
		uimanager.inventory.visible = paused
		uimanager.get_tree().paused = paused
	if uimanager.levelup_screen.visible == true:
		uimanager.get_tree().paused = true
	elif uimanager.levelup_screen.visible == false and uimanager.inventory.visible == false and uimanager.pausemenu.visible == false and uimanager.shopopen == false and uimanager.input_settings.visible == false:
		uimanager.get_tree().paused = false
	if uimanager.shopopen == true:
		uimanager.get_tree().paused = true
	elif uimanager.shopopen == false and uimanager.inventory.visible == false and uimanager.pausemenu.visible == false and uimanager.levelup_screen.visible == false and uimanager.input_settings.visible == false:
		uimanager.get_tree().paused = false
	if uimanager.input_settings.visible:
		uimanager.get_tree().paused = true
	elif uimanager.levelup_screen.visible == false and uimanager.inventory.visible == false and uimanager.pausemenu.visible == false and uimanager.shopopen == false and uimanager.input_settings.visible == false:
		uimanager.get_tree().paused = false
	
func frame_freeze(timescale, duration):
	Engine.time_scale = timescale
	await(player.get_tree().create_timer(duration, true,false,true).timeout)
	Engine.time_scale = 1.0
	
func resume():
	uimanager.pausemenuOpen = true
	pause_play()

func loadgame():
	if WorldData.world_dic["actual_level"] != null:
		get_tree().change_scene_to_file(WorldData.world_dic["actual_level"])
	
func quit():
	get_tree().quit()
