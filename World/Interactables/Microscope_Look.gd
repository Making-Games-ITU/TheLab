extends Interactable

@export var exit_sound: FmodEventEmitter3D
@export var uninteractable_sound: FmodEventEmitter3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if %Micrograph.visible:
		InteractionPrompt.instance.hide_prompt()
		return
	elif GameStats.vial_in_microscope:
		if VialStats.empty:
			prompt_text = "Vial is empty"
		else:
			prompt_text = "Analyze vial"
	else:
		prompt_text = "No vial placed"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if %Micrograph.visible:
		_exit_mircoscope()
	elif GameStats.vial_in_microscope:
		if VialStats.empty:
			_uninteractable()
		else:
			_enter_microscope()
	else:
		_uninteractable()
	_update_prompt()

func _enter_microscope() -> void:
	%Micrograph.visible = true
	%ExitFullscreenImage.visible = true
	PlayerStats.is_analyzing = true
	AudioManager.one_shot(sound_emitter)
	print("Analyzing")

func _exit_mircoscope() -> void:
	%Micrograph.visible = false
	%ExitFullscreenImage.visible = false
	PlayerStats.is_analyzing = false
	AudioManager.one_shot(exit_sound)
	print("Returning from analyzing")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No vial placed")
