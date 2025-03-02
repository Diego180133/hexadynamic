extends CharacterBody2D

@onready var HealthBar = $Node/BossHealth
@onready var Player = $"../Player"
@onready var BossPolygon = $Polygon2DOutline/Polygon2D
@onready var BossPolygonOutline = $Polygon2DOutline
@export var Bullet: PackedScene
@export var Dagger: PackedScene
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
var dashSlash = false
var bulletRotation := 0.0
var intensity := 0.0
var loop := 0
var spawnRotation = 90
var speed = 0
var predictPos:Vector2
var newAttackAction = true

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
		5:
			Attack5(delta)
		6:
			Attack6(delta)

func comboBuild():
	ComboString = []
	currentComboAttack = 0
	attackAmount = RandomNumberGenerator.new().randi_range(4,6)
	for i in range(attackAmount):
		ComboString.append(RandomNumberGenerator.new().randi_range(1,6))
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
		for i in 18:
			var newBullet = Bullet.instantiate() as Node2D
			get_tree().current_scene.add_child(newBullet)
			newBullet.bulletGroup = 1
			newBullet.bulletType = 2
			newBullet.initPos = global_position
			newBullet.angle = angle
			newBullet.displace = (PI*i)/9
			newBullet.rotSpeed = 0.25
				
				
			newBullet = Bullet.instantiate() as Node2D
			get_tree().current_scene.add_child(newBullet)
			newBullet.bulletGroup = 1
			newBullet.bulletType = 2
			newBullet.initPos = global_position
			newBullet.angle = angle
			newBullet.displace = (PI*i)/9
			newBullet.rotSpeed = -0.25
		actionTimer = 1000
			
	if attackTimer <= 0:
		currentComboAttack += 1
		actionTimer = 1000
		velocity = Vector2(0,0)
		newAttack = true
		
	timers(delta)

func Attack2(delta):
	
	if newAttack == true:
		attackTimer = 60
		actionTimer = 30
		newAttack = false
	
	look_at(Player.position)
	velocity = transform.x*100
	
	if actionTimer <= 0:
		spawnRotation = 90
		for i in 2:
			var newDagger = Dagger.instantiate() as Node2D
			newDagger.dark = true
			get_tree().current_scene.add_child(newDagger)
			newDagger.bulletGroup = 3
			newDagger.bulletType = 3
			newDagger.speed = 400
			newDagger.spawnRotation = spawnRotation
			newDagger.velocity = newDagger.speed * global_position.direction_to(Player.global_position)
			newDagger.velocity = newDagger.velocity.rotated(deg_to_rad(newDagger.spawnRotation))
			spawnRotation += 180
			newDagger.global_position = global_position
			newDagger.timer = 300
		actionTimer = 1000
		
	if attackTimer <= 0:
		currentComboAttack += 1
		attackTimer = 300
		actionTimer = 1000
		newAttack = true
		velocity = Vector2(0,0)
	
	timers(delta)

func Attack3(delta):
	if newAttack == true:
		attackTimer = 70
		actionTimer = 70
		actionTimer2 = 70
		animTimer = 70
		rotationStorage = 0
		newAttack = false
		loop = 1
		look_at(Player.position)
	

	velocity = Vector2(0,0)
	if animTimer > 60:
		look_at(Player.position)
	
	if animTimer > 0 && animTimer < 45:
		rotationStorage += deg_to_rad((360/45) * 60 * delta)
		look_at(Player.position)
		rotate(rotationStorage)
	
	if actionTimer2 <= 10:
		predictPos = Player.position + ((Player.input * Player.accel * global_position.distance_to(Player.position)) / 1350)
		actionTimer2 = 1000
		
	if actionTimer <= 0:
		var newBullet = Bullet.instantiate() as Node2D
		newBullet.dark = true
		get_tree().current_scene.add_child(newBullet)
		newBullet.damage = 50
		newBullet.bulletGroup = 3
		newBullet.bulletType = 5
		newBullet.global_position = global_position
		newBullet.look_at(predictPos)
		look_at(predictPos)
		actionTimer = 10000
		
	if attackTimer <= 0:
		if loop > 0:
			attackTimer = 70
			actionTimer = 60
			actionTimer2 = 60
			animTimer = 60
			loop -= 1
		else:
			currentComboAttack += 1
			attackTimer = 300
			newAttack = true
			actionTimer = 1000
	
	timers(delta)

