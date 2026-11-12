extends Interactable
@export var led_light : Light3D
@export var on_color : Color
@export var interaction_indicator : Interactable_Indecator
@export var collision_shape : CollisionShape3D
@export var character_ref : Character

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if PlayerStats.is_holding == PlayerStats.HoldState.FLASH_DRIVE:
		prompt_text = "Turn on"
	else:
		prompt_text = "Electrical flash drive required"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if PlayerStats.is_holding == PlayerStats.HoldState.FLASH_DRIVE:
		_turn_on_electricity()
		
	else:
		_uninteractable()



func _turn_on_electricity() -> void:
	%LightController.turn_on_all_lights()
	%LightController.turn_on_all_machines()
	led_light.light_color = on_color
	collision_shape.set_deferred("disabled", true)
	interaction_indicator.hide()
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	character_ref.start_dialogue("940724dd-fe4c-4689-a09e-d38e5a250648")
	
func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
