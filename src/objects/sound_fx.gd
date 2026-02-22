extends Node2D

func _ready():
	
	Signals.connect("pop_effect", Callable(self, "_on_play_sound"))
	
func _on_play_sound(sound_name):
	match sound_name: 
		"drum":
			$pop1_SFX.play()
		"miss":
			$miss_SFX.play()
		_:
			return
