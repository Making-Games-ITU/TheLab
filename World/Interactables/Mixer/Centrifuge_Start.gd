extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D
signal centrifuge_start_pressed

func _ready() -> void:
	super()
	
func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.vial_in_mixer:
		if VialStats.empty:
			prompt_text = "Vial is empty"
		else:
			prompt_text = "Start centrifuge"
	else:
		prompt_text = "No vial in centrifuge"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.vial_in_mixer:
		if VialStats.empty:
			_uninteractable()
		else:
			_start_centrifuge()
	else:
		_uninteractable()

func _start_centrifuge():
	if VialStats.murky:
		VialStats.murky = false
		centrifuge_start_pressed.emit()
	_update_prompt()
	AudioManager.one_shot(sound_emitter)
	print("Centrifuge started")
	#TODO
	if anim:
		anim.play("remove")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No vial in centrifuge or vial is empty")
