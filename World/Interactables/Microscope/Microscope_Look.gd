extends Interactable

@export var exit_sound: FmodEventEmitter3D

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func vial_in() -> bool:
	if GameStats.vial_location == GameStats.VialLocation.MICROSCOPE:
		return true
	else:
		return false

func _update_prompt() -> void:
	if %Micrograph.visible:
		InteractionPrompt.instance.hide_prompt()
		return
	elif vial_in():
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
	elif vial_in():
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
	print("No vial placed")
