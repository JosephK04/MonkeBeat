extends Node2D
@onready var proj := $ProjectileSprite
var velocity: Vector2 = Vector2.ZERO
var spawn_time: float

func _process(_delta):
	proj.position += velocity * _delta
	
	if proj.global_position.distance_to(get_viewport_rect().size / 2) < 5.0:
		destroyed()

func setup(spawn_x: float, spawn_y: float, dir: Vector2, rot: float):
	position = Vector2(spawn_x, spawn_y)
	velocity = dir * GameConfig.projectile_speed
	proj.rotation_degrees = rot
	proj.scale = Vector2(0.07, 0.2)
	spawn_time = Time.get_ticks_msec()

func destroyed():
	queue_free()
