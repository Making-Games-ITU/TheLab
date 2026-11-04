extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if GameStats.is_vial_used:
		prompt_text = "Vial already obtained"
	elif PlayerStats.is_holding == PlayerStats.HoldState.CHEMICAL:
		prompt_text = "Hands are full"
	else:
		prompt_text = "Take empty vial"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.is_vial_used or PlayerStats.is_holding != PlayerStats.HoldState.NONE:
		_uninteractable()
	else:
		_get_new_vial()

func _get_new_vial():
	VialStats.empty_vial()
	VialStats._update_liquid()
	PlayerStats.is_holding = PlayerStats.HoldState.VIAL
	GameStats.is_vial_used = true
	_update_prompt()
	AudioManager.one_shot(sound_emitter)

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("Vial already obtained or hands are full")
