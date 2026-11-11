extends Interactable

@export var chemical_name: String
@export var composite: VialStats.Composite
@export var placeback_sound: FmodEventEmitter3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
		prompt_text = "Take " + chemical_name
	elif PlayerStats.is_holding == PlayerStats.HoldState.CHEMICAL:
		prompt_text = "Place flask back"
	else:
		prompt_text = "Hands are full"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
		_take_chemical()
	elif PlayerStats.is_holding == PlayerStats.HoldState.CHEMICAL:
		_place_chemical()
	else:
		_uninteractable()

func _take_chemical() -> void:
	PlayerStats.is_holding = PlayerStats.HoldState.CHEMICAL
	PlayerStats.current_chemical = composite
	PlayerStats.current_chemical_name = chemical_name
	_update_prompt()
	AudioManager.one_shot(sound_emitter)
	print("Chemical taken: ", PlayerStats.current_chemical_name)

func _place_chemical() -> void:
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	PlayerStats.current_chemical_name = ""
	_update_prompt()
	AudioManager.one_shot(placeback_sound)
	print("Chemical placed back")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No chemical in hand to put back")
