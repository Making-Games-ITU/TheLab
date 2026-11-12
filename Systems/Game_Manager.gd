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

func _set_danger_level() -> void:
	progress()
	
	var danger = GameStats.danger_level
	
	match _progression_level:
		0: #Control (Healthy)
			danger = 0
		1: #Parasites 
			danger = 0
			danger += GameStats.body_state - 3
		2: #Mutation 
			danger = 1
			danger += GameStats.body_state - 3
		3: #Both 
			danger = 2
			danger += GameStats.body_state - 3
		_: #Add new stages here
			danger = 0
	
	GameStats.danger_level = danger
	#TODO: Set audio param to danger level here. 

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
		1: #Parasites 
			GameStats.body_state = 3 # neutral
		2: #Mutation 
			GameStats.body_state = 3 # neutral
		3: #Both 
			GameStats.body_state = 3 # neutral
		_: #Add new stages here
			GameStats.body_state = 3 # neutral

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
	if GameStats.body_state == 1:
		print("Already cured")
		return
	
	# Vial is damaged = bad
	if VialStats.damaged:
		GameStats.body_state += 1
		_check_game_over()
		return
		
	var no_chemicals = true
		
	# Check for chemicals and if integrated
	for key in VialStats.chemicals:
		if VialStats.chemicals[key].quantity > 0.0:
			no_chemicals = false
			if not VialStats.chemicals[key].integrated:
				GameStats.body_state += 1
				_check_game_over()
				return
	
	if no_chemicals:
		return
	
	match VialStats.infection:
		1: #Mutation
			_check_wrong_chemical(VialStats.Composite.HYDROGEN)
			print("check hydrogen")
		2: #Parasites
			_check_wrong_chemical(VialStats.Composite.NITROGEN)
			print("check nitroggen")
		3: #both
			if VialStats.chemicals[VialStats.Composite.NITROGEN].quantity <= 0.0:
				VialStats.infection =  VialStats.InfectionType.CELL_MUTATION
			elif VialStats.chemicals[VialStats.Composite.HYDROGEN].quantity <= 0.0:
				VialStats.infection =  VialStats.InfectionType.PARASITES
			else:
				GameStats.body_state = 1
		0:
			#TODO: What should happen if no blood in vial? 
			print("Missing blood in vial")
		_: 
			print("Something went wrong")
			
	print(GameStats.body_state)
	_check_if_cured()

func _check_if_cured() -> void:
	_set_danger_level()
	if GameStats.body_state == 1:
		GameStats.cured += 1

func _check_wrong_chemical(chemical : VialStats.Composite) -> void:
	if VialStats.chemicals[chemical].quantity > 0.0:
		GameStats.body_state += 1
		_check_game_over()
	else:
		GameStats.body_state = 1

func _check_game_over() -> void:
	print(GameStats.body_state)
	_set_danger_level()
	if GameStats.body_state == 6:
		%GameOverScreen.visible = true
		await get_tree().create_timer(2.0).timeout
		get_tree().quit()
