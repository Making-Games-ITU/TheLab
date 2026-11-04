extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D

func _ready() -> void:
	super()
	
func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.mixer_current_speed > GameStats.MIXER_MIN_SPEED:
		prompt_text = "Decrease speed"
	else:
		prompt_text = "Speed at minimum"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.mixer_current_speed > GameStats.MIXER_MIN_SPEED:
		_decrease_speed()
	else:
		_uninteractable()

func _decrease_speed() -> void:
	GameStats.mixer_current_speed -= 1
	AudioManager.one_shot(sound_emitter)
	_update_prompt()
	#TODO: Button animation
	print("Mixer speed down, currently: ", GameStats.mixer_current_speed)

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("Can't go to lower speeds")
