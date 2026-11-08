extends Interactable

@export var vial_place_sound: FmodEventEmitter3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if GameStats.is_vial_used:
		if PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
			if VialStats.empty:
				prompt_text = "Place vial back"
			else:
				prompt_text = "Vial not empty"
		else:
			prompt_text = "Vial already obtained"
	else:
		if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
			prompt_text = "Take empty vial"
		else:
			prompt_text = "Hands are full"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.is_vial_used:
		if PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
			if VialStats.empty:
				_place_vial_back()
			else:
				_uninteractable()
		else:
			_uninteractable()
	else:
		if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
			_get_new_vial()
		else:
			_uninteractable()

func _get_new_vial() -> void:
	VialStats.empty_vial()
	VialStats._update_liquid()
	PlayerStats.is_holding = PlayerStats.HoldState.VIAL
	GameStats.is_vial_used = true
	GameStats.vial_location = GameStats.VialLocation.PLAYER
	_update_prompt()
	AudioManager.one_shot(sound_emitter)
	print("Vial taken")

func _place_vial_back() -> void:
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	GameStats.vial_location = GameStats.VialLocation.NONE
	GameStats.is_vial_used = false
	_update_prompt()
	AudioManager.one_shot(vial_place_sound)
	print("Vial placed back")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("Vial already obtained or holding wrong item")
