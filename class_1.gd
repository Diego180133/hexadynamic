extends Node2D

@export var Attack: PackedScene
var attackCooldown = 0

func _ready():
	pass


func _process(delta):
	main_attack(delta)
	
func main_attack(delta):
	if Input.is_action_pressed("Attack") and (attackCooldown == 0):
		var newAttack = Attack.instantiate() as Node2D
		get_tree().current_scene.add_child(newAttack)
		newAttack.bulletGroup = 2
		newAttack.bulletType = 1
		newAttack.speed = 1000
		newAttack.damage = 500
		newAttack.global_position = global_position
		newAttack.look_at(get_global_mouse_position())
		attackCooldown = 10
	
	if attackCooldown > 0:
		attackCooldown -= 60 * delta
	else:
		attackCooldown = 0
