extends Control


@onready var hotbar_container = $HBoxContainer




# Called when the node enters the scene tree for the first time.
func _ready():
	#InventoryManager.inventory_updated.connect(_update_hotbar_ui)
	#_update_hotbar_ui()
	pass

#func _update_hotbar_ui():
	#clear_hotbar_container()
	#for i in range(InventoryManager.inventory_hotbar_size):
		#var slot = InventoryManager.inventory_slot_scene.instantiate()
		#slot.set_slot_index(i)
		#hotbar_container.add_child(slot)
		#if InventoryManager.inventory_hotbar[i] != null:
			#slot.set_item(InventoryManager.inventory_hotbar[i])
		#else:
			#slot.set_empty()
		#slot.update_assignment_status()
		
		

#clear hotbar slots
#func clear_hotbar_container():
	#while hotbar_container.get_child_count() > 0 :
		#var child = hotbar_container.get_child(0)
		#hotbar_container.remove_child(child)
		#child.queue_free()
