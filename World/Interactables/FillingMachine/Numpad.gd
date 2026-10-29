extends IButton


@export var number : int
 
# Called when the node enters the scene tree for the first time.
func _press_button() -> void:
	GameStats.amount.append(number)	
	print(GameStats.amount)
