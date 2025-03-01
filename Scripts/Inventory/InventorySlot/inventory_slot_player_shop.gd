extends Control



@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailPanel
@onready var item_name = $DetailPanel/ItemName
@onready var item_type = $DetailPanel/ItemType
@onready var item_effect = $DetailPanel/ItemEffect
@onready var outer_border = $OuterBorder
@onready var item_cost = $DetailPanel/CoinImg/Cost
@onready var usage_panel = $UsagePanel
@onready var quantity_panel = $QuantityPanel


#slot item
var item = null
var is_assigned = false

func _ready():
	$ItemButton.grab_focus()

func _process(delta):
	if $QuantityPanel/HSlider.has_focus():
		if Input.is_action_just_pressed("JoystickLClick"):
			$QuantityPanel/HSlider.value -= 1
		if Input.is_action_just_pressed("JoystickRClick"):
			$QuantityPanel/HSlider.value += 1
		if Input.is_action_just_pressed("JoystickLBumper"):
			$QuantityPanel/HSlider.value = $QuantityPanel/HSlider.min_value
		if Input.is_action_just_pressed("JoystickRBumper"):
			$QuantityPanel/HSlider.value = $QuantityPanel/HSlider.max_value

func _on_item_button_mouse_entered():#if the mouse is on the slot show info
	$ItemButton.grab_focus()
	if item != null:
		usage_panel.visible = false
		quantity_panel.visible = false
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
	

func _on_item_button_gui_input(event):
	if event is InputEventMouseButton or event is InputEventJoypadButton:#if it's a mouse input from the buttons
		$ItemButton.grab_focus()
		if (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == JOY_BUTTON_A) and event.is_pressed():#if left click has been pressed
			if item != null:
				usage_panel.visible = !usage_panel.visible
				if usage_panel.visible:
					$UsagePanel/SellButton.grab_focus()

func _on_sell_button_pressed():
	details_panel.hide()
	quantity_panel.show()
	if item != null:
		$QuantityPanel/HSlider.min_value = 1
		$QuantityPanel/HSlider.max_value = item["quantity"]
		


func _on_h_slider_value_changed(value):
	$QuantityPanel/Quantity.text = str(value)


func _on_confirm_button_pressed():
	var total_gain = $QuantityPanel/HSlider.value * item["cost"]
	PlayerData.player_dic["Coins"] += total_gain
	GameManager.uimanager.shop.check_item_shop(item, $QuantityPanel/HSlider.value)
	GameManager.uimanager.shop.remove_item_from_player(item["type"], item["effect"],$QuantityPanel/HSlider.value)
	GameManager.uimanager.shop.populate_inventory()
	quantity_panel.hide()
	usage_panel.hide()


func _on_cancel_button_pressed():
	quantity_panel.hide()
	usage_panel.hide()
	$ItemButton.grab_focus()


func _on_sell_button_mouse_entered():
	$UsagePanel/SellButton.grab_focus()
	#$ItemButton.release_focus()


func _on_confirm_button_mouse_entered():
	$QuantityPanel/ConfirmButton.grab_focus()


func _on_cancel_button_mouse_entered():
	$QuantityPanel/CancelButton.grab_focus()




func _on_item_button_focus_entered():
	usage_panel.visible = true
