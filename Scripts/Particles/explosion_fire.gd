extends Node2D

@onready var particles = $CPUParticles2D
@onready var audioplayer = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	particles.emitting = true
	audioplayer.play()
	var pitch_mod = randf_range(-0.05,+0.05)
	audioplayer.pitch_scale = 1 + pitch_mod


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
