class_name IVialSlot extends Interactable

@export var take_vial_sound: FmodEventEmitter3D
@export var vial_slot: GameStats.VialLocation

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if vial_slot == GameStats.vial_location:
		if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
			prompt_text = "Take vial"
		else:
			prompt_text = "Hands are full"
	else:
		if PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
			prompt_text = "Insert vial"
		else:
			prompt_text = "No vial in hand"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if vial_slot == GameStats.vial_location:
		if PlayerStats.is_holding == PlayerStats.HoldState.NONE and not GameStats.vial_in_animation:
			_take_vial()
		else:
			_uninteractable()
	else:
		if PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
			_insert_vial()
		else:
			_uninteractable()

func _insert_vial():
	GameStats.vial_location = vial_slot
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	AudioManager.one_shot(sound_emitter)
	_update_prompt()
	print("Vial inserted")
	#TODO
	if anim:
		anim.play("insert")

func _take_vial():
	GameStats.vial_location = GameStats.VialLocation.PLAYER
	PlayerStats.is_holding = PlayerStats.HoldState.VIAL
	AudioManager.one_shot(take_vial_sound)
	_update_prompt()
	print("Vial picked up")
	#TODO
	if anim:
		anim.play("take")

func _uninteractable() -> void:
	super()
	print("No vial to place, wrong item in hand or animation in progress")
