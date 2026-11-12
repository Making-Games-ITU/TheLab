extends Node

@export var next_timer: float =  1.0

var _clear_timer : Timer
var _progression_level = GameStats.progression_level
var _cured = GameStats.cured

func _ready() -> void:
	progress()
	#_clear_timer = Timer.new()
	#_clear_timer.one_shot = true
	#add_child(_clear_timer)
	#_clear_timer.start(next_timer)

#short-hand for updating progression level
func progress() -> void:
	_progression_level = GameStats.progression_level
	_cured = GameStats.cured

func check_danger_level() -> void:
	var danger = GameStats.danger_level


#Add a infection type for a given progression level here
func get_infection_type() -> void:
	progress()
	match _progression_level:
		0:
			VialStats.infection = VialStats.InfectionType.NONE
		1:
			VialStats.infection = VialStats.InfectionType.PARASITES
		2:
			VialStats.infection = VialStats.InfectionType.CELL_MUTATION
		3:
			VialStats.infection = VialStats.InfectionType.BOTH
		_:  #Add new stages here
			VialStats.infection = VialStats.InfectionType.BOTH

#Add a body state for a given progression level here
func get_body_state() -> void:
	progress()
	match _progression_level:
		0: #Control (Healthy)
			GameStats.body_state = 1 # cured
			GameStats.cured += 1
			GameStats.danger_level = _progression_level
		1: #Parasites 
			GameStats.body_state = 3 # neutral
			GameStats.danger_level = 0
		2: #Mutation 
			GameStats.body_state = 3 # neutral
			GameStats.danger_level = 1
		3: #Both 
			GameStats.body_state = 3 # neutral
			GameStats.danger_level = 2	
		_: #Add new stages here
			GameStats.body_state = 3 # neutral
			GameStats.danger_level = _progression_level

func update_progression_level() -> void:
	progress()
	#progression currently matches the amount of cured bodies. Will only progress if the player succesfully cures a body (or later maybe X bodies)
	match _cured:
		1:
			GameStats.progression_level = 1
			print("Level: 1 (Parasites)")
		2:
			GameStats.progression_level = 2
			print("Level: 2 (Mutation)")
		3:
			GameStats.progression_level = 3
			print("Level: 3 (Parasites & Mutation)")
		4:
			#reset for playtest
			GameStats.progression_level = 0
			GameStats.cured = 0
			print("Level: 0 (healthy)")


func check_if_successful() -> void:
	print(GameStats.body_state)
	# Body state already at minimum but keep trying = bad
	if GameStats.body_state == 1:
		print("Already cured")
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
