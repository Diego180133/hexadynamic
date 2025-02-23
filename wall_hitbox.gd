extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_area_entered)

func _area_entered(area):
	if area.is_in_group("WallCollide"):
		area.collided_with_wall = true
		print("wall collision")
