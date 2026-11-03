extends Interactable

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
	if GameStats.vial_in_collector:
		if VialStats.empty:
			if GameStats.body_exists:
				_extractBlood()
			else:
				print("No body to extract from")
		else:
			print("Vial not empty")
	else:
		print("No vial in sample collector")
	
func _extractBlood() -> void:
	VialStats.empty = false
	VialStats.infection = 1
	VialStats._update_liquid()
	print("Blood extracted with infection: ", VialStats.infection)
	# Not working
	if anim:
		anim.play("extract")
