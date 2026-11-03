extends Node

# Easy check if anything happened if needed
# For example, can be used to update shader
signal changed 

# Vial shader related stats
const MIN_HEIGHT := 0.15      # liquid_height with only blood
const FULL_HEIGHT := 0.5      # liquid_height when full; tune to your mesh
const MAX_QUANTITY := 10.0    # total quantity that counts as full
const BLOOD_AMOUNT := 2.0     # how strongly the blood counts in the color mix
const MAX_CHEMICAL := 10.0    # total chemical amount that fills the vial
const EMPTY_COLOR := Color.BLACK
const BLOOD_COLOR := Color(0.8, 0.05, 0.1)
const CHEMICAL_COLORS := {
	Composite.A: Color(0.2, 0.9, 0.3),
	Composite.B: Color(0.3, 0.4, 1.0),
}
var empty: bool = true
var liquid_material: ShaderMaterial = preload("res://World/Items/Test Tube/Test_tube_liquid_shader_material.tres")

# Infection related stats
enum Infection {
	NONE = 0,
	CELL_MUTATION = 1,
	PARASITES = 2,
	BOTH = 3,
}
var infection: Infection = Infection.NONE

# Chemical related stats
enum Composite {None, A, B }
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
enum Speed { Min, Low, Medium, High, Max }

func _ready() -> void:
	changed.connect(_update_liquid)
	_update_liquid()

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

func _set_liquid(height: float, color: Color) -> void:
	liquid_material.set_shader_parameter("liquid_height", height)
	liquid_material.set_shader_parameter("liquid_surface_color", color.lightened(0.3))
	# The body color comes from the rim gradient, so recolor its first point
	var gradient_tex = liquid_material.get_shader_parameter("liquid_rim_gradient")
	gradient_tex.gradient.set_color(0, color)

func empty_vial() -> void:
	infection = Infection.NONE
	empty = true
	damaged = false
	centrifuged = false
	for key in chemicals:
		chemicals[key] = Chemical.new()
	changed.emit()

# Adding chemical composition to vial
# Used by that chemical machine
func add_chemical(composite: Composite, amount: float) -> void:
	if amount <= 0.0:
		return
	empty = false
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
