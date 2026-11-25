extends Machine

@export var press_anim : ButtonPressAnimation 
@export var needle_anim : AnimationPlayer

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

func _on_interact(_interactor: Node) -> void:
	press_anim.press()
	if vial_in() and VialStats.empty and GameStats.body_exists:
		_extractBlood()
	else:
		_uninteractable()

func _extractBlood() -> void:
	#TODO
	AudioManager.one_shot(sound_emitter)
	if anim:
		_Inject_Needle()
		GameStats.vial_in_animation = true
		anim.play("close")
		await anim.animation_finished
		VialStats.empty = false
		VialStats.murky = true
		sampler_extract_pressed.emit()
		
		#check game progression level to get appropriate infection
		GameManager.get_infection_type()		
		
		VialStats._update_liquid()
		print("Blood extracted with infection: ", VialStats.infection)
		anim.play("open")
		GameStats.vial_in_animation = false

func _uninteractable() -> void:
	print("No body to extract from or Vial not empty or No vial in collector")

func _Inject_Needle() -> void:
	needle_anim.play("Tube_Needle/Inject_Needle")
	await anim.animation_finished
	await get_tree().create_timer(1).timeout
	needle_anim.play_backwards("Tube_Needle/Inject_Needle")
	
