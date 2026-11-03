extends Interactable

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.vial_in_microscope:
		prompt_text = "Take vial"
	elif PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
		prompt_text = "Place vial"
	else:
		prompt_text = "No vial to place"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.vial_in_microscope:
		_take_vial()
	elif PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
		_place_vial()
	else:
		print("No vial to place")

func _place_vial():
	GameStats.vial_in_microscope = true
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	%Prop_Microscope_Vial.visible = true
	print("Vial placed in microscope")
	_update_prompt()

func _take_vial():
	GameStats.vial_in_microscope = false
	PlayerStats.is_holding = PlayerStats.HoldState.VIAL
	%Prop_Microscope_Vial.visible = false
	print("Picked up vial from microscope")
	_update_prompt()
