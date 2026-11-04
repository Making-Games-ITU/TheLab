extends Interactable

@export var chemName: String
@export var composite: VialStats.Composite
@export var placeback_sound: FmodEventEmitter3D
@export var uninteractable_sound: FmodEventEmitter3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
		prompt_text = "Take " + chemName
	elif PlayerStats.is_holding == PlayerStats.HoldState.CHEMICAL:
		prompt_text = "Place bottle back"
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
	GameStats.current_chemical = composite
	_update_prompt()
	AudioManager.one_shot(sound_emitter)
	print("Chemical taken: ", GameStats.current_chemical)

func _place_chemical() -> void:
	GameStats.current_chemical = VialStats.Composite.None
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	_update_prompt()
	AudioManager.one_shot(placeback_sound)
	print("Chemical placed back")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No chemical in hand to put back")
