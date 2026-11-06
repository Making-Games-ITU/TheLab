extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D
@export var press_anim : ButtonPressAnimation 

var _scanning: bool = false
signal scan_pressed

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if GameStats.body_exists:
		if _scanning:
			prompt_text = "Already scanning"
		else:
			prompt_text = "Scan body state"
	else:
		prompt_text = "No body to scan"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	press_anim.press()
	if GameStats.body_exists:
		if _scanning:
			_uninteractable()
		else:
			_start_scan()
	else:
		_uninteractable()

func _start_scan() -> void:
	_scanning = true
	AudioManager.one_shot(sound_emitter)
	if anim:
		anim.play("scan")
		await anim.animation_finished
		#TODO: Change screen output here
		scan_pressed.emit()
		_scanning = false
	else:
		# bypassing anim for now
		scan_pressed.emit()
		#TODO: Change screen output here
		_scanning = false 
	print("Scanned Body")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No body to scan or already scanning")
