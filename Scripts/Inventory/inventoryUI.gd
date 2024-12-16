extends Control

@onready var grid_container = $Inventory/ItemPanel/GridContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	InventoryManager.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Update_Inventory_Stats()


func _on_inventory_updated():
	clear_grid_container()
	#add slots for each inventory position
	for item in PlayerData.player_dic["inventory"]:
		var slot = InventoryManager.inventory_slot_scene.instantiate()
		grid_container.add_child(slot)
		if item != null:
			PlayerData.inventory_dic = item
			slot.set_item(item)
			#print(PlayerData.inventory_dic)
		else :
			slot.set_empty()
	
	
func clear_grid_container():
	while grid_container.get_child_count()>0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()

func Update_Inventory_Stats():
	$Inventory/StatPanel/Health.text = "Max Health: " + str(PlayerData.player_dic["max_health"])
	$Inventory/StatPanel/Stamina.text = "Max Stamina: " + str(PlayerData.player_dic["max_dashes"])
	$Inventory/StatPanel/Magic.text = "Max Mana: " + str(PlayerData.player_dic["max_mana"])
	$Inventory/StatPanel/MeleeDmg.text = "Melee Damage: " + str(PlayerData.player_dic["melee_dmg"])
	$Inventory/StatPanel/MagicDmg.text = "magic Damage: " + str(PlayerData.player_dic["magic_dmg"])
	$Inventory/StatPanel/DodgeChance.text = "Dodge Chance: " + str(PlayerData.player_dic["dodge"]) + "%"
	$Inventory/StatPanel/CritChance.text = "Crit Chance: " + str(PlayerData.player_dic["crit_chance"]) + "%"
