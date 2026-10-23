extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


func interact(interactor: Node) -> void:
	_get_new_vial()
	
func _get_new_vial():
	if not PlayerStats.has_new_vial:
		PlayerStats.has_new_vial = true
		print(PlayerStats.has_new_vial)
	else:
		print("Already have an empty vial")
