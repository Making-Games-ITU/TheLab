extends Interactable

@export var press_anim : ButtonPressAnimation 

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
	press_anim.press()
	if GameStats.body_exists:
		_dispose_body()
	else:
		_uninteractable()

func _dispose_body():
	GameStats.body_exists = false
	GameManager.update_progression_level()
	AudioManager.one_shot(sound_emitter)
	_update_prompt()
	print("Body disposed")
	# This below doesn't work
	if anim:
		anim.play("dispose_body")

func _uninteractable() -> void:
	print("No body to dispose")
