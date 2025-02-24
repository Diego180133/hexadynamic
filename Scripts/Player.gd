extends CharacterBody2D

@onready var HealthBar = $"../PlayerHealth"
@onready var ENBar = $"../ENBar"

@export var Attack: PackedScene
@export var MaxHealth = 100
@export var energy = 400
@export var energyRegen = 45
@export var healthRegen = 3

var health = 0
var accel = 400
var MaxEnergy = 400
var MaxSpeed = 400
var input = Vector2(0,0)
var dashCooldown = 0
var attackCooldown = 0


func _ready():
	health = MaxHealth
	HealthBar.healthbar(health)
	ENBar.ENBar(energy)
	
func _physics_process(delta):
	PlayerMovement(delta)
	
func _process(delta):
	
	playerAttack(delta)
	_Health_Update()
	
	if energy < MaxEnergy:
		energy += (energyRegen * delta)
	ENBar.energy = energy
	
	if health < MaxHealth:
		health += (healthRegen * delta)
		
	
	
	if health <= 0:
		pass
	
func PlayerMovement(delta):
	if Input.is_action_pressed("Slow") and MaxSpeed <= 500:
		accel = 200
		MaxSpeed = 200
	elif Input.is_action_just_released("Slow"):
		accel = 400
		MaxSpeed = 400
	if Input.is_action_pressed("Direction_Right"):
		input.x = 1
	elif Input.is_action_pressed("Direction_Left"):
		input.x = -1
	else:
		input.x = 0
		
	if Input.is_action_pressed("Direction_Up"):
		input.y = -1
	elif Input.is_action_pressed("Direction_Down"):
		input.y = 1
	else:
		input.y = 0
		
	if Input.is_action_just_pressed("Dash") and energy >= 100:
		MaxSpeed = 3100
		velocity = MaxSpeed * input
		dashCooldown = 30
		energy -= 100
	
	if dashCooldown > 0:
		dashCooldown -= 60 * delta
	else:
		dashCooldown = 0
	
	if MaxSpeed > 400:
		MaxSpeed -= 300
	
	
	input = input.normalized()
	
	if input == Vector2(0,0):
			velocity = Vector2(0,0)
	else:
		velocity += (input * accel)
		velocity = velocity.limit_length(MaxSpeed)
	
	move_and_slide()

func playerAttack(delta):
	if Input.is_action_pressed("Attack") and (attackCooldown == 0):
		var newAttack = Attack.instantiate() as Node2D
		get_tree().current_scene.add_child(newAttack)
		newAttack.bulletGroup = 2
		newAttack.bulletType = 1
		newAttack.speed = 1000
		newAttack.global_position = global_position
		newAttack.look_at(get_global_mouse_position())
		attackCooldown = 10
	
	if attackCooldown > 0:
		attackCooldown -= 60 * delta
	else:
		attackCooldown = 0

func _Health_Update():
	HealthBar.health = health
	
	
