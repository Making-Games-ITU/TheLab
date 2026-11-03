extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if PlayerStats.has_vial:
		prompt_text = "Dispose vial"
	else:
		prompt_text = "No vial to dispose"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if PlayerStats.has_vial:
		_dispose_vial()
	else:
		print("No vial to dispose")
	
func _dispose_vial() -> void:
	VialStats.empty_vial()
	VialStats._update_liquid()
	GameStats.is_vial_used = false
	PlayerStats.has_vial = false
	_update_prompt()
