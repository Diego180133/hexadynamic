extends Polygon2D

@export var n = 5
@export var r = 20
var points = []
func _ready():
	for i in range(n):
		var theta = PI*2 / n * i # get the angle for the current iteration, in radians
		var x = r * cos(theta)
		var y = r * sin(theta)
		var point = Vector2(x, y)
		points.append(point)
		polygon = points
	print(points)
