extends Interactable

func interact(interactor: Node) -> void:
	if GameStats.vial_in_collector:
		print("YO remove the vial from the collector first")
	else:
		_get_new_vial()
	
func _get_new_vial():
	PlayerStats.has_new_vial = true
	PlayerStats.has_sample = false
	VialStats.empty_vial()
	print(PlayerStats.has_new_vial," ", VialStats.infection)
