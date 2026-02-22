extends Node2D
@onready var music_player = $MusicPlayer
@onready var projectile := preload("res://src/objects/projectile.tscn")
@onready var viewport_size = get_parent().get_viewport_rect().size
var parent: Node2D
var in_edit_mode: bool
var current_level_name = "CrescentExpressway"
var recording = []
var notes_remaining = 0
var notes = []
var TRAVEL_TIME = GameConfig.get_travel_time()
var active_hit_times = []
var fading = false
var last_note_time := 0.0

func _ready():
	in_edit_mode = GameConfig.edit_mode
	parent = get_parent()
	Signals.connect("create_projectile", Callable(self, "_on_create_projectile"))
	music_player.stream = GameConfig.get_music(current_level_name)
	start_music()
	
	if in_edit_mode:
		return
	else:
		var loaded_notes = GameConfig.load_beatmap(GameConfig.current_level_name)
		start_level(loaded_notes)

func _process(_delta):
	if in_edit_mode:
		if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("click2"):
			var hit_time = music_player.get_playback_position()
			recording.append({
				"time": hit_time,
				"direction": parent.player.facing
			})
		return
	
	var song_time = music_player.get_playback_position() + AudioServer.get_time_since_last_mix() - GameConfig.audio_offset
	
	while notes.size() > 0:
		var note = notes[0]
		var spawn_time = note.time - TRAVEL_TIME
		if spawn_time <= song_time:
			var late_by = song_time - spawn_time
			spawn_projectile(note, late_by)
			notes.pop_front()
			notes_remaining -= 1
		else:
			break
	
	if not fading and notes.size() == 0 and song_time > last_note_time + TRAVEL_TIME:
		fading = true
		fade_out_music()	

func start_music():
	var wait_time = 2.0
	await get_tree().create_timer(wait_time).timeout
	music_player.play()

func fade_out_music():
	get_parent().get_node("GameUI").save_results()
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -40, 3.0)
	tween.tween_callback(func(): music_player.stop())
	get_parent().fade_transition()
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://src/levels/result_screen.tscn")
	
func start_level(loaded_notes: Array):
	var baked_delay = 0.04
	notes = loaded_notes
	for note in notes:
		note.time -= baked_delay
		note.direction = int(note.direction)
	notes_remaining = notes.size()
	
	if notes.size() > 0:
		last_note_time = notes[-1].time

func spawn_projectile(note: Dictionary, late_by):
	var proj = CreateProjectile(note.direction)
	active_hit_times.append({
		"time": note.time,
		"direction": note.direction,
		"proj": proj
	})
	
	if late_by > 0.0:
		proj.position += proj.velocity * late_by

func CreateProjectile(spawn_dir: int):
	var dir: Vector2
	var proj_inst = projectile.instantiate()
	get_parent().add_child(proj_inst)
	
	if spawn_dir == GameConfig.direction.UP:
		dir = Vector2.DOWN
		proj_inst.setup(viewport_size.x/2, 0, dir, 0)
	elif spawn_dir == GameConfig.direction.DOWN:
		dir = Vector2.UP
		proj_inst.setup(viewport_size.x/2, viewport_size.y, dir, 0)
	elif spawn_dir == GameConfig.direction.LEFT:
		dir = Vector2.RIGHT
		proj_inst.setup(420, viewport_size.y/2, dir, 90)
	elif spawn_dir == GameConfig.direction.RIGHT:
		dir = Vector2.LEFT
		proj_inst.setup(1500, viewport_size.y/2, dir, 90)
	
	return proj_inst

func _on_create_projectile():
	CreateProjectile(parent.player.facing)

func _input(_event):
	if in_edit_mode:
		if Input.is_action_just_pressed("save"):
			GameConfig.save_beatmap(GameConfig.current_level_name, recording)
