extends Control

#perfect 00f1ff
#great 00f100
#ok fff100
#miss ff0000

func SetTextInfo(text: String):
	$ScoreText.text = "[center]" + text
	
	match text:
		"PERFECT":
			$ScoreText.set("theme_override_colors/default_color", Color("00f1ff"))
		"GREAT":
			$ScoreText.set("theme_override_colors/default_color", Color("00f100"))
		"OK":
			$ScoreText.set("theme_override_colors/default_color", Color("fff100"))
		"MISS":
			$ScoreText.set("theme_override_colors/default_color", Color("ff0000"))
