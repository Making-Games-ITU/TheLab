extends Interactable

@export var flash_drive_name : String
@export var collision_shape : CollisionShape3D
@export var character_ref : Character

func _ready() -> void:
	super()
	hide()
	collision_shape.set_deferred("disabled", true)
	character_ref.get_sentence_from_act("7eb6ec85-442b-4d72-8dd7-9f2558b68c04").on_finished = func():
		show()
		collision_shape.set_deferred("disabled", false)

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
		prompt_text = "Take " + flash_drive_name
	else:
		prompt_text = "Hands are full"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if PlayerStats.is_holding == PlayerStats.HoldState.NONE:
		_take_flash_drive()
	else:
		_uninteractable()

func _take_flash_drive() -> void:
	PlayerStats.is_holding = PlayerStats.HoldState.FLASH_DRIVE
	_update_prompt()
	AudioManager.one_shot(sound_emitter)
	hide()
	collision_shape.set_deferred("disabled", true)

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
