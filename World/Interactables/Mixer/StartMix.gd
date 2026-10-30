extends IButton

func _press_button() -> void:
	if GameStats.vial_in_mixer:
		for key in VialStats.chemicals:
			VialStats.integrate_chemical(key, GameStats.mixer_speed)
			print(VialStats.is_integrated(key))
