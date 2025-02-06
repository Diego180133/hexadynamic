extends Area2D

var iFrames = 0

func _ready():
	area_entered.connect(_area_entered)
	
func _process(delta):
	if iFrames > 0:
		iFrames -= (60 * delta)
	else:
		iFrames = 0

func _area_entered(area):
	if area.is_in_group("boss") and (iFrames == 0):
		_boss_damage()
		iFrames = 60
	if area.is_in_group("enemyProjectile"):
		if (iFrames == 0):
			_bullet_damage()
			iFrames = 60
		area.queue_free()

func _boss_damage():
	get_parent().health -= 50
	
func _bullet_damage():
	get_parent().health -= 35
