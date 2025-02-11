extends Button

const PRESSED_IMG = preload("res://Sprites/UI/SettingsButtonPressed.png")
const NORMAL_IMG = preload("res://Sprites/UI/SettingsButtonNormal.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_down():
	icon = PRESSED_IMG


func _on_button_up():
	icon = NORMAL_IMG
