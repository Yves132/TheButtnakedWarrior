@tool#this means that the changes we make appear in the editor as well

extends Node2D

#item proprties
@export var item_type = ""
@export var item_name = ""
@export var item_texture : Texture
@export var item_effect = ""
@export var is_on_hotbar = false#not used right now
@export var cost : int
var scene_path : String = "res://Scenes/Inventory/InventoryItem/inventory_item.tscn"#this is the path to this scene
#it will be used in enemies script to spawn items

@onready var icon_sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.

var player_in_range = false#used to determine if player is near item
var on_floor = false#used to determine if item is on floor

func _ready():
	if  not Engine.is_editor_hint():#if we are not still in the editor
		icon_sprite.texture = item_texture#the texture changes in game
		#print(icon_sprite.texture)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():#if we are still in the editor
		icon_sprite.texture = item_texture#the texture updates
	if player_in_range and Input.is_action_just_pressed("interact"):
		pickup_item()#call the function in this script
	if on_floor == false:
		position.y = position.y + (50*delta)#moves the item towards the floor
		
func pickup_item():#this function picks up items
	var item = {
		"quantity" : 1,
		"type" : item_type,
		"name" : item_name,
		"effect" : item_effect,
		"texture" : item_texture,
		"is_on_hotbar" : is_on_hotbar,
		"cost" : cost,
		"scene_path" : scene_path
	}#set the dictionary values
	#print(item)
	if InventoryManager.player_node:
		InventoryManager.add_item(item)#we call additem from InventoryManager script #, false)#just needed if hotbar was present
		self.queue_free()#remove it from the scene

func set_item_data(data):#called by inventorymanager in function dropitem
	item_type = data["type"]
	item_name = data["name"]
	item_effect = data["effect"]
	item_texture = data["texture"]
	cost = data["cost"]


func _on_area_2d_body_entered(body):
	if body is Player:
		player_in_range = true
		body.interact_ui.visible = true#sets the interact ui to visible in player scene


func _on_area_2d_body_exited(body):
	if body is Player:
		player_in_range = false
		body.interact_ui.visible = false#sets the interact ui to invisible in player scene


func _on_floor_checker_body_entered(body):
	if body is tile_map or tile_map_one_way:#if item touches the floor or platforms
		on_floor = true#is on floor
