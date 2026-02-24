extends Node

signal create_projectile
signal tapped
signal released
signal pop_effect(sound_name)
signal miss

signal IncrementScore(incr: int)
signal IncrementCombo()
signal ResetCombo()

signal note_judged(accuracy)
