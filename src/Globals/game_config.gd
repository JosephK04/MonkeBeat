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
var result_accuracy = 0.0
var grade = ""
var perfect_count = 0
var great_count = 0
var ok_count = 0

#scores
const BASE_PERFECT_WINDOW = 0.06
const BASE_GREAT_WINDOW = 0.1
const BASE_OK_WINDOW = 0.14
const BASE_MISS_WINDOW = 0.28

var audio_offset = 0

var background_dim = 0.5

func result_grade():
	if result_accuracy == 100: 
		grade = "[color=silver] SS [/color]"
	elif result_miss == 0 and result_accuracy >= 90:
		grade = "[color=gold] S [/color]"
	elif result_accuracy >= 90: 
		grade = "[color=green] A [/color]"
	elif result_accuracy >= 80:
		grade = "[color=yellow] B [/color]"
	elif result_accuracy >= 70:
		grade = "[color=blue] C [/color]"
	elif result_accuracy >= 60:
		grade = "[color=red] D [/color]"
	else:
		grade = "[color=red] F [/color]"
		
	return grade
	
#Parsing Storing logic for Maps
var current_level_name = "CrescentExpressway"

var level_info = {
	"CrescentExpressway": {
		"display_name": "Crescent Expressway"
	}
}
	
func get_notes_path(level_name: String) -> String:
	var filename = level_name
	var user_path = "user://beatmaps/" + filename
	var res_path = "res://beatmaps/" + filename
	
	if FileAccess.file_exists(user_path):
		return user_path
	else:
		return res_path

func save_beatmap(level_name: String, notes: Array):
	var filename = level_name
	var dir_path = "user://beatmaps/" + filename
	
	if not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_absolute(dir_path)
	
	var path = dir_path + "/" + level_name + ".json" #path PLUS DIFFICULTY LATER
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(notes))
	file.close()
	print("Saved to: ", path)
	
func load_beatmap(level_name: String) -> Array: #difficulty as parameter later
	var path = get_notes_path(level_name)#+ difficulty
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var filename = dir.get_next()
	while filename != "":
		if filename.get_extension() in ["json"]:
			var file = FileAccess.open(path + "/" + filename, FileAccess.READ)
			var data = JSON.parse_string(file.get_as_text())
			file.close()
			return data
		filename = dir.get_next()
	return []
	
	
func get_music(level_name): 
	var path = get_notes_path(level_name)
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var filename = dir.get_next()
	while filename != "":
		if filename.get_extension() in ["ogg", "mp3", "wav"]:
			return load(path + "/" + filename)
		filename = dir.get_next()
	return null

#ratios 
func get_travel_time():
	return BASE_TRAVEL_TIME * ratio
	
func get_perfect_window():
	return BASE_PERFECT_WINDOW * (BASE_SPEED / projectile_speed)

func get_great_window():
	return BASE_GREAT_WINDOW * (BASE_SPEED / projectile_speed)

func get_ok_window():
	return BASE_OK_WINDOW * (BASE_SPEED / projectile_speed)
	
func get_miss_window():
	return BASE_MISS_WINDOW * (BASE_SPEED / projectile_speed)

func _ready(): 
	Signals.JudgeCount.connect(JudgeCount)
	
func JudgeCount(type):
	match type: 
		"perfect":
			perfect_count += 1
		"great":
			great_count += 1
		"ok":
			ok_count += 1
