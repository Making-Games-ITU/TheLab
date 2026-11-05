extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D
@onready var _centrifuge_speed_label: Label = %Centrifuge_Speed_Label

func _ready() -> void:
	super()
	
func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.centrifuge_current_speed < GameStats.CENTRIFUGE_MAX_SPEED:
		prompt_text = "Increase speed"
	else:
		prompt_text = "Speed at max"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.centrifuge_current_speed < GameStats.CENTRIFUGE_MAX_SPEED:
		_increase_speed()
	else:
		_uninteractable()

func _increase_speed() -> void:
	GameStats.centrifuge_current_speed += 1
	AudioManager.one_shot(sound_emitter)
	_centrifuge_speed_label.text = "Speed: " + str(GameStats.centrifuge_current_speed)
	_update_prompt()
	#TODO: Button animation
	print("Mixer speed up, currently: ", GameStats.centrifuge_current_speed)

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("Can't go to higher speeds")
