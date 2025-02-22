extends ProgressBar

var energy = 0 : set = _update_energy

func ENBar(_energy):
	energy = _energy
	max_value = energy
	value = energy
func _ready():
	pass # Replace with function body.

func _update_energy(new_energy):
	energy = min(max_value, new_energy)
	value = energy
