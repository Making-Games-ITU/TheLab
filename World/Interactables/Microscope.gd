extends Interactable

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if %Micrograph.visible:
		InteractionPrompt.instance.hide_prompt()
		return
	elif GameStats.vial_in_microscope:
		prompt_text = "Analyze vial"
	else:
		prompt_text = "No vial placed"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if %Micrograph.visible:
		%Micrograph.visible = false
		%Control2.visible = false
		PlayerStats.is_analyzing = false
		print("Returning from analyzing")
	elif GameStats.vial_in_microscope:
		%Micrograph.visible = true
		%Control2.visible = true
		PlayerStats.is_analyzing = true
		print("Analyzing")
	else:
		print("No vial placed")
	_update_prompt()
