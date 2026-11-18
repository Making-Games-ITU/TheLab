extends Horror_Event

@export var horror_sound_emitter : FmodEventEmitter3D
@export var area = Area3D

var distance : float

func _ready() -> void:
	GameManager.progression_update.connect(func(): 
		if GameStats.progression_level >= 0:
			start_event()
			print("event started in vents")
		)

func _player_enter(interactor :  Node) -> void:
	if interactor is Player:
		print("INININ")
		stop_event()

func _player_exit(interactor :  Node) -> void:
	if interactor is Player:
		print("outouta")
		


func start_event():
	var rng = RandomNumberGenerator.new()
	var number = rng.randi_range(2,4)
	var idint = id.to_int()
	
	if idint == number:
		print("vent: ",number)
		area.body_entered.connect(_player_enter)
		area.body_exited.connect(_player_exit)
		horror_sound_emitter.play()

func stop_event():
	area.body_entered.disconnect(_player_enter)
	area.body_exited.disconnect(_player_exit)
	horror_sound_emitter.stop()
