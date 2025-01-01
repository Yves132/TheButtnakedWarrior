extends Control



@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailPanel
@onready var item_name = $DetailPanel/ItemName
@onready var item_type = $DetailPanel/ItemType
@onready var item_effect = $DetailPanel/ItemEffect
@onready var outer_border = $OuterBorder


#slot item
var item = null
var is_assigned = false



func _on_item_button_mouse_entered():#if the mouse is on the slot show info
	if item != null:
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
	if item["effect"] != "":#sets the effect
		item_effect.text = str(item["effect"])
	else:
		item_effect.text = ""
	#update_assignment_status()
	#print(PlayerData.inventory_dic)
	
