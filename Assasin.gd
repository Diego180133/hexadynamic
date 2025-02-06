extends CharacterBody2D

@onready var HealthBar = $"../BossHealth"
@onready var Player = $"../Player"
@export var Bullet: PackedScene
@export var Health = 10000
var angle := 0.0
var attackAmount := 5
var currentComboAttack := 0
var actionTimer := 0.0
var attackTimer := 0.0
var animTimer := 0.0
var ComboString = []
var newAttack := true
var rotationStorage := 0.0

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

func comboBuild():
	ComboString = []
	currentComboAttack = 0
	attackAmount = RandomNumberGenerator.new().randi_range(4,6)
	for i in range(attackAmount):
		ComboString.append(RandomNumberGenerator.new().randi_range(1,3))
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
		attackTimer = 300
		actionTimer = 0
		newAttack = false
		
	look_at(Player.position)
	velocity = Vector2(0,0)
		
	if actionTimer <= 0:
		angle += PI / 24
		for i in 24:
			var newBullet = Bullet.instantiate() as Node2D
			get_tree().current_scene.add_child(newBullet)
			newBullet.bulletType = 2
			newBullet.initPos = global_position
			newBullet.angle = angle
			newBullet.displace = (PI*i)/12
			newBullet.rotSpeed = 0.25
				
				
			newBullet = Bullet.instantiate() as Node2D
			get_tree().current_scene.add_child(newBullet)
			newBullet.bulletType = 2
			newBullet.initPos = global_position
			newBullet.angle = angle
			newBullet.displace = (PI*i)/12
			newBullet.rotSpeed = -0.25
		actionTimer = 60
			
	if attackTimer <= 0:
		currentComboAttack += 1
		newAttack = true
		
	actionTimer -= 60 * delta
	attackTimer -= 60 * delta

func Attack2(delta):
	
	if newAttack == true:
		attackTimer = 300
		actionTimer = 0
		newAttack = false
	
	look_at(Player.position)
	velocity = transform.x*100
	
	if actionTimer <= 0:
		var newBullet = Bullet.instantiate() as Node2D
		get_tree().current_scene.add_child(newBullet)
		newBullet.bulletType = 3
		newBullet.velocity = Vector2(300,0)
		newBullet.global_position = global_position
		newBullet.look_at(Player.position)
		newBullet.timer = 1500
		
		actionTimer = 60
		
	if attackTimer <= 0:
		currentComboAttack += 1
		attackTimer = 300
		newAttack = true
	
	actionTimer -= 60 * delta
	attackTimer -= 60 * delta

func Attack3(delta):
	if newAttack == true:
		attackTimer = 180
		actionTimer = 120
		animTimer = 120
		rotationStorage = 0
		newAttack = false
		look_at(Player.position)
	

	velocity = Vector2(0,0)
	if animTimer > 60:
		look_at(Player.position)
	
	if animTimer > 0 && animTimer < 60:
		rotationStorage += deg_to_rad((360/60) * 60 * delta)
		look_at(Player.position)
		rotate(rotationStorage)
	
	if actionTimer <= 0:
		var newBullet = Bullet.instantiate() as Node2D
		get_tree().current_scene.add_child(newBullet)
		newBullet.bulletType = 1
		newBullet.global_position = global_position
		newBullet.speed = 2500
		newBullet.look_at(Player.position + ((Player.velocity * global_position.distance_to(Player.position)) / (newBullet.speed)))
		look_at(Player.position + ((Player.velocity * global_position.distance_to(Player.position)) / (newBullet.speed)))		
		actionTimer = 10000
		
	if attackTimer <= 0:
		currentComboAttack += 1
		attackTimer = 300
		newAttack = true
	
	actionTimer -= 60 * delta
	attackTimer -= 60 * delta
	animTimer -= 60 * delta

func cooldown(delta):
	pass
