extends Control

const SLOT_SHOP = preload("res://Scenes/Inventory/InventorySlots/inventory_slot_shop.tscn")
const SLOT_PLAYER = preload("res://Scenes/Inventory/InventorySlots/inventory_slot__player_in_shop.tscn")

@onready var shop_inventory = []
@onready var player_money = $TextureRect/PlayerInventory/TextureRect/Money
@onready var player_grid = $TextureRect/PlayerInventory/GridContainer
@onready var message = $TextureRect/Label


@export var item_type = ""
@export var item_name = ""
@export var item_texture : Texture
@export var item_effect = ""
@export var cost : int
@export var is_on_hotbar = false#not used right now
var scene_path : String = "res://Scenes/Inventory/InventoryItem/inventory_item.tscn"#this is the path to this scene

# Called when the node enters the scene tree for the first time.
func _ready():
	#player_inventory.resize(PlayerData.player_dic["inventory"].size())
	shop_inventory.resize(20)
	populate_inventory()#we match the player inventory with what we see in the shop
	add_meat()#we call this to add items in the shop


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#PLAYER INVENTORY

func populate_inventory():
	player_money.text = str(PlayerData.player_dic["Coins"])
	#for i in player_inventory.size():
		#player_inventory[i] = PlayerData.player_dic["inventory"][i]
	clear_grid_container_player()#used to prevent multiplying of slots
	for item in PlayerData.player_dic["inventory"]:#check every slot in the array playerinventory
		#print(item)
		var slot = SLOT_PLAYER.instantiate()#instantiate the slot scene, there are functions useful in inventoryslot script
		player_grid.add_child(slot)#add the slot
		if item != null:#if the slot is full, set it's values (from inventoryslot script)
			slot.set_item(item)
		else:#if it's empty set it empty (from inventoryslot script)
			slot.set_empty()

func clear_grid_container_player():
	while player_grid.get_child_count()>0:#while there are children of grid container (slots in inventory)
		var child = player_grid.get_child(0)#get the first child
		player_grid.remove_child(child)#remove it from its children
		child.queue_free()#delete it
		
func check_item(item,amount):
	if item["effect"] == "Heal 1 HP":
		add_meat_player(amount)
	if item["effect"] == "SPD+(20)":
		add_wing_player(amount)
	if item["effect"] == "Regen Health":
		add_blood_player(amount)

func add_meat_player(amount):#this starts adding items to the shop
	var counter = 0
	item_type = "Consumable"#we define the properties
	item_name = "Goblin Meat"
	item_effect = "Heal 1 HP"
	cost = 2
	item_texture = $Meat.texture#set the texture
	while counter < amount:#get a random number of items
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
		add_item_to_player(item)#call this function to add items to the array
		counter += 1
	populate_inventory()

func add_wing_player(amount):#this adds the second type of item
	var counter = 0
	item_type = "Consumable"#we define the properties
	item_name = "Bat Wing"
	item_effect = "SPD+(20)"
	cost = 3
	item_texture = $Wing.texture#set the texture
	while counter < amount:#get a random number of items
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
		add_item_to_player(item)#call this function to add items to the array
		counter += 1
	populate_inventory()

func add_blood_player(amount):#this adds the third type of item
	var counter = 0
	item_type = "Consumable"#we define the properties
	item_name = "Troll's Blood"
	item_effect = "Regen Health"
	cost = 5
	item_texture = $Blood.texture#set the texture
	while counter < amount:#get a random number of items
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
		add_item_to_player(item)#call this function to add items to the array
		counter += 1
	populate_inventory()
	

func add_item_to_player(item):
	for i in range(PlayerData.player_dic["inventory"].size()):
		if PlayerData.player_dic["inventory"][i] != null and PlayerData.player_dic["inventory"][i]["type"] == item["type"] and PlayerData.player_dic["inventory"][i]["effect"] == item["effect"]:
			PlayerData.player_dic["inventory"][i]["quantity"] += item["quantity"]
			InventoryManager.inventory_updated.emit()
			return true
	for i in range(PlayerData.player_dic["inventory"].size()):
		if PlayerData.player_dic["inventory"][i] != null and PlayerData.player_dic["inventory"][i]["type"] == item["type"] and PlayerData.player_dic["inventory"][i]["effect"] == item["effect"]:
			PlayerData.player_dic["inventory"][i]["quantity"] += item["quantity"]
			InventoryManager.inventory_updated.emit()
			return true
		elif PlayerData.player_dic["inventory"][i] == null:
			PlayerData.player_dic["inventory"][i] = item
			InventoryManager.inventory_updated.emit()
			return true
	return false
 
func remove_item_from_player(ItemType, ItemEffect, Amount):
	for i in PlayerData.player_dic["inventory"].size():
		if PlayerData.player_dic["inventory"][i] != null and PlayerData.player_dic["inventory"][i]["type"] == ItemType and PlayerData.player_dic["inventory"][i]["effect"] == ItemEffect:
			PlayerData.player_dic["inventory"][i]["quantity"] -= Amount
			if PlayerData.player_dic["inventory"][i]["quantity"] <= 0:
				PlayerData.player_dic["inventory"][i] = null
			InventoryManager.inventory_updated.emit()
			return true
	return false

