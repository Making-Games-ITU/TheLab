extends Interactable

@export var take_vial_sound: FmodEventEmitter3D
@export var uninteractable_sound: FmodEventEmitter3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.vial_in_microscope and PlayerStats.is_holding == PlayerStats.HoldState.NONE:
		prompt_text = "Take vial"
	elif PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
		prompt_text = "Place vial"
	else:
		prompt_text = "No vial to place"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.vial_in_microscope and PlayerStats.is_holding == PlayerStats.HoldState.NONE:
		_take_vial()
	elif PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
		_place_vial()
	else:
		_uninteractable()

func _place_vial():
	GameStats.vial_in_microscope = true
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	%Prop_Microscope_Vial.visible = true
	AudioManager.one_shot(sound_emitter)
	_update_prompt()
	print("Vial placed in microscope")

func _take_vial():
	GameStats.vial_in_microscope = false
	PlayerStats.is_holding = PlayerStats.HoldState.VIAL
	%Prop_Microscope_Vial.visible = false
	_update_prompt()
	AudioManager.one_shot(take_vial_sound)
	print("Picked up vial from microscope")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No vial to place or wrong item in hand")
