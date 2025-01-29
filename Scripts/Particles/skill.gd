extends CPUParticles2D

@export var available:bool
@export var taken:bool
@export var unavailable:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if taken:
		modulate = Color(1,1,1)
		available = false
		unavailable = false
	if available:
		modulate = Color(0.392, 0.459, 1)
		taken = false
		unavailable = false
	if unavailable:
		modulate = Color(0.664, 0, 0.1)
		available = false
		taken = false
