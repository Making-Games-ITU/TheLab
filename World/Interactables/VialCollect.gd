extends Interactable

# Called when the node enters the scene tree for the first time.
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
	if GameStats.is_vial_used:
		print("Vial already obtained")
	elif PlayerStats.is_holding == PlayerStats.HoldState.CHEMICAL:
		print("Hands are full")
	else:
		_get_new_vial()
	
func _get_new_vial():
	VialStats.empty_vial()
	VialStats._update_liquid()
	PlayerStats.is_holding = PlayerStats.HoldState.VIAL
	GameStats.is_vial_used = true
	_update_prompt()
	AudioManager.one_shot(sound_emitter)
