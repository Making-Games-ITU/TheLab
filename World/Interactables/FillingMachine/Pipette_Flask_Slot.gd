extends Interactable

@export var take_flask_sound: FmodEventEmitter3D
@export var uninteractable_sound: FmodEventEmitter3D
@onready var flask_vial_model := $Flask_Model

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if GameStats.flask_in_pipette:
		if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
			prompt_text = "Take flask"
		else:
			prompt_text = "Hands are full"
	else:
		if PlayerStats.is_holding == PlayerStats.HoldState.CHEMICAL:
			prompt_text = "Insert flask"
		else:
			prompt_text = "No flask to insert"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.flask_in_pipette:
		if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
			_take_flask()
		else:
			_uninteractable()
	else:
		if PlayerStats.is_holding == PlayerStats.HoldState.CHEMICAL:
			_insert_flask()
		else:
			_uninteractable()

func _insert_flask():
	GameStats.flask_in_pipette = true
	flask_vial_model.visible = true
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	AudioManager.one_shot(sound_emitter)
	print("Flask inserted into pipette flask slot")
	#TODO
	if anim:
		anim.play("insert")

func _take_flask():
	GameStats.flask_in_pipette = false
	flask_vial_model.visible = false
	PlayerStats.is_holding = PlayerStats.HoldState.CHEMICAL
	AudioManager.one_shot(take_flask_sound)
	_update_prompt()
	print("Picked up flask from pipette flask slot")
	#TODO
	if anim:
		anim.play("remove")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No flask to insert or wrong object in hand or hands are full")
