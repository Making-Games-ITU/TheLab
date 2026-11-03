extends Interactable

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
	if GameStats.vial_in_collector:
		if VialStats.empty:
			print("Vial is empty")
		else:
			if GameStats.body_exists:
				_inject()
			else:
				print("No body to inject into")
	else:
		print("No vial in vial slot")

func _inject() -> void:
	VialStats.empty_vial()
	VialStats._update_liquid()
	# Doesn't work
	if anim:
		anim.play("inject")
