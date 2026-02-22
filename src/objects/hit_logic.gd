extends Node2D
@onready var score_text = preload("res://src/objects/score_press_text.tscn")

var music_player
var player

var perfect_window = GameConfig.get_perfect_window()
var great_window = GameConfig.get_great_window()
var ok_window = GameConfig.get_ok_window()
var perfect_score = 100
var great_score = 75
var ok_score = 25

var note_array

func _ready():
	await get_tree().process_frame
	player = get_parent().player
	note_array = get_parent().get_node("LevelEditor").active_hit_times
	music_player = get_parent().get_node("LevelEditor/MusicPlayer")
	Signals.connect("tapped", Callable(self, "_on_tapped"))

func _process(_delta):
	if note_array.size() > 0:
		var current_time = music_player.get_playback_position() + AudioServer.get_time_since_last_mix() - GameConfig.audio_offset
		if current_time > note_array[0].time + ok_window:
			note_array.pop_front()
			Signals.emit_signal("miss")
			Signals.ResetCombo.emit()
			Signals.emit_signal("note_judged", "miss")
			var press_score_text = "MISS"
			var timing_text = score_text.instantiate()
			add_child(timing_text)
			timing_text.global_position = Vector2(0, 100)
			timing_text.SetTextInfo(press_score_text)
			
func _on_tapped():
	var tapped_time = music_player.get_playback_position() + AudioServer.get_time_since_last_mix() - GameConfig.audio_offset
	
	if note_array.size() == 0:
		return
	
	var diff = abs(tapped_time - note_array[0].time)
	
	if int(player.facing) != int(note_array[0].direction):
		if diff <= ok_window:
			note_array.pop_front()
			Signals.emit_signal("miss")
			Signals.ResetCombo.emit()
			Signals.emit_signal("note_judged", "miss")
			var press_score_text = "miss"
			var timing_text = score_text.instantiate()
			add_child(timing_text)
			timing_text.global_position = Vector2(0, 100)
			timing_text.SetTextInfo(press_score_text)
			
		return
	
	var score = 0
	var press_score_text = ""
	
	if diff <= perfect_window:
		score = perfect_score
		press_score_text = "PERFECT"
		Signals.emit_signal("note_judged", "perfect")
	elif diff <= great_window:
		score = great_score
		press_score_text = "GREAT"
		Signals.emit_signal("note_judged", "great")
	elif diff <= ok_window:
		score = ok_score
		press_score_text = "OK"
		Signals.emit_signal("note_judged", "ok")
	else:
		return
	
	pop_animation(note_array[0].proj)
	note_array.pop_front()
	Signals.emit_signal("pop_effect", "drum")
	Signals.IncrementScore.emit(score)
	Signals.IncrementCombo.emit()
		
	var timing_text = score_text.instantiate()
	add_child(timing_text)
	timing_text.global_position = Vector2(0, 100)
	timing_text.SetTextInfo(press_score_text)

func pop_animation(proj):
	var tween = create_tween()
	tween.tween_property(proj, "modulate:a", 0.0, 0.02)
