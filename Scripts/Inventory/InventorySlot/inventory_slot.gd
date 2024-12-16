extends Control



@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailPanel
@onready var item_name = $DetailPanel/ItemName
@onready var item_type = $DetailPanel/ItemType
@onready var item_effect = $DetailPanel/ItemEffect
@onready var usage_panel = $UsagePanel
#@onready var assign_button = $UsagePanel/AssignButton

#slot item
var item = null
var slot_index = -1
var is_assigned = false

#set index
func set_slot_index(new_index):
	slot_index = new_index

func _on_item_button_pressed():
	if item != null:
		usage_panel.visible = !usage_panel.visible


func _on_item_button_mouse_entered():
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true


func _on_item_button_mouse_exited():
		details_panel.visible = false
		
func set_empty():
	#print("empty")
	icon.texture = null
	quantity_label.text = ""
	
#set slot items with its value from the dictionary
func set_item(new_item):
	#print(PlayerData.inventory_dic)
	item = new_item
	icon.texture = new_item["texture"]
	quantity_label.text =  str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str(item["effect"])
	else:
		item_effect.text = ""
	#update_assignment_status()
	#print(PlayerData.inventory_dic)
	


func _on_drop_button_pressed():
	if item != null:
		var drop_position = InventoryManager.player_node.position
		var drop_offset = Vector2(30 * InventoryManager.player_node.direction, 0)
		InventoryManager.drop_item(item, drop_position + drop_offset)
		InventoryManager.remove_item(item["type"], item["effect"])
		#InventoryManager.remove_hotbar_item(item["type"], item["effect"])
		
		usage_panel.visible = false


func _on_use_button_pressed():
	usage_panel.visible = false
	if item != null and item["effect"] != "":
		if InventoryManager.player_node:
			InventoryManager.player_node.apply_item_effect(item)
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
