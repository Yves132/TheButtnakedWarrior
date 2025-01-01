extends Node
class_name RuntimeLevel


@onready var level_name = $".".name#level name
@onready var actual_level = get_scene_file_path()#returns the packedscene 
@onready var scene_transition_animation = $SceneTransitionAnimation/AnimationPlayer
@onready var cave_level_entrance = $CaveEntrance
@onready var cave_level_exit = $CaveExit
#var enemies = []#this could be useful for bosses
@onready var path2d = $Path2D#for cutscene purposes
@onready var camera = $Path2D/PathFollow2D/Camera2D#for cutscene purposes
@onready var bossfightstart = $BossFightStart#to know when bossfight starts

func _ready():
	data_setter()
	scene_transition_animation.get_parent().get_node("ColorRect").color.a = 255
	scene_transition_animation.play("fade_out")
	WorldData.world_dic["actual_level"] = actual_level
	
	
	#enemies = $EnemyHolder.get_children()#all this section is useless now
	#WorldData.world_dic["dead_enemies"].resize(enemies.size())
	#for i in WorldData.world_dic["dead_enemies"].size():
		#WorldData.world_dic["dead_enemies"][i] = false
	#WorldData.world_dic["enemies"] = enemies
	
	GameManager.uimanager.saving_icon.show()
	GameManager.uimanager.saving_icon.play("Saving")
	SaveManager.save_game()#saves the game whenever we change scene

func data_setter():#we set here things that must be set to standard values when entering the scene
	if path2d != null:
		camera.enabled = false#disables scene camera on ready
		$Path2D/PathFollow2D.progress_ratio = 0#sets bosscamera progress to default
	FrogAi.hostile = false

func _process(delta):
	boss_fight_manager(delta)
	cave_manager()
		
		
func boss_fight_manager(delta):
	if GameManager.cutscene:
		if path2d != null:
			$Path2D/PathFollow2D.progress_ratio += delta#start to move the camera towards boss
	if WorldData.world_dic["first_boss_defeated"]:#when the boss is defeted
		if path2d != null and bossfightstart != null:
			camera.enabled = false#disable camera
			GameManager.player.PlayerCamera.enabled = true#enable playercamera
			bossfightstart.monitoring = false#disable area monitoring for bossbattle
			$BossFightStart/Blocker.set_collision_layer_value(2, false)#disable wall bossfight

func cave_manager():
	if cave_level_entrance != null:
		if cave_level_entrance.overlaps_area(GameManager.player.HitBox):
			if Input.is_action_just_pressed("up"):
				scene_transition_animation.play("fade_in")
				await scene_transition_animation.animation_finished
				get_tree().change_scene_to_file(cave_level_entrance.level)
				PlayerData.player_dic["last_positionx"] = GameManager.player.position.x
				PlayerData.player_dic["last_positiony"] = GameManager.player.position.y
				PlayerData.player_dic["positionx"] = PlayerData.positionx
				PlayerData.player_dic["positiony"] = PlayerData.positiony
	
	if cave_level_exit != null:
		if cave_level_exit.overlaps_area(GameManager.player.HitBox):
			if Input.is_action_just_pressed("up"):
				scene_transition_animation.play("fade_in")
				await scene_transition_animation.animation_finished
				get_tree().change_scene_to_file(cave_level_exit.level)
				PlayerData.player_dic["positionx"] = PlayerData.player_dic["last_positionx"]
				PlayerData.player_dic["positiony"] = PlayerData.player_dic["last_positiony"]

func _on_change_scene_area_entered(area):
	PlayerData.player_dic["positionx"] = PlayerData.positionx
	PlayerData.player_dic["positiony"] = PlayerData.positiony
	WorldData.world_dic["checkpoint_active"] = WorldData.checkpoint_active
	WorldData.world_dic["chest_opened"] = WorldData.chest_opened
	WorldData.world_dic["secret_found"] = WorldData.secret_found
	if actual_level == "res://Scenes/WorldScenes/GoblinHills.tscn":
		if area.get_parent() is Player:
			get_tree().change_scene_to_file("res://Scenes/WorldScenes/levelTwo.tscn")

func _on_boss_fight_start_area_exited(area):
	if area.get_parent() is Player:
		GameManager.player.PlayerCamera.enabled = false#disable player camera, we do it thorugh gamemanager reference to player
		camera.enabled = true#enable boss battle camera
		GameManager.cutscene = true#set cutscene to true in gamemanager global script so we know we are in a cutscene
		$BossFightStart/Blocker.set_collision_layer_value(2, true)#set a blocker wall so player is confined in boss arena


func _on_cave_entrance_area_entered(area):
	if area.get_parent() is Player:
		$CaveEntrance/Label.show()


func _on_cave_entrance_area_exited(area):
	if area.get_parent() is Player:
		$CaveEntrance/Label.hide()


func _on_cave_exit_area_entered(area):
	if area.get_parent() is Player:
		$CaveExit/Label.show()


func _on_cave_exit_area_exited(area):
	if area.get_parent() is Player:
		$CaveExit/Label.hide()
