extends CollisionShape2D

var timer = 1500
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= 60 * delta
	if timer <= 0:
		get_parent().queue_free()
