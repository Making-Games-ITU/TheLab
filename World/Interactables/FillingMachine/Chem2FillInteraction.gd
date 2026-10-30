extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	prompt_text = "Place Chemical Bottle"
	_refresh_prompt()


func interact(interactor: Node) -> void:
	if GameStats.chem_in_pip:
		if anim:
			anim.play("remove")
		_take()
	else:
		if anim:
			anim.play("insert")
		_insert()	

func _insert():
	if PlayerStats.has_chemical: 
		GameStats.chem_in_pip = true
		PlayerStats.has_chemical = false
		print("Chem inserted: ", GameStats.chem_in_pip)
		prompt_text = "Take Chemical Bottle"
		_refresh_prompt()
	else:
		print("No Chemical in inventory.")

func _take():
	GameStats.chem_in_pip = false
	PlayerStats.has_chemical = true
	
	print("Picked up: ", GameStats.current_chemical)
	
	prompt_text = "Place Chemical Bottle"
	_refresh_prompt()
