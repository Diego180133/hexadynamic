extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_area_entered)

func _area_entered(area):
	if area.is_in_group("enemyProjectile") or area.is_in_group("playerProjectile"):
		area.queue_free()
