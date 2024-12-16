extends Control

	
func update_health(max_health, health):
	$ProgressBar.max_value = max_health
	$ProgressBar.value = health
