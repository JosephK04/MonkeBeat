extends Node2D
		
func _on_start_pressed() -> void:
	GameConfig.edit_mode = false
	get_tree().change_scene_to_file("res://src/levels/game_level.tscn")


func _on_edit_pressed() -> void:
	GameConfig.edit_mode = true
	get_tree().change_scene_to_file("res://src/levels/game_level.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://src/levels/settings_screen.tscn")
