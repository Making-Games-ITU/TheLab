extends Interactable

func _ready() -> void:
	super()
	prompt_text = "Start scan"
	_refresh_prompt()

func interact(interactor: Node) -> void:
	if GameStats.body_exists:
		_start_scan()
	else:
		print("Scanner not ready")
	

func _start_scan() -> void:
	print("Starting scan")
	if anim:
		anim.play("scan")
		sound_emitter.play()
		await anim.animation_finished
		print("Scan complete")
		
	
