extends Node

var uimanager = UiManager
#per oggetti con ancoraggio al centro
func _center_and_scale_anchor_center(window_size, object):
	object.position = Vector2(window_size.x / 2, window_size.y / 2)
	object.scale.x = window_size.x * 2 /640
	object.scale.y = window_size.x * 2 / 640

#per oggetto con ancoraggio alto a sinistra
func _center_and_scale_anchor_left(window_size, object, x = 0, y = 0):
	if x == 0 and y == 0:
		object.position = Vector2((window_size.x - object.size.x * object.scale.x) / 2, (window_size.y - object.size.y * object.scale.y) / 2)
	else:
		object.position = Vector2((window_size.x - object.size.x * object.scale.x) / 2 + x*object.scale.x, (window_size.y - object.size.y * object.scale.y) / 2 + y*object.scale.y)
	object.scale.x = window_size.x * 2 /640
	object.scale.y = window_size.x * 2 / 640

func _center_and_scale_font_bigger(window_size, object, x = 0, y = 0):#:')
	if x == 0 and y == 0:
		object.position = Vector2((window_size.x - object.size.x * object.scale.x) / 2, (window_size.y - object.size.y * object.scale.y) / 2)
	else:
		object.position = Vector2((window_size.x - object.size.x * object.scale.x) / 2 + x*object.scale.x, (window_size.y - object.size.y * object.scale.y) / 2 + y*object.scale.y)
	object.scale.x = window_size.x /640
	object.scale.y = window_size.x / 640

func _center_and_scale_menus(window_size, object,x = 0, y = 0):
	if x == 0 and y == 0:
		object.position = Vector2((window_size.x - object.size.x * object.scale.x) / 2, (window_size.y - object.size.y * object.scale.y) / 2)
	else:
		object.position = Vector2((window_size.x - object.size.x * object.scale.x) / 2 + x*object.scale.x, (window_size.y - object.size.y * object.scale.y) / 2 + y*object.scale.y)
	object.scale.x = window_size.x /1280
	object.scale.y = window_size.x / 1280

func _scale_ui(window_size, object):
	object.scale.x = window_size.x /640
	object.scale.y = window_size.x / 640

	
