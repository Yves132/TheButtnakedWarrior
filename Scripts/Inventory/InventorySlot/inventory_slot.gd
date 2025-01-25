extends Control



@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailPanel
@onready var item_name = $DetailPanel/ItemName
@onready var item_type = $DetailPanel/ItemType
@onready var item_effect = $DetailPanel/ItemEffect
@onready var usage_panel = $UsagePanel
@onready var outer_border = $OuterBorder
@onready var item_cost = $DetailPanel/CoinImg/Cost
#@onready var assign_button = $UsagePanel/AssignButton

#signals
signal drag_start(slot)#used to indicate when we are dragging an item
signal drag_stop()

#slot item
var item = null
var slot_index = -1
var is_assigned = false

#set index
func set_slot_index(new_index):#this was called by inventory hotbar script
	slot_index = new_index


func _on_item_button_mouse_entered():#if the mouse is on the slot show info
	$ItemButton.grab_focus()
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true


func _on_item_button_mouse_exited():#if it ain't no more hide it
		details_panel.visible = false
		
func set_empty():#sets the slot to be empty
	#print("empty")
	icon.texture = null#no texture
	quantity_label.text = ""#no quantity
	
#set slot items with its value from the dictionary
func set_item(new_item):#sets the slot to be filled (called from inventory UI script)
	#print(PlayerData.inventory_dic)
	item = new_item#it is the item received from inventory ui script
	icon.texture = new_item["texture"]#sets the texture
	quantity_label.text =  str(item["quantity"])#sets the quantity
	item_name.text = str(item["name"])#sets the name
	item_type.text = str(item["type"])#sets the type
	item_cost.text = str(item["cost"])
	if item["effect"] != "":#sets the effect
		item_effect.text = str(item["effect"])
	else:
		item_effect.text = ""
	#update_assignment_status()
	#print(PlayerData.inventory_dic)
	


func _on_drop_button_pressed():
	if item != null:
		var drop_position = InventoryManager.player_node.position#gets the player position
		var drop_offset = Vector2(30 * InventoryManager.player_node.direction, 0)#sets the drop offset
		InventoryManager.drop_item(item, drop_position + drop_offset)#calls the function in inventory manager script
		InventoryManager.remove_item(item["type"], item["effect"])#calls the function in inventorymanager script
		#InventoryManager.remove_hotbar_item(item["type"], item["effect"])
		usage_panel.visible = false


func _on_use_button_pressed():
	usage_panel.visible = false
	if item != null and item["effect"] != "":
		if InventoryManager.player_node:
			InventoryManager.player_node.apply_item_effect(item)#calls this function in playerscript
			#InventoryManager.remove_item(item["type"],item["effect"])
			#InventoryManager.remove_hotbar_item(item["type"], item["effect"])
		else:
			print("player could not be found")

#updates hotbar assignment status

#func update_assignment_status():#irrelevant no hotbar will be present
	#is_assigned = InventoryManager.is_item_assigned_to_hotbar(item)
	#print(is_assigned)
	#if is_assigned:
		#assign_button.text = "Unassign"
	#else:
		#assign_button.text = "Assign"

#assign/unassign hotbar item

#func _on_assign_button_pressed():#irrelevant no hotbar will be present
	#if item != null:
		#if is_assigned:
			#InventoryManager.unassign_hotbar_item(item["type"], item["effect"])
			#is_assigned = false
		#else:
			#InventoryManager.add_item(item, true)
			#is_assigned = true
		#update_assignment_status()


func _on_item_button_gui_input(event):#this helps use distinguish various events ( e.g. right click from left click)
	if event is InputEventMouseButton or event is InputEventJoypadButton:#if it's a mouse input from the buttons
		if (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == JOY_BUTTON_A) and event.is_pressed():#if left click has been pressed
			if item != null:
				usage_panel.visible = !usage_panel.visible
		#dragging item
		if (event.button_index == MOUSE_BUTTON_RIGHT or event.button_index == JOY_BUTTON_RIGHT_SHOULDER):#if it is right click 
			if event.is_pressed():#if it has been  clicked
				#print("here")
				outer_border.modulate == Color(1,1,0)
				drag_start.emit(self)
			if event.is_released():#if it has been released
				outer_border.modulate = Color(1,1,1)
				drag_stop.emit()
		
		
		
		
		
		
		
