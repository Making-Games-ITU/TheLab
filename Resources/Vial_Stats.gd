extends Node

# Vial shader related stats
const MIN_HEIGHT := 0.05      # liquid_height with only blood
const FULL_HEIGHT := 0.5      # liquid_height when full; tune to your mesh
const MAX_QUANTITY := 10.0    # total quantity that counts as full
const BLOOD_AMOUNT := 0.2     # how strongly the blood counts in the color mix
const MAX_CHEMICAL := 10.0    # total chemical amount that fills the vial
const EMPTY_COLOR := Color.BLACK
const BLOOD_COLOR := Color(0.8, 0.05, 0.1)
const CHEMICAL_COLORS := {
	Composite.A: Color(0.2, 0.9, 0.3),
	Composite.B: Color(0.3, 0.4, 1.0),
}
var empty: bool = true
var liquid_material: ShaderMaterial = preload("res://World/Items/Test Tube/Test_tube_liquid_shader_material.tres")

# Micrograph shader related stats
var micrograph_shader: ShaderMaterial = preload("res://UI/Microscope/micrograph_shader_material.tres")

# Infection related stats
enum Infection {
	NONE = 0,
	CELL_MUTATION = 1,
	PARASITES = 2,
	BOTH = 3,
}
var infection: Infection = Infection.NONE

# Chemical related stats
enum Composite { NONE, A, B }
class Chemical:
	var quantity: float = 0.0
	var integrated: bool = false
var chemicals: Dictionary = {
	Composite.A: Chemical.new(),
	Composite.B: Chemical.new(),
}

# Centrifuge related stats
var murky: bool = false
var centrifuged: bool = false
var damaged: bool = false
const CENTRIFUGE_HIGH_SPEED: float = 3000.0
const CENTRIFUGE_DAMAGE_SPEED: float = 6000.0
enum Speed { Min, Low, Medium, High, Max }

func _ready() -> void:
	_update_liquid()

# Vial liquid shader update
func _update_liquid() -> void:
	if empty:
		_set_liquid(-1.0, EMPTY_COLOR)
		return
	var total_chem := 0.0
	var mix := BLOOD_COLOR * BLOOD_AMOUNT
	for key in chemicals:
		var q := get_quantity(key)
		total_chem += q
		mix += CHEMICAL_COLORS[key] * q
	var color := mix / (BLOOD_AMOUNT + total_chem)
	var fill := clampf(total_chem / MAX_CHEMICAL, 0.0, 1.0)
	_set_liquid(lerpf(MIN_HEIGHT, FULL_HEIGHT, fill), color)

# Vial liquid shader uptade
func _set_liquid(height: float, color: Color) -> void:
	liquid_material.set_shader_parameter("liquid_height", height)
	liquid_material.set_shader_parameter("liquid_surface_color", color.lightened(0.3))
	var gradient_tex = liquid_material.get_shader_parameter("liquid_rim_gradient")
	gradient_tex.gradient.set_color(0, color)

# Reset vial
func empty_vial() -> void:
	infection = Infection.NONE
	empty = true
	damaged = false
	centrifuged = false
	for key in chemicals:
		chemicals[key] = Chemical.new()
	_update_liquid()

# Pipette: adding chemical composition to vial
func add_chemical(composite: Composite, amount: float) -> void:
	empty = false
	var _chemical: Chemical = chemicals[composite]
	_chemical.quantity += amount
	_chemical.integrated = false
	_update_liquid()

# Mixer (Centrifuge) functionality for just the rotation
func centrifuge(rpm: float) -> void:
	if rpm >= CENTRIFUGE_HIGH_SPEED:
		centrifuged = true
	if rpm >= CENTRIFUGE_DAMAGE_SPEED:
		damaged = true

# Mixer (Centrifuge) functionality for integrating chemicals
func integrate_chemical(composite: Composite, speed : Speed) -> void:
	var chem: Chemical = chemicals[composite]
	if chem.quantity > 0.0:
		match composite:
			Composite.A:
				if speed == Speed.Low:
					chem.integrated = true
					#Add if mixing damages
			Composite.B:
				if speed == Speed.Medium:
					chem.integrated = true
					#Add if mixing damages

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
