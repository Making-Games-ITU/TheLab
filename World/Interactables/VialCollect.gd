extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


func interact(interactor: Node) -> void:
	if GameStats.vial_in_collector:
		print("YO remove the vial from the collector first")
	else:
		_get_new_vial()
	
func _get_new_vial():
	PlayerStats.has_new_vial = true
	PlayerStats.has_sample = false
	VialStats.empty = true
	VialStats.infection = 0
	for key in VialStats.chemicals:
		VialStats.chemicals[key] = VialStats.Chemical.new()
	print(PlayerStats.has_new_vial," ", VialStats.infection)
