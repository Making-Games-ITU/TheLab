extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D
signal sampler_extract_pressed # For micrograph interactions script

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if GameStats.vial_in_collector:
		if VialStats.empty:
			if GameStats.body_exists:
				prompt_text = "Extract blood"
			else:
				prompt_text = "No body to extract from"
		else:
			prompt_text = "Vial not empty"
	else:
		prompt_text = "No vial in vial slot"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.vial_in_collector and VialStats.empty and GameStats.body_exists:
		_extractBlood()
	else:
		_uninteractable()

func _extractBlood() -> void:
	VialStats.empty = false
	VialStats.murky = true
	sampler_extract_pressed.emit()
	VialStats.infection = VialStats.Infection.CELL_MUTATION
	VialStats._update_liquid()
	AudioManager.one_shot(sound_emitter)
	print("Blood extracted with infection: ", VialStats.infection)
	#TODO
	if anim:
		anim.play("extract")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No body to extract from or Vial not empty or No vial in collector")
