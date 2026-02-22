extends Control

func _ready():
	
	var tween = create_tween()
	tween.tween_property($FadeRect, "color:a", 0.0, 1.0)	
	
	$ScoreCount.text = "Score: " + str(GameConfig.result_score)
	$MaxComboCount.text = "Max Combo: [color=green]" + str(GameConfig.result_max_combo) + "[/color]"
	$MissCount.text = "Misses: [color=red]" + str(GameConfig.result_miss) + "[/color]"
	$Percentage.text = "Accuracy: " + str("%.2f" % GameConfig.result_accuracy)
	$GradeLetter.text = GameConfig.grade
	
func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/levels/game_level.tscn")


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/levels/main_menu.tscn")
