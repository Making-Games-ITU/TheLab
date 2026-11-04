extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D

func _ready() -> void:
	super()
	
func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.vial_in_mixer:
		prompt_text = "Start centrifuge"
	else:
		prompt_text = "No vial in centrifuge"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.vial_in_mixer:
		_start_centrifuge()
	else:
		_uninteractable()

func _start_centrifuge():
	# VialStats.integrate_chemical()
	if VialStats.murky:
		VialStats.murky = false
		VialStats.micrograph_enable_clear_image()
	_update_prompt()
	AudioManager.one_shot(sound_emitter)
	print("Centrifuge started")
	#TODO
	if anim:
		anim.play("remove")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No vial in centrifuge")
