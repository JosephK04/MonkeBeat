extends Node2D
var offset_adjust = GameConfig.audio_offset

func _ready(): 
	$DimSlider.value = GameConfig.background_dim
	offset_adjust = GameConfig.audio_offset * 1000
	$OffsetNumber.text = "[center]" + str(offset_adjust) + "ms"
	
func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/levels/main_menu.tscn")


func _on_offset_plus_pressed() -> void:
	offset_adjust += 5
	$OffsetNumber.text = "[center]" + str(offset_adjust) + "ms"
	GameConfig.audio_offset = offset_adjust / 1000.0

func _on_offset_plus_2_pressed() -> void:
	offset_adjust += 1
	$OffsetNumber.text = "[center]" + str(offset_adjust) + "ms"
	GameConfig.audio_offset = offset_adjust / 1000.0

func _on_offset_minus_pressed() -> void:
	offset_adjust -= 5
	$OffsetNumber.text = "[center]" + str(offset_adjust) + "ms"
	GameConfig.audio_offset = offset_adjust / 1000.0

func _on_offset_minus_2_pressed() -> void:
	offset_adjust -= 1
	$OffsetNumber.text = "[center]" + str(offset_adjust) + "ms"
	GameConfig.audio_offset = offset_adjust / 1000.0


func _on_h_slider_value_changed(value: float) -> void:
	GameConfig.background_dim = $DimSlider.value 