#SHOP INVENTORY-------------------------------------------------------------------------------------------------------

func populate_shop():
	clear_grid_container_shop()#used to prevent multiplying of slots
	for item in shop_inventory:#check every slot in shop inventory array
		var slot = SLOT_SHOP.instantiate()#instantiate the slot scene, there are functions useful in inventoryslot script
		$TextureRect/GoblinInventory/GridContainer.add_child(slot)#add the slot
		if item != null:#if the slot is full, set it's values (from inventoryslot script)
			slot.set_item(item)
		else:#if it's empty set it empty (from inventoryslot script)
			slot.set_empty()
	
func clear_grid_container_shop():
	while $TextureRect/GoblinInventory/GridContainer.get_child_count() >0:#while there are children of grid container (slots in inventory)
		var child = $TextureRect/GoblinInventory/GridContainer.get_child(0)#get the first child
		$TextureRect/GoblinInventory/GridContainer.remove_child(child)#remove it from its children
		child.queue_free()#delete it


func add_meat():#this starts adding items to the shop
	var counter = 0
	item_type = "Consumable"#we define the properties
	item_name = "Goblin Meat"
	item_effect = "Heal 1 HP"
	cost = 4
	item_texture = $Meat.texture#set the texture
	while counter <= randi() %15 + 5:#get a random number of items
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
		add_item_to_shop(item)#call this function to add items to the array
		counter += 1
	add_wing()#we add the second type of item

func add_wing():#this adds the second type of item
	var counter = 0
	item_type = "Consumable"#we define the properties
	item_name = "Bat Wing"
	item_effect = "SPD+(20)"
	cost = 6
	item_texture = $Wing.texture#set the texture
	while counter <= randi() %10 + 5:#get a random number of items
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
		add_item_to_shop(item)#call this function to add items to the array
		counter += 1
	add_blood()#we add the third type of item

func add_blood():#this adds the third type of item
	var counter = 0
	item_type = "Consumable"#we define the properties
	item_name = "Troll's Blood"
	item_effect = "Regen Health"
	cost = 10
	item_texture = $Blood.texture#set the texture
	while counter <= randi() %5 + 1:#get a random number of items
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
		add_item_to_shop(item)#call this function to add items to the array
		counter += 1
	populate_shop()#we populate the grid visually with the items we just put inside

func add_item_to_shop(item):#adds items to the array 
	for i in range(shop_inventory.size()):#runs the whole array
		if shop_inventory[i] != null and shop_inventory[i]["type"] == item["type"] and shop_inventory[i]["effect"] == item["effect"]:
			shop_inventory[i]["quantity"] += item["quantity"]#if the item is already there add quantity
			return true
	for i in range(shop_inventory.size()):#runs the whole array
		if shop_inventory[i] != null and shop_inventory[i]["type"] == item["type"] and shop_inventory[i]["effect"] == item["effect"]:
			shop_inventory[i]["quantity"] += item["quantity"]#if the item is already there add quantity
			return true
		elif shop_inventory[i] == null:#if the item is not there and the slot is null, add item to the slot
			shop_inventory[i] = item
			return true
	return false
	

func remove_item_from_shop(ItemType, ItemEffect, Amount):
	for i in shop_inventory.size():
		if shop_inventory[i] != null and shop_inventory[i]["type"] == ItemType and shop_inventory[i]["effect"] == ItemEffect:
			shop_inventory[i]["quantity"] -= Amount
			if shop_inventory[i]["quantity"] <= 0:
				shop_inventory[i] = null
			return true
	return false
	
func check_item_shop(item,amount):
	if item["effect"] == "Heal 1 HP":
		add_meat_from_player(amount)
	if item["effect"] == "SPD+(20)":
		add_wing_from_player(amount)
	if item["effect"] == "Regen Health":
		add_blood_from_player(amount)

func add_meat_from_player(Amount):#this starts adding items to the shop
	var counter = 0
	item_type = "Consumable"#we define the properties
	item_name = "Goblin Meat"
	item_effect = "Heal 1 HP"
	cost = 4
	item_texture = $Meat.texture#set the texture
	while counter < Amount:#get a random number of items
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
		add_item_to_shop(item)#call this function to add items to the array
		counter += 1
	populate_shop()#we populate the grid visually with the items we just put inside

func add_wing_from_player(Amount):#this adds the second type of item
	var counter = 0
	item_type = "Consumable"#we define the properties
	item_name = "Bat Wing"
	item_effect = "SPD+(20)"
	cost = 6
	item_texture = $Wing.texture#set the texture
	while counter < Amount:#get a random number of items
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
		add_item_to_shop(item)#call this function to add items to the array
		counter += 1
	populate_shop()#we populate the grid visually with the items we just put inside

func add_blood_from_player(Amount):#this adds the third type of item
	var counter = 0
	item_type = "Consumable"#we define the properties
	item_name = "Troll's Blood"
	item_effect = "Regen Health"
	cost = 10
	item_texture = $Blood.texture#set the texture
	while counter < Amount:#get a random number of items
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
		add_item_to_shop(item)#call this function to add items to the array
		counter += 1
	populate_shop()#we populate the grid visually with the items we just put inside
