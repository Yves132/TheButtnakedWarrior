extends Node

#inventory items
var inventory = []

#custom signals
signal inventory_updated#emits each time the inventory updates, and sends the signal to InventoryUI script

#scene and node references
var player_node : Node = null#this is the player
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
	
#adds an item to the inventory, returns true if successful
func add_item(item):#called by inventory item script #, to_hotbar = false):#just needed if hotbar would be present
	#var added_to_hotbar = false
	
	#add to hotbar
	#if to_hotbar:
		#added_to_hotbar = add_hotbar_item(item)
		#inventory_updated.emit()
	#add to inventory
	#if not added_to_hotbar:
		for i in range(PlayerData.player_dic["inventory"].size()):#runs through thew whole inventory array in playerdata.playerdic
			#print(i)
			#checks if item exists in inventory and matches both type and effect
			if PlayerData.player_dic["inventory"][i] != null and PlayerData.player_dic["inventory"][i]["type"] == item["type"] and PlayerData.player_dic["inventory"][i]["effect"] == item["effect"]:
				PlayerData.player_dic["inventory"][i]["quantity"] += item["quantity"]#increase the quantity
				inventory_updated.emit()#emit the signal to inventory ui
				return true
		for i in range(PlayerData.player_dic["inventory"].size()):#runs through thew whole inventory array in playerdata.playerdic
			#print(i)
			#checks if item exists in inventory and matches both type and effect
			if PlayerData.player_dic["inventory"][i] != null and PlayerData.player_dic["inventory"][i]["type"] == item["type"] and PlayerData.player_dic["inventory"][i]["effect"] == item["effect"]:
				PlayerData.player_dic["inventory"][i]["quantity"] += item["quantity"]#increase the quantity
				inventory_updated.emit()#emit the signal to inventory ui
				return true
			elif PlayerData.player_dic["inventory"][i] == null:#if item does not exist yet
				PlayerData.player_dic["inventory"][i] = item#set the item in inventory array in playerdata script
				#PlayerData.player_dic["inventory"][i]["quantity"] = item["quantity"]
				#print(PlayerData.player_dic["inventory"][i])
				inventory_updated.emit()#emit the signal to inventory ui
				return true
		return false
		
	
	
#removes an item to the inventory, based on type and effect
func remove_item(item_type, item_effect):#called by inventory item script
	for i in range(PlayerData.player_dic["inventory"].size()):#runs through thew whole inventory array in playerdata.playerdic
		if PlayerData.player_dic["inventory"][i] != null and PlayerData.player_dic["inventory"][i]["type"] == item_type and PlayerData.player_dic["inventory"][i]["effect"] == item_effect:
			#print("PlayerData.player_dic["inventory"]: ", PlayerData.player_dic["inventory"][i]["quantity"])
			PlayerData.player_dic["inventory"][i]["quantity"] -= 1#decrease the quantity
			if PlayerData.player_dic["inventory"][i]["quantity"] <= 0:#if it reaches 0 
				PlayerData.player_dic["inventory"][i] = null#free the array slot
			inventory_updated.emit()#emit the signal to inventory ui
			return true
	return false

#increases inventory size dinamically
func increase_inventory_size(extra_slots):#used for certain items
	inventory.resize(inventory.size() + extra_slots)
	PlayerData.player_dic["inventory"].resize(PlayerData.player_dic["inventory"] + extra_slots)
	inventory_updated.emit()#emit the signal to inventory ui

func set_player_reference(player):
	player_node = player#this sets the reference to the actual player, it is set by the player script

func adjust_drop_position(position):
	var radius = 100#drop radius for items
	var nearby_items = get_tree().get_nodes_in_group("Items")#gets all instantiated items in group Items
	for item in nearby_items:#checks those items
		if item.global_position.distance_to(position) < radius:#gets the global position of each and the distance to playerpos
			#and if it is less than radius
			var radius_offset = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))#sets an offset 
			position += radius_offset#the position gets modified by offset
			break
	return position#returns the modified position
	
func drop_item(item_data, drop_position):#this is called by inventoryslot script
	var item_scene = load(item_data["scene_path"])#gets the item which is being dropped
	var item_instance = item_scene.instantiate()#instantiates the item
	item_instance.set_item_data(item_data)#sets the data calling function in inventory item script
	drop_position = adjust_drop_position(drop_position)#calls the function in this script and gets the position through her
	item_instance.global_position = drop_position#sets the global position in the scene
	get_tree().current_scene.add_child(item_instance)#spawns it


func swap_inventory_items(index1, index2):#swaps items in inventory based on their index
	if index1 < 0 or index1 > PlayerData.player_dic["inventory"].size() or index2 < 0 or index2 > PlayerData.player_dic["inventory"].size():#if any given index is not valid
		return false
	var temp = PlayerData.player_dic["inventory"][index1]#we store the item we want to swap in a temp variable
	PlayerData.player_dic["inventory"][index1] = PlayerData.player_dic["inventory"][index2]#we swap items
	PlayerData.player_dic["inventory"][index2] = temp
	inventory_updated.emit()#emit the signal to inventory ui
	return true
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
