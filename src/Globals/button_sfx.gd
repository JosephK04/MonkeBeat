extends Node

var hover_sound = preload("res://sounds/menuclick.wav")
var click_sound = preload("res://sounds/menuhit.wav")
var player: AudioStreamPlayer


func _ready(): 
	player = AudioStreamPlayer.new()
	player.volume_db = -8
	add_child(player)
	get_tree().node_added.connect(_on_node_added)
	connect_existing_buttons(get_tree().root)
	
func connect_existing_buttons(node):
	for child in node.get_children():
		if child is BaseButton:
			_on_node_added(child)
		connect_existing_buttons(child)

func _on_node_added(node):
	if node is BaseButton:
		node.pivot_offset = node.size / 2 #centering scaling
		var original_scale = node.scale
		node.mouse_entered.connect(func(): 
			play(hover_sound)
			var tween = node.create_tween()
			tween.tween_property(node, "scale", original_scale * 1.05, 0.1)
		)
		node.mouse_exited.connect(func():
			var tween = node.create_tween()
			tween.tween_property(node, "scale", original_scale, 0.1)
		)
		if not node.is_in_group("noclicksound"):
			node.pressed.connect(func(): play(click_sound))
	
func play(sound):
	player.stream = sound
	player.play()
