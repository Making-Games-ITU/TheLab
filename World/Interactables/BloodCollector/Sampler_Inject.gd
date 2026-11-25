extends Machine

@export var press_anim : ButtonPressAnimation 
@export var needle_anim : AnimationPlayer

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

func _on_interact(_interactor: Node) -> void:
	press_anim.press()
	if vial_in() and GameStats.body_exists:
		if VialStats.empty:
			_uninteractable()
		else:
			_inject()

func _inject() -> void:
	#TODO:
	if anim:
		_Inject_Needle()
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
	GameStats.has_scanned = false

func _uninteractable() -> void:
	print("Vial is empty or No body to inject into or no vial ins collector")

func _Inject_Needle() -> void:
	needle_anim.play("Tube_Needle/Inject_Needle")
	await anim.animation_finished
	await get_tree().create_timer(1).timeout
	needle_anim.play_backwards("Tube_Needle/Inject_Needle")
	
