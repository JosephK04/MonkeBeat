extends Control

var score: int = 0
var combo_count: int = 0
var max_combo: int = 0
var miss_count: int = -1

func _ready():
	Signals.IncrementScore.connect(IncrementScore)
	Signals.IncrementCombo.connect(IncrementCombo)
	Signals.ResetCombo.connect(ResetCombo)
	
	ResetCombo()
	%ComboLabel.text = "0x"
	
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
