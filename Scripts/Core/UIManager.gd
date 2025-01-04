extends CanvasLayer

class_name UiManager#class name
var player : Player#variable player is of type Player (classname of player)
#var HeartFull = preload("res://Sprites/UI/UI5Heart.png")#this is how you load images, you need to store them in a var
var manafull = preload("res://Sprites/UI/ManaFull.png")
var manaempty = preload("res://Sprites/UI/ManaEmpty.png")
@onready var pausemenu := $PauseMenu
@onready var inventory := $Inventory
@onready var shop := $shop
@onready var deathscreen := $Panel
@onready var saving_icon := $SavingIcon
@onready var playerlevel := $PlayerLevel
@onready var xptimer := $XPtimer
@onready var pausemenuOpen = false
@onready var inventoryopen = false
@onready var shopopen = false
@onready var inventory_hotbar = $Inventory_Hotbar
@onready var levelup_screen = $LevelupScreen


func _ready():
	GameManager.collected_coins.connect(UpdateCoins)#here we connect the signal emitted from gamemanager to the func
	GameManager.uimanager = self #telling gamemanager that i am uimanager
	#player = GameManager.player #who is player
	Update_health()
	Update_playerlevel()
	Update_playerxp()
	$CoinDisplay.text = str(PlayerData.player_dic["Coins"])
	
	#updateUI()
	
func _process(delta):
	if deathscreen.visible == false and levelup_screen.visible == false:
		if Input.is_action_just_pressed("PauseMenu") and inventory.visible == false and shopopen == false:
			pausemenuOpen = true
			GameManager.pause_play()
		if Input.is_action_just_pressed("PauseMenu") and inventory.visible == true:
			inventoryopen = true
			GameManager.pause_play()
		if Input.is_action_just_pressed("Inventory") and pausemenu.visible == false and shopopen == false:
			inventoryopen = true
			GameManager.pause_play()
		if Input.is_action_just_pressed("PauseMenu") and shopopen == true:
			shopopen = false
			GameManager.pause_play()
			
	if levelup_screen.visible:
		GameManager.pause_play()
		#if inventory.visible == true:
			#inventory_hotbar.hide()
		#else:
			#inventory_hotbar.show()
		


func UpdateCoins(coins_gained): #coins_gained stores the variable of the signal
	$CoinDisplay.text = str(PlayerData.player_dic["Coins"]) #we update the text with the value received

func Update_health():#updates ui health of player
	$HeartsFull.size.x = PlayerData.player_dic["health"] * 512
	$HeartsEmpty.size.x = (PlayerData.player_dic["max_health"] - PlayerData.player_dic["health"]) * 512
	$HeartsEmpty.position.x = $HeartsFull.position.x + $HeartsFull.size.x * $HeartsFull.scale.x
	
	
func Update_mana(currentmana):
	$ManaFull.size.x = currentmana *512 
	$ManaEmpty.size.x =(PlayerData.player_dic["max_mana"] - currentmana) *512
	$ManaEmpty.position.x = $ManaFull.position.x + $ManaFull.size.x * $ManaFull.scale.x

func Update_dashes(currentdashes):
	$DashFull.size.x = currentdashes * 512
	$DashEmpty.size.x = (PlayerData.player_dic["max_dashes"] - currentdashes) * 512
	$DashEmpty.position.x = $DashFull.position.x + $DashFull.size.x * $DashFull.scale.x

func Update_playerxp():
	playerlevel.show()
	xptimer.start()
	$PlayerLevel/Playerxp.max_value = PlayerData.player_dic["xp_required"]
	$PlayerLevel/Playerxp.value = PlayerData.player_dic["current_xp"]

func Update_playerlevel():
	playerlevel.show()
	xptimer.start()
	$PlayerLevel.text = str(PlayerData.player_dic["player_level"])
	

	
func _on_resume_button_pressed():
	GameManager.resume()


func _on_quit_button_pressed():
	GameManager.quit()


func _on_respawn_button_pressed():
	#print(WorldData.world_dic["actual_level"])
	if WorldData.world_dic["actual_level"] != null :
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/UI/loading_screen.tscn")


func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")


func _on_saving_icon_animation_finished():
	saving_icon.hide()


func _on_x_ptimer_timeout():
	$PlayerLevel.hide()


func _on_inventory_button_pressed():
	pausemenuOpen = true
	GameManager.pause_play()
	inventoryopen = true
	GameManager.pause_play()
