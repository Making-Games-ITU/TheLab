extends Machine

@export var press_anim : ButtonPressAnimation 

signal scan_pressed
signal scan_over

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if GameStats.body_exists:
		if GameStats.is_scanning:
			prompt_text = "Already scanning"
		else:
			prompt_text = "Scan body state"
	else:
		prompt_text = "No body to scan"
	InteractionPrompt.instance.show_prompt(prompt_text)

func _on_interact(interactor: Node) -> void:
	press_anim.press()
	if GameStats.body_exists:
		if GameStats.is_scanning:
			_uninteractable()
		else:
			_start_scan()
	else:
		_uninteractable()

func _start_scan() -> void:
	GameStats.is_scanning = true
	AudioManager.one_shot(sound_emitter)
	if anim:
		anim.play("scan")
		scan_pressed.emit()
		await anim.animation_finished
		scan_over.emit()
		GameStats.is_scanning = false
	else:
		# bypassing anim for now
		scan_pressed.emit()
		#TODO: Change screen output here
		GameStats.is_scanning = false 
	GameStats.has_scanned = true
	print("Scanned Body")

func _uninteractable() -> void:
	super()
	print("No body to scan or already scanning")
