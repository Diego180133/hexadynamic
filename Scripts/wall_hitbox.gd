extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)

func _area_entered(area):
	if area.is_in_group("WallCollide"):
		area.collided_with_wall = true
		

func _area_exited(area):
	if area.is_in_group("WallCollide"):
		area.collided_with_wall = false
