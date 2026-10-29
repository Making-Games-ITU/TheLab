extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	prompt_text = "Insert Vial"
	_refresh_prompt()

func interact(interactor: Node) -> void:
	if GameStats.vial_in_mixer:
		if anim:
			anim.play("remove")
		_take_vial()
	else:
		if anim:
			anim.play("insert")
		_insert_vial()	

func _insert_vial():
	if PlayerStats.has_sample: 
		GameStats.vial_in_mixer = true
		PlayerStats.has_new_vial = false
		PlayerStats.has_sample = false
		print("Vial inserted: ", GameStats.vial_in_mixer)
		prompt_text = "Take vial"
		_refresh_prompt()
	elif PlayerStats.has_new_vial:
		#What if player has inserted sample in machine and takes a new vial and tries to insert
		print("Vial Empty.")
	else:
		print("No Vial in inventory.")

func _take_vial():
	GameStats.vial_in_mixer = false
	PlayerStats.has_sample = true
	
	print("Picked up Vial: ", GameStats.vial_in_mixer)
	
	prompt_text = "Insert Vial"
	_refresh_prompt()
