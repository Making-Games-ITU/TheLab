extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

func focus() -> void:
	_update_prompt()

func _update_prompt() -> void:
	_set_outline(true)
	if GameStats.is_vial_used:
		prompt_text = "Vial already collected"
	else:
		prompt_text = "Take empty vial"
	InteractionPrompt.instance.show_prompt(prompt_text)


func interact(interactor: Node) -> void:
	_get_new_vial()
	
func _get_new_vial():
	if not GameStats.is_vial_used:
		VialStats.empty_vial()
		PlayerStats.has_new_vial = true
		GameStats.is_vial_used = true
	else:
		return # Play sound effect


# We need a trashcan to dispose a vial
