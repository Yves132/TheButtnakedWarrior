@tool

extends Node2D


@export var item_type = ""
@export var item_name = ""
@export var item_texture : Texture
@export var item_effect = ""
@export var is_on_hotbar = false
var scene_path : String = "res://Scenes/Inventory/InventoryItem/inventory_item.tscn"

@onready var icon_sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.

var player_in_range = false
var on_floor = false

func _ready():
	if  not Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		#print(icon_sprite.texture)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
	if player_in_range and Input.is_action_just_pressed("interact"):
		pickup_item()
	if on_floor == false:
		position.y = position.y + (50*delta)
		
func pickup_item():
	var item = {
		"quantity" : 1,
		"type" : item_type,
		"name" : item_name,
		"effect" : item_effect,
		"texture" : item_texture,
		"is_on_hotbar" : is_on_hotbar,
		"scene_path" : scene_path
	}
	print(item)
	if InventoryManager.player_node:
		InventoryManager.add_item(item) #, false)#just needed if hotbar was present
		self.queue_free()

func set_item_data(data):
	item_type = data["type"]
	item_name = data["name"]
	item_effect = data["effect"]
	item_texture = data["texture"]


func _on_area_2d_body_entered(body):
	if body is Player:
		player_in_range = true
		body.interact_ui.visible = true


func _on_area_2d_body_exited(body):
	if body is Player:
		player_in_range = false
		body.interact_ui.visible = false


func _on_floor_checker_body_entered(body):
	if body is tile_map or tile_map_one_way:
		on_floor = true
