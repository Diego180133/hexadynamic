extends Area2D

@onready var Sprite = $AnimatedSprite2D
var speed = 1000
var rotSpeed := 0.5
var rSpeed := 5
var initPos: Vector2
var radius := 0.0
var d := 0.0
var displace := 0.0
var angle := 0.0
var bulletType := 0
var velocity:Vector2 
var torsion_speed:= 0.04
var timer = 100
var colorShade = Vector4(1,0,1,0.4)
var bulletGroup = 0
var collided_with_wall = false
var spawnRotation = 0
var dark = false

func _ready():
	if dark == true:
		Sprite.play("dark_purple")
	else:
		Sprite.play("default")

func _physics_process(delta):
	
	d += delta
	
	match bulletGroup:
		
		1:
			add_to_group("enemyProjectile")
		3:
			add_to_group("WallCollide")
			add_to_group("enemyProjectile")
		
	if bulletGroup != 0:
		bulletGroup = 0
		
	Sprite.material.set_shader_parameter("colorShade", colorShade)
	
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
			
		#Spawns more bullets
		5:
			scale = Vector2(3,3)
			position += transform.x * speed * delta
			if collided_with_wall == true:
				for i in 24:
					var newBullet = (load("res://Scenes/bullet.tscn") as PackedScene).instantiate()
					get_tree().current_scene.add_child(newBullet)
					newBullet.bulletGroup = 1
					newBullet.bulletType = 2
					newBullet.initPos = global_position
					newBullet.angle = angle
					newBullet.displace = (PI*i)/12
					newBullet.rotSpeed = 0.25
					newBullet.rSpeed = 8
				var Explosion = (load("res://Scenes/ExplosionParticles.tscn") as PackedScene).instantiate()
				get_tree().current_scene.add_child(Explosion)
				Explosion.global_position = global_position
	
	if collided_with_wall == true:
		queue_free()
