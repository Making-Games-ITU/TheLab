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
		anim.play("close")
		await anim.animation_finished
		_check_if_successful()
		VialStats.empty_vial()
		VialStats._update_liquid()
		sampler_inject_pressed.emit()
		AudioManager.one_shot(sound_emitter)
		print("Serum injected")
		anim.play("open")

func _check_if_successful() -> void:
	# Body state already at minimum but keep trying = bad
	if GameStats.body_state == 1:
		GameStats.body_state += 1
		_check_game_over()
		return
	# Vial is damaged = bad
	if VialStats.damaged:
		GameStats.body_state += 1
		_check_game_over()
		return
	# Chemical in vial but not integrated = bad
	for key in VialStats.chemicals:
		if VialStats.chemicals[key].quantity > 0.0:
			if not VialStats.chemicals[key].integrated:
				GameStats.body_state += 1
				_check_game_over()
				return
	# If vial has the wrong chemical in it = bad
	if VialStats.infection == VialStats.InfectionType.CELL_MUTATION:
		for key in VialStats.chemicals:
			if VialStats.chemicals[key].quantity > 0.0:
				if key != VialStats.Composite.HYDROGEN:
					GameStats.body_state += 1
					_check_game_over()
					return
	# If no chemical is present
	var no_chemicals = true
	for key in VialStats.chemicals:
		if VialStats.chemicals[key].quantity != 0.0:
			no_chemicals = false
	if no_chemicals:
		return
	GameStats.body_state -= 1

func _check_game_over() -> void:
	if GameStats.body_state == 6:
		%GameOverScreen.visible = true
		await get_tree().create_timer(2.0).timeout
		get_tree().quit()

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("Vial is empty or No body to inject into or no vial ins collector")