func Attack4(delta):
	
	if newAttack == true:
		BossPolygon.material.set_shader_parameter("attack_color", Vector4(1,0.5,1,0))
		intensity = 0
		attackTimer = 120
		actionTimer = 90
		actionTimer2 = 92
		newAttack = false
		slowDown = false
		velocity = Vector2(0,0)
		bulletRotation = 90
		var Particles = (load("res://Scenes/wave_particle.tscn") as PackedScene).instantiate()
		Particles.waitTime = 1.5
		Particles.lifeTime = 0.3
		Particles.amount_ = 1
		Particles.colorValue = Color(1,0.3,1,0.3)
		get_tree().current_scene.add_child(Particles)
		Particles.global_position = global_position

	if actionTimer > 10 && actionTimer < 100:
		intensity += (0.8 * delta)
		BossPolygon.material.set_shader_parameter("intensity", intensity)
		look_at(Player.position + ((Player.input * Player.accel * global_position.distance_to(Player.position)) / (1250)))
		
	
	if actionTimer <= 0:
		intensity = 0
		BossPolygon.material.set_shader_parameter("intensity", intensity)
		actionTimer = 10000
		var Particles = (load("res://Scenes/DashingParticles.tscn") as PackedScene).instantiate()
		Particles.radius = 50
		Particles.amount_ = 50
		Particles.waitTime = 1
		Particles.lifeTime = 0.4
		Particles.colorValue = Color(0.8,0,1,1)
		get_tree().current_scene.add_child(Particles)
		Particles.global_position = global_position
		velocity = transform.x*3000
		slowDown = true
		
	if actionTimer2 <= 0:
		bulletRotation = -bulletRotation
		var newBullet = Bullet.instantiate() as Node2D
		get_tree().current_scene.add_child(newBullet)
		newBullet.bulletGroup = 3
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
	
	timers(delta)

func Attack5(delta):
	if newAttack == true:
		attackTimer = 130
		actionTimer = 60
		actionTimer2 = 40
		newAttack = false
		newAttackAction = true
		
	if actionTimer2 <= 40:
		BossPolygon.color.a = actionTimer2/40
		BossPolygonOutline.color.a = actionTimer2/40
		
		if newAttackAction == true:
			var RelocateParticles = (load("res://Scenes/ExplosionParticles.tscn") as PackedScene).instantiate()
			RelocateParticles.color = Color(0,0,0,0.3)
			RelocateParticles.amount = 100
			RelocateParticles.explosiveness = 0
			RelocateParticles.emission_sphere_radius = 30
			RelocateParticles.initial_velocity_min = -500
			RelocateParticles.initial_velocity_max = -100
			get_tree().current_scene.add_child(RelocateParticles)
			predictPos = Player.position + ((Player.input * Player.accel * global_position.distance_to(Player.position)) / (900))
			RelocateParticles.global_position = predictPos
			newAttackAction = false
		
		
	if actionTimer2 <= 0:
		actionTimer2 = 10000
		global_position = predictPos
		var RelocateParticles2 = (load("res://Scenes/ExplosionParticles.tscn") as PackedScene).instantiate()
		get_tree().current_scene.add_child(RelocateParticles2)
		RelocateParticles2.color = Color(1,0,1,1)
		RelocateParticles2.amount = 100
		RelocateParticles2.initial_velocity_min = 150
		RelocateParticles2.initial_velocity_max = 600
		RelocateParticles2.explosiveness = 1
		RelocateParticles2.lifetime = 1
		RelocateParticles2.global_position = predictPos
		
		for i in 12:
			var newBullet = Bullet.instantiate() as Node2D
			get_tree().current_scene.add_child(newBullet)
			newBullet.bulletGroup = 3
			newBullet.bulletType = 2
			newBullet.initPos = global_position
			newBullet.angle = angle
			newBullet.displace = (PI*i)/6
			newBullet.rotSpeed = 0
		
	if actionTimer2 > 60:
		BossPolygonOutline.color.a += 15 * delta
		BossPolygon.color.a += 15 * delta
			
	
	if actionTimer <= 0:
		actionTimer = 200
		speed = 800
		dashSlash = true
	
	if actionTimer >= 100 && actionTimer <= 170:
		var Slash = (load("res://Scenes/Slash.tscn") as PackedScene).instantiate()
		get_tree().current_scene.add_child(Slash)
		Slash.global_position = global_position
		Slash.rotation = rotation
		Slash.global_position += transform.x * 180
		actionTimer = 3000
	
	if dashSlash == true:
		velocity = transform.x * speed
		speed -= 850 * delta

	if attackTimer <= 0:
		currentComboAttack += 1
		attackTimer = 300
		actionTimer = 1000
		newAttack = true
		dashSlash = false
		velocity = Vector2(0,0)
	
	look_at(Player.position)
	timers(delta)

func Attack6(delta):
	if newAttack == true:
		attackTimer = 80
		actionTimer = 30
		speed = 0
		loop = 1
		newAttack = false
	
	look_at(Player.position)
	
	if actionTimer <= 0:
		spawnRotation = -45
		for i in 7:
			var newDagger = Dagger.instantiate() as Node2D
			get_tree().current_scene.add_child(newDagger)
			newDagger.bulletGroup = 3
			newDagger.bulletType = 1
			newDagger.speed = 450
			newDagger.global_position = global_position
			newDagger.look_at(Player.global_position)
			newDagger.spawnRotation = spawnRotation
			newDagger.rotate(deg_to_rad(newDagger.spawnRotation))
			spawnRotation += 15
			speed = 400
			actionTimer = 30
	
	if speed > 0:
		speed -= 600 * delta
	else:
		speed = 0
		
	velocity = transform.x * speed
	
	if attackTimer <= 0:
		currentComboAttack += 1
		attackTimer = 300
		newAttack = true
		actionTimer = 1000
	
	timers(delta)

func cooldown(delta):
	pass

func timers(delta):
	actionTimer -= 60 * delta
	actionTimer2 -= 60 * delta
	attackTimer -= 60 * delta
	animTimer -= 60 * delta
