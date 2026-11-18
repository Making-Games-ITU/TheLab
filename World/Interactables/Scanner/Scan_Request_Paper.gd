extends Machine

@export var press_anim : ButtonPressAnimation 

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if GameStats.has_scanned:
		if GameStats.is_scanning:
			prompt_text = "Scanning in progress"
		else:
			prompt_text = "Request Scan Paper"
	else:
		prompt_text = "Body not scanned"
	InteractionPrompt.instance.show_prompt(prompt_text)

func _on_interact(interactor: Node) -> void:
	press_anim.press()
	if GameStats.has_scanned:
		if GameStats.is_scanning:
			_uninteractable()
		else:
			_get_scan_paper()
	else:
		_uninteractable()

func _get_scan_paper() -> void:
	AudioManager.one_shot(sound_emitter)
	print("Got scan paper")

func _uninteractable() -> void:
	super()
	print("Scanning in progress or body not scanned")
