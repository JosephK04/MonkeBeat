extends Node2D

@onready var player_sprite = preload("res://src/objects/player.tscn")
@onready var viewport_size = get_viewport_rect().size

var player: Node2D
var current_tween: Tween

func _ready():
	player = player_sprite.instantiate()
	player.z_index = 5
	add_child(player)
	player.position = viewport_size / 2
	player.scale = Vector2(0.5, 0.5)
	Signals.connect("tapped", Callable(self, "_on_tapped"))
	Signals.connect("released", Callable(self, "_on_released"))
	Signals.connect("miss", Callable(self, "_on_miss"))
	$Background.modulate = Color(1.0 - GameConfig.background_dim, 1.0 - GameConfig.background_dim, 1.0 - GameConfig.background_dim, 1.0)
	
func _process(_delta):
	pass
	
func _draw(): 
	draw_rect(Rect2(425, 5, 1070, 1070), Color.WHITE, false, 10)
	draw_rect(Rect2(300, 0, 120, 1080), Color.BLACK)
	draw_rect(Rect2(1500, 0, 120, 1080), Color.BLACK)
	

func flash(color: Color, duration: float):
	if current_tween:
		current_tween.kill()
	player.modulate = color
	current_tween = create_tween()
	current_tween.tween_interval(duration)
	current_tween.tween_callback(func(): player.modulate = Color.WHITE)
	
func _on_tapped():
	player.modulate = Color.LIGHT_BLUE

func _on_released():
	player.modulate = Color.WHITE
	
func _on_miss():
	flash(Color.RED, 0.1)
	Signals.emit_signal("pop_effect", "miss")

func fade_transition():
	
	var tween = create_tween()
	tween.tween_property($CanvasLayer/FadeRect, "color:a", 1.0, 1.5)
	await tween.finished
