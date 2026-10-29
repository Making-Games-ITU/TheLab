extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

func focus() -> void:
	_update_prompt()
	
func _update_prompt() -> void:
	_set_outline(true)
	if PlayerStats.has_new_vial or PlayerStats.has_sample:
		prompt_text = "Dispose sample"
	else:
		prompt_text = "No sample to dispose"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	_dispose_vial()
	
func _dispose_vial() -> void:
	if PlayerStats.has_new_vial or PlayerStats.has_sample:
		GameStats.is_vial_used = false
		PlayerStats.has_new_vial = false
		PlayerStats.has_sample = false
		# Play some other sound here I guess
	else:
		return # Play oof sound here
