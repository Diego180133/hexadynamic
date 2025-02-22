extends ProgressBar

var health = 0 : set = _update_health

func healthbar(_health):
	health = _health
	max_value = health
	value = health
func _ready():
	pass # Replace with function body.

func _update_health(new_health):
	health = min(max_value, new_health)
	value = health
	
