extends Interactable

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.body_exists:
		prompt_text = "Dispose body"
	else:
		prompt_text = "No body to dispose"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.body_exists:
		_dispose_body()
	else:
		print("No body to dispose")

func _dispose_body():
	print("Body disposed")
	%Body.visible = false
	GameStats.body_exists = false
	if sound_emitter != null:
		AudioManager.one_shot(sound_emitter)
	_update_prompt()
	# This below doesn't work
	if anim:
		anim.play("RESET")
