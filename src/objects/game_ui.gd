extends Control

var score: int = 0
var combo_count: int = 0
var max_combo: int = 0
var miss_count: int = -1
var notes_passed: int = 0
var total_score: int = 0

func _ready():
	Signals.IncrementScore.connect(IncrementScore)
	Signals.IncrementCombo.connect(IncrementCombo)
	Signals.ResetCombo.connect(ResetCombo)
	Signals.connect("note_judged", Callable(self, "_on_note_judged"))
	ResetCombo()
	%ComboLabel.text = "0x"

func _on_note_judged(accuracy):
	match accuracy:
		"perfect":
			total_score += 100.0
		"great":
			total_score += 75.0
		"ok":
			total_score += 25.0
		"miss":
			pass
	notes_passed += 1
	
	var percentage = total_score / (notes_passed * 100.0) * 100.0
	GameConfig.result_accuracy = percentage
	%AccuracyLabel.text = "%.2f" % percentage + "%"

func IncrementScore(incr: int):
	score += incr
	%ScoreLabel.text = " " + str(score) + " pts"
	
func IncrementCombo():
	combo_count += 1
	if combo_count > max_combo:
		max_combo = combo_count
	%ComboLabel.text = " " + str(combo_count) + "x"
	$CanvasLayer/AnimationPlayer.play("points")
	
func ResetCombo():
	miss_count += 1
	combo_count = 0
	%ComboLabel.text = ""
	
func save_results(): 
	GameConfig.result_score = score
	GameConfig.result_max_combo = max_combo
	GameConfig.result_miss = miss_count
