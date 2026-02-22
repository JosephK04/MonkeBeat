extends Node

enum direction { UP, DOWN, LEFT, RIGHT}

var edit_mode = false

var BASE_SPEED = 750.0

var projectile_speed = 900.0

const BASE_TRAVEL_TIME = 0.66

var ratio = (BASE_SPEED / projectile_speed)

var result_score = 0
var result_max_combo = 0
var result_miss = 0

#scores
const BASE_PERFECT_WINDOW = 0.05
const BASE_GREAT_WINDOW = 0.09
const BASE_OK_WINDOW = 0.13

#Parsing Storing logic for Maps
var current_level_name = "CrescentExpressway"

var audio_offset = 0

var level_info = {
	"CrescentExpressway": {
		"notes_path": "CrescentExpressway.json",
		"music": "res://music/crescent_expressway.ogg",
		"display_name": "Crescent Expressway"
	}
}

func get_notes_path(level_name: String) -> String:
	var filename = level_info[level_name]["notes_path"]
	var user_path = "user://beatmaps/" + filename
	var res_path = "res://beatmaps/" + filename
	
	if FileAccess.file_exists(user_path):
		return user_path
	else:
		return res_path

func save_beatmap(level_name: String, notes: Array):
	var filename = level_info[level_name]["notes_path"]
	var dir_path = "user://beatmaps"
	
	if not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_absolute(dir_path)
		
	var file = FileAccess.open(dir_path + "/" + filename, FileAccess.WRITE)
	file.store_string(JSON.stringify(notes))
	file.close()
	print("Saved to: ", dir_path + "/" + filename)
	
func load_beatmap(level_name: String) -> Array:
	var path = get_notes_path(level_name)
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		return data
	return []
	
func get_music(level_name): 
	return load(level_info[level_name]["music"])

#ratios 
func get_travel_time():
	return BASE_TRAVEL_TIME * ratio
	
func get_perfect_window():
	return BASE_PERFECT_WINDOW * (BASE_SPEED / projectile_speed)

func get_great_window():
	return BASE_GREAT_WINDOW * (BASE_SPEED / projectile_speed)

func get_ok_window():
	return BASE_OK_WINDOW * (BASE_SPEED / projectile_speed)
	
