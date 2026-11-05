extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D
var bodyIdString : String = "BODY #"

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.body_exists:
		prompt_text = "Body already requested"
	else:
		prompt_text = "Request new body"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.body_exists:
		_uninteractable()
	else:
		_new_body()

func _new_body() -> void:
	#TODO: Body variance should be here
	#TODO: Potential game difficulty increase would be set here
	print("New body requested: ", GameStats.body_ID)
	GameStats.body_number += 1 
	GameStats.body_ID = bodyIdString+ "%04d" % GameStats.body_number
	GameStats.body_exists = true
	GameStats.body_state = 3 # neutral
	%Body.visible = true
	AudioManager.one_shot(sound_emitter)
	_update_prompt()
	# This below doesn't work yet
	if anim:
		anim.play("request")
		await anim.animation_finished

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("Body already requested")
