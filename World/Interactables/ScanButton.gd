extends Interactable

func _ready() -> void:
	super()
	prompt_text = "Start scan"
	_refresh_prompt()

func interact(interactor: Node) -> void:
	if GameStats.toggle_sample_collector:
		_start_scan()
	else:
		print("Scanner not ready")
	

func _start_scan() -> void:
	if anim:
		GameStats.toggle_sample_collector = false
		anim.play("scan")
		sound_emitter.play()
		print("Starting scan")
		await anim.animation_finished
		print("Scan complete")
		GameStats.toggle_sample_collector = true
		
	
