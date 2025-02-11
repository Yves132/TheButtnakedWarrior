extends Node

var config = ConfigFile.new()
const SETTING_FILE_PATH = "user://settings.ini"
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
		
		config.set_value("video", "fullscreen", true)
		
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		
		config.set_value("JoypadBinding", "joyup", "Left Stick Up")
		config.set_value("JoypadBinding", "joyleft", "Left Stick Left")
		config.set_value("JoypadBinding", "joydown", "Left Stick Down")
		config.set_value("JoypadBinding", "joyright", "Left Stick right")
		config.set_value("JoypadBinding", "joyjump", "PS Triangle, Xbox Y")
		config.set_value("JoypadBinding", "joyrun", "PS R2, Xbox RT")
		config.set_value("JoypadBinding", "joyinteract", "PS Square, Xbox X")
		config.set_value("JoypadBinding", "joydash", "PS Circle, Xbox B")
		config.set_value("JoypadBinding", "joyinventory", "Select")
		config.set_value("JoypadBinding", "joymelee", "PS R1, Xbox Rb")
		config.set_value("JoypadBinding", "joymagic", "PS L1, Xbox Lb")
		
		config.save(SETTING_FILE_PATH)
	else:
		config.load(SETTING_FILE_PATH)

func save_video_setting(key:String, value):
	config.set_value("video", key, value)
	config.save(SETTING_FILE_PATH)
	
func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings
		
func save_audio_setting(key:String, value):
	config.set_value("audio", key, value)
	config.save(SETTING_FILE_PATH)

func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings
		

func save_keybinding(action : StringName, event : InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)
		
	config.set_value("Keybinding", action, event_str)
	config.save(SETTING_FILE_PATH)
	
func save_joybinding(action : StringName, event : InputEvent):
	var event_str
	if event is InputEventJoypadButton:
		event_str = str(event)
	if event is InputEventJoypadMotion:
		event_str = str(event)
	config.set_value("JoypadBinding", action, event_str)
	
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

func load_joypadbindings():
	var joypadbindings = {}
	var keys = config.get_section_keys("JoypadBinding")
	for key in keys:
		var input_event
		var event_str = config.get_value("JoypadBinding", key)
		if event_str.contains("motion"):
			input_event = InputEventJoypadMotion.new()
		else:
			input_event = InputEventJoypadButton.new()
		
		joypadbindings[key] = input_event
	return joypadbindings
