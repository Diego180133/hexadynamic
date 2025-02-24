extends CharacterBody2D

@onready var HealthBar = $"../BossHealth"
@onready var Player = $"../Player"
@onready var BossPolygon = $Polygon2DOutline/Polygon2D
@export var Bullet: PackedScene
@export var Health = 10000
var angle := 0.0
var attackAmount := 5
var currentComboAttack := 0
var actionTimer := 0.0
var actionTimer2 := 0.0
var attackTimer := 0.0
var animTimer := 0.0
var ComboString = []
var newAttack := true
var rotationStorage := 0.0
var slowDown := false
var bulletRotation := 0.0
var intensity := 0.0
var loop := 0
var spawnRotation = 90

func _ready():
	HealthBar.healthbar(Health)
	comboBuild()

func _physics_process(delta):
	move_and_slide()

func _process(delta):
	match ComboString[currentComboAttack]:
		11:
			comboBuild()
		12:
			cooldown(delta)
		1:
			Attack1(delta)
		2: 
			Attack2(delta)
		3:
			Attack3(delta)
		4: 
			Attack4(delta)

func comboBuild():
	ComboString = []
	currentComboAttack = 0
	attackAmount = RandomNumberGenerator.new().randi_range(4,6)
	for i in range(attackAmount):
		ComboString.append(RandomNumberGenerator.new().randi_range(1,4))
	ComboString[attackAmount - 1] = 11
	print(ComboString)
	attackTimer = 300
	actionTimer = 60
	return ComboString

func _Health_Update():
	HealthBar.health = Health
	
func _area_entered():
	pass

func Attack1(delta):
	if newAttack == true:
		attackTimer = 60
		actionTimer = 0
		newAttack = false
		
	look_at(Player.position)
	velocity = transform.x*100
		
	if actionTimer <= 0:
		angle += PI / 24
		for i in 24:
			var newBullet = Bullet.instantiate() as Node2D
			get_tree().current_scene.add_child(newBullet)
			newBullet.bulletGroup = 1
			newBullet.bulletType = 2
			newBullet.initPos = global_position
			newBullet.angle = angle
			newBullet.displace = (PI*i)/12
			newBullet.rotSpeed = 0.25
				
				
			newBullet = Bullet.instantiate() as Node2D
			get_tree().current_scene.add_child(newBullet)
			newBullet.bulletGroup = 1
			newBullet.bulletType = 2
			newBullet.initPos = global_position
			newBullet.angle = angle
			newBullet.displace = (PI*i)/12
			newBullet.rotSpeed = -0.25
		actionTimer = 1000
			
	if attackTimer <= 0:
		currentComboAttack += 1
		actionTimer = 1000
		newAttack = true
		
	actionTimer -= 60 * delta
	attackTimer -= 60 * delta

func Attack2(delta):
	
	if newAttack == true:
		attackTimer = 40
		actionTimer = 30
		newAttack = false
	
	look_at(Player.position)
	velocity = transform.x*100
	
	if actionTimer <= 0:
		spawnRotation = 90
		for i in 2:
			var newBullet = Bullet.instantiate() as Node2D
			get_tree().current_scene.add_child(newBullet)
			newBullet.bulletGroup = 1
			newBullet.bulletType = 3
			newBullet.speed = 400
			newBullet.spawnRotation = spawnRotation
			newBullet.velocity = newBullet.speed * global_position.direction_to(Player.global_position)
			newBullet.velocity = newBullet.velocity.rotated(deg_to_rad(newBullet.spawnRotation))
			spawnRotation += 180
			newBullet.global_position = global_position
			newBullet.timer = 450
		actionTimer = 60
		
	if attackTimer <= 0:
		currentComboAttack += 1
		attackTimer = 300
		actionTimer = 1000
		newAttack = true
		velocity = Vector2(0,0)
	
	actionTimer -= 60 * delta
	attackTimer -= 60 * delta

func Attack3(delta):
	if newAttack == true:
		attackTimer = 120
		actionTimer = 120
		animTimer = 120
		rotationStorage = 0
		newAttack = false
		loop = 1
		look_at(Player.position)
	

	velocity = Vector2(0,0)
	if animTimer > 60:
		look_at(Player.position)
	
	if animTimer > 0 && animTimer < 60:
		rotationStorage += deg_to_rad((360/60) * 60 * delta)
		look_at(Player.position)
		rotate(rotationStorage)
	
	if actionTimer <= 0:
		var newBigBullet = Bullet.instantiate() as Node2D
		get_tree().current_scene.add_child(newBigBullet)
		newBigBullet.bulletGroup = 3
		newBigBullet.bulletType = 5
		newBigBullet.global_position = global_position
		newBigBullet.speed = 750
		newBigBullet.look_at(Player.position + ((Player.velocity * global_position.distance_to(Player.position)) / (newBigBullet.speed))/3)
		look_at(Player.position + ((Player.velocity * global_position.distance_to(Player.position)) / (newBigBullet.speed)))
		actionTimer = 10000
		
	if attackTimer <= 0:
		if loop > 0:
			attackTimer = 120
			actionTimer = 60
			animTimer = 60
			loop -= 1
		else:
			currentComboAttack += 1
			attackTimer = 300
			newAttack = true
			actionTimer = 1000
	
	actionTimer -= 60 * delta
	attackTimer -= 60 * delta
	animTimer -= 60 * delta

func Attack4(delta):
	
	if newAttack == true:
		BossPolygon.material.set_shader_parameter("attack_color", Vector4(255,0,255,0))
		intensity = 0
		attackTimer = 120
		actionTimer = 90
		actionTimer2 = 92
		newAttack = false
		slowDown = false
		bulletRotation = 90

	if actionTimer > 0 && actionTimer < 100:
		intensity += (0.7/1.5 * delta)
		BossPolygon.material.set_shader_parameter("intensity", intensity)
		look_at(Player.position + ((Player.velocity * global_position.distance_to(Player.position)) / (2000)))
		
	
	if actionTimer <= 0:
		intensity = 0
		BossPolygon.material.set_shader_parameter("intensity", intensity)
		actionTimer = 10000
		var Particles = (load("res://Scenes/DashingParticles.tscn") as PackedScene).instantiate()
		get_tree().current_scene.add_child(Particles)
		Particles.global_position = global_position
		velocity = transform.x*3000
		slowDown = true
		
	if actionTimer2 <= 0:
		bulletRotation = -bulletRotation
		var newBullet = Bullet.instantiate() as Node2D
		get_tree().current_scene.add_child(newBullet)
		newBullet.bulletGroup = 1
		newBullet.bulletType = 4
		newBullet.global_position = global_position
		newBullet.speed = 0
		newBullet.rotation = rotation
		newBullet.rotate(deg_to_rad(bulletRotation))
		actionTimer2 = 2
		
	if slowDown == true:
		velocity -= (2 * velocity * delta)
		
	if attackTimer <= 0:
		currentComboAttack += 1
		attackTimer = 300
		actionTimer = 1000
		velocity = Vector2(0,0)
		newAttack = true
		slowDown = false
	
	actionTimer -= 60 * delta
	attackTimer -= 60 * delta
	actionTimer2 -= 60 * delta

func cooldown(delta):
	pass
