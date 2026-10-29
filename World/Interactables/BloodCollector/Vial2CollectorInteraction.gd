extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	prompt_text = "Insert Vial"
	_refresh_prompt()
	_toggle_interaction() 

func _process(delta: float) -> void:
	_toggle_interaction()

func _toggle_interaction():
	if GameStats.toggle_sample_collector:
		area.set_collision_layer_value(9, true)
	else:
		if anim:
			anim.play("close")
		area.set_collision_layer_value(9, false)

func interact(interactor: Node) -> void:
	if GameStats.vial_in_collector:
		if anim:
			anim.play("remove")
		_take_vial()
	else:
		if anim:
			anim.play("insert")
		_insert_vial()	

func _insert_vial():
	if PlayerStats.has_new_vial or PlayerStats.has_sample: 
		GameStats.vial_in_collector = true
		PlayerStats.has_new_vial = false
		PlayerStats.has_sample = false
		print("Vial inserted: ", GameStats.vial_in_collector)
		prompt_text = "Take vial"
		_refresh_prompt()
	else:
		print("No Vial in inventory.")

func _take_vial():
	GameStats.vial_in_collector = false
	if VialStats.empty:
		PlayerStats.has_new_vial = true
	else:
		PlayerStats.has_sample = true
	
	print("Picked up Vial: ", GameStats.vial_in_collector)
	
	prompt_text = "Insert Vial"
	_refresh_prompt()
