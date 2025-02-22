extends Area2D

@onready var anim = $AnimatedSprite2D
var speed = 1000
var rotSpeed := 0.5
var rSpeed := 4
var initPos: Vector2
var radius := 0.0
var d := 0.0
var displace := 0.0
var angle := 0.0
var bulletType := 0
var velocity: Vector2
var torsion_speed:= 0.04
var timer = 100

func _ready():
	anim.play("default")


func _physics_process(delta):
	
	d += delta
	
	match bulletType:
		
		#Direct
		1:
			position += transform.x * speed * delta
			
		#Orbit
		2:
			position = Vector2((sin(d * rotSpeed + angle + displace)) * radius,
			 (cos(d * rotSpeed + angle + displace)) * radius
			) + initPos
		
			radius += rSpeed
			
		#tracking
		3:
			var playerPosition:Vector2 = get_tree().get_first_node_in_group("player").position
			var vectorToPlayer:Vector2 = (playerPosition - position).normalized()
			velocity = velocity.rotated(torsion_speed * velocity.angle_to(vectorToPlayer))
			position += velocity * delta
			timer -= 60 * delta
			if timer <= 0:
				queue_free()
			
		#linear speed up
		4:
			position += transform.x * speed * delta
			speed += 120 * delta
		
