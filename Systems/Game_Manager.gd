extends Node

@export var next_timer: float =  1.0

var _clear_timer : Timer

func _ready() -> void:
	_clear_timer = Timer.new()
	_clear_timer.one_shot = true
	add_child(_clear_timer)
	_clear_timer.start(next_timer)

func get_blood_type(progress : int) -> void:
	match progress:
		0:
			VialStats.infection = VialStats.InfectionType.NONE
		_:
			VialStats.infection = VialStats.InfectionType.CELL_MUTATION

func check_if_successful() -> void:
	# Body state already at minimum but keep trying = bad
	if GameStats.body_state == 1:
		GameStats.body_state += 1
		_check_game_over()
		return
	# Vial is damaged = bad
	if VialStats.damaged:
		GameStats.body_state += 1
		_check_game_over()
		return
	# Chemical in vial but not integrated = bad
	for key in VialStats.chemicals:
		if VialStats.chemicals[key].quantity > 0.0:
			if not VialStats.chemicals[key].integrated:
				GameStats.body_state += 1
				_check_game_over()
				return
	# If vial has the wrong chemical in it = bad
	if VialStats.infection == VialStats.InfectionType.CELL_MUTATION:
		for key in VialStats.chemicals:
			if VialStats.chemicals[key].quantity > 0.0:
				if key != VialStats.Composite.HYDROGEN:
					GameStats.body_state += 1
					_check_game_over()
					return
	# If no chemical is present
	var no_chemicals = true
	for key in VialStats.chemicals:
		if VialStats.chemicals[key].quantity != 0.0:
			no_chemicals = false
	if no_chemicals:
		return
	GameStats.body_state -= 1

func _check_game_over() -> void:
	if GameStats.body_state == 6:
		%GameOverScreen.visible = true
		await get_tree().create_timer(2.0).timeout
		get_tree().quit()
