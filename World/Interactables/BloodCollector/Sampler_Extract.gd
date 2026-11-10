extends Interactable

@export var press_anim : ButtonPressAnimation 

signal sampler_extract_pressed # For micrograph interactions script

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
			if GameStats.body_exists:
				prompt_text = "Extract blood"
			else:
				prompt_text = "No body to extract from"
		else:
			prompt_text = "Vial not empty"
	else:
		prompt_text = "No vial in vial slot"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	press_anim.press()
	if vial_in() and VialStats.empty and GameStats.body_exists:
		_extractBlood()
	else:
		_uninteractable()

func _extractBlood() -> void:
	#TODO
	AudioManager.one_shot(sound_emitter)
	if anim:
		GameStats.vial_in_animation = true
		anim.play("close")
		await anim.animation_finished
		VialStats.empty = false
		VialStats.murky = true
		sampler_extract_pressed.emit()
		
		#check game progression level to get appropriate infection
		GameManager.get_blood_type(GameStats.difficulty_stage)		
		
		VialStats._update_liquid()
		print("Blood extracted with infection: ", VialStats.infection)
		anim.play("open")
		GameStats.vial_in_animation = false

func _uninteractable() -> void:
	print("No body to extract from or Vial not empty or No vial in collector")
