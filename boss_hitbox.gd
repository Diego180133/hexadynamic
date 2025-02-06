extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_area_entered)

func _area_entered(area):
	if area.is_in_group("playerProjectile"):
		area.queue_free()
		_attack_damage()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _attack_damage():
	get_parent().Health -= 20
	get_parent()._Health_Update()
