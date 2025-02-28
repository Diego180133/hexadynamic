extends Area2D

var reverse = false
@onready var Sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	Sprite.play("default")


func _on_timer_timeout():
	queue_free()
