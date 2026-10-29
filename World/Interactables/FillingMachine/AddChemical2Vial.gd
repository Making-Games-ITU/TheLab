extends Interactable



func interact(interactor: Node) -> void:
	if GameStats.chem_in_pip and GameStats.vial_in_pip:
		var quantity = GameStats.parseAmount()
		var chem = GameStats.current_chemical
		VialStats.add_chemical(chem, quantity)
		print("Adding ", quantity, " of ", chem, ". Current amount: ", VialStats.get_quantity(chem))
	else:
		print("Machine not ready")
