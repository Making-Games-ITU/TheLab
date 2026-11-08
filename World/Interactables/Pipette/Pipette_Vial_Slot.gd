extends Interactable

@export var take_vial_sound: FmodEventEmitter3D
@export var uninteractable_sound: FmodEventEmitter3D
@onready var pipette_vial_model := $Pipette_Vial
@onready var pipette_vial_tube_on := $Pipette_Vial_Tube_ON
@onready var pipette_vial_tube_off := $Pipette_Vial_Tube_OFF

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.vial_in_pipette:
		if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
			prompt_text = "Take vial"
		else:
			prompt_text = "Hands are full"
	else:
		if PlayerStats.is_holding == PlayerStats.HoldState.VIAL:
			prompt_text = "Insert vial"
		else:
			prompt_text = "No vial to insert"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.vial_in_pipette:
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
	GameStats.vial_in_pipette = true
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	AudioManager.one_shot(sound_emitter)
	_update_prompt()
	print("Vial inserted into pipette vial slot")
	#TODO
	if anim:
		anim.play("insert")

func _take_vial():
	GameStats.vial_in_pipette = false
	PlayerStats.is_holding = PlayerStats.HoldState.VIAL
	AudioManager.one_shot(take_vial_sound)
	_update_prompt()
	print("Picked up vial from pipette vial slot")
	#TODO
	if anim:
		anim.play("take")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No vial to insert or wrong object in hand or hands are full")
