extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
		prompt_text = "Dispose vial"
	elif PlayerStats.is_holding == PlayerStats.HoldState.CHEMICAL:
		prompt_text = "Dispose chemical"
	else:
		prompt_text = "No vial to dispose"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
		_dispose_vial()
	elif PlayerStats.is_holding == PlayerStats.HoldState.CHEMICAL:
		_dispose_chemical()
	else:
		print("No vial to dispose")

func _dispose_chemical() -> void:
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	_update_prompt()

func _dispose_vial() -> void:
	VialStats.empty_vial()
	VialStats._update_liquid()
	GameStats.is_vial_used = false
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	_update_prompt()
