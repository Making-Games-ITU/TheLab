extends Node

# Easy check if anything happened if needed
# For example, can be used to update shader
signal changed 

# Infection related stats
enum Infection {
	NONE = 0,
	CELL_MUTATION = 1,
	PARASITES = 2,
	BOTH = 3,
}
var infection: Infection = Infection.NONE

# Chemical related stats
enum Composite { A, B }
class Chemical:
	var quantity: float = 0.0
	var integrated: bool = false
var chemicals: Dictionary = {
	Composite.A: Chemical.new(),
	Composite.B: Chemical.new(),
}

# Centrifuging related stats
var centrifuged: bool = false
var damaged: bool = false
const CENTRIFUGE_HIGH_SPEED: float = 3000.0
const CENTRIFUGE_DAMAGE_SPEED: float = 6000.0

# Adding chemical composition to vial
# Used by that chemical machine
func add_chemical(composite: Composite, amount: float) -> void:
	if amount <= 0.0:
		return
	for key in chemicals:
		var other: Chemical = chemicals[key]
		if key != composite and other.quantity > 0.0 and not other.integrated:
			damaged = true
	var chem: Chemical = chemicals[composite]
	chem.quantity += amount
	chem.integrated = false
	changed.emit()

# Mixer (Centrifuge) functionality for just the rotation
func centrifuge(rpm: float) -> void:
	if rpm >= CENTRIFUGE_HIGH_SPEED:
		centrifuged = true
	if rpm >= CENTRIFUGE_DAMAGE_SPEED:
		damaged = true
	changed.emit()

# Mixer (Centrifuge) functionality for integrating chemicals
func integrate_chemical(composite: Composite) -> void:
	var chem: Chemical = chemicals[composite]
	if chem.quantity > 0.0:
		chem.integrated = true
		changed.emit()

# Functions to check for infections
func has_cell_mutation() -> bool:
	return infection & Infection.CELL_MUTATION != 0
func has_parasites() -> bool:
	return infection & Infection.PARASITES != 0

# Functions to check for chemical compositions
func get_quantity(composite: Composite) -> float:
	return chemicals[composite].quantity
func is_integrated(composite: Composite) -> bool:
	return chemicals[composite].integrated
