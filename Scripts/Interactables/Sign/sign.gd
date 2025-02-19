extends Node2D

@export var Img :Texture2D
@export var Txt :String

@onready var label = $Label
@onready var sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = Img
	label.text = Txt


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body is Player:
		label.show()

func _on_area_2d_body_exited(body):
	if body is Player:
		label.hide()
		
