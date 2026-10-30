extends IButton

func _press_button() -> void:
	if VialStats.Speed.find_key(GameStats.mixer_speed + 1) != null:
		GameStats.mixer_speed += 1
		print(GameStats.mixer_speed )
