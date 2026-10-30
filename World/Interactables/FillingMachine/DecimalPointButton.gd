extends IButton

func _press_button() -> void:
	if GameStats.amount == "":
		GameStats.amount += "0."
	else:
		GameStats.amount += "."
	print(GameStats.amount)
