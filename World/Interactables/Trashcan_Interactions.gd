extends Interactable

@export var dispose_chemical_sound: FmodEventEmitter3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
		prompt_text = "Dispose vial"
	elif PlayerStats.is_holding == PlayerStats.HoldState.CHEMICAL:
		prompt_text = "Dispose chemical"
	else:
		prompt_text = "No vial to dispose"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
		_dispose_vial()
	elif PlayerStats.is_holding == PlayerStats.HoldState.CHEMICAL:
		_dispose_flask()
	else:
		_uninteractable()

func _dispose_flask() -> void:
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	PlayerStats.current_chemical = VialStats.Composite.NONE
	PlayerStats.current_chemical_name = ""
	_update_prompt()
	AudioManager.one_shot(dispose_chemical_sound)

func _dispose_vial() -> void:
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	VialStats.empty_vial()
	VialStats._update_liquid()
	GameStats.vial_location = GameStats.VialLocation.NONE
	_update_prompt()
	AudioManager.one_shot(sound_emitter)

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No thing to dispose")
