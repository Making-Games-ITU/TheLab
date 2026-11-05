extends Interactable

@export var take_vial_sound: FmodEventEmitter3D
@export var uninteractable_sound: FmodEventEmitter3D
@onready var centrifuge_vial_model := %CentrifugeVialModel
@onready var _centrifuge_state_label: Label = %Centrifuge_State_Label

func _ready() -> void:
	super()
	
func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.vial_in_centrifuge:
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
	if GameStats.vial_in_centrifuge:
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
	GameStats.vial_in_centrifuge = true
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	if VialStats.empty:
		_centrifuge_state_label.text = "Vial empty"
	else:
		_centrifuge_state_label.text = "Ready"
	AudioManager.one_shot(sound_emitter)
	_update_prompt()
	print("Vial inserted")
	#TODO
	if anim:
		anim.play("insert")

func _take_vial():
	GameStats.vial_in_centrifuge = false
	PlayerStats.is_holding = PlayerStats.HoldState.VIAL
	_centrifuge_state_label.text = "No vial"
	AudioManager.one_shot(take_vial_sound)
	_update_prompt()
	print("Vial picked up")
	#TODO
	if anim:
		anim.play("take")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No vial to place or wrong item in hand")
