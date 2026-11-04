extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D

func _ready() -> void:
	super()
	
func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.mixer_current_speed < GameStats.MIXER_MAX_SPEED:
		prompt_text = "Increase speed"
	else:
		prompt_text = "Speed at max"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.mixer_current_speed < GameStats.MIXER_MAX_SPEED:
		_increase_speed()
	else:
		_uninteractable()

func _increase_speed() -> void:
	GameStats.mixer_current_speed += 1
	AudioManager.one_shot(sound_emitter)
	_update_prompt()
	#TODO: Button animation
	print("Mixer speed up, currently: ", GameStats.mixer_current_speed)

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("Can't go to higher speeds")
