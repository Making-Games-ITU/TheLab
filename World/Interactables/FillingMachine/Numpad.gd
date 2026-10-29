extends IButton


@export var number : String
 
# Called when the node enters the scene tree for the first time.
func _press_button() -> void:
	if GameStats.amount.is_empty() and number == "0":
		pass
	else:
		GameStats.amount += number
		print(GameStats.amount)
