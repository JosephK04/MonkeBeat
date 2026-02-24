extends Node2D

var facing = GameConfig.direction.DOWN

func _ready():
	pass
	
func _process(_delta):
	pass

func _input(_event):
	
	if Input.is_action_just_pressed("face_up"):
		$PlayerSprite.rotation_degrees = 180
		facing = GameConfig.direction.UP
		
	if Input.is_action_just_pressed("face_down"):
		$PlayerSprite.rotation_degrees = 0
		facing = GameConfig.direction.DOWN
	
	if Input.is_action_just_pressed("face_left"):
		$PlayerSprite.rotation_degrees = 90
		facing = GameConfig.direction.LEFT
	
	if Input.is_action_just_pressed("face_right"):
		$PlayerSprite.rotation_degrees = -90
		facing = GameConfig.direction.RIGHT
	
	if (Input.is_action_just_pressed("click") or Input.is_action_just_pressed("click2")):
		Signals.emit_signal("tapped")
	
	if Input.is_action_just_released("click") and not Input.is_action_pressed("click2"):
		Signals.emit_signal("released")
	if Input.is_action_just_released("click2") and not Input.is_action_pressed("click"):
		Signals.emit_signal("released")
		
		
