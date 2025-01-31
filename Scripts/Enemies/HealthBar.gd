extends Control

@onready var damage_bar = $ProgressBar/ProgressBar
@onready var health_bar = $ProgressBar
	
func update_health(max_health, health):
	health_bar.max_value = max_health
	damage_bar.max_value = max_health
	health_bar.value = health
	await get_tree().create_timer(0.4).timeout
	damage_bar.value = health
	
