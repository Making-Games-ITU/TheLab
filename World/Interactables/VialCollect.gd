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
	else:
		prompt_text = "Take empty vial"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if not GameStats.is_vial_used:
		_get_new_vial()
	else:
		print("Vial already obtained")
	
func _get_new_vial():
	VialStats.empty_vial()
	VialStats._update_liquid()
	PlayerStats.has_vial = true
	GameStats.is_vial_used = true
	_update_prompt()
