extends CanvasLayer

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	visible = !visible
	get_tree().paused = !get_tree().paused
	
func _on_resume_button_pressed() -> void:
	toggle_pause()
	get_tree().paused = false


func _on_restart_button_pressed() -> void:
	toggle_pause()
	get_tree().reload_current_scene()

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/levels/main_menu.tscn")
