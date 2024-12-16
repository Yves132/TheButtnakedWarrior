extends Node

#inventory items
var inventory = []

#custom signals
signal inventory_updated

#scene and node references
var player_node : Node = null
@onready var inventory_slot_scene = preload("res://Scenes/Inventory/InventorySlots/inventory_slot.tscn") 

#hotbar items
#var inventory_hotbar_size = 5
#var inventory_hotbar = []
# Called when the node enters the scene tree for the first time.
func _ready():
	#initaializes inventory to 20 slots
	inventory.resize(20)
	PlayerData.player_dic["inventory"].resize(20)
	#inventory_hotbar.resize(inventory_hotbar_size)#not needed since hotbar is not present
	#PlayerData.player_dic["inventory_hotbar_array"].resize(inventory_hotbar_size)
	

# Called every frame. 'delta' is the eldapsed time since the previous frame.
func save_inventory():
	for i in range(PlayerData.player_dic["inventory"].size()):
		PlayerData.player_dic["inventory"][i] = inventory [i]
		#print(PlayerData.player_dic["inventory"][i], "saved")
	return true
	
#func save_hotbar_inventory():#not needed since hotbar not present
	#for i in range(PlayerData.player_dic["inventory_hotbar_array"].size()):
		#PlayerData.player_dic["inventory_hotbar_array"][i] = inventory_hotbar[i]
		#print(PlayerData.player_dic["inventory_hotbar_array"], "hotbar saved")
	#return true
	

func load_inventory():
	for i in range(inventory.size()):
		inventory[i] = PlayerData.player_dic["inventory"][i]
		
		
#adds an item to the inventory, returns true if successful
func add_item(item): #, to_hotbar = false):#just needed if hotbar would be present
	#var added_to_hotbar = false
	
	#add to hotbar
	#if to_hotbar:
		#added_to_hotbar = add_hotbar_item(item)
		#inventory_updated.emit()
	#add to inventory
	#if not added_to_hotbar:
		for i in range(inventory.size()):
			#print(i)
			#checks if item exists in inventory and matches both type and effect
			if PlayerData.player_dic["inventory"][i] != null and PlayerData.player_dic["inventory"][i]["type"] == item["type"] and PlayerData.player_dic["inventory"][i]["effect"] == item["effect"]:
				PlayerData.player_dic["inventory"][i]["quantity"] += item["quantity"]
				#print(PlayerData.player_dic["inventory"][i])
				inventory_updated.emit()
				return true
			elif PlayerData.player_dic["inventory"][i] == null:
				PlayerData.player_dic["inventory"][i] = item
				#print(PlayerData.player_dic["inventory"][i])
				inventory_updated.emit()
				return true
		return false
		
	
	
#removes an item to the inventory, based on type and effect
func remove_item(item_type, item_effect):
	for i in range(PlayerData.player_dic["inventory"].size()):
		if PlayerData.player_dic["inventory"][i] != null and PlayerData.player_dic["inventory"][i]["type"] == item_type and PlayerData.player_dic["inventory"][i]["effect"] == item_effect:
			#print("PlayerData.player_dic["inventory"]: ", PlayerData.player_dic["inventory"][i]["quantity"])
			PlayerData.player_dic["inventory"][i]["quantity"] -= 1
			if PlayerData.player_dic["inventory"][i]["quantity"] <= 0:
				PlayerData.player_dic["inventory"][i] = null
				#inventory[i] = inventory[i]
			inventory_updated.emit()
			return true
	return false

#increases inventory size dinamically
func increase_inventory_size(extra_slots):
	inventory.resize(inventory.size() + extra_slots)
	PlayerData.player_dic["inventory"].resize(PlayerData.player_dic["inventory"] + extra_slots)
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player

func adjust_drop_position(position):
	var radius = 100
	var nearby_items = get_tree().get_nodes_in_group("Items")
	for item in nearby_items:
		if item.global_position.distance_to(position) < radius:
			var radius_offset = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
			position += radius_offset
			break
	return position
	
func drop_item(item_data, drop_position):
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	get_tree().current_scene.add_child(item_instance)
	
#func add_hotbar_item(item):#irrelevant no hotbar will be present
	#for i in range(inventory_hotbar_size):
		#if inventory_hotbar[i] == null:
			#inventory_hotbar[i] = item
			#return true
	#return false

#removes an item from hotbar

#func remove_hotbar_item(item_type, item_effect):#irrelevant no hotbar will be present
	#for i in range(inventory_hotbar.size()):
		#if inventory_hotbar[i] != null and inventory_hotbar[i]["type"] == item_type and inventory_hotbar[i]["effect"] == item_effect:
			#if inventory_hotbar[i]["quantity"] <= 0:
				#inventory_hotbar[i] = null
			#inventory_updated.emit()
			#return true
	#return false

#unassign an item from hotbar

#func unassign_hotbar_item(item_type, item_effect):#irrelevant no hotbar will be present
	#for i in range(inventory_hotbar.size()):
		#if inventory_hotbar[i] != null and  inventory_hotbar[i]["type"] == item_type and inventory_hotbar[i]["effect"] == item_effect:
			#inventory_hotbar[i] = null
			#inventory_updated.emit()
			#return true
	#return false

#prevents duplicate item assignment

#func is_item_assigned_to_hotbar(item_to_check):#irrelevant no hotbar will be present
	#print(inventory_hotbar)
	#return item_to_check in inventory_hotbar
