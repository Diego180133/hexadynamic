extends Area2D

var iFrames = 0
@onready var PlayerInside = $"../PlayerBorder/PlayerInside"
@onready var Hitbox = $"../HitboxSprite"
var flashing = false
var flashOpacity := 0.0
func _ready():
	area_entered.connect(_area_entered)
	
func _process(delta):
	if iFrames > 0:
		iFrames -= (60 * delta)
	else:
		iFrames = 0
		
	if flashing == true:
		PlayerInside.material.set_shader_parameter("flash_opacity", flashOpacity)
		flashOpacity -= delta
		if flashOpacity <= 0:
			flashing = false
			flashOpacity = 0
	
func _area_entered(area):
	if area.is_in_group("boss") and (iFrames == 0):
		_boss_damage()
		_flash()
		iFrames = 60
		
	if area.is_in_group("enemyProjectile"):
		if (iFrames == 0):
			_bullet_damage()
			iFrames = 60
			_flash()
		area.queue_free()

func _boss_damage():
	get_parent().health -= 50
	
func _bullet_damage():
	get_parent().health -= 35
	
func _flash():
	flashing = true
	flashOpacity = 0.7
	PlayerInside.material.set_shader_parameter("flash_opacity", flashOpacity)
