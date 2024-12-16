extends Node
class_name RuntimeLevel


@onready var level_name = $".".name
@onready var actual_level = get_scene_file_path()
var enemies = []
var coins = []
@onready var camera = $Path2D/PathFollow2D/Camera2D

func _ready():
	WorldData.world_dic["actual_level"] = actual_level
	enemies = $EnemyHolder.get_children()
	WorldData.world_dic["dead_enemies"].resize(enemies.size())
	for i in WorldData.world_dic["dead_enemies"].size():
		WorldData.world_dic["dead_enemies"][i] = false
	#WorldData.world_dic["dead_enemies"] = WorldData.dead_enemies
	WorldData.world_dic["enemies"] = enemies
	print(WorldData.world_dic["actual_level"])
	camera.enabled = false#disables scene camera on ready
	$Path2D/PathFollow2D.progress_ratio = 0#sets bosscamera progress to default
	SaveManager.save_game()#saves the game whenever we change scene
	#print(WorldData.world_dic["checkpoint_active"])

func _process(delta):
	if GameManager.cutscene:
		$Path2D/PathFollow2D.progress_ratio += delta#start to move the camera towards boss


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
