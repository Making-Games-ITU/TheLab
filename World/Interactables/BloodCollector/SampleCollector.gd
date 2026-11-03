extends Interactable

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.vial_in_collector:
		prompt_text = "Take vial"
	elif PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
		prompt_text = "Insert vial"
	else:
		prompt_text = "No vial to insert"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.vial_in_collector:
		_take_vial()
	elif PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
		_insert_vial()
	else:
		print("No vial to insert")

func _insert_vial():
	GameStats.vial_in_collector = true
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	%SampleCollectorVial.visible = true
	print("Vial inserted")
	_update_prompt()

func _take_vial():
	GameStats.vial_in_collector = false
	PlayerStats.is_holding = PlayerStats.HoldState.VIAL
	%SampleCollectorVial.visible = false
	print("Picked up Vial")
	_update_prompt()
