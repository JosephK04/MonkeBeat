extends Node2D
@onready var proj := $ProjectileSprite
var velocity: Vector2 = Vector2.ZERO
var spawn_time: float
var passed := false

func _process(_delta):
	proj.position += velocity * _delta
	
	var center = get_viewport_rect().size / 2
	
	if not passed:
		if velocity.y < 0 and proj.global_position.y <= center.y:
			passed = true
		elif velocity.y > 0 and proj.global_position.y >= center.y:
			passed = true
		elif velocity.x < 0 and proj.global_position.x <= center.x:
			passed = true
		elif velocity.x > 0 and proj.global_position.x >= center.x:
			passed = true
			
	if passed:
		destroyed()

func setup(spawn_x: float, spawn_y: float, dir: Vector2, rot: float):
	position = Vector2(spawn_x, spawn_y)
	velocity = dir * GameConfig.projectile_speed
	proj.rotation_degrees = rot
	proj.scale = Vector2(0.07, 0.2)
	spawn_time = Time.get_ticks_msec()

func destroyed():
	queue_free()
