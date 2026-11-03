extends Interactable

var bodyIdString : String = "BODY #"

func focus() -> void:
	_update_prompt()
	
func _update_prompt() -> void:
	_set_outline(true)
	if GameStats.body_exists:
		prompt_text = "Body already requested"
	else:
		prompt_text = "Request new body"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.body_exists:
		print("Body already requested")
	else:
		_new_body()

func _new_body() -> void:
	# Body variance should be here
	# Potential game difficulty increase would be set here
	print("New body requested: ", GameStats.body_ID)
	GameStats.body_number += 1 
	GameStats.body_ID = bodyIdString+ "%04d" % GameStats.body_number
	GameStats.body_exists = true
	%Body.visible = true
	if sound_emitter != null:
		AudioManager.one_shot(sound_emitter)
	_update_prompt()
	# This below doesn't work yet
	if anim:
		anim.play("request")
		await anim.animation_finished
