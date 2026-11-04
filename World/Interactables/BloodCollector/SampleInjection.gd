extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if GameStats.vial_in_collector:
		if VialStats.empty:
			prompt_text = "Vial is empty"
		else:
			if GameStats.body_exists:
				prompt_text = "Inject serum"
			else:
				prompt_text = "No body to inject into"
	else:
		prompt_text = "No vial in vial slot"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.vial_in_collector and GameStats.body_exists:
		if VialStats.empty:
			_uninteractable()
		else:
			_inject()

func _inject() -> void:
	VialStats.empty_vial()
	VialStats._update_liquid()
	AudioManager.one_shot(sound_emitter)
	print("Serum injected")
	# Doesn't work
	if anim:
		anim.play("inject")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("Vial is empty or No body to inject into or no vial ins collector")
