extends Interactable

@export var take_vial_sound: FmodEventEmitter3D
@export var uninteractable_sound: FmodEventEmitter3D

func _ready() -> void:
	super()
	
func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.vial_in_mixer:
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
	if GameStats.vial_in_mixer:
		if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
			_take_vial()
		else:
			_uninteractable()
	else:
		if PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
			_insert_vial()
		else:
			_uninteractable()

func _insert_vial():
	GameStats.vial_in_mixer = true
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	_update_prompt()
	AudioManager.one_shot(sound_emitter)
	print("Vial inserted")
	#TODO
	if anim:
		anim.play("insert")

func _take_vial():
	GameStats.vial_in_mixer = false
	PlayerStats.is_holding = PlayerStats.HoldState.VIAL
	AudioManager.one_shot(take_vial_sound)
	print("Vial picked up")
	#TODO
	if anim:
		anim.play("remove")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No vial to place or wrong item in hand")
