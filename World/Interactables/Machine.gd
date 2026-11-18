class_name Machine extends Interactable

func interact(interactor: Node) -> void:
	print("i am machine")
	if GameStats.power:
		_on_interact(interactor)
	else:
		print("No Power")
		_uninteractable()
		
	
func _on_interact(interactor: Node) -> void:
	pass
