extends Area2D

var flashing = false
var flashOpacity = 0.0
@onready var BossPolygon = $"../Polygon2DOutline/Polygon2D"
@onready var Boss = $".."
var damage = 0
var collided_with_wall = false

func _ready():
	area_entered.connect(_area_entered)

func _area_entered(area):
	if area.is_in_group("playerProjectile"):
		area.queue_free()
		damage = area.damage
		_attack_damage()
		_flash()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flashing == true:
		BossPolygon.material.set_shader_parameter("flash_opacity", flashOpacity)
		flashOpacity -= delta
		if flashOpacity <= 0:
			flashing = false
			flashOpacity = 0
	
	if collided_with_wall == true:
		Boss.set_collision_mask_value(2,false)
		Boss.set_collision_layer_value(2,false)
	else:
		Boss.set_collision_mask_value(2,true)
		Boss.set_collision_layer_value(2,true)
	
func _attack_damage():
	get_parent().Health -= damage
	get_parent()._Health_Update()

func _flash():
	flashing = true
	flashOpacity = 0.4
	BossPolygon.material.set_shader_parameter("flash_opacity", flashOpacity)
