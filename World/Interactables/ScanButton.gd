extends Interactable

var _scanning : bool = false

func _ready() -> void:
	super()
	prompt_text = "Start scan"
	_refresh_prompt()

func interact(interactor: Node) -> void:
	if GameStats.body_exists and not _scanning:
		_start_scan()
	elif _scanning:
		_stop_scan()
	else:
		print("Scanner not ready")

func _start_scan() -> void:
	_scanning = true
	print("Starting scan")
	if anim:
		anim.play("scan")
		area.set_collision_layer_value(9, false)
		#sound_emitter.play()
		#Uncomment when sound added
		await anim.animation_finished
		area.set_collision_layer_value(9, true)
		print("Scan online")
	prompt_text = "Stop scan"
	_refresh_prompt()
		
func _stop_scan() -> void:
	_scanning = false
	print("Stopping scan")
	if anim:
		anim.play("stop")
		area.set_collision_layer_value(9, false)
		#sound_emitter.play()
		#Uncomment when sound added
		await anim.animation_finished
		area.set_collision_layer_value(9, true)
		print("Scan offline")
	prompt_text = "Start scan"
	_refresh_prompt()
