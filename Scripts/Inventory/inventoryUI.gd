extends Control

@onready var grid_container = $Inventory/ItemPanel/GridContainer#the grid container arranges its children automatically
# Called when the node enters the scene tree for the first time.

#drag/drop
var dragged_slot = null#this is the variable that will store the dragged slot

func _ready():
	InventoryManager.inventory_updated.connect(_on_inventory_updated)#this connects the signal from inventory manager 
	#to the function _on_inventory_updated() in this script
	_on_inventory_updated()#call that function in this script

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Update_Inventory_Stats()#updates the player stats


func _on_inventory_updated():
	clear_grid_container()#calls the function in this script
	#add slots for each inventory position, basically we populate the inventory
	for item in PlayerData.player_dic["inventory"]:#goes through the inventory, and for every space it has
		var slot = InventoryManager.inventory_slot_scene.instantiate()#instantiates a slot through inventorymanager reference
		slot.drag_start.connect(_on_drag_start)#we connect the signal from inventory slot script to function in this script
		slot.drag_stop.connect(_on_drag_end)#we connect the signal from inventory slot script to function in this script
		grid_container.add_child(slot)#adds it to the world as child of grid container (add the inventory slot)
		if item != null:#if inventory space is filled
			PlayerData.inventory_dic = item#we set inventorydic in playerdata script to be that item #necessary???? #i think not
			slot.set_item(item)#calls the function set item in inventory slot script
			#print(PlayerData.inventory_dic)
		else :
			slot.set_empty()#calls the function set empty in the inventroy slot script
	
	
func clear_grid_container():#here we blank the inventory
	while grid_container.get_child_count()>0:#while there are children of grid container (slots in inventory)
		var child = grid_container.get_child(0)#get the first child
		grid_container.remove_child(child)#remove it from its children
		child.queue_free()#delete it

#store dragged slot reference
func _on_drag_start(slot_control: Control):#we pass a var of type control beacuse the slot root is of type control
	dragged_slot = slot_control
	
func _on_drag_end():
	var drop_target = get_slot_under_mouse()
	if drop_target and dragged_slot != drop_target:
		drop_slot(dragged_slot, drop_target)#we call the function in this script and pass it the values of the slots we are swapping
	dragged_slot = null

func get_slot_under_mouse() -> Control:#this function returns the slot in which we want to drop the item
	print("got it")
	var mouse_position = get_global_mouse_position()#get the global position of mouse
	for slot in grid_container.get_children():#go through the inventory slots
		var slot_rect = Rect2(slot.global_position, slot.size)#get the current slot's position and area
		if slot_rect.has_point(mouse_position):#this function verifies if the point (mouse position) is inside the area
			return slot#returns the slot
	return null#otherwise the position is invalid

func get_slot_index(slot:Control) -> int:#here we get the slot index by going through all fo grid_container's children 
	for i in range(grid_container.get_child_count()):
		#valid slot found
		if grid_container.get_child(i) == slot:
			return i
	#invalid slot
	return -1

func drop_slot(slot1:Control, slot2:Control):#here we assign the slot indexes to a variable, and we check if the slots are valid
	var slot1_index = get_slot_index(slot1)
	var slot2_index = get_slot_index(slot2)
	if slot1_index == -1 or slot2_index == -1:
		#print("invalid slot found")
		return
	else:
		if InventoryManager.swap_inventory_items(slot1_index, slot2_index):
			#print("dropping slot items: " , slot1, slot2_index)
			_on_inventory_updated()
	

func Update_Inventory_Stats():#just for playerstats
	$Inventory/StatPanel/Health.text = "Max Health: " + str(PlayerData.player_dic["max_health"])
	$Inventory/StatPanel/Stamina.text = "Max Stamina: " + str(PlayerData.player_dic["max_dashes"])
	$Inventory/StatPanel/Magic.text = "Max Mana: " + str(PlayerData.player_dic["max_mana"])
	$Inventory/StatPanel/MeleeDmg.text = "Melee Damage: " + str(PlayerData.player_dic["melee_dmg"])
	$Inventory/StatPanel/MagicDmg.text = "magic Damage: " + str(PlayerData.player_dic["magic_dmg"])
	$Inventory/StatPanel/DodgeChance.text = "Dodge Chance: " + str(PlayerData.player_dic["dodge"]) + "%"
	$Inventory/StatPanel/CritChance.text = "Crit Chance: " + str(PlayerData.player_dic["crit_chance"]) + "%"
	$Inventory/StatPanel/PlayerLevel.text = str(PlayerData.player_dic["player_level"])
	$Inventory/StatPanel/PlayerLevel/Playerxp.max_value = PlayerData.player_dic["xp_required"]
	$Inventory/StatPanel/PlayerLevel/Playerxp.value = PlayerData.player_dic["current_xp"]
	$Inventory/StatPanel/PlayerLevel/XPInfo.text = "Current: " + str(PlayerData.player_dic["current_xp"], " Required: " + str(PlayerData.player_dic["xp_required"]))
	$Inventory/PlayerPanel/Coins/amount.text = str(PlayerData.player_dic["Coins"])
