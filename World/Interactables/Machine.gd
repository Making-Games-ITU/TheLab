class_name Machine extends Interactable

func interact(interactor: Node) -> void:
	if not GameStats.power:
		_on_interact(interactor)
	else:
		print("No Power")
		_uninteractable()
		
	
func _on_interact(_interactor: Node) -> void:
	pass
