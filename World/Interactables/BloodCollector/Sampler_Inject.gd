extends Interactable

@export var press_anim : ButtonPressAnimation 

signal sampler_inject_pressed # For micrograph interactions script

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func vial_in() -> bool:
	if GameStats.vial_location == GameStats.VialLocation.SAMPLER:
		return true
	else:
		return false

func _update_prompt() -> void:
	if vial_in():
		if VialStats.empty:
			prompt_text = "Vial is empty"
		else:
			if GameStats.body_exists:
				prompt_text = "Inject serum"
			else:
				prompt_text = "No body to inject into"
	else:
		prompt_text = "No vial in vial slot"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	press_anim.press()
	if vial_in() and GameStats.body_exists:
		if VialStats.empty:
			_uninteractable()
		else:
			_inject()

func _inject() -> void:
	#TODO:
	if anim:
		GameStats.vial_in_animation = true
		anim.play("close")
		await anim.animation_finished
		GameManager.check_if_successful()
		VialStats.empty_vial()
		VialStats._update_liquid()
		sampler_inject_pressed.emit()
		AudioManager.one_shot(sound_emitter)
		print("Serum injected")
		anim.play("open")
		GameStats.vial_in_animation = false

func _uninteractable() -> void:
	print("Vial is empty or No body to inject into or no vial ins collector")
