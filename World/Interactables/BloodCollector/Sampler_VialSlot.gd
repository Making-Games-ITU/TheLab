extends Interactable

@export var take_vial_sound: FmodEventEmitter3D
@export var uninteractable_sound: FmodEventEmitter3D
@onready var sample_collector_vial: Node3D = %SampleCollectorVialModel

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.vial_in_collector:
		if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
			prompt_text = "Take vial"
		else:
			prompt_text = "Hands are full"
	elif PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
		prompt_text = "Insert vial"
	else:
		prompt_text = "No vial to insert"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.vial_in_collector:
		if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
			_take_vial()
		else:
			_uninteractable()
	elif PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
		_insert_vial()
	else:
		_uninteractable()

func _insert_vial():
	GameStats.vial_in_collector = true
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	sample_collector_vial.visible = true
	AudioManager.one_shot(sound_emitter)
	_update_prompt()
	print("Vial inserted")

func _take_vial():
	GameStats.vial_in_collector = false
	PlayerStats.is_holding = PlayerStats.HoldState.VIAL
	sample_collector_vial.visible = false
	AudioManager.one_shot(take_vial_sound)
	_update_prompt()
	print("Picked up Vial")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No vial to insert or wrong object in hand")
