extends Node2D
var hit_sounds = []
var audio_pool_size = 5
var drum_index = 0

func _ready():
	Signals.connect("pop_effect", Callable(self, "_on_play_sound"))
	var drum_sound = preload("res://sounds/soft-hitnormal.wav")
	for i in audio_pool_size: 
		var drum = AudioStreamPlayer.new()
		drum.volume_db = -20
		drum.stream = drum_sound
		add_child(drum)
		hit_sounds.append(drum)
		
func _on_play_sound(sound_name):
	match sound_name: 
		"drum":
			hit_sounds[drum_index].play()
			drum_index = (drum_index + 1) % audio_pool_size
		"miss":
			$miss_SFX.play()
		_:
			return
