extends Node

var config = ConfigFile.new()
const SETTING_FILE_PATH = "res://Saves/settings.ini"
# Called when the node enters the scene tree for the first time.
func _ready():
	if !FileAccess.file_exists(SETTING_FILE_PATH):
		config.set_value("Keybinding", "up", "W")
		config.set_value("Keybinding", "left", "A")
		config.set_value("Keybinding", "down", "S")
		config.set_value("Keybinding", "right", "D")
		config.set_value("Keybinding", "jump", "Space")
		config.set_value("Keybinding", "run", "Shift")
		config.set_value("Keybinding", "interact", "E")
		config.set_value("Keybinding", "Dash", "Alt")
		config.set_value("Keybinding", "Inventory", "I")
		config.set_value("Keybinding", "Melee", "mouse_1")
		config.set_value("Keybinding", "Magic", "mouse_2")
		
		config.save(SETTING_FILE_PATH)
	else:
		config.load(SETTING_FILE_PATH)

func save_keybinding(action : StringName, event : InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)
		
	config.set_value("Keybinding", action, event_str)
	config.save(SETTING_FILE_PATH)

func load_keybindings():
	var keybindings = {}
	var keys = config.get_section_keys("Keybinding")
	for key in keys:
		var input_event
		var event_str = config.get_value("Keybinding", key)
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
		
		keybindings[key] = input_event
	return keybindings
