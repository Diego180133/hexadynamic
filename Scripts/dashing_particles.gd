extends CPUParticles2D

func _ready():
	emitting = true

func _process(delta):
	global_position = get_tree().get_first_node_in_group("boss").global_position
	
func _on_timer_timeout():
	queue_free()
