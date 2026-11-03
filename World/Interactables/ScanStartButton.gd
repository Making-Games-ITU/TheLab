extends Interactable

var _scanning: bool = false

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
	if GameStats.body_exists:
		if _scanning:
			print("Already scanning")
		else:
			_start_scan()
	else:
		print("No body to scan")

func _start_scan() -> void:
	_scanning = true
	print("Starting scan")
	if anim:
		anim.play("scan")
		await anim.animation_finished
		# Change screen output here
		_scanning = false
	else:
		# Change screen output here
		_scanning = false # bypassing anim for now
