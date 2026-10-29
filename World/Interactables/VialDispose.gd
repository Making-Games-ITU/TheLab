extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


func interact(interactor: Node) -> void:
	_dispose_vial()
	
func _dispose_vial() -> void:
	GameStats.is_vial_used = false
	PlayerStats.has_new_vial = false
	PlayerStats.has_sample = false
