extends Control

@onready var input_button_scene = preload("res://Scenes/UI/InputSettings/input_button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList


var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"up" = "Up",
	"left" = "Left",
	"down" = "Down",
	"right" = "Right",
	"jump" = "Jump",
	"run" = "Run",
	"Dash" = "Dash",
	"interact" = "Interact",
	"Inventory" = "Inventory",
	"Magic" = "Magic",
	"Melee" = "Melee"
}
# Called when the node enters the scene tree for the first time.
func _ready():
	_load_keybindings_from_settings()
	_create_action_list()

func _load_keybindings_from_settings():
	var keybindings = ConfigFileHandler.load_keybindings()
	for action in keybindings.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybindings[action])
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _create_action_list():
	#InputMap.load_from_project_settings()#loads default input settings
	for item in action_list.get_children():
		item.queue_free() #with this for loop the action list is empty
	for action in input_actions:
		var button = input_button_scene.instantiate()#we instantiate a button for each action in input map
		var label_action = button.find_child("LabelAction")#we get the child called LabelAction in button scene
		var label_input = button.find_child("LabelInput")#we get the child called LabelInput in button scene
		label_action.text = input_actions[action]#we set the text of the label to action var 
		var events = InputMap.action_get_events(action)#we get the key to press tied to the action
		if events.size() > 0:#if there is a key bound to an action
			label_input.text = events[0].as_text().trim_suffix(" (Physical)")#the text becomes that key
		else:
			label_input.text = ""
		action_list.add_child(button)#we add the button
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."
		
func _input(event):
	if is_remapping:
		if event is InputEventKey or (event is InputEventMouseButton and event.pressed):
			#turn double click into single click
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)#removes all events bound to action
			InputMap.action_add_event(action_to_remap, event)#binds the desired event(key) to action
			ConfigFileHandler.save_keybinding(action_to_remap, event)
			_update_action_list(remapping_button, event)
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			accept_event()

func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")

func _on_reset_button_pressed():
	InputMap.load_from_project_settings()
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			ConfigFileHandler.save_keybinding(action, events[0])
	_create_action_list()
