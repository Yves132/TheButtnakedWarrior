extends Node2D
class_name Checkpoint #giving this class a name so we can call it from other scripts

@export var spawnpoint = false #is this the spawnpoint
#var activated = false #has player touched the checkpoint
var player_on_checkpoint

func _ready():
	$Panel/RestButton.grab_focus()
	if spawnpoint == true :
		GameManager.CurrentCheckpoint = self
		
	if WorldData.world_dic["checkpoint_active"]:
		GameManager.CurrentCheckpoint = self
		$AnimationPlayer.play("Lit")

func _process(delta):
	#print(WorldData.world_dic["actual_level"])
	if player_on_checkpoint:
		$Label.show()
		if Input.is_action_just_pressed("interact"):
			$Panel.show()
			WorldData.world_dic["checkpoint_active"] = true
			PlayerData.player_dic["positionx"] = position.x
			PlayerData.player_dic["positiony"] = position.y
			$AnimationPlayer.play("Lit")
	else:
		$Label.hide()
		$Panel.hide()
		
	
	
		

func activate(): #func called when player touches checkpoint
	GameManager.CurrentCheckpoint = self #Assigning to the variable "CurrentCheckpoint" in GameManager script this node : "Checkpoint"
	if not spawnpoint:
		PlayerData.player_dic["health"] = PlayerData.player_dic["max_health"]
		GameManager.uimanager.Update_health()
	#InventoryManager.save_inventory()
	#InventoryManager.save_hotbar_inventory()
	GameManager.uimanager.saving_icon.show()
	GameManager.uimanager.saving_icon.play("Saving")
	SaveManager.save_game()
	#print(PlayerData.player_dic["inventory"])

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:#if player touches checkpoint and checkpoint not activated
		player_on_checkpoint = true
	


func _on_area_2d_area_exited(area):
	if area.get_parent() is Player:#if player touches checkpoint and checkpoint not activated
		player_on_checkpoint = false


func _on_rest_button_pressed():
	GameManager.player.resting = true
	activate() #run activate()

func _on_level_up_button_pressed():
	GameManager.uimanager.levelup_screen.show()
